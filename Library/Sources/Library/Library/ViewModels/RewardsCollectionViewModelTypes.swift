import Foundation
import KsApi
import ReactiveSwift
import UIKit

/// Presentation contexts for the rewards collection screen.
public enum RewardsCollectionViewContext {
  /// Selecting a reward to create a new pledge.
  case createPledge
  /// Selecting or updating a reward for an existing pledge.
  case managePledge
}

/// Input actions accepted by `RewardsCollectionViewModel`.
public protocol RewardsCollectionViewModelInputs {
  /// Configures the view model with project, referral tag, context, and optional secret token.
  func configure(
    with project: Project,
    refTag: RefTag?,
    context: RewardsCollectionViewContext,
    secretRewardToken: String?
  )
  /// Notifies the view model that the user confirmed switching away from add-ons.
  func confirmedEditReward()
  /// Updates whether reward cells should display a bottom divider line.
  func rewardCellShouldShowDividerLine(_ show: Bool)
  /// Notifies the view model that the user selected the reward with the given identifier.
  func rewardSelected(with rewardId: Int)
  /// Notifies the view model that the shipping location view failed to load.
  func shippingLocationViewDidFailToLoad()
  /// Notifies the view model that a shipping location was selected.
  func shippingLocationSelected(_ location: Location?)
  /// Notifies the view model that the trait collection changed.
  func traitCollectionDidChange(_ traitCollection: UITraitCollection)
  /// Notifies the view model that the view appeared.
  func viewDidAppear()
  /// Notifies the view model that subviews laid out.
  func viewDidLayoutSubviews()
  /// Notifies the view model that the view loaded.
  func viewDidLoad()
  /// Notifies the view model that the view will appear.
  func viewWillAppear()
}

/// Output signals and state exposed by `RewardsCollectionViewModel`.
public protocol RewardsCollectionViewModelOutputs {
  /// Emits the number of reward items for configuring the footer view.
  var configureRewardsCollectionViewFooterWithCount: Signal<Int, Never> { get }
  /// Emits when scroll indicators should flash on appear.
  var flashScrollIndicators: Signal<Void, Never> { get }
  /// Emits pledge data when navigating to add-on selection.
  var goToAddOnSelection: Signal<PledgeViewData, Never> { get }
  /// Emits pledge data when navigating to customize the selected reward.
  var goToCustomizeYourReward: Signal<PledgeViewData, Never> { get }
  /// Emits whether the navigation bar shadow image should be hidden.
  var navigationBarShadowImageHidden: Signal<Bool, Never> { get }
  /// Emits card view data items to display in the collection view.
  var reloadDataWithValues: Signal<[RewardCardViewData], Never> { get }
  /// Emits the number of placeholder reward cards to display while loading.
  var showPlaceholderRewardCards: Signal<Int, Never> { get }
  /// Emits whether the rewards collection footer should be hidden.
  var rewardsCollectionViewFooterIsHidden: Signal<Bool, Never> { get }
  /// Emits the initial reward index path to scroll to once loaded.
  var scrollToRewardIndexPath: Signal<IndexPath, Never> { get }
  /// Emits alert title and message when switching rewards drops previously chosen add-ons.
  var showEditRewardConfirmationPrompt: Signal<(String, String), Never> { get }
  /// Emits the localized navigation bar title.
  var title: Signal<String, Never> { get }

  /// Returns the currently selected reward, if any.
  func selectedReward() -> Reward?
}

/// Protocol grouping inputs and outputs for `RewardsCollectionViewModel`.
public protocol RewardsCollectionViewModelType {
  /// View model inputs.
  var inputs: RewardsCollectionViewModelInputs { get }
  /// View model outputs.
  var outputs: RewardsCollectionViewModelOutputs { get }
}

