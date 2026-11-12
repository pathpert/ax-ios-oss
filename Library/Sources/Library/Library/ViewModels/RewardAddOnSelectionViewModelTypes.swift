import Foundation
import KsApi
import ReactiveSwift

/// Identifier of a selected reward or add-on.
public typealias SelectedRewardId = Int
/// Quantity chosen for a selected reward or add-on.
public typealias SelectedRewardQuantity = Int
/// Mapping from reward identifier to selected quantity.
public typealias SelectedRewardQuantities = [SelectedRewardId: SelectedRewardQuantity]

/// Data source items displayed in the add-on selection table view.
public enum RewardAddOnSelectionDataSourceItem: Equatable {
  /// An add-on reward card cell item.
  case rewardAddOn(RewardAddOnCardViewData)
  /// An empty state item when add-ons are unavailable or failed to load.
  case emptyState(EmptyStateViewType)

  /// Returns the associated add-on card view data when this item represents `.rewardAddOn`.
  public var rewardAddOnCardViewData: RewardAddOnCardViewData? {
    switch self {
    case let .rewardAddOn(data): return data
    case .emptyState: return nil
    }
  }

  /// Returns the associated empty state type when this item represents `.emptyState`.
  public var emptyStateViewType: EmptyStateViewType? {
    switch self {
    case .rewardAddOn: return nil
    case let .emptyState(viewType): return viewType
    }
  }
}

/// Input actions accepted by `RewardAddOnSelectionViewModel`.
public protocol RewardAddOnSelectionViewModelInputs {
  /// Triggers a refresh of available add-on rewards.
  func beginRefresh()
  /// Configures the view model with initial pledge view data.
  func configure(with data: PledgeViewData)
  /// Notifies the view model that the continue CTA button was tapped.
  func continueButtonTapped()
  /// Notifies the view model that bonus pledge amount validation or value changed.
  func pledgeAmountViewControllerDidUpdate(with data: PledgeAmountData)
  /// Updates the chosen quantity for an add-on reward.
  func rewardAddOnCardViewDidSelectQuantity(quantity: Int, rewardId: Int)
  /// Notifies the view model that the view loaded.
  func viewDidLoad()
}

/// Output signals exposed by `RewardAddOnSelectionViewModel`.
public protocol RewardAddOnSelectionViewModelOutputs {
  /// Emits continue CTA button state and formatted pledge total.
  var configureContinueCTAViewWithData: Signal<RewardAddOnSelectionContinueCTAViewData, Never> { get }
  /// Emits project, base reward, and initial bonus amount to configure the pledge amount view.
  var configurePledgeAmountViewWithData: Signal<PledgeAmountViewConfigData, Never> { get }
  /// Emits when pull-to-refresh or initial loading completes.
  var endRefreshing: Signal<(), Never> { get }
  /// Emits updated `PledgeViewData` when advancing to checkout or pledge confirmation.
  var goToPledge: Signal<PledgeViewData, Never> { get }
  /// Emits the localized section header title.
  var headerTitle: Signal<String, Never> { get }
  /// Emits the localized navigation bar title.
  var pageTitle: Signal<String, Never> { get }
  /// Emits updated add-on items without triggering a full table reload.
  var loadAddOnRewardsIntoDataSource: Signal<[RewardAddOnSelectionDataSourceItem], Never> { get }
  /// Emits add-on items and triggers a full table view reload.
  var loadAddOnRewardsIntoDataSourceAndReloadTableView:
    Signal<[RewardAddOnSelectionDataSourceItem], Never> { get }
  /// Emits when pull-to-refresh begins.
  var startRefreshing: Signal<(), Never> { get }
}

/// Protocol grouping inputs and outputs for `RewardAddOnSelectionViewModel`.
public protocol RewardAddOnSelectionViewModelType {
  /// View model inputs.
  var inputs: RewardAddOnSelectionViewModelInputs { get }
  /// View model outputs.
  var outputs: RewardAddOnSelectionViewModelOutputs { get }
}

