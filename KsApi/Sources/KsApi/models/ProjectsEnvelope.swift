

/// Generic paginated list envelope of `Project` models and pagination URLs.
public struct ProjectsEnvelope: Decodable {
  /// Projects in the current page.
  public let projects: [Project]
  /// Pagination URL container.
  public let urls: UrlsEnvelope

  /// Pagination URL container.
  public struct UrlsEnvelope: Decodable {
    /// REST API pagination links.
    public let api: ApiEnvelope

    /// Nested API pagination URLs.
    public struct ApiEnvelope {
      /// Cursor URL for the next page of projects, or empty string when exhausted.
      public let moreProjects: String
    }
  }
}

extension ProjectsEnvelope.UrlsEnvelope.ApiEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case moreProjects = "more_projects"
  }

  /// Decodes the API pagination envelope, defaulting absent `more_projects` URLs to `""`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.moreProjects = try values.decodeIfPresent(String.self, forKey: .moreProjects) ?? ""
  }
}
