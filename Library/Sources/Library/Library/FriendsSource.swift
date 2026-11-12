/// Analytics attribution source from which a Find Friends flow was entered.
public enum FriendsSource {
  /// Entered from the Discovery feed banner/prompt.
  case discovery
  /// Entered from the Find Friends onboarding/referral flow.
  case findFriends
  /// Entered from account Settings.
  case settings

  /// Analytics event tag string representing the entry source.
  public var trackingString: String {
    switch self {
    case .discovery: return "discovery"
    case .findFriends: return "find-friends"
    case .settings: return "settings"
    }
  }
}
