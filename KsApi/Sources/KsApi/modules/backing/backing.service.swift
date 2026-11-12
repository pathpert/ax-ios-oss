import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Backing Operations

/// Isolates legacy `ServiceType` pledge creation and update calls behind `AXProblemDetails` errors.
public protocol BackingLegacyBridgeProtocol {
  /// Creates a new backing for a project pledge.
  func createBacking(contract: ValidatedCreateBackingContract) -> Result<CreateBackingEnvelope, AXProblemDetails>
  /// Updates an existing backing's amount, rewards, location, or payment source.
  func updateBacking(contract: ValidatedUpdateBackingContract) -> Result<UpdateBackingEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating backing mutations to `ServiceType`.
public final class LegacyBackingServiceAdapter: BackingLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Creates a backing synchronously and translates legacy errors.
  public func createBacking(
    contract: ValidatedCreateBackingContract
  ) -> Result<CreateBackingEnvelope, AXProblemDetails> {
    let input = CreateBackingInput(
      amount: contract.legacyFormattedAmount,
      applePay: nil,
      incremental: contract.incremental,
      locationId: contract.locationId,
      paymentSourceId: contract.paymentSourceId,
      projectId: contract.projectId,
      refParam: contract.refParam,
      rewardIds: contract.rewardIds,
      setupIntentClientSecret: contract.setupIntentClientSecret
    )
    guard let result = self.legacyService.createBacking(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on createBacking"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "createBacking"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "createBacking")
    }
  }

  /// Updates an existing backing synchronously and translates legacy errors.
  /// Updates an existing backing idempotently while enforcing rate-limit quota.
  public func updateBacking(
    contract: ValidatedUpdateBackingContract
  ) -> Result<UpdateBackingEnvelope, AXProblemDetails> {
    let input = UpdateBackingInput(
      amount: contract.legacyFormattedAmount,
      applePay: nil,
      id: contract.backingId,
      incremental: contract.incremental,
      locationId: contract.locationId,
      paymentSourceId: contract.paymentSourceId,
      rewardIds: contract.rewardIds,
      setupIntentClientSecret: nil
    )
    guard let result = self.legacyService.updateBacking(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on updateBacking"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "updateBacking"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "updateBacking")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Backing Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating pledge backing creation and updates.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with modified pledge parameters fails with HTTP 409 conflict.
public final class BackingModuleService {
  private struct CachedCreateEntry {
    let fingerprint: CreateBackingRequestSchema
    let contract: BackingMutationContract
  }

  private struct CachedUpdateEntry {
    let fingerprint: UpdateBackingRequestSchema
    let contract: BackingMutationContract
  }

  private let bridge: BackingLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var createStore: [IdempotencyKey: CachedCreateEntry] = [:]
  private var updateStore: [IdempotencyKey: CachedUpdateEntry] = [:]

  /// Creates a `BackingModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: BackingLegacyBridgeProtocol,
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
      bridge: LegacyBackingServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Creates a backing idempotently while enforcing rate-limit quota.
  public func createBacking(
    schema: CreateBackingRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<BackingMutationContract>, AXProblemDetails> {
    if let existing = self.createStore[idempotencyKey] {
      guard existing.fingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = BackingMutationContract(
        checkoutId: existing.contract.checkoutId,
        state: existing.contract.state,
        requiresAction: existing.contract.requiresAction,
        clientSecret: existing.contract.clientSecret,
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
      self.bridge.createBacking(contract: validated).map { envelope in
        let checkout = envelope.createBacking.checkout
        let output = BackingMutationContract(
          checkoutId: checkout.id,
          state: checkout.state.rawValue,
          requiresAction: checkout.backing.requiresAction,
          clientSecret: checkout.backing.clientSecret,
          idempotencyReplayed: false
        )
        self.createStore[idempotencyKey] = CachedCreateEntry(fingerprint: schema, contract: output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Updates an existing backing idempotently while enforcing rate-limit quota.
  public func updateBacking(
    schema: UpdateBackingRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<BackingMutationContract>, AXProblemDetails> {
    if let existing = self.updateStore[idempotencyKey] {
      guard existing.fingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = BackingMutationContract(
        checkoutId: existing.contract.checkoutId,
        state: existing.contract.state,
        requiresAction: existing.contract.requiresAction,
        clientSecret: existing.contract.clientSecret,
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
      self.bridge.updateBacking(contract: validated).map { envelope in
        let checkout = envelope.updateBacking.checkout
        let output = BackingMutationContract(
          checkoutId: checkout.id,
          state: checkout.state.rawValue,
          requiresAction: checkout.backing.requiresAction,
          clientSecret: checkout.backing.clientSecret,
          idempotencyReplayed: false
        )
        self.updateStore[idempotencyKey] = CachedUpdateEntry(fingerprint: schema, contract: output)
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different backing mutation payload.",
      suggestedAction: "Generate a new UUID v4 'Idempotency-Key' when modifying backing parameters.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key already bound to a different backing payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) backing mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

