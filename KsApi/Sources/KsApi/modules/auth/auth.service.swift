import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Auth Operations

/// Isolates legacy `ServiceType` Sign in with Apple and email verification calls behind `AXProblemDetails`.
public protocol AuthLegacyBridgeProtocol {
  /// Authenticates a user using a validated Sign in with Apple payload.
  func signInWithApple(schema: SignInWithAppleRequestSchema) -> Result<SignInWithAppleEnvelope, AXProblemDetails>
  /// Confirms a user's email address from a verification token.
  func verifyEmail(token: String) -> Result<EmailVerificationResponseEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating auth operations to `ServiceType`.
public final class LegacyAuthServiceAdapter: AuthLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Signs in with Apple synchronously and translates legacy errors.
  public func signInWithApple(
    schema: SignInWithAppleRequestSchema
  ) -> Result<SignInWithAppleEnvelope, AXProblemDetails> {
    let input = SignInWithAppleInput(
      appId: schema.iosAppBundleId,
      authCode: schema.authCode,
      firstName: schema.firstName,
      lastName: schema.lastName
    )
    guard let result = self.legacyService.signInWithApple(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on signInWithApple"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "signInWithApple"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "signInWithApple") }
  }

  /// Verifies an email token synchronously and translates legacy errors.
  /// Verifies an email address token idempotently while enforcing quota.
  public func verifyEmail(token: String) -> Result<EmailVerificationResponseEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.verifyEmail(withToken: token).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on verifyEmail"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "verifyEmail"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "verifyEmail") }
  }
}

// MARK: - Rule 2 & Rule 5: Auth Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating Sign in with Apple and email verification.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified auth payload returns HTTP 409 conflict.
public final class AuthModuleService {
  private let bridge: AuthLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var appleAuthStore: [IdempotencyKey: (SignInWithAppleRequestSchema, AppleAuthSessionContract)] = [:]
  private var emailVerifyStore: [IdempotencyKey: (VerifyEmailRequestSchema, String)] = [:]

  /// Creates an `AuthModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: AuthLegacyBridgeProtocol,
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.init(
      bridge: LegacyAuthServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Exchanges a Sign in with Apple authorization code idempotently while enforcing quota.
  public func signInWithApple(
    schema: SignInWithAppleRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<AppleAuthSessionContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.appleAuthStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = AppleAuthSessionContract(
        userUid: contract.userUid,
        apiAccessToken: contract.apiAccessToken,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.signInWithApple(schema: validated).map { env in
        let output = AppleAuthSessionContract(
          userUid: env.signInWithApple.user.uid,
          apiAccessToken: env.signInWithApple.apiAccessToken,
          idempotencyReplayed: false
        )
        self.appleAuthStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Verifies an email address token idempotently while enforcing quota.
  public func verifyEmail(
    schema: VerifyEmailRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<String>, AXProblemDetails> {
    if let (savedSchema, msg) = self.emailVerifyStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      return .success(AXServiceResponse(
        value: msg,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { token in
      self.bridge.verifyEmail(token: token).map { env in
        self.emailVerifyStore[idempotencyKey] = (schema, env.message)
        return AXServiceResponse(
          value: env.message,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private static func idempotencyConflict(key: IdempotencyKey) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/idempotency-conflict",
      title: "Idempotency-Key Payload Conflict",
      status: 409,
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different auth payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each authentication or verification request.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key bound to another auth payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) auth mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

