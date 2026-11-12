import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Comments Controller & Deprecation Guardrails

/// Agent-native REST controller handling sanitized comment posting and user blocking mutations.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not route callers through legacy `PostCommentInput` or `BlockUserInput`.
public final class CommentsController {
  /// Endpoint metadata for `POST /ax/v1/comments`.
  public static let postCommentEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/comments",
    summary: "Posts a sanitized project/update comment or reply with Base64 GraphID validation and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/users/blocks`.
  public static let blockUserEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/users/blocks",
    summary: "Blocks a user by Base64 User GraphID with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: CommentsModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `CommentsController` backed by `service` and an optional audit hook.
  public init(
    service: CommentsModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/comments` after validating `Idempotency-Key`, body length, and target GraphIDs.
  public func handlePostComment(
    payload: PostCommentRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<CommentMutationContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.postCommentEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.postComment(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.postCommentEndpoint.path,
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
          endpoint: Self.postCommentEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `POST /ax/v1/users/blocks` with mandatory `Idempotency-Key` and Base64 GraphID checks.
  public func handleBlockUser(
    payload: BlockUserRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<Bool>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.blockUserEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.blockUser(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.blockUserEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.blockUserEndpoint.path,
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

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Comment & Block Inputs

extension PostCommentInput {
  /// Deprecation descriptor redirecting callers to `PostCommentRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "PostCommentInput",
    meaning: "Legacy GraphQL input using untyped [String: Any] dictionary serialization and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows through PostCommentInput.",
      "Do not use toInputDictionary() -> [String: Any]."
    ],
    deprecated: true,
    replacementPrimitive: "PostCommentRequestSchema via CommentsController.handlePostComment(payload:headers:)"
  )
}

extension BlockUserInput {
  /// Deprecation descriptor redirecting callers to `BlockUserRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "BlockUserInput",
    meaning: "Legacy GraphQL input lacking Base64 User GraphID validation and Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through BlockUserInput."],
    deprecated: true,
    replacementPrimitive: "BlockUserRequestSchema via CommentsController.handleBlockUser(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `CommentsController` backed by `self`.
  public func makeAXCommentsController(
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> CommentsController {
    let service = CommentsModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return CommentsController(service: service, onMutationHook: onMutationHook)
  }
}

