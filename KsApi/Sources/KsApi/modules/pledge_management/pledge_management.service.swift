import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Pledge Management

/// Isolates legacy `ServiceType` checkout validation calls behind `AXProblemDetails` errors.
public protocol PledgeManagementLegacyBridgeProtocol {
  /// Validates a checkout session against a payment source and client secret.
  func validateCheckout(schema: ValidateCheckoutRequestSchema) -> Result<ValidateCheckoutEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating checkout validation to `ServiceType`.
public final class LegacyPledgeManagementServiceAdapter: PledgeManagementLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Validates the checkout synchronously and translates legacy errors.
  public func validateCheckout(
    schema: ValidateCheckoutRequestSchema
  ) -> Result<ValidateCheckoutEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.validateCheckout(
      checkoutId: schema.checkoutId,
      paymentSourceId: schema.paymentSourceId,
      paymentIntentClientSecret: schema.paymentIntentClientSecret
    ).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on validateCheckout"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "validateCheckout"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "validateCheckout")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Pledge Management Module Service

/// Rate-limited, idempotent service orchestrating checkout payment validation.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with different validation parameters returns HTTP 409 conflict.
public final class PledgeManagementModuleService {
  private let bridge: PledgeManagementLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var validationStore: [IdempotencyKey: (ValidateCheckoutRequestSchema, ValidatedCheckoutStatusContract)] = [:]

  /// Creates a `PledgeManagementModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: PledgeManagementLegacyBridgeProtocol,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30
  ) {
    self.init(
      bridge: LegacyPledgeManagementServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Validates a checkout session idempotently while enforcing rate-limit quota.
  public func validateCheckout(
    schema: ValidateCheckoutRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<ValidatedCheckoutStatusContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.validationStore[idempotencyKey] {
      guard savedSchema == schema else {
        return .failure(AXProblemDetails(
          type: "https://docs.kickstarter.com/errors/idempotency-conflict",
          title: "Idempotency-Key Payload Conflict",
          status: 409,
          detail: "Idempotency-Key '\(idempotencyKey.rawValue)' was already used with a different checkout validation payload.",
          suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' when validating a different checkout or payment source.",
          isRetriable: false,
          invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key bound to another payload.")]
        ))
      }
      let replayed = ValidatedCheckoutStatusContract(
        checkoutId: contract.checkoutId,
        isValid: contract.isValid,
        validationMessages: contract.validationMessages,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) checkout validations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().flatMap { validated in
      self.bridge.validateCheckout(schema: validated).map { env in
        let output = ValidatedCheckoutStatusContract(
          checkoutId: validated.checkoutId,
          isValid: true,
          validationMessages: env.messages,
          idempotencyReplayed: false
        )
        self.validationStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }
}

