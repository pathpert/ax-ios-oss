import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Attribution & Push Registration

/// Isolates legacy `ServiceType` attribution and push-token calls behind `AXProblemDetails` errors.
public protocol AttributionLegacyBridgeProtocol {
  /// Dispatches a validated third-party attribution event.
  func triggerThirdPartyEvent(
    contract: ValidatedThirdPartyEventContract,
    clientMutationId: String
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails>
  /// Registers an APNs device token for the active user session.
  func registerPushToken(token: String) -> Result<VoidEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating attribution calls to `ServiceType`.
public final class LegacyAttributionServiceAdapter: AttributionLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Executes `triggerThirdPartyEventInput` synchronously and translates legacy errors.
  public func triggerThirdPartyEvent(
    contract: ValidatedThirdPartyEventContract,
    clientMutationId: String
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = TriggerThirdPartyEventInput(
      deviceId: contract.deviceId,
      eventName: contract.eventName,
      projectId: contract.projectId,
      pledgeAmount: contract.legacyPledgeDollars,
      shipping: contract.legacyShippingDollars,
      transactionId: contract.transactionId,
      userId: contract.userId,
      appData: nil,
      clientMutationId: clientMutationId
    )
    guard let result = self.legacyService.triggerThirdPartyEventInput(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on triggerThirdPartyEventInput"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "triggerThirdPartyEventInput"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "triggerThirdPartyEventInput")
    }
  }

  /// Registers an APNs hex token synchronously and translates legacy errors.
  /// Registers an APNs token with idempotency replay protection and quota enforcement.
  public func registerPushToken(token: String) -> Result<VoidEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.register(pushToken: token).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on registerPushToken"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "registerPushToken"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "registerPushToken")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Attribution Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating attribution events and push registration.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified payload fails with HTTP 409 conflict.
public final class AttributionModuleService {
  private let bridge: AttributionLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var eventStore: [IdempotencyKey: TriggerThirdPartyEventRequestSchema] = [:]
  private var pushStore: [IdempotencyKey: RegisterPushTokenRequestSchema] = [:]

  /// Creates an `AttributionModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: AttributionLegacyBridgeProtocol,
    rateLimitMax: Int = 100,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 100,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15
  ) {
    self.init(
      bridge: LegacyAttributionServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Records a third-party event with idempotency replay protection and quota enforcement.
  public func triggerThirdPartyEvent(
    schema: TriggerThirdPartyEventRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<Bool>, AXProblemDetails> {
    if let saved = self.eventStore[idempotencyKey] {
      guard saved == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      return .success(AXServiceResponse(
        value: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.triggerThirdPartyEvent(contract: validated, clientMutationId: idempotencyKey.rawValue).map { _ in
        self.eventStore[idempotencyKey] = schema
        return AXServiceResponse(
          value: true,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Registers an APNs token with idempotency replay protection and quota enforcement.
  public func registerPushToken(
    schema: RegisterPushTokenRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<String>, AXProblemDetails> {
    if let saved = self.pushStore[idempotencyKey] {
      guard saved == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      return .success(AXServiceResponse(
        value: saved.apnsHexToken.lowercased(),
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { normalizedToken in
      self.bridge.registerPushToken(token: normalizedToken).map { _ in
        self.pushStore[idempotencyKey] = schema
        return AXServiceResponse(
          value: normalizedToken,
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different attribution/push payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each attribution event or push token registration.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key bound to another payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) attribution requests exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

