import Prelude

extension FriendStatsEnvelope {
  /// Functional optics namespace for `FriendStatsEnvelope`.
  public enum lens {
    /// Lens focusing on nested `FriendStatsEnvelope.Stats`.
    public static let stats = Lens<FriendStatsEnvelope, FriendStatsEnvelope.Stats>(
      view: { $0.stats },
      set: { stats, _ in FriendStatsEnvelope(stats: stats) }
    )
  }
}

extension Lens where Whole == FriendStatsEnvelope, Part == FriendStatsEnvelope.Stats {
  /// Composed lens focusing on `friendProjectsCount`.
  public var friendProjectsCount: Lens<FriendStatsEnvelope, Int> {
    return FriendStatsEnvelope.lens.stats .. FriendStatsEnvelope.Stats.lens.friendProjectsCount
  }

  /// Composed lens focusing on `remoteFriendsCount`.
  public var remoteFriendsCount: Lens<FriendStatsEnvelope, Int> {
    return FriendStatsEnvelope.lens.stats .. FriendStatsEnvelope.Stats.lens.remoteFriendsCount
  }
}
