

/// Paginated envelope of user or project activity feed items.
public struct ActivityEnvelope {
  /// Activity items in the current page.
  public let activities: [Activity]
  /// Pagination links for fetching subsequent activity pages.
  public let urls: UrlsEnvelope

  /// Pagination URL container.
  public struct UrlsEnvelope {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope {
      /// Cursor URL for the next page of activities (empty string when none).
      public let moreActivities: String
    }
  }
}

extension ActivityEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case activities
    case urls
  }
}

extension ActivityEnvelope.UrlsEnvelope: Decodable {}

extension ActivityEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case moreActivities = "more_activities"
  }

  /// Decodes the nested pagination envelope, defaulting absent `more_activities` cursors to `""`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.moreActivities = try values.decodeIfPresent(String.self, forKey: .moreActivities) ?? ""
  }
}
