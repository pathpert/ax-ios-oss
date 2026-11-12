import KDS
import KsApi
import ReactiveSwift
import UIKit

/// Badge display payload rendered at the top of a reward card.
public struct RewardCardBadgeData {
  /// Localized badge title text.
  public let text: String
  /// Styling configuration for the badge surface and typography.
  public let badgeStyle: BadgeStyle
  /// Optional leading badge icon image.
  public let image: UIImage?
}

/// Tag pill styling and text rendered at the footer of a reward card.
public struct RewardCardPillData: Equatable {
  /// Pill container background color.
  public let backgroundColor: UIColor
  /// Localized pill text.
  public let text: String
  /// Foreground label text color.
  public let textColor: UIColor
}

/// Presentation context controlling reward card copy and visibility rules.
public enum RewardCardViewContext {
  /// Displayed during initial pledge checkout selection.
  case pledge
  /// Displayed while managing an existing backing.
  case manage
}

/// Input configuration payload for `RewardCardView`.
public struct RewardCardViewData {
  /// Project owning the reward.
  public let project: Project
  /// Reward model displayed by the card.
  public let reward: Reward
  /// Flow context (`pledge` or `manage`).
  public let context: RewardCardViewContext
  /// Currently selected shipping destination, when applicable.
  public let currentShippingLocation: Location?

  /// Creates a `RewardCardViewData` value.
  public init(
    project: Project,
    reward: Reward,
    context: RewardCardViewContext,
    currentShippingLocation: Location?
  ) {
    self.project = project
    self.reward = reward
    self.context = context
    self.currentShippingLocation = currentShippingLocation
  }
}

/// Input events handled by `RewardCardViewModel`.
public protocol RewardCardViewModelInputs {
  /// Configures the view model with reward, project, and shipping context data.
  func configure(with data: RewardCardViewData)
  /// Signals that the user tapped anywhere on the reward card.
  func rewardCardTapped()
}

/// Output signals emitted by `RewardCardViewModel`.
public protocol RewardCardViewModelOutputs {
  /// Emits whether card tap interaction should be enabled.
  var cardUserInteractionIsEnabled: Signal<Bool, Never> { get }
  /// Emits whether the currency conversion label should be hidden.
  var conversionLabelHidden: Signal<Bool, Never> { get }
  /// Emits formatted user-currency conversion text.
  var conversionLabelText: Signal<String, Never> { get }
  /// Emits localized reward description text.
  var descriptionLabelText: Signal<String, Never> { get }
  /// Emits whether the estimated shipping section should be hidden.
  var estimatedShippingStackViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the estimated delivery section should be hidden.
  var estimatedDeliveryStackViewHidden: Signal<Bool, Never> { get }
  /// Emits formatted estimated delivery month and year text.
  var estimatedDeliveryDateLabelText: Signal<String, Never> { get }
  /// Emits formatted estimated shipping range or fee text.
  var estimatedShippingLabelText: Signal<String?, Never> { get }
  /// Emits whether the included items section should be hidden.
  var includedItemsStackViewHidden: Signal<Bool, Never> { get }
  /// Emits formatted included reward item titles and quantities.
  var items: Signal<[String], Never> { get }
  /// Emits whether the status pills container should be hidden.
  var pillCollectionViewHidden: Signal<Bool, Never> { get }
  /// Emits configured pill view data to render in the footer.
  var reloadPills: Signal<[RewardCardPillData], Never> { get }
  /// Emits displayable local pickup location text.
  var rewardLocationPickupLabelText: Signal<String, Never> { get }
  /// Emits whether the local pickup location section should be hidden.
  var rewardLocationStackViewHidden: Signal<Bool, Never> { get }
  /// Emits formatted minimum pledge amount text.
  var rewardMinimumLabelText: Signal<String, Never> { get }
  /// Emits the tapped reward identifier when card selection occurs.
  var rewardSelected: Signal<Int, Never> { get }
  /// Emits whether the reward title label should be hidden.
  var rewardTitleLabelHidden: Signal<Bool, Never> { get }
  /// Emits styled attributed title text including any selected quantity prefix.
  var rewardTitleLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits reward hero image metadata when present.
  var rewardImage: Signal<Reward.Image, Never> { get }
  /// Emits whether the reward image view should be hidden.
  var rewardImageHidden: Signal<Bool, Never> { get }
  /// Emits badge display data for secret or featured rewards.
  var rewardBadge: Signal<RewardCardBadgeData?, Never> { get }
}

/// View model interface for formatting and handling interactions on `RewardCardView`.
public protocol RewardCardViewModelType {
  /// Input receiver for reward card configuration and taps.
  var inputs: RewardCardViewModelInputs { get }
  /// Output signals bound by `RewardCardView`.
  var outputs: RewardCardViewModelOutputs { get }
}

