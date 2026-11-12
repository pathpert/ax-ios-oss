

/// Response envelope containing friend-activity summary counters for the current user.
public struct FriendStatsEnvelope {
  /// Decoded friend statistics payload.
  public let stats: Stats

  /// Aggregate friend and backed-project counts returned by the API.
  public struct Stats {
    /// Number of projects backed by the viewer's friends.
    public let friendProjectsCount: Int
    /// Number of remote Kickstarter friends followed by the viewer.
    public let remoteFriendsCount: Int
  }
}

extension FriendStatsEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case stats
  }
}

extension FriendStatsEnvelope.Stats: Decodable {
  enum CodingKeys: String, CodingKey {
    case friendProjectsCount = "friend_projects_count"
    case remoteFriendsCount = "remote_friends_count"
  }
}
