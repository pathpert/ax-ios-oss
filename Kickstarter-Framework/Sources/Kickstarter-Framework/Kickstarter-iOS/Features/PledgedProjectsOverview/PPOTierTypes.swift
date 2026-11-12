import Foundation
import GraphAPI
import Kingfisher
import KsApi
import Library

/// Pledged Projects Overview tier categories corresponding to backend open-search sort values.
public enum PPOTierType: String {
  // Source of truth for enum values can be found at
  // https://github.com/kickstarter/kickstarter/blob/main/app/models/open_search/pledged_projects_overview.rb
  case fixPayment = "Tier1PaymentFailed"
  case confirmAddress = "Tier1AddressLockingSoon"
  case openSurvey = "Tier1OpenSurvey"
  case authenticateCard = "Tier1PaymentAuthenticationRequired"
  case pledgeManagement = "PledgeManagement"

  case surveySubmitted = "SurveySubmitted"
  case pledgeCollected = "PledgeCollected"
  case addressConfirmed = "AddressConfirmed"
  case awaitingReward = "AwaitingReward"
  case rewardReceived = "RewardReceived"

  case campaignLive = "CampaignLive"
  case campaignFunded = "CampaignFunded"
  case campaignEnded = "CampaignEnded"

  case campaignFailed = "CampaignFailed"
  case pledgeDropped = "PledgeDropped"
  case pledgeCanceled = "PledgeCanceled"

  /// Tier types shown in the Pledged Projects Overview project-alerts tab.
  public static func projectAlertTypes() -> [PPOTierType] {
    return [
      .fixPayment,
      .confirmAddress,
      .openSurvey,
      .authenticateCard,
      .pledgeManagement
    ]
  }

  /// GraphQL sort enum values corresponding to `projectAlertTypes()`.
  public static func projectAlertGraphQLTypes() -> [PledgeProjectsOverviewSort] {
    return self.projectAlertTypes().map { $0.toPledgeProjectsOverviewSort() }
  }

  /// Tier types for successfully funded projects requiring backer follow-up or fulfillment tracking.
  public static func fundedProjectTypes() -> [PPOTierType] {
    return self.projectAlertTypes() + [
      .surveySubmitted,
      .pledgeCollected,
      .addressConfirmed,
      .awaitingReward,
      .rewardReceived
    ]
  }

  /// GraphQL sort enum values corresponding to `fundedProjectTypes()`.
  public static func fundedProjectGraphQLTypes() -> [PledgeProjectsOverviewSort] {
    return self.fundedProjectTypes().map { $0.toPledgeProjectsOverviewSort() }
  }

  /// All Pledged Projects Overview tier types across alerts, funded, and ended states.
  public static func allTypes() -> [PPOTierType] {
    return self.fundedProjectTypes() + [
      .campaignLive,
      .campaignFunded,
      .campaignEnded,
      .campaignFailed,
      .pledgeDropped,
      .pledgeCanceled
    ]
  }

  /// GraphQL sort enum values corresponding to `allTypes()`.
  public static func allGraphQLTypes() -> [PledgeProjectsOverviewSort] {
    return self.allTypes().map { $0.toPledgeProjectsOverviewSort() }
  }

  /// Converts this local tier case into its generated GraphQL `PledgeProjectsOverviewSort` counterpart.
  // swiftlint:disable:next cyclomatic_complexity
  public func toPledgeProjectsOverviewSort() -> PledgeProjectsOverviewSort {
    switch self {
    case .fixPayment: return .tier1PaymentFailed
    case .confirmAddress: return .tier1AddressLockingSoon
    case .openSurvey: return .tier1OpenSurvey
    case .authenticateCard: return .tier1PaymentAuthenticationRequired
    case .pledgeManagement: return .pledgeManagement

    case .surveySubmitted: return .surveySubmitted
    case .pledgeCollected: return .pledgeCollected
    case .addressConfirmed: return .addressConfirmed
    case .awaitingReward: return .awaitingReward
    case .rewardReceived: return .rewardReceived

    case .campaignLive: return .campaignLive
    case .campaignFunded: return .campaignFunded
    case .campaignEnded: return .campaignEnded

    case .campaignFailed: return .campaignFailed
    case .pledgeDropped: return .pledgeDropped
    case .pledgeCanceled: return .pledgeCanceled
    }
  }
}
