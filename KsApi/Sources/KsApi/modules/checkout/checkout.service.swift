import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter

/// Protocol isolating legacy KsApi Service calls behind a strictly-typed boundary.
public protocol CheckoutLegacyBridgeProtocol {
  func createCheckout(contract: ValidatedCreateCheckoutContract) -> Result<CreateCheckoutEnvelope, AXProblemDetails>
  func cancelBacking(backingId: String) -> Result<EmptyResponseEnvelope, AXProblemDetails>
}

/// Strangler Fig Adapter wrapping the monolithic `ServiceType` so `ErrorEnvelope` and `SignalProducer`
/// never leak into Agent-Native module boundaries.
public final class LegacyCheckoutServiceAdapter: CheckoutLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Executes `createCheckout` synchronously and maps `ErrorEnvelope` failures into `AXProblemDetails`.
  public func createCheckout(
    contract: ValidatedCreateCheckoutContract
  ) -> Result<CreateCheckoutEnvelope, AXProblemDetails> {
    let legacyInput = CreateCheckoutInput(
      projectId: contract.projectId,
      amount: contract.legacyFormattedAmount,
      locationId: contract.locationId,
      rewardIds: contract.rewardIds,
      refParam: contract.refParam
    )
    guard let result = self.legacyService.createCheckout(input: legacyInput).single() else {
      return .failure(Self.emptySignalProblem(operation: "createCheckout"))
    }
    return result.mapError { Self.translateLegacyError($0, operation: "createCheckout") }
  }

  /// Executes `cancelBacking` synchronously and translates legacy errors into `AXProblemDetails`.
  /// Cancels an active backing idempotently while tracking the remaining rate-limit budget.
  public func cancelBacking(backingId: String) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let legacyInput = CancelBackingInput(backingId: backingId)
    guard let result = self.legacyService.cancelBacking(input: legacyInput).single() else {
      return .failure(Self.emptySignalProblem(operation: "cancelBacking"))
    }
    return result.mapError { Self.translateLegacyError($0, operation: "cancelBacking") }
  }

  // MARK: - Rule 4: Deterministic ErrorEnvelope -> RFC 9457 Problem Details Translation

  /// Maps a legacy `ErrorEnvelope` into a structured `AXProblemDetails` descriptor.
  public static func translateLegacyError(_ envelope: ErrorEnvelope, operation: String) -> AXProblemDetails {
    let joined = envelope.errorMessages.isEmpty
      ? "Legacy upstream error during \(operation)."
      : envelope.errorMessages.joined(separator: "; ")

    switch envelope.ksrCode {
    case .AccessTokenInvalid:
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/authentication-required",
        title: "Authentication Token Invalid",
        status: 401,
        detail: "OAuth token was rejected during '\(operation)': \(joined)",
        suggestedAction: "Refresh or re-authenticate the user's OAuth token via Service.login(_:) before retrying '\(operation)'.",
        isRetriable: false
      )
    case .ValidateCheckoutError:
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/checkout-validation-failed",
        title: "Checkout Validation Failed",
        status: 422,
        detail: joined,
        suggestedAction: "Verify project state is live, reward IDs belong to the target project, and pledge amount meets the reward minimum.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "checkout", reason: joined)]
      )
    case .JSONParsingFailed, .DecodingJSONFailed, .ErrorEnvelopeJSONParsingFailed:
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/upstream-contract-violation",
        title: "Upstream Response Decoding Failed",
        status: 502,
        detail: "Failed to decode upstream response for '\(operation)': \(joined)",
        suggestedAction: "Verify GraphQL selection set fields ('id', 'paymentUrl', 'backing.id') are non-null on the upstream response.",
        isRetriable: true
      )
    default:
      let status = (400...599).contains(envelope.httpCode) ? envelope.httpCode : 502
      let retriable = status >= 500 || status == 429
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/upstream-service-error",
        title: "Upstream Service Error",
        status: status,
        detail: joined,
        suggestedAction: retriable
          ? "Wait with exponential backoff and retry '\(operation)' using the same Idempotency-Key."
          : "Inspect request payload parameters for '\(operation)' and correct invalid inputs before retrying.",
        isRetriable: retriable
      )
    }
  }

  private static func emptySignalProblem(operation: String) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/empty-upstream-stream",
      title: "Empty Upstream Signal",
      status: 502,
      detail: "Legacy SignalProducer for '\(operation)' completed without emitting a value or error.",
      suggestedAction: "Retry '\(operation)' with the same Idempotency-Key or inspect the configured ApolloClient mock.",
      isRetriable: true
    )
  }
}

