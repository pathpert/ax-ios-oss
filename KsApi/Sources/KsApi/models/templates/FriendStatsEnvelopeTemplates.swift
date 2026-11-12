/// `FriendStatsEnvelope` extensions declared in `FriendStatsEnvelopeTemplates.swift`.
extension FriendStatsEnvelope {
  internal static let template = FriendStatsEnvelope(
    stats: FriendStatsEnvelope.Stats(
      friendProjectsCount: 100,
      remoteFriendsCount: 100
    )
  )
}
