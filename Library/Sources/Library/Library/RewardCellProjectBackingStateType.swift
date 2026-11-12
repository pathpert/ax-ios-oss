import KsApi
import UIKit

/// Enumeration representing `RewardCellProjectBackingStateType` cases.
public enum RewardCellProjectBackingStateType: Equatable {
  /// Funding phase classification for a reward's project.
  public enum ProjectState {
    /// Project is not currently accepting live or late pledges.
    case nonLive
    /// Project is actively live for standard pledges.
    case live
    /// Project has ended funding and is in post-campaign late-pledging.
    case inPostCampaignPledgingPhase
  }

  /// User has not backed this project.
  case nonBacked(live: ProjectState)
  /// User has an active backing on this project.
  case backed(live: ProjectState)

  static func state(with project: Project) -> RewardCellProjectBackingStateType {
    guard project.personalization.backing != nil else {
      if project.isInPostCampaignPledgingPhase {
        return .nonBacked(live: .inPostCampaignPledgingPhase)
      }

      return .nonBacked(live: project.state == .live ? .live : .nonLive)
    }

    switch project.state {
    case .live:
      return .backed(live: .live)
    default:
      return .backed(live: .nonLive)
    }
  }

  var canCreateNewPledge: Bool {
    switch self {
    case .nonBacked(live: .live):
      return true
    case .nonBacked(live: .inPostCampaignPledgingPhase):
      return true
    case .nonBacked(live: .nonLive):
      return false

    case .backed:
      return false
    }
  }
}
