import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Creator Updates Controller & Deprecation Guardrails

/// Agent-native REST controller for updating and publishing creator project update drafts.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not call legacy `ServiceType.update(draft:...)` or `publish(draft:)` directly.
public final class CreatorUpdatesController {
  /// Endpoint metadata for `PUT /ax/v1/creator/updates/draft`.
  public static let updateDraftEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/creator/updates/draft",
    summary: "Updates a project update draft with title/body sanitization and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/creator/updates/publish`.
  public static let publishDraftEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/creator/updates/publish",
    summary: "Publishes a creator update draft with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: CreatorUpdatesModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `CreatorUpdatesController` backed by `service` and an optional audit hook.
  public init(
    service: CreatorUpdatesModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `PUT /ax/v1/creator/updates/draft` with title/body validation and `Idempotency-Key` safety.
  public func handleUpdateDraft(
    payload: UpdateCreatorDraftRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<CreatorUpdateDraftContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.updateDraftEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.updateDraft(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.updateDraftEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.updateDraftEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `POST /ax/v1/creator/updates/publish` with `Idempotency-Key` replay protection.
  public func handlePublishDraft(
    payload: PublishCreatorDraftRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<CreatorUpdateDraftContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.publishDraftEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.publishDraft(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.publishDraftEndpoint.path,
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
          endpoint: Self.publishDraftEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }
}

extension UpdateDraft {
  /// Deprecation descriptor redirecting callers to `UpdateCreatorDraftRequestSchema` / `PublishCreatorDraftRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "UpdateDraft",
    meaning: "Legacy REST v1 update draft model used in unguarded ServiceType.update(draft:title:body:isPublic:) calls.",
    format: "Legacy struct (Deprecated direct mutation)",
    negativeConstraints: ["Do not invoke ServiceType.update(draft:...) or publish(draft:) without Idempotency-Key guardrails."],
    deprecated: true,
    replacementPrimitive: "UpdateCreatorDraftRequestSchema / PublishCreatorDraftRequestSchema via CreatorUpdatesController"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `CreatorUpdatesController` backed by `self`.
  public func makeAXCreatorUpdatesController(
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> CreatorUpdatesController {
    let service = CreatorUpdatesModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return CreatorUpdatesController(service: service, onMutationHook: onMutationHook)
  }
}

