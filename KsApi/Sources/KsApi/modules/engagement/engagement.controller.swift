import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Engagement Controller & Deprecation Guardrails

/// Agent-native REST controller handling project watch/unwatch toggles and moderation flaggings.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not route callers through legacy `WatchProjectInput` or `CreateFlaggingInput`.
public final class EngagementController {
  /// Endpoint metadata for `POST /ax/v1/projects/watch`.
  public static let watchProjectEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/projects/watch",
    summary: "Watches (saves) a project by Base64 GraphID with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `DELETE /ax/v1/projects/watch`.
  public static let unwatchProjectEndpoint = AXEndpointDescriptor(
    method: "DELETE",
    path: "/ax/v1/projects/watch",
    summary: "Unwatches a project by Base64 GraphID with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/moderation/flaggings`.
  public static let createFlaggingEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/moderation/flaggings",
    summary: "Flags a project, comment, or post for guideline review with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: EngagementModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates an `EngagementController` backed by `service` and an optional audit hook.
  public init(
    service: EngagementModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/projects/watch` with Base64 GraphID and `Idempotency-Key` validation.
  public func handleWatchProject(
    payload: WatchProjectRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<ProjectWatchContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.watchProjectEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.watchProject(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.watchProjectEndpoint.path,
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
          endpoint: Self.watchProjectEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `DELETE /ax/v1/projects/watch` with Base64 GraphID and `Idempotency-Key` validation.
  public func handleUnwatchProject(
    payload: WatchProjectRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<ProjectWatchContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.unwatchProjectEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.unwatchProject(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.unwatchProjectEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.unwatchProjectEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `POST /ax/v1/moderation/flaggings` with `Idempotency-Key` validation and RFC 9457 error mapping.
  public func handleCreateFlagging(
    payload: CreateFlaggingRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<Bool>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.createFlaggingEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.createFlagging(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createFlaggingEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createFlaggingEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 201,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 201, headers: responseHeaders, body: res.value))
      }
    }
  }

  private static func extractIdempotencyHeader(from headers: [String: String]) -> String? {
    headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
  }
}

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Watch & Flagging Inputs

extension WatchProjectInput {
  /// Deprecation descriptor redirecting callers to `WatchProjectRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "WatchProjectInput",
    meaning: "Legacy GraphQL input using untyped dictionary serialization.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through WatchProjectInput."],
    deprecated: true,
    replacementPrimitive: "WatchProjectRequestSchema via EngagementController"
  )
}

extension CreateFlaggingInput {
  /// Deprecation descriptor redirecting callers to `CreateFlaggingRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "CreateFlaggingInput",
    meaning: "Legacy GraphQL input using untyped dictionary serialization.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through CreateFlaggingInput."],
    deprecated: true,
    replacementPrimitive: "CreateFlaggingRequestSchema via EngagementController.handleCreateFlagging(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `EngagementController` backed by `self`.
  public func makeAXEngagementController(
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> EngagementController {
    let service = EngagementModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return EngagementController(service: service, onMutationHook: onMutationHook)
  }
}

