import Foundation

extension ProjectStatsEnvelope: Decodable {
  private enum CodingKeys: String, CodingKey {
    case cumulativeStats = "cumulative"
    case fundingDistribution = "funding_distribution"
    case referralAggregateStats = "referral_aggregates"
    case referralDistribution = "referral_distribution"
    case rewardDistribution = "reward_distribution"
    case videoStats = "video_stats"
  }

  /// Decodes a `ProjectStatsEnvelope` from campaign dashboard JSON, skipping malformed date buckets.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.cumulativeStats = try values.decode(CumulativeStats.self, forKey: .cumulativeStats)
    self.fundingDistribution = try values.decode(
      [OptionalObject<FundingDateStats>].self,
      forKey: .fundingDistribution
    ).compactMap { $0.value }
    self.referralAggregateStats = try values
      .decode(ReferralAggregateStats.self, forKey: .referralAggregateStats)
    self.referralDistribution = try values.decode([ReferrerStats].self, forKey: .referralDistribution)
    self.rewardDistribution = try values.decode([RewardStats].self, forKey: .rewardDistribution)
    self.videoStats = try values.decodeIfPresent(VideoStats.self, forKey: .videoStats)
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Decodable {
  enum CodingKeys: String, CodingKey {
    case averagePledge = "average_pledge"
    case backersCount = "backers_count"
    case goal
    case percentRaised = "percent_raised"
    case pledged
  }

  /// Decodes cumulative campaign stats from REST JSON.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.averagePledge = try Int(values.decode(Double.self, forKey: .averagePledge))
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.goal = try stringToIntOrZero(values.decode(String.self, forKey: .goal))
    self.percentRaised = try values.decode(Double.self, forKey: .percentRaised)
    self.pledged = try stringToIntOrZero(values.decode(String.self, forKey: .pledged))
  }
}

extension ProjectStatsEnvelope.CumulativeStats: Equatable {}
/// Compares two `CumulativeStats` values by `averagePledge` to preserve legacy equality semantics.
public func == (lhs: ProjectStatsEnvelope.CumulativeStats, rhs: ProjectStatsEnvelope.CumulativeStats)
  -> Bool {
  return lhs.averagePledge == rhs.averagePledge
}

extension ProjectStatsEnvelope.FundingDateStats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count"
    case cumulativePledged = "cumulative_pledged"
    case cumulativeBackersCount = "cumulative_backers_count"
    case date
    case pledged
  }

  /// Decodes a funding date data point from REST JSON.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try values.decodeIfPresent(Int.self, forKey: .backersCount) ?? 0
    if let value = try? values.decode(String.self, forKey: .cumulativePledged) {
      self.cumulativePledged = stringToIntOrZero(value)
    } else {
      self.cumulativePledged = try values.decode(Int.self, forKey: .cumulativePledged)
    }
    self.cumulativeBackersCount = try values.decode(Int.self, forKey: .cumulativeBackersCount)
    self.date = try values.decode(TimeInterval.self, forKey: .date)
    if let value = try? values.decode(String.self, forKey: .pledged) {
      self.pledged = stringToIntOrZero(value)
    } else {
      self.pledged = 0
    }
  }
}

extension ProjectStatsEnvelope.FundingDateStats: Equatable {}
/// Compares two `FundingDateStats` values by timestamp `date`.
public func == (lhs: ProjectStatsEnvelope.FundingDateStats, rhs: ProjectStatsEnvelope.FundingDateStats)
  -> Bool {
  return lhs.date == rhs.date
}

extension ProjectStatsEnvelope.ReferralAggregateStats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case custom
    case external
    case kickstarter = "internal"
  }

  /// Decodes referral aggregate stats from REST JSON.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.custom = try values.decode(Double.self, forKey: .custom)
    self.external = try stringToDouble(values.decode(String.self, forKey: .external))
    self.kickstarter = try values.decode(Double.self, forKey: .kickstarter)
  }
}

extension ProjectStatsEnvelope.ReferralAggregateStats: Equatable {}
/// Compares all three referral aggregate amounts for equality.
public func == (
  lhs: ProjectStatsEnvelope.ReferralAggregateStats,
  rhs: ProjectStatsEnvelope.ReferralAggregateStats
) -> Bool {
  return lhs.custom == rhs.custom &&
    lhs.external == rhs.external &&
    lhs.kickstarter == rhs.kickstarter
}

