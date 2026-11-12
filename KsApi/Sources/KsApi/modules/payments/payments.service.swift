import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Payments

/// Isolates legacy `ServiceType` payment intent and source deletion calls behind `AXProblemDetails`.
public protocol PaymentsLegacyBridgeProtocol {
  /// Creates a payment intent for a pledge checkout.
  func createPaymentIntent(contract: ValidatedPaymentIntentContract) -> Result<PaymentIntentEnvelope, AXProblemDetails>
  /// Deletes a saved payment source from the user's account.
  func deletePaymentSource(paymentSourceId: String) -> Result<DeletePaymentMethodEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating payment operations to `ServiceType`.
public final class LegacyPaymentsServiceAdapter: PaymentsLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Creates a payment intent synchronously and translates legacy errors.
  public func createPaymentIntent(
    contract: ValidatedPaymentIntentContract
  ) -> Result<PaymentIntentEnvelope, AXProblemDetails> {
    let input = CreatePaymentIntentInput(
      projectId: contract.projectId,
      backingId: contract.backingId,
      amountDollars: contract.legacyAmountDollars,
      checkoutId: contract.checkoutId,
      digitalMarketingAttributed: contract.digitalMarketingAttributed
    )
    guard let result = self.legacyService.createPaymentIntentInput(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on createPaymentIntent"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "createPaymentIntent"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "createPaymentIntent")
    }
  }

  /// Deletes a stored payment method synchronously and translates legacy errors.
  /// Deletes a saved payment source idempotently while enforcing rate-limit quota.
  public func deletePaymentSource(
    paymentSourceId: String
  ) -> Result<DeletePaymentMethodEnvelope, AXProblemDetails> {
    let input = PaymentSourceDeleteInput(paymentSourceId: paymentSourceId)
    guard let result = self.legacyService.deletePaymentMethod(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on deletePaymentMethod"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "deletePaymentMethod"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "deletePaymentMethod")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Payments Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating payment intent creation and payment source deletion.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified payment payload fails with HTTP 409 conflict.
public final class PaymentsModuleService {
  private struct CachedIntentEntry {
    let fingerprint: CreatePaymentIntentRequestSchema
    let contract: PaymentIntentContract
  }

  private struct CachedDeleteEntry {
    let fingerprint: DeletePaymentSourceRequestSchema
    let contract: DeletedPaymentSourceContract
  }

  private let bridge: PaymentsLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var intentStore: [IdempotencyKey: CachedIntentEntry] = [:]
  private var deleteStore: [IdempotencyKey: CachedDeleteEntry] = [:]

  /// Creates a `PaymentsModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: PaymentsLegacyBridgeProtocol,
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
      bridge: LegacyPaymentsServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Creates a payment intent idempotently while enforcing rate-limit quota.
  public func createPaymentIntent(
    schema: CreatePaymentIntentRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<PaymentIntentContract>, AXProblemDetails> {
    if let existing = self.intentStore[idempotencyKey] {
      guard existing.fingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = PaymentIntentContract(
        clientSecret: existing.contract.clientSecret,
        amountInCents: existing.contract.amountInCents,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() {
      return .failure(rateLimitError)
    }

    return schema.validate().flatMap { validated in
      self.bridge.createPaymentIntent(contract: validated).map { envelope in
        let output = PaymentIntentContract(
          clientSecret: envelope.clientSecret,
          amountInCents: validated.amountInCents,
          idempotencyReplayed: false
        )
        self.intentStore[idempotencyKey] = CachedIntentEntry(fingerprint: schema, contract: output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Deletes a saved payment source idempotently while enforcing rate-limit quota.
  public func deletePaymentSource(
    schema: DeletePaymentSourceRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<DeletedPaymentSourceContract>, AXProblemDetails> {
    if let existing = self.deleteStore[idempotencyKey] {
      guard existing.fingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = DeletedPaymentSourceContract(
        deletedPaymentSourceId: existing.contract.deletedPaymentSourceId,
        remainingStoredCardsCount: existing.contract.remainingStoredCardsCount,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() {
      return .failure(rateLimitError)
    }

    return schema.validate().flatMap { validatedId in
      self.bridge.deletePaymentSource(paymentSourceId: validatedId).map { envelope in
        let output = DeletedPaymentSourceContract(
          deletedPaymentSourceId: validatedId,
          remainingStoredCardsCount: envelope.storedCards.count,
          idempotencyReplayed: false
        )
        self.deleteStore[idempotencyKey] = CachedDeleteEntry(fingerprint: schema, contract: output)
        return AXServiceResponse(
          value: output,
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different payment payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' when changing payment intent or card deletion parameters.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key already bound to a different payment payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) payment mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as indicated by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

