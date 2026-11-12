import Foundation
import Prelude
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Creator Updates

/// Isolates legacy `ServiceType` creator-update calls behind `AXProblemDetails` errors.
public protocol CreatorUpdatesLegacyBridgeProtocol {
  /// Updates an existing creator update draft with validated title and body content.
  func updateDraft(contract: ValidatedUpdateDraftContract) -> Result<UpdateDraft, AXProblemDetails>
  /// Publishes a creator update draft.
  func publishDraft(schema: PublishCreatorDraftRequestSchema) -> Result<Update, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating creator-update calls to `ServiceType`.
public final class LegacyCreatorUpdatesServiceAdapter: CreatorUpdatesLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Updates the creator draft synchronously and translates legacy errors.
  public func updateDraft(
    contract: ValidatedUpdateDraftContract
  ) -> Result<UpdateDraft, AXProblemDetails> {
    let draft = UpdateDraft.template
      |> UpdateDraft.lens.update.id .~ contract.draftId
      |> UpdateDraft.lens.update.projectId .~ contract.projectId
    guard let result = self.legacyService.update(
      draft: draft,
      title: contract.sanitizedTitle,
      body: contract.sanitizedBody,
      isPublic: contract.isPublic
    ).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on updateDraft"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "updateDraft"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "updateDraft") }
  }

  /// Publishes the creator draft synchronously and translates legacy errors.
  public func publishDraft(
    schema: PublishCreatorDraftRequestSchema
  ) -> Result<Update, AXProblemDetails> {
    let draft = UpdateDraft.template
      |> UpdateDraft.lens.update.id .~ schema.draftId
      |> UpdateDraft.lens.update.projectId .~ schema.projectId
    guard let result = self.legacyService.publish(draft: draft).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on publishDraft"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "publishDraft"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "publishDraft") }
  }
}

// MARK: - Rule 2 & Rule 5: Creator Updates Module Service

/// Rate-limited, idempotent service orchestrating creator update draft edits and publishing.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified draft or publish payload returns HTTP 409 conflict.
public final class CreatorUpdatesModuleService {
  private let bridge: CreatorUpdatesLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var updateStore: [IdempotencyKey: (UpdateCreatorDraftRequestSchema, CreatorUpdateDraftContract)] = [:]
  private var publishStore: [IdempotencyKey: (PublishCreatorDraftRequestSchema, CreatorUpdateDraftContract)] = [:]

  /// Creates a `CreatorUpdatesModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: CreatorUpdatesLegacyBridgeProtocol,
    rateLimitMax: Int = 30,
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
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.init(
      bridge: LegacyCreatorUpdatesServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Updates a creator update draft idempotently while enforcing rate-limit quota.
  public func updateDraft(
    schema: UpdateCreatorDraftRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<CreatorUpdateDraftContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.updateStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = CreatorUpdateDraftContract(
        updateId: contract.updateId,
        projectId: contract.projectId,
        title: contract.title,
        isPublic: contract.isPublic,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.updateDraft(contract: validated).map { draft in
        let output = CreatorUpdateDraftContract(
          updateId: draft.update.id,
          projectId: draft.update.projectId,
          title: validated.sanitizedTitle,
          isPublic: validated.isPublic,
          idempotencyReplayed: false
        )
        self.updateStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Publishes a creator update draft idempotently while enforcing rate-limit quota.
  public func publishDraft(
    schema: PublishCreatorDraftRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<CreatorUpdateDraftContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.publishStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = CreatorUpdateDraftContract(
        updateId: contract.updateId,
        projectId: contract.projectId,
        title: contract.title,
        isPublic: contract.isPublic,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.publishDraft(schema: validated).map { update in
        let output = CreatorUpdateDraftContract(
          updateId: update.id,
          projectId: update.projectId,
          title: update.title,
          isPublic: update.isPublic ?? true,
          idempotencyReplayed: false
        )
        self.publishStore[idempotencyKey] = (schema, output)
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different creator update payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each draft update or publish action.",
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
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) creator update mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