extension ProjectStatsEnvelope.ReferrerStats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count"
    case code
    case percentageOfDollars = "percentage_of_dollars"
    case pledged
    case referrerName = "referrer_name"
    case referrerType = "referrer_type"
  }

  /// Decodes individual referrer statistics from REST JSON.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.code = try values.decode(String.self, forKey: .code)
    self.percentageOfDollars = try stringToDouble(values.decode(String.self, forKey: .percentageOfDollars))
    self.pledged = try stringToDouble(values.decode(String.self, forKey: .pledged))
    self.referrerName = try values.decode(String.self, forKey: .referrerName)
    self.referrerType = try values.decode(ReferrerType.self, forKey: .referrerType)
  }
}

extension ProjectStatsEnvelope.ReferrerStats: Equatable {}
/// Compares two `ReferrerStats` values by `code`.
public func == (lhs: ProjectStatsEnvelope.ReferrerStats, rhs: ProjectStatsEnvelope.ReferrerStats) -> Bool {
  return lhs.code == rhs.code
}

extension ProjectStatsEnvelope.ReferrerStats.ReferrerType: Decodable {
  /// Decodes a `ReferrerType` string case-insensitively, defaulting unknown values to `.unknown`.
  public init(from decoder: Decoder) throws {
    do {
      let value = try decoder.singleValueContainer().decode(String.self).lowercased()
      switch value {
      case "custom":
        self = .custom
      case "external":
        self = .external
      case "kickstarter":
        self = .internal
      default:
        self = .unknown
      }
    } catch {
      self = .unknown
    }
  }
}

extension ProjectStatsEnvelope.RewardStats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count"
    case rewardId = "reward_id"
    case minimum
    case pledged
  }

  /// Decodes reward distribution metrics from REST JSON, supporting string or double `minimum`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.rewardId = try values.decode(Int.self, forKey: .rewardId)

    do {
      self.minimum = try values.decodeIfPresent(String.self, forKey: .minimum).flatMap(stringToDouble)
    } catch {
      self.minimum = try values.decodeIfPresent(Double.self, forKey: .minimum)
    }
    self.pledged = try stringToIntOrZero(values.decode(String.self, forKey: .pledged))
  }
}

extension ProjectStatsEnvelope.RewardStats: Equatable {}
/// Compares two `RewardStats` values by `rewardId`.
public func == (lhs: ProjectStatsEnvelope.RewardStats, rhs: ProjectStatsEnvelope.RewardStats)
  -> Bool {
  return lhs.rewardId == rhs.rewardId
}

extension ProjectStatsEnvelope.VideoStats: Decodable {
  private enum CodingKeys: String, CodingKey {
    case externalCompletions = "external_completions"
    case externalStarts = "external_starts"
    case internalCompletions = "internal_completions"
    case internalStarts = "internal_starts"
  }

  /// Decodes campaign video playback counters from REST JSON.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.externalCompletions = try values.decode(Int.self, forKey: .externalCompletions)
    self.externalStarts = try values.decode(Int.self, forKey: .externalStarts)
    self.internalCompletions = try values.decode(Int.self, forKey: .internalCompletions)
    self.internalStarts = try values.decode(Int.self, forKey: .internalStarts)
  }
}

extension ProjectStatsEnvelope.VideoStats: Equatable {}
/// Compares all four start/completion counts for `VideoStats` equality.
public func == (lhs: ProjectStatsEnvelope.VideoStats, rhs: ProjectStatsEnvelope.VideoStats) -> Bool {
  return
    lhs.externalCompletions == rhs.externalCompletions &&
    lhs.externalStarts == rhs.externalStarts &&
    lhs.internalCompletions == rhs.internalCompletions &&
    lhs.internalStarts == rhs.internalStarts
}

private func stringToIntOrZero(_ string: String) -> Int {
  return
    Double(string).flatMap(Int.init)
      ?? Int(string)
      ?? 0
}

private func stringToDouble(_ string: String) -> Double {
  return Double(string) ?? 0
}

private struct OptionalObject<Base: Decodable>: Decodable {
  let value: Base?

  init(from decoder: Decoder) throws {
    do {
      let container = try decoder.singleValueContainer()
      self.value = try container.decode(Base.self)
    } catch {
      self.value = nil
    }
  }
}

