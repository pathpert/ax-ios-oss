import KsApi

/// Lightweight Pledged Projects Overview user summary flags tracking pending backer actions.
/// - Negative Constraint: Do not mutate counts locally without refreshing from the Pledged Projects Overview query.
public struct PPOUserSettings: Codable, Equatable {
  /// `true` if the user has at least one pending pledged project action.
  public let hasAction: Bool
  /// Total number of backings requiring user attention in Pledged Projects Overview.
  public let backingActionCount: Int

  /// Creates Pledged Projects Overview summary settings.
  public init(hasAction: Bool, backingActionCount: Int) {
    self.hasAction = hasAction
    self.backingActionCount = backingActionCount
  }
}
