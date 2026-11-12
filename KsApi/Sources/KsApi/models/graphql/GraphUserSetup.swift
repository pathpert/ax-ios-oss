import Foundation

/// Viewer account setup payload decoded from GraphQL (`me`), including email and enabled server features.
///
/// Negative Constraint: Do not mutate as persistent cache; refresh on login and app foregrounding.
public struct GraphUserSetup: Decodable, Equatable {
  /// Verified or pending primary account email address, if available.
  public var email: String?
  /// Server-evaluated feature flags enabled for this user/session.
  public var enabledFeatures: Set<ServerFeature>
  /// Whether the backer has at least one pending Post-Campaign Pledge Manager / PPO action.
  public var ppoHasAction: Bool?
  /// Count of backings requiring user action (e.g. errored payment or incomplete survey).
  public var backingActionCount: Int?
}
