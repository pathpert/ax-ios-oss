

/// Paginated creator project-activity envelope.
public struct ProjectActivityEnvelope: Decodable {
  /// Project activity entries in the current page.
  public let activities: [Activity]
  /// Pagination URL container.
  public let urls: UrlsEnvelope

  /// Pagination URL container.
  public struct UrlsEnvelope: Decodable {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope: Decodable {
      private enum CodingKeys: String, CodingKey {
        case moreActivities = "more_activities"
      }

      /// Cursor URL for fetching the next page of project activities.
      public let moreActivities: String
    }
  }
}
