import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Social Graph

/// Isolates legacy `ServiceType` friend-follow calls behind `AXProblemDetails` errors.
public protocol SocialLegacyBridgeProtocol {
  /// Follows another Kickstarter user by numeric ID.
  func followFriend(userId: Int) -> Result<User, AXProblemDetails>
  /// Unfollows another Kickstarter user by numeric ID.
  func unfollowFriend(userId: Int) -> Result<VoidEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating social graph calls to `ServiceType`.
public final class LegacySocialServiceAdapter: SocialLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Follows a friend synchronously and translates legacy errors.
  public func followFriend(userId: Int) -> Result<User, AXProblemDetails> {
    guard let result = self.legacyService.followFriend(userId: userId).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on followFriend"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "followFriend"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "followFriend") }
  }

  /// Unfollows a friend synchronously and translates legacy errors.
  /// Unfollows a friend idempotently while enforcing rate-limit quota.
  public func unfollowFriend(userId: Int) -> Result<VoidEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.unfollowFriend(userId: userId).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on unfollowFriend"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "unfollowFriend"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "unfollowFriend") }
  }
}

// MARK: - Rule 2 & Rule 5: Social Module Service

/// Rate-limited, idempotent service orchestrating social friend follow and unfollow mutations.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a different target user ID fails with HTTP 409 conflict.
public final class SocialModuleService {
  private let bridge: SocialLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var followStore: [IdempotencyKey: (FollowFriendRequestSchema, SocialFollowContract)] = [:]
  private var unfollowStore: [IdempotencyKey: (FollowFriendRequestSchema, SocialFollowContract)] = [:]

  /// Creates a `SocialModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: SocialLegacyBridgeProtocol,
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
      bridge: LegacySocialServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Follows a friend idempotently while enforcing rate-limit quota.
  public func followFriend(
    schema: FollowFriendRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<SocialFollowContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.followStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = SocialFollowContract(
        targetUserId: contract.targetUserId,
        isFollowing: contract.isFollowing,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { userId in
      self.bridge.followFriend(userId: userId).map { _ in
        let output = SocialFollowContract(targetUserId: userId, isFollowing: true)
        self.followStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Unfollows a friend idempotently while enforcing rate-limit quota.
  public func unfollowFriend(
    schema: FollowFriendRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<SocialFollowContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.unfollowStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = SocialFollowContract(
        targetUserId: contract.targetUserId,
        isFollowing: contract.isFollowing,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { userId in
      self.bridge.unfollowFriend(userId: userId).map { _ in
        let output = SocialFollowContract(targetUserId: userId, isFollowing: false)
        self.unfollowStore[idempotencyKey] = (schema, output)
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
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different social follow/unfollow payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each follow or unfollow operation.",
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
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) social mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

