import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `RewardCardContainerViewModel`.
public protocol RewardCardContainerViewModelInputs {
  /// Configures the reward card container with reward, project, and selected shipping context.
  func configureWith(data: RewardCardViewData)
  /// Signals that the reward card's primary pledge CTA button was tapped.
  func pledgeButtonTapped()
}

/// Outputs emitted by `RewardCardContainerViewModel`.
public protocol RewardCardContainerViewModelOutputs {
  /// Emits visual button styling appropriate for the reward and backing state.
  var pledgeButtonStyleType: Signal<ButtonStyleType, Never> { get }
  /// Emits whether the pledge CTA button is interactive.
  var pledgeButtonEnabled: Signal<Bool, Never> { get }
  /// Emits whether the pledge CTA button is hidden.
  var pledgeButtonHidden: Signal<Bool, Never> { get }
  /// Emits localized title copy for the pledge CTA button, if visible.
  var pledgeButtonTitleText: Signal<String?, Never> { get }
  /// Emits the selected reward ID when the user taps the pledge CTA button.
  var rewardSelected: Signal<Int, Never> { get }
  /// Returns whether `reward` matches the reward currently bound to this card container.
  func currentReward(is reward: Reward) -> Bool
}

/// Interface combining inputs and outputs for `RewardCardContainerViewModel`.
public protocol RewardCardContainerViewModelType {
  /// Input receiver for reward card configuration and button taps.
  var inputs: RewardCardContainerViewModelInputs { get }
  /// Output signals configuring the pledge action button and reward selection events.
  var outputs: RewardCardContainerViewModelOutputs { get }
}

/// View model managing CTA button state and reward selection inside reward carousel cards.
public final class RewardCardContainerViewModel: RewardCardContainerViewModelType,
  RewardCardContainerViewModelInputs, RewardCardContainerViewModelOutputs {
  /// Initializes the reward card container view model.
  public init() {
    let data = self.configDataProperty
      .signal
      .skipNil()

    let reward: Signal<Reward, Never> =
      data
        .map { $0.reward }

    self.currentRewardProperty <~ reward

    let pledgeButtonTitleText = data
      .map { data in
        pledgeButtonTitle(data: data)
      }

    self.pledgeButtonTitleText = pledgeButtonTitleText

    self.pledgeButtonStyleType = data
      .map { data in
        buttonStyleType(data: data)
      }

    self.pledgeButtonEnabled = data
      .map { data in
        rewardsCarouselCanNavigateToReward(
          data.reward,
          in: data.project,
          selectedShippingLocation: data.currentShippingLocation
        )
      }

    self.pledgeButtonHidden = pledgeButtonTitleText.map(isNil)

    self.rewardSelected = reward
      .takeWhen(self.pledgeButtonTappedProperty.signal)
      .map { $0.id }
  }

  private let configDataProperty = MutableProperty<RewardCardViewData?>(nil)
  /// Configures the container view model with `RewardCardViewData`.
  public func configureWith(data: RewardCardViewData) {
    self.configDataProperty.value = data
  }

  private let pledgeButtonTappedProperty = MutableProperty(())
  /// Triggers reward selection when the pledge CTA button is tapped.
  public func pledgeButtonTapped() {
    self.pledgeButtonTappedProperty.value = ()
  }

  /// Emits the computed button style variant.
  public let pledgeButtonStyleType: Signal<ButtonStyleType, Never>
  /// Emits whether the pledge CTA button is enabled.
  public let pledgeButtonEnabled: Signal<Bool, Never>
  /// Emits whether the pledge CTA button is hidden.
  public let pledgeButtonHidden: Signal<Bool, Never>
  /// Emits localized title copy for the pledge CTA button.
  public let pledgeButtonTitleText: Signal<String?, Never>
  /// Emits the ID of the selected reward upon CTA tap.
  public let rewardSelected: Signal<Int, Never>

  private let currentRewardProperty = MutableProperty<Reward?>(nil)
  /// Returns `true` if `reward` equals the card's currently displayed reward.
  public func currentReward(is reward: Reward) -> Bool {
    return self.currentRewardProperty.value == reward
  }

  /// Returns `self` as `RewardCardContainerViewModelInputs`.
  public var inputs: RewardCardContainerViewModelInputs { return self }
  /// Returns `self` as `RewardCardContainerViewModelOutputs`.
  public var outputs: RewardCardContainerViewModelOutputs { return self }
}

// MARK: - Functions

private func pledgeButtonTitle(data: RewardCardViewData) -> String? {
  if currentUserIsCreator(of: data.project) { return nil }

  let projectBackingState = RewardCellProjectBackingStateType.state(with: data.project)
  let isBackingThisReward = userIsBacking(reward: data.reward, inProject: data.project)
  let isRewardAvailable = rewardIsAvailable(data.reward)
  let rewardShipsToLocation = rewardCanShip(data.reward, toLocation: data.currentShippingLocation)

  // If the reward can't ship to your selected location, show the 'not available' string.
  // If you're already backing this reward, fall back to the default behavior (which will show a 'Continue' string).
  if !rewardShipsToLocation, !isBackingThisReward {
    return Strings.Not_available_in_selected_country()
  }

  switch (projectBackingState, isBackingThisReward, isRewardAvailable) {
  case (.backed(.live), false, true):
    return Strings.Select()
  case (.backed(.live), true, _):
    return Strings.Continue()
  case (.backed(.nonLive), true, _):
    return Strings.Selected()
  case (.nonBacked(.live), _, true):
    return Strings.Select()
  case (.backed(.nonLive), false, _),
       (.backed(.inPostCampaignPledgingPhase), _, _),
       (.nonBacked(.nonLive), _, _):
    return nil
  case (_, _, false):
    return Strings.No_longer_available()
  case (.nonBacked(.inPostCampaignPledgingPhase), _, true):
    return Strings.Select()
  }
}

private func buttonStyleType(data: RewardCardViewData) -> ButtonStyleType {
  if currentUserIsCreator(of: data.project) { return .none }

  let projectBackingState = RewardCellProjectBackingStateType.state(with: data.project)
  let isBackingThisReward = userIsBacking(reward: data.reward, inProject: data.project)

  switch projectBackingState {
  case .backed(.live):
    if isBackingThisReward {
      return .green
    }
  case .nonBacked(.live):
    return .green
  case .backed(.nonLive):
    if isBackingThisReward {
      return .black
    }
    return .none
  case .nonBacked(.nonLive),
       .backed(.inPostCampaignPledgingPhase):
    return .none
  case .nonBacked(.inPostCampaignPledgingPhase):
    return .green
  }

  return .green
}
