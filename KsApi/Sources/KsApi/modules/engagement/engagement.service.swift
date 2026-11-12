import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Engagement Operations

/// Isolates legacy `ServiceType` project-watch and flagging calls behind `AXProblemDetails` errors.
public protocol EngagementLegacyBridgeProtocol {
  /// Watches/saves a project for the current user.
  func watchProject(schema: WatchProjectRequestSchema, clientMutationId: String) -> Result<WatchProjectResponseEnvelope, AXProblemDetails>
  /// Unwatches/removes a saved project for the current user.
  func unwatchProject(schema: WatchProjectRequestSchema, clientMutationId: String) -> Result<WatchProjectResponseEnvelope, AXProblemDetails>
  /// Submits a moderation/flagging report for a project or comment.
  func createFlagging(schema: CreateFlaggingRequestSchema, clientMutationId: String) -> Result<EmptyResponseEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating engagement calls to `ServiceType`.
public final class LegacyEngagementServiceAdapter: EngagementLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Watches a project synchronously and translates legacy errors.
  public func watchProject(
    schema: WatchProjectRequestSchema,
    clientMutationId: String
  ) -> Result<WatchProjectResponseEnvelope, AXProblemDetails> {
    let input = WatchProjectInput(
      clientMutationId: clientMutationId,
      id: schema.projectId,
      trackingContext: schema.trackingContext
    )
    guard let result = self.legacyService.watchProject(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on watchProject"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "watchProject"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "watchProject") }
  }

  /// Unwatches a project synchronously and translates legacy errors.
  /// Unwatches a project idempotently while enforcing rate-limit quota.
  public func unwatchProject(
    schema: WatchProjectRequestSchema,
    clientMutationId: String
  ) -> Result<WatchProjectResponseEnvelope, AXProblemDetails> {
    let input = WatchProjectInput(
      clientMutationId: clientMutationId,
      id: schema.projectId,
      trackingContext: schema.trackingContext
    )
    guard let result = self.legacyService.unwatchProject(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on unwatchProject"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "unwatchProject"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "unwatchProject") }
  }

  /// Submits a flagging report synchronously and translates legacy errors.
  /// Submits a flagging report idempotently while enforcing rate-limit quota.
  public func createFlagging(
    schema: CreateFlaggingRequestSchema,
    clientMutationId: String
  ) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = CreateFlaggingInput(
      contentId: schema.contentId,
      kind: schema.kind,
      details: schema.details,
      clientMutationId: clientMutationId
    )
    guard let result = self.legacyService.createFlaggingInput(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on createFlaggingInput"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "createFlaggingInput"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "createFlaggingInput") }
  }
}

// MARK: - Rule 2 & Rule 5: Engagement Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating project watches, unwatches, and flagging.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified payload fails with HTTP 409 conflict.
public final class EngagementModuleService {
  private let bridge: EngagementLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var watchStore: [IdempotencyKey: (WatchProjectRequestSchema, ProjectWatchContract)] = [:]
  private var unwatchStore: [IdempotencyKey: (WatchProjectRequestSchema, ProjectWatchContract)] = [:]
  private var flaggingStore: [IdempotencyKey: CreateFlaggingRequestSchema] = [:]

  /// Creates an `EngagementModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: EngagementLegacyBridgeProtocol,
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
      bridge: LegacyEngagementServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Watches a project idempotently while enforcing rate-limit quota.
  public func watchProject(
    schema: WatchProjectRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<ProjectWatchContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.watchStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = ProjectWatchContract(
        projectId: contract.projectId,
        isWatched: contract.isWatched,
        watchesCount: contract.watchesCount,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.watchProject(schema: validated, clientMutationId: idempotencyKey.rawValue).map { env in
        let p = env.watchProject.project
        let output = ProjectWatchContract(
          projectId: p.id,
          isWatched: p.isWatched,
          watchesCount: p.watchesCount,
          idempotencyReplayed: false
        )
        self.watchStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Unwatches a project idempotently while enforcing rate-limit quota.
  public func unwatchProject(
    schema: WatchProjectRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<ProjectWatchContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.unwatchStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = ProjectWatchContract(
        projectId: contract.projectId,
        isWatched: contract.isWatched,
        watchesCount: contract.watchesCount,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.unwatchProject(schema: validated, clientMutationId: idempotencyKey.rawValue).map { env in
        let p = env.watchProject.project
        let output = ProjectWatchContract(
          projectId: p.id,
          isWatched: p.isWatched,
          watchesCount: p.watchesCount,
          idempotencyReplayed: false
        )
        self.unwatchStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Submits a flagging report idempotently while enforcing rate-limit quota.
  public func createFlagging(
    schema: CreateFlaggingRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<Bool>, AXProblemDetails> {
    if let savedSchema = self.flaggingStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      return .success(AXServiceResponse(
        value: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { validated in
      self.bridge.createFlagging(schema: validated, clientMutationId: idempotencyKey.rawValue).map { _ in
        self.flaggingStore[idempotencyKey] = schema
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different engagement payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each watch, unwatch, or flagging request.",
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
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) engagement mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

