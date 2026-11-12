import Foundation

/// Project or creator update comment model returned by GraphQL comment queries and mutations.
///
/// Format: `id` is a GraphQL global ID; `createdAt` is Unix epoch seconds.
/// Negative Constraint: Do not pass raw integer IDs to `postComment` or reply endpoints expecting GraphQL global `id` / `parentId`.
public struct Comment {
  /// Author profile summary for the comment creator.
  public var author: Author
  /// Ordered list of role/affiliation badges displayed next to the author name.
  public var authorBadges: [AuthorBadge]
  /// Plain-text comment body content.
  public var body: String
  /// Creation timestamp in Unix epoch seconds (`nil` for unsynced local optimistic drafts).
  public let createdAt: TimeInterval?
  /// GraphQL global comment identifier.
  public var id: String
  /// `true` if the author deleted this comment.
  public var isDeleted: Bool
  /// GraphQL global ID of the parent comment when this comment is a reply; `nil` for top-level comments.
  public var parentId: String?
  /// Number of nested replies under this top-level comment (`nil` on replies).
  public var replyCount: Int?
  /// `true` if the comment has been flagged for moderation review.
  public var hasFlaggings: Bool
  /// `true` if moderation removed the comment for violating community guidelines.
  public var removedPerGuidelines: Bool
  /// `true` if moderation reviewed flags and upheld/sustained the comment.
  public var sustained: Bool

  /// Primary display badge from `authorBadges`, defaulting to `.backer` when empty.
  public var authorBadge: AuthorBadge {
    return self.authorBadges.first ?? .backer
  }

  /// `true` when `parentId != nil`, indicating a threaded reply rather than a root comment.
  public var isReply: Bool {
    return self.parentId != nil
  }

  /// Client-side optimistic submission state of the `Comment` (`unknown` for server-loaded comments).
  public var status: Status = .unknown

  /// Author metadata embedded on a `Comment`.
  public struct Author: Decodable, Equatable {
    /// GraphQL global user identifier.
    public var id: String
    /// Avatar thumbnail URL string.
    public var imageUrl: String
    /// `true` if this author has been blocked by the current viewer.
    public var isBlocked: Bool
    /// `true` if this author is the creator of the commented project.
    public var isCreator: Bool
    /// Public display name of the comment author.
    public var name: String
  }

  /// Role badge shown alongside a comment author.
  public enum AuthorBadge: String, Decodable {
    /// Official project collaborator badge.
    case collaborator
    /// Project creator badge.
    case creator
    /// Standard project backer badge.
    case backer
    /// Kickstarter Superbacker badge.
    case superbacker
    /// Badge identifying comments authored by the current viewer.
    case you
  }

  /// Client submission and retry lifecycle state for optimistically posted comments.
  public enum Status: String, Decodable {
    /// Comment submission failed and can be retried locally.
    case failed
    /// Comment retry request is currently in flight.
    case retrying
    /// Retry succeeded and the comment is confirmed by the server.
    case retrySuccess
    /// Comment was posted or loaded from the server normally.
    case success
    /// Default state before an explicit submission status is assigned.
    case unknown // Before a status is set
  }
}

extension Comment: Decodable {}

extension Comment {
  /// Builds an optimistic local `Comment` placeholder used while tracking retryable post mutations.
  public static func failableComment(
    withId id: String,
    date: Date,
    project: Project,
    parentId: String?,
    user: User,
    body: String
  ) -> Comment {
    let author = Author(
      id: "\(user.id)",
      imageUrl: user.avatar.medium,
      isBlocked: user.isBlocked,
      isCreator: project.creator == user,
      name: user.name
    )
    return Comment(
      author: author,
      authorBadges: [.you],
      body: body,
      createdAt: date.timeIntervalSince1970,
      id: id,
      isDeleted: false,
      parentId: parentId,
      replyCount: 0,
      hasFlaggings: false,
      removedPerGuidelines: false,
      sustained: false,
      status: .success
    )
  }

  /// Returns a copy of `self` with `status` updated to the given client lifecycle state.
  public func updatingStatus(to status: Comment.Status) -> Comment {
    var comment = self
    comment.status = status
    return comment
  }
}

extension Comment: Equatable {}

extension Comment {
  /// `true` if the comment is hidden from standard rendering due to deletion, removal, or active flagging.
  public var isDeletedOrFlagged: Bool {
    return self.isDeleted
      || self.removedPerGuidelines
      || self.isFlagged
  }

  /// `true` when the comment has unresolved flags (`hasFlaggings && !sustained`).
  public var isFlagged: Bool {
    self.hasFlaggings && !self.sustained
  }
}
