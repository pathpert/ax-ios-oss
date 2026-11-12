import Foundation

/// REST-backed comment payload returned by `/v1/projects/\(project.id)/activities`.
/// - Negative Constraint: Legacy model paired with `ActivityCommentAuthor` because GraphQL lacks this activity feed endpoint; prefer `Comment` elsewhere.
public struct ActivityComment {
  /// Comment author metadata from the REST activity feed.
  public let author: ActivityCommentAuthor
  /// Plain-text comment body.
  public let body: String
  /// Unix timestamp (seconds since epoch) when the comment was posted.
  public let createdAt: TimeInterval
  /// Deletion timestamp in Unix seconds, or `nil` when active (server `0` coalesces to `nil`).
  public let deletedAt: TimeInterval?
  /// Numeric identifier of the comment.
  public let id: Int
}

extension ActivityComment: Decodable {
  enum CodingKeys: String, CodingKey {
    case author
    case body
    case createdAt = "created_at"
    case deletedAt = "deleted_at"
    case id
  }

  /// Decodes an activity comment payload, coalescing non-positive `deleted_at` timestamps to `nil`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.author = try values.decode(ActivityCommentAuthor.self, forKey: .author)
    self.body = try values.decode(String.self, forKey: .body)
    self.createdAt = try values.decode(TimeInterval.self, forKey: .createdAt)
    self.id = try values.decode(Int.self, forKey: .id)

    // Decode a time interval so that non-positive values are coalesced to `nil`. We do this because the API
    // sends back `0` when the comment hasn't been deleted, and we'd rather handle that value as `nil`.
    let value = try values.decodeIfPresent(TimeInterval.self, forKey: .deletedAt) ?? 0
    self.deletedAt = value > 0 ? value : nil
  }
}

extension ActivityComment: Equatable {}

/// Compares two activity comments by `id`.
public func == (lhs: ActivityComment, rhs: ActivityComment) -> Bool {
  return lhs.id == rhs.id
}
