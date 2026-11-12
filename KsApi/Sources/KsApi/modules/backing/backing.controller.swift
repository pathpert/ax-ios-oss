import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Backing Controller & Deprecation Guardrails

/// Agent-native REST controller handling validated backing creation and update mutations.
///
/// Negative Constraint: Requires an `Idempotency-Key` header and integer-cent amounts; do not use legacy string-amount `CreateBackingInput` or `UpdateBackingInput`.
public final class BackingController {
  /// Endpoint metadata for `POST /ax/v1/backings`.
  public static let createBackingEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/backings",
    summary: "Creates a new project backing using integer cents, validated GraphIDs, and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `PUT /ax/v1/backings`.
  public static let updateBackingEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/backings",
    summary: "Updates an existing project backing with Poka-Yoke boundary checks and Idempotency-Key enforcement.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: BackingModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `BackingController` backed by `service` and an optional audit hook.
  public init(
    service: BackingModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/backings` with mandatory `Idempotency-Key` validation and RFC 9457 error responses.
  public func handleCreateBacking(
    payload: CreateBackingRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<BackingMutationContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.createBackingEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.createBacking(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createBackingEndpoint.path,
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
          endpoint: Self.createBackingEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `PUT /ax/v1/backings` with mandatory `Idempotency-Key` validation and RFC 9457 error responses.
  public func handleUpdateBacking(
    payload: UpdateBackingRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<BackingMutationContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.updateBackingEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.updateBacking(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.updateBackingEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.updateBackingEndpoint.path,
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

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Backing Inputs

extension CreateBackingInput {
  /// Deprecation descriptor redirecting callers to `CreateBackingRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "CreateBackingInput",
    meaning: "Legacy GraphQL input using string amount and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through CreateBackingInput."],
    deprecated: true,
    replacementPrimitive: "CreateBackingRequestSchema via BackingController.handleCreateBacking(payload:headers:)"
  )
}

extension UpdateBackingInput {
  /// Deprecation descriptor redirecting callers to `UpdateBackingRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "UpdateBackingInput",
    meaning: "Legacy GraphQL input using optional string amount and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through UpdateBackingInput."],
    deprecated: true,
    replacementPrimitive: "UpdateBackingRequestSchema via BackingController.handleUpdateBacking(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `BackingController` backed by `self`.
  public func makeAXBackingController(
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> BackingController {
    let service = BackingModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return BackingController(service: service, onMutationHook: onMutationHook)
  }
}

