
import Foundation

/// Author metadata nested inside REST `ActivityComment` responses.
public struct ActivityCommentAuthor: Decodable {
  /// Avatar image URLs for the comment author.
  public var avatar: Avatar
  /// Numeric user ID of the author.
  public var id: Int
  /// Display name of the author.
  public var name: String
  /// API and web profile URLs for the author.
  public var urls: Url

  /// Author avatar URL variants.
  public struct Avatar: Decodable {
    /// Medium avatar URL, when available.
    public var medium: String?
    /// Small avatar URL.
    public var small: String
    /// Thumbnail avatar URL.
    public var thumb: String
  }

  /// Nested API and web URLs pointing to the author's profile.
  public struct Url {
    /// REST API resource URL for the user.
    public var api: String
    /// Public Kickstarter web URL for the user.
    public var web: String
  }
}

extension ActivityCommentAuthor.Url: Decodable {
  enum CodingKeys: String, CodingKey {
    case api
    case user
    case web
  }

  /// Decodes nested `api.user` and `web.user` profile URLs for an activity comment author.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.api = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .api)
      .decode(String.self, forKey: .user)
    self.web = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .web)
      .decode(String.self, forKey: .user)
  }
}
