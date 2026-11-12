import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Social Controller & Deprecation Guardrails

/// Agent-native REST controller for following and unfollowing users.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not invoke bulk `ServiceType.followAllFriends()` in automated workflows.
public final class SocialController {
  /// Endpoint metadata for `POST /ax/v1/social/friends`.
  public static let followFriendEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/social/friends",
    summary: "Follows a Kickstarter user with self-follow prevention and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `DELETE /ax/v1/social/friends`.
  public static let unfollowFriendEndpoint = AXEndpointDescriptor(
    method: "DELETE",
    path: "/ax/v1/social/friends",
    summary: "Unfollows a Kickstarter user with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: SocialModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `SocialController` backed by `service` and an optional audit hook.
  public init(
    service: SocialModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/social/friends` with self-follow prevention and `Idempotency-Key` safety.
  public func handleFollowFriend(
    payload: FollowFriendRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<SocialFollowContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.followFriendEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.followFriend(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.followFriendEndpoint.path,
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
          endpoint: Self.followFriendEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `DELETE /ax/v1/social/friends` with `Idempotency-Key` safety.
  public func handleUnfollowFriend(
    payload: FollowFriendRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<SocialFollowContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.unfollowFriendEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.unfollowFriend(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.unfollowFriendEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.unfollowFriendEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }
}

extension FriendStatsEnvelope {
  /// Deprecation descriptor redirecting bulk-follow callers to `FollowFriendRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ServiceType.followAllFriends",
    meaning: "Legacy bulk friend follow endpoint lacking per-target validation and Idempotency-Key safety.",
    format: "Legacy REST endpoint (Deprecated)",
    negativeConstraints: ["Do not invoke ServiceType.followAllFriends() in automated agent workflows."],
    deprecated: true,
    replacementPrimitive: "FollowFriendRequestSchema via SocialController.handleFollowFriend(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `SocialController` backed by `self`.
  public func makeAXSocialController(
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> SocialController {
    let service = SocialModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return SocialController(service: service, onMutationHook: onMutationHook)
  }
}

