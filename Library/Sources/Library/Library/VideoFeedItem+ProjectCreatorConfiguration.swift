import KsApi

/// `VideoFeedItem` extensions declared in `VideoFeedItem+ProjectCreatorConfiguration.swift`.
extension VideoFeedItem: HasProjectCreatorProperties {
  /// Extracts creator header properties (`id`, `name`, `projectWebURL`) from this video feed item.
  public var projectCreatorProperties: ProjectCreatorProperties {
    ProjectCreatorProperties(
      id: self.pid,
      name: self.title,
      projectWebURL: self.projectURL
    )
  }
}

extension VideoFeedItem: HasProjectWebURL {
  /// Web URL string of the project associated with this video feed item.
  public var projectWebURL: String { self.projectURL }
}
