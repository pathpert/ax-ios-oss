

/// Paginated REST envelope returned by project discovery queries.
public struct DiscoveryEnvelope: Decodable {
  /// Projects matching the query in the current page.
  public let projects: [Project]
  /// Pagination cursor URLs.
  public let urls: UrlsEnvelope
  /// Aggregate result count metadata.
  public let stats: StatsEnvelope

  /// Pagination URL container.
  public struct UrlsEnvelope: Decodable {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope {
      /// Cursor URL for fetching the next discovery page.
      public let moreProjects: String
    }
  }

  /// Aggregate match statistics for a discovery query.
  public struct StatsEnvelope: Decodable {
    /// Total number of projects matching the discovery filter.
    public let count: Int
  }
}

extension DiscoveryEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case moreProjects = "more_projects"
  }
}
