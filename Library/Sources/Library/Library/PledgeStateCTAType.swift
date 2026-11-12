import UIKit

/// Visual and copy configuration for the primary pledge action CTA on a project page.
/// - Negative Constraint: Do not derive CTA navigation directly from `buttonTitle`; inspect the enum case instead.
public enum PledgeStateCTAType: Equatable {
  case fix
  case pledge
  case manage
  case viewBacking
  case viewRewards
  case viewYourRewards
  case prelaunch(saved: Bool, watchCount: Int)
  case pledgeManager

  /// Localized CTA button title for the current pledge state.
  public var buttonTitle: String {
    switch self {
    case .fix:
      return Strings.Manage()
    case .pledge:
      return Strings.Back_this_project()
    case .manage:
      return Strings.Manage()
    case .viewBacking:
      return Strings.View_your_pledge()
    case .viewRewards:
      return Strings.View_rewards()
    case .viewYourRewards:
      return Strings.View_your_rewards()
    case let .prelaunch(saved, _):
      return saved ? Strings.Saved() : Strings.Notify_me_on_launch()
    case .pledgeManager:
      return Strings.Go_to_pledge_manager()
    }
  }

  /// Semantic button styling variant associated with this CTA state.
  public var buttonStyle: ButtonStyleType {
    switch self {
    case .fix:
      return .red
    case .pledge:
      return .green
    case .manage:
      return .blue
    case .viewBacking, .viewRewards, .viewYourRewards, .pledgeManager:
      return .black
    case let .prelaunch(saved, _):
      return saved ? .none : .black
    }
  }

  /// `true` when the auxiliary status stack view should remain hidden.
  public var stackViewIsHidden: Bool {
    switch self {
    case .pledge, .viewBacking, .viewRewards, .viewYourRewards, .prelaunch, .pledgeManager:
      return true
    case .fix, .manage:
      return false
    }
  }

  /// Optional status heading displayed alongside `.fix` or `.manage` states.
  public var titleLabel: String? {
    switch self {
    case .fix:
      return Strings.Payment_failure()
    case .manage:
      return Strings.Youre_a_backer()
    default:
      return nil
    }
  }

  /// Optional explanatory subtitle shown for `.fix` payment-failure states.
  public var subtitleLabel: String? {
    switch self {
    case .fix:
      return Strings.We_cant_process_your_pledge()
    default:
      return nil
    }
  }

  /// `true` when both the status stack view and adjacent spacer should be collapsed.
  public var stackViewAndSpacerAreHidden: Bool {
    switch self {
    case .pledge, .viewBacking, .viewRewards, .viewYourRewards, .prelaunch, .pledgeManager:
      return true
    case .fix, .manage:
      return false
    }
  }
}
