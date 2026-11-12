import Foundation
import ReactiveSwift

/// Paginated GraphQL envelope containing replies to a parent `Comment`.
public struct CommentRepliesEnvelope: Decodable {
  /// Root parent comment to which `replies` belong.
  public var comment: Comment
  /// Backward pagination cursor for loading earlier replies.
  public var cursor: String?
  /// Whether earlier replies exist before `cursor`.
  public var hasPreviousPage: Bool
  /// Reply comments in the current page.
  public var replies: [Comment]
  /// Total reply count for `comment`.
  public var totalCount: Int
}

extension CommentRepliesEnvelope {
  /// Default page size requested when loading additional comment replies.
  public static let paginationLimit = 7
}
