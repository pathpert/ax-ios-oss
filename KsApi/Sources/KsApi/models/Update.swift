
import Foundation

/// Creator project update post model returned by updates and activity endpoints.
///
/// Format: `publishedAt` is a Unix epoch timestamp in seconds; `sequence` is 1-based per project.
/// Negative Constraint: `body` is omitted (`nil`) in index summaries; fetch the single-update endpoint for full HTML copy.
public struct Update {
  /// HTML body content of the update, or `nil` on summary responses.
  public let body: String?
  /// Total number of comments posted on this update, if available.
  public let commentsCount: Int?
  /// `true` if the authenticated viewer has liked this update.
  public let hasLiked: Bool?
  /// Server-assigned numeric update identifier.
  public let id: Int
  /// `true` if the update is publicly visible; `false` when backers-only.
  public let isPublic: Bool
  /// Total number of likes on this update, if available.
  public let likesCount: Int?
  /// Numeric identifier of the parent `Project`.
  public let projectId: Int
  /// Publication time as Unix epoch seconds, or `nil` if unpublished draft.
  public let publishedAt: TimeInterval?
  /// 1-based ordinal sequence number of the update within the project.
  public let sequence: Int
  /// Update headline title.
  public let title: String
  /// Canonical web URLs associated with this update.
  public let urls: UrlsEnvelope
  /// Authoring creator `User`, if included in the payload.
  public let user: User?
  /// `true` when the update is visible to the requesting user.
  public let visible: Bool?

  /// Container for web URL routing metadata of an `Update`.
  public struct UrlsEnvelope {
    /// Web link group for this update.
    public let web: WebEnvelope

    /// Direct web URLs targeting the update detail page.
    public struct WebEnvelope {
      /// Canonical HTTPS URL string of the update page.
      public let update: String
    }
  }
}

extension Update: Equatable {}

/// Compares two `Update` values by their unique server `id`.
public func == (lhs: Update, rhs: Update) -> Bool {
  return lhs.id == rhs.id
}

extension Update: Decodable {
  enum CodingKeys: String, CodingKey {
    case body
    case commentsCount = "comments_count"
    case hasLiked = "has_liked"
    case id
    case isPublic = "public"
    case likesCount = "likes_count"
    case projectId = "project_id"
    case publishedAt = "published_at"
    case sequence
    case title
    case urls
    case user
    case visible
  }

  /// Decodes a project `Update` payload, defaulting omitted titles to an empty string.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.body = try values.decodeIfPresent(String.self, forKey: .body)
    self.commentsCount = try values.decodeIfPresent(Int.self, forKey: .commentsCount)
    self.hasLiked = try values.decodeIfPresent(Bool.self, forKey: .hasLiked)
    self.id = try values.decode(Int.self, forKey: .id)
    self.isPublic = try values.decode(Bool.self, forKey: .isPublic)
    self.likesCount = try values.decodeIfPresent(Int.self, forKey: .likesCount)
    self.projectId = try values.decode(Int.self, forKey: .projectId)
    self.publishedAt = try values.decodeIfPresent(TimeInterval.self, forKey: .publishedAt)
    self.sequence = try values.decode(Int.self, forKey: .sequence)
    self.title = try values.decodeIfPresent(String.self, forKey: .title) ?? ""
    self.urls = try values.decode(Update.UrlsEnvelope.self, forKey: .urls)
    self.user = try values.decodeIfPresent(User.self, forKey: .user)
    self.visible = try values.decodeIfPresent(Bool.self, forKey: .visible)
  }
}

extension Update.UrlsEnvelope.WebEnvelope: Swift.Codable {}

extension Update.UrlsEnvelope: Swift.Codable {}
