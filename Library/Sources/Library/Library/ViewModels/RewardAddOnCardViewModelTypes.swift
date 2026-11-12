import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input data required to configure a reward add-on card.
public struct RewardAddOnCardViewData: Equatable {
  /// Project associated with the reward add-on.
  public let project: Project
  /// Reward add-on represented by the card.
  public let reward: Reward
  /// Display context for the card.
  public let context: RewardCardViewContext
  /// Optional shipping rule used when calculating add-on shipping costs.
  public let shippingRule: ShippingRule?
  /// Currently selected quantities keyed by reward identifier.
  public let selectedQuantities: SelectedRewardQuantities
}

/// Input actions supported by `RewardAddOnCardViewModel`.
public protocol RewardAddOnCardViewModelInputs {
  /// Call when the user taps the Add button.
  func addButtonTapped()
  /// Call with the card's configuration data.
  func configure(with data: RewardAddOnCardViewData)
  /// Call when the user taps the add-on card itself.
  func rewardAddOnCardTapped()
  /// Call when the quantity stepper value changes.
  func stepperValueChanged(_ value: Double)
}

/// UI outputs emitted by `RewardAddOnCardViewModel`.
public protocol RewardAddOnCardViewModelOutputs {
  /// Emits whether the Add button should be hidden.
  var addButtonHidden: Signal<Bool, Never> { get }
  /// Emits whether the currency conversion label should be hidden.
  var amountConversionLabelHidden: Signal<Bool, Never> { get }
  /// Emits formatted converted pledge amount copy.
  var amountConversionLabelText: Signal<String, Never> { get }
  /// Emits attributed pledge amount and shipping cost text.
  var amountLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits the add-on reward description text.
  var descriptionLabelText: Signal<String, Never> { get }
  /// Emits when light selection haptic feedback should fire.
  var generateSelectionFeedback: Signal<Void, Never> { get }
  /// Emits when warning haptic feedback should fire at step bounds.
  var generateNotificationWarningFeedback: Signal<Void, Never> { get }
  /// Emits attributed bullet list of included reward items.
  var includedItemsLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the included items stack view should be hidden.
  var includedItemsStackViewHidden: Signal<Bool, Never> { get }
  /// Emits formatted estimated shipping copy when shipping is enabled.
  var estimatedShippingLabelText: Signal<String?, Never> { get }
  /// Emits whether the estimated shipping stack view should be hidden.
  var estimatedShippingStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the updated reward quantity and identifier tuple.
  var notifiyDelegateDidSelectQuantity: Signal<(SelectedRewardQuantity, SelectedRewardId), Never> { get }
  /// Emits whether the badge pills view should be hidden.
  var pillsViewHidden: Signal<Bool, Never> { get }
  /// Emits the currently selected quantity string.
  var quantityLabelText: Signal<String, Never> { get }
  /// Emits metadata pill strings (time left, remaining count, backer limit).
  var reloadPills: Signal<[String], Never> { get }
  /// Emits the selected pickup location display string.
  var rewardLocationPickupLabelText: Signal<String, Never> { get }
  /// Emits whether the pickup location stack view should be hidden.
  var rewardLocationStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the selected reward identifier when the card is tapped.
  var rewardSelected: Signal<Int, Never> { get }
  /// Emits the add-on reward title text.
  var rewardTitleLabelText: Signal<String, Never> { get }
  /// Emits the maximum stepper value allowed for this add-on.
  var stepperMaxValue: Signal<Double, Never> { get }
  /// Emits whether the quantity stepper stack view should be hidden.
  var stepperStackViewHidden: Signal<Bool, Never> { get }
  /// Emits the current stepper value.
  var stepperValue: Signal<Double, Never> { get }
  /// Emits the optional reward image model.
  var rewardImage: Signal<Reward.Image, Never> { get }
  /// Emits whether the reward image view should be hidden.
  var rewardImageHidden: Signal<Bool, Never> { get }
}

/// View model interface for a reward add-on selection card.
public protocol RewardAddOnCardViewModelType {
  /// Input interface for the add-on card view model.
  var inputs: RewardAddOnCardViewModelInputs { get }
  /// Output interface for the add-on card view model.
  var outputs: RewardAddOnCardViewModelOutputs { get }
}