// MARK: - Rule 2 & Rule 5: Checkout Module Service (Idempotency + Rate Limit Guardrails)

/// Envelope pairing a strongly-typed service response with its remaining rate-limit headers.
public struct AXServiceResponse<Value: Equatable>: Equatable {
  /// Strongly-typed response payload returned by the module service.
  public let value: Value
  /// Rate-limit budget snapshot attached to this response.
  public let rateLimitHeaders: AXRateLimitHeaders

  /// Creates an `AXServiceResponse`.
  public init(value: Value, rateLimitHeaders: AXRateLimitHeaders) {
    self.value = value
    self.rateLimitHeaders = rateLimitHeaders
  }
}

/// Rate-limited, idempotent service orchestrating checkout creation and backing cancellation.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified request returns HTTP 409 conflict.
public final class CheckoutModuleService {
  private struct CachedCheckoutEntry {
    let requestFingerprint: CreateCheckoutRequestSchema
    let session: CheckoutSessionContract
  }

  private let bridge: CheckoutLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var checkoutIdempotencyStore: [IdempotencyKey: CachedCheckoutEntry] = [:]
  private var cancelIdempotencyStore: [IdempotencyKey: String] = [:]

  /// Creates a `CheckoutModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: CheckoutLegacyBridgeProtocol,
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
      bridge: LegacyCheckoutServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Creates a checkout session with idempotency replay protection and quota enforcement.
  public func createCheckout(
    schema: CreateCheckoutRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<CheckoutSessionContract>, AXProblemDetails> {
    if let existing = self.checkoutIdempotencyStore[idempotencyKey] {
      guard existing.requestFingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = CheckoutSessionContract(
        checkoutId: existing.session.checkoutId,
        backingId: existing.session.backingId,
        paymentUrl: existing.session.paymentUrl,
        amountInCents: existing.session.amountInCents,
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

    return schema.validate().flatMap { contract in
      self.bridge.createCheckout(contract: contract).map { envelope in
        let session = CheckoutSessionContract(
          checkoutId: envelope.checkout.id,
          backingId: envelope.checkout.backingId,
          paymentUrl: envelope.checkout.paymentUrl,
          amountInCents: contract.amountInCents,
          idempotencyReplayed: false
        )
        self.checkoutIdempotencyStore[idempotencyKey] = CachedCheckoutEntry(
          requestFingerprint: schema,
          session: session
        )
        return AXServiceResponse(
          value: session,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Cancels an active backing idempotently while tracking the remaining rate-limit budget.
  public func cancelBacking(
    schema: CancelBackingRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<Bool>, AXProblemDetails> {
    if let existingBackingId = self.cancelIdempotencyStore[idempotencyKey] {
      guard existingBackingId == schema.backingId else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      return .success(AXServiceResponse(
        value: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() {
      return .failure(rateLimitError)
    }

    return schema.validate().flatMap { validatedBackingId in
      self.bridge.cancelBacking(backingId: validatedBackingId).map { _ in
        self.cancelIdempotencyStore[idempotencyKey] = validatedBackingId
        return AXServiceResponse(
          value: true,
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different mutation payload.",
      suggestedAction: "Generate a new UUID v4 for 'Idempotency-Key' when changing parameters, or restore the original payload to replay.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key already bound to a different request payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) requests exceeded (X-RateLimit-Remaining: 0).",
        suggestedAction: "Pause mutation requests for \(self.retryAfterSeconds) seconds as indicated by 'Retry-After' before retrying with the same Idempotency-Key.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}
