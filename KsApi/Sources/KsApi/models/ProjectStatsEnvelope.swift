import Foundation

/// Campaign statistics envelope returned for creator dashboards and analytics views.
///
/// - Negative constraint: Do not treat optional `videoStats` or empty distribution arrays as fatal decode errors.
public struct ProjectStatsEnvelope {
  /// Aggregate cumulative pledge totals and average pledge metrics.
  public let cumulativeStats: CumulativeStats
  /// Daily time-series breakdown of backings and pledged amounts.
  public let fundingDistribution: [FundingDateStats]
  /// Aggregate referral revenue shares across custom, external, and internal sources.
  public let referralAggregateStats: ReferralAggregateStats
  /// Per-referrer traffic and conversion metrics.
  public let referralDistribution: [ReferrerStats]
  /// Per-reward tier backing counts and pledged totals.
  public let rewardDistribution: [RewardStats]
  /// Video play and completion counts (`nil` if project has no campaign video).
  public let videoStats: VideoStats?

  /// Cumulative campaign totals snapshot.
  public struct CumulativeStats {
    /// Average pledge per backer in project currency integer units.
    public let averagePledge: Int
    /// Total number of backers across the campaign.
    public let backersCount: Int
    /// Campaign funding goal in project currency integer units.
    public let goal: Int
    /// Funding percentage (`1.0` == 100%, or backend scale matching `percent_raised`).
    public let percentRaised: Double
    /// Total amount pledged in project currency integer units.
    public let pledged: Int
  }

  /// Single-day campaign funding time-series data point.
  public struct FundingDateStats {
    /// Incremental backer count gained on `date`.
    public let backersCount: Int
    /// Cumulative pledged amount up to and including `date`.
    public let cumulativePledged: Int
    /// Cumulative backer count up to and including `date`.
    public let cumulativeBackersCount: Int
    /// Unix epoch timestamp representing the summary date.
    public let date: TimeInterval
    /// Incremental amount pledged on `date`.
    public let pledged: Int
  }

  /// Aggregate referral dollar/revenue breakdown by channel.
  public struct ReferralAggregateStats {
    /// Amount attributed to creator custom referral tags.
    public let custom: Double
    /// Amount attributed to external referrers.
    public let external: Double
    /// Amount attributed to Kickstarter internal discovery/navigation.
    public let kickstarter: Double
  }

  /// Conversion metrics for an individual traffic referrer.
  public struct ReferrerStats {
    /// Number of backers attributed to this referrer.
    public let backersCount: Int
    /// Short referral tracking code or identifier.
    public let code: String
    /// Share of total pledged dollars attributed to this referrer.
    public let percentageOfDollars: Double
    /// Total amount pledged through this referrer.
    public let pledged: Double
    /// Human-readable referrer label displayed in dashboards.
    public let referrerName: String
    /// Categorized channel type of this referrer.
    public let referrerType: ReferrerType

    /// High-level classification of a campaign referrer source.
    public enum ReferrerType: String {
      /// Creator-defined custom referral tag.
      case custom
      /// Third-party external website or social referrer.
      case external
      /// Internal Kickstarter discovery/search/feature placement.
      case `internal`
      /// Unrecognized future referrer classification (`unknown` fallback).
      case unknown
    }
  }

  /// Pledge distribution metrics for a specific reward tier.
  public struct RewardStats {
    /// Number of backers who chose this reward tier.
    public let backersCount: Int
    /// Numeric reward tier identifier (`0` for no-reward sentinel).
    public let rewardId: Int
    /// Reward tier minimum pledge threshold (`nil` if omitted).
    public let minimum: Double?
    /// Total amount pledged to this reward tier.
    public let pledged: Int

    /// Zeroed fallback `RewardStats` instance used when representing empty reward rows.
    public static let zero = RewardStats(backersCount: 0, rewardId: 0, minimum: 0.00, pledged: 0)
  }

  /// Campaign video start and completion metrics segmented by internal vs external playback.
  public struct VideoStats {
    /// Total completions recorded on external embeds.
    public let externalCompletions: Int
    /// Total starts recorded on external embeds.
    public let externalStarts: Int
    /// Total completions recorded inside Kickstarter properties.
    public let internalCompletions: Int
    /// Total starts recorded inside Kickstarter properties.
    public let internalStarts: Int
  }
}
