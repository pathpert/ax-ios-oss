import Prelude

extension ProjectStatsEnvelope.ReferralAggregateStats {
  /// Functional optics namespace for `ProjectStatsEnvelope.ReferralAggregateStats`.
  public enum lens {
    /// Lens focusing on `custom` referral dollars.
    public static let custom = Lens<ProjectStatsEnvelope.ReferralAggregateStats, Double>(
      view: { $0.custom },
      set: { ProjectStatsEnvelope.ReferralAggregateStats(
        custom: $0, external: $1.external,
        kickstarter: $1.kickstarter
      ) }
    )

    /// Lens focusing on `external` referral dollars.
    public static let external = Lens<ProjectStatsEnvelope.ReferralAggregateStats, Double>(
      view: { $0.external },
      set: { ProjectStatsEnvelope.ReferralAggregateStats(
        custom: $1.custom, external: $0,
        kickstarter: $1.kickstarter
      ) }
    )

    /// Lens focusing on `kickstarter` internal referral dollars.
    public static let kickstarter = Lens<ProjectStatsEnvelope.ReferralAggregateStats, Double>(
      view: { $0.kickstarter },
      set: { ProjectStatsEnvelope.ReferralAggregateStats(
        custom: $1.custom, external: $1.external,
        kickstarter: $0
      ) }
    )
  }
}
