import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Social Graph & Friend Following

/// Poka-Yoke request schema for following or unfollowing another Kickstarter user.
///
/// - Negative constraint: `targetUserId` must be `> 0` and must differ from `currentAuthenticatedUserId` (self-follow is forbidden).
public struct FollowFriendRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the user to follow or unfollow.
  public let targetUserId: Int
  /// Optional identifier of the signed-in caller used to reject self-follow attempts.
  public let currentAuthenticatedUserId: Int?

  /// Field-level descriptors and negative constraints for `FollowFriendRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "targetUserId": .describe(
      field: "targetUserId",
      meaning: "Positive integer identifier of the Kickstarter user to follow or unfollow.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative integers.",
        "Do not pass the currently authenticated user's own ID (self-follow is forbidden).",
        "Do not use for bulk/automated mass-follow operations."
      ]
    )
  ]

  /// Creates a `FollowFriendRequestSchema` payload.
  public init(targetUserId: Int, currentAuthenticatedUserId: Int? = nil) {
    self.targetUserId = targetUserId
    self.currentAuthenticatedUserId = currentAuthenticatedUserId
  }

  /// Validates positive `targetUserId` and enforces the self-follow prohibition.
  public func validate() -> Result<Int, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.targetUserId <= 0 {
      violations.append(AXInvalidParam(name: "targetUserId", reason: "Must be a positive integer > 0."))
    } else if let selfId = self.currentAuthenticatedUserId, selfId == self.targetUserId {
      violations.append(AXInvalidParam(
        name: "targetUserId",
        reason: "Cannot follow or unfollow the currently authenticated user (self-follow forbidden)."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Social follow/unfollow request failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide a positive integer targetUserId > 0 that is distinct from currentAuthenticatedUserId.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(self.targetUserId)
  }
}

/// Idempotent social follow/unfollow status contract.
public struct SocialFollowContract: Codable, Equatable, Sendable {
  /// Target Kickstarter user identifier.
  public let targetUserId: Int
  /// Resulting follow state (`true` = following, `false` = unfollowed).
  public let isFollowing: Bool
  /// `true` when returned from the idempotency cache without re-submitting.
  public let idempotencyReplayed: Bool

  /// Creates a `SocialFollowContract`.
  public init(targetUserId: Int, isFollowing: Bool, idempotencyReplayed: Bool = false) {
    self.targetUserId = targetUserId
    self.isFollowing = isFollowing
    self.idempotencyReplayed = idempotencyReplayed
  }
}

