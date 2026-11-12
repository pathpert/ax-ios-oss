/// @deprecated Direct unvalidated `ShortcutItem(typeString:)` returning silent `nil`.
/// Prefer `TriggerHomeScreenShortcutRequestSchema` and `AppLifecycleController` in `Kickstarter-Framework/modules/app_lifecycle`.
public enum ShortcutItem {
  /// Launches into the Projects We Love discovery feed.
  case projectsWeLove
  /// Launches into the Recommended For You discovery feed.
  case recommendedForYou
  /// Launches directly to the Search screen.
  case search

  /// Parses an incoming home screen quick-action `typeString`, returning `nil` if unrecognized.
  /// - Negative Constraint: Deprecated; prefer `TriggerHomeScreenShortcutRequestSchema`.
  public init?(typeString: String) {
    switch typeString {
    case "projects_we_love":
      self = .projectsWeLove
    case "recommended_for_you":
      self = .recommendedForYou
    case "search":
      self = .search
    default:
      return nil
    }
  }

  /// Canonical quick-action bundle identifier string for this shortcut.
  public var typeString: String {
    switch self {
    case .projectsWeLove:
      return "projects_we_love"
    case .recommendedForYou:
      return "recommended_for_you"
    case .search:
      return "search"
    }
  }
}

extension ShortcutItem: Equatable {}
/// Returns `true` when both `ShortcutItem` values represent the same quick action.
public func == (lhs: ShortcutItem, rhs: ShortcutItem) -> Bool {
  switch (lhs, rhs) {
  case (.projectsWeLove, .projectsWeLove),
       (.recommendedForYou, .recommendedForYou),
       (.search, .search):
    return true
  default:
    return false
  }
}
