import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Auth Controller & Deprecation Guardrails

/// Agent-native REST controller for Apple Sign-In exchange and email verification mutations.
///
/// Negative Constraint: Requires a valid `Idempotency-Key` header on every request; do not use legacy `SignInWithAppleInput` or raw token queries directly.
public final class AuthController {
  /// Endpoint metadata for `POST /ax/v1/auth/apple`.
  public static let signInWithAppleEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/auth/apple",
    summary: "Exchanges an Apple Sign-In authorization code for a Kickstarter API access token with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/auth/verify-email`.
  public static let verifyEmailEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/auth/verify-email",
    summary: "Verifies a user's email address using a bare verification token with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: AuthModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates an `AuthController` backed by `service` and an optional audit hook.
  public init(
    service: AuthModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/auth/apple` after validating `Idempotency-Key`, bundle ID, and authorization code.
  public func handleSignInWithApple(
    payload: SignInWithAppleRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<AppleAuthSessionContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.signInWithAppleEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.signInWithApple(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.signInWithAppleEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        let status = res.value.idempotencyReplayed ? 200 : 201
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.signInWithAppleEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `POST /ax/v1/auth/verify-email` with bare-token and `Idempotency-Key` validation.
  public func handleVerifyEmail(
    payload: VerifyEmailRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<String>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.verifyEmailEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.verifyEmail(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.verifyEmailEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.verifyEmailEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }

  private static func extractIdempotencyHeader(from headers: [String: String]) -> String? {
    headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
  }
}

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Auth Inputs

extension SignInWithAppleInput {
  /// Deprecation descriptor redirecting callers to `SignInWithAppleRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "SignInWithAppleInput",
    meaning: "Legacy GraphQL input lacking bundle ID and authorization code boundary validation.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through SignInWithAppleInput."],
    deprecated: true,
    replacementPrimitive: "SignInWithAppleRequestSchema via AuthController.handleSignInWithApple(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `AuthController` backed by `self`.
  public func makeAXAuthController(
    rateLimitMax: Int = 20,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> AuthController {
    let service = AuthModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return AuthController(service: service, onMutationHook: onMutationHook)
  }
}

