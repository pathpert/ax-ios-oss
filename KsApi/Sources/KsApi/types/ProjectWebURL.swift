import GraphAPI

/// Shared abstraction providing a canonical web URL string for either REST `Project` or GraphQL `ProjectFragment`.
///
/// Negative Constraint: Do not construct web URLs via string concatenation; read `projectWebURL` directly.
public protocol HasProjectWebURL {
  var projectWebURL: String { get }
}

extension Project: HasProjectWebURL {
  /// Canonical Kickstarter web URL string from `Project.urls.web.project`.
  public var projectWebURL: String {
    self.urls.web.project
  }
}

extension GraphAPI.ProjectFragment: HasProjectWebURL {
  /// Canonical Kickstarter web URL string from `ProjectFragment.url`.
  public var projectWebURL: String {
    self.url
  }
}
