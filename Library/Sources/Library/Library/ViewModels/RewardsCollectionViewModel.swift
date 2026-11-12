import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model managing the rewards list, shipping location filtering, and reward selection flow.
public final class RewardsCollectionViewModel: RewardsCollectionViewModelType,
  RewardsCollectionViewModelInputs, RewardsCollectionViewModelOutputs {
  /// Initializes the view model and wires reward loading, selection, and analytics signals.
  public init() {
    let configData = self.configDataProperty.signal
      .skipNil()
      .takeWhen(self.viewDidLoadProperty.signal)

    let project = configData.map { $0.0 }
    let refTag = configData.map { $0.1 }
    let secretRewardToken = configData.map { $0.3 }

    self.title = configData
      .map { ($0.2, $0.0) }
      .takeWhen(self.viewDidLoadProperty.signal)
      .map(titleForContext)

    // The selected shipping location. Can be nil if the project has no shippable rewards.
    let selectedShippingLocation: Signal<Location?, Never> = self.shippingLocationSelectedSignal
      .signal
      .skipRepeats()

    let isLoadingProperty = MutableProperty(true)

    // Fetch the sorted rewards when a shipping country code is selected.
    let fetchedRewards = project
      .combineLatest(with: selectedShippingLocation)
      .on(value: { _ in isLoadingProperty.value = true })
      .flatMap { project, location in
        fetchRewards(forProject: project, sortedForShippingLocation: location)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
          .values()
          .on(completed: { isLoadingProperty.value = false })
      }
      .map(filteredRewards)

    self.scrollToRewardIndexPath = Signal.combineLatest(
      project,
      fetchedRewards,
      secretRewardToken,
      self.viewDidLayoutSubviewsProperty.signal
    )
    .map { args in
      rewardToScrollIndexPath(args.0, rewards: args.1, secretRewardToken: args.2)
    }
    .skipNil()
    .take(first: 1)

    let isLoading = isLoadingProperty
      .signal(takeInitialValueWhen: configData.ignoreValues())
      .skipRepeats()

    self.showPlaceholderRewardCards = project
      .combineLatestAndFilterOn(isLoading)
      .map { $0.rewards.count }

    self.reloadDataWithValues = Signal.combineLatest(project, fetchedRewards, selectedShippingLocation)
      .combineLatestAndFilterOn(isLoading.signal.negate())
      .map { args -> [RewardCardViewData] in
        let (project, rewards, location) = args
        return rewards.map { reward in
          RewardCardViewData(
            project: project,
            reward: reward,
            context: .pledge,
            currentShippingLocation: location
          )
        }
      }

    self.configureRewardsCollectionViewFooterWithCount = self.reloadDataWithValues.map { $0.count }
    self.flashScrollIndicators = self.viewDidAppearProperty.signal

    // MARK: Shipping Location

    let selectedShippingRule: Signal<ShippingRule?, Never> = selectedShippingLocation
      .takePairWhen(self.selectedRewardProperty.signal.skipNil())
      .map { shippingRule(forReward: $0.1, selectedLocation: $0.0) }

    let selectedRewardFromId = fetchedRewards
      .takePairWhen(self.rewardSelectedWithRewardIdProperty.signal.skipNil())
      .map { args in args.0.first(where: { $0.id == args.1 }) }
      .skipNil()

    self.selectedRewardProperty <~ selectedRewardFromId

    let goToPledge: Signal<(PledgeViewData, Bool), Never> = Signal.combineLatest(
      project,
      selectedRewardFromId,
      refTag,
      selectedShippingRule
    )
    .takeWhen(self.rewardSelectedWithRewardIdProperty.signal)
    .filter { project, reward, _, shippingRule in
      rewardsCarouselCanNavigateToReward(reward, in: project, selectedShippingLocation: shippingRule?.location)
    }
    .map { args -> (PledgeViewData, Bool) in
      makePledgeViewDataAndHasAddOns(
        project: args.0,
        reward: args.1,
        refTag: args.2,
        selectedShippingRule: args.3
      )
    }

    let goToAddOnSelectionNotBackedWithAddOns = goToPledge
      .filter(second >>> isTrue)
      .map(first)
      .filter(shouldTriggerEditRewardPrompt >>> isFalse)

    let goToAddOnSelectionBackedWithAddOns = goToPledge
      .filter(second >>> isTrue)
      .map(first)
      .filter(shouldTriggerEditRewardPrompt >>> isTrue)

    let goToPledgeNotBackedWithAddOns = goToPledge
      .filter(second >>> isFalse)
      .map(first)
      .filter(shouldTriggerEditRewardPrompt >>> isFalse)

    let goToPledgeBackedWithAddOns = goToPledge
      .filter(second >>> isFalse)
      .map(first)
      .filter(shouldTriggerEditRewardPrompt >>> isTrue)

    self.showEditRewardConfirmationPrompt = Signal.merge(
      goToAddOnSelectionBackedWithAddOns,
      goToPledgeBackedWithAddOns
    )
    .map { _ in (Strings.Continue_with_this_reward(), Strings.It_may_not_offer_some_or_all_of_your_add_ons()) }

    let goToAddOnSelectionBackedConfirmed = goToPledge
      .takeWhen(self.confirmedEditRewardProperty.signal)
      .filter(second >>> isTrue)
      .map(first)

    let goToPledgeBackedConfirmed = goToPledge
      .takeWhen(self.confirmedEditRewardProperty.signal)
      .filter(second >>> isFalse)
      .map(first)

    self.goToAddOnSelection = Signal.merge(
      goToAddOnSelectionNotBackedWithAddOns,
      goToAddOnSelectionBackedConfirmed
    )

    self.goToCustomizeYourReward = Signal.merge(
      goToPledgeNotBackedWithAddOns,
      goToPledgeBackedConfirmed
    )

    self.rewardsCollectionViewFooterIsHidden = self.traitCollectionChangedProperty.signal
      .skipNil()
      .map { isFalse($0.verticalSizeClass == .regular) }

    let hideDividerLine = self.rewardCellShouldShowDividerLineProperty.signal.negate()
    self.navigationBarShadowImageHidden = Signal.merge(
      hideDividerLine,
      hideDividerLine.takeWhen(self.viewWillAppearProperty.signal)
    )

    // MARK: Tracking

    Signal.combineLatest(project, refTag)
      .takeWhen(self.viewDidLoadProperty.signal)
      .observeValues { trackRewardsEvent(project: $0.0, reward: .noReward, refTag: $0.1, isSelection: false) }

    Signal.combineLatest(project, selectedRewardFromId, refTag)
      .observeValues { trackRewardsEvent(project: $0.0, reward: $0.1, refTag: $0.2, isSelection: true) }

    _ = Signal.combineLatest(project, self.viewDidAppearProperty.signal.ignoreValues())
      .observeValues { triggerRewardSelectionViewedThirdPartyEvent(for: $0.0) }
  }

  private let configDataProperty = MutableProperty<(
    Project,
    RefTag?,
    RewardsCollectionViewContext,
    String?
  )?>(nil)
  /// Configures the view model with project, referral tag, context, and optional secret reward token.
  public func configure(
    with project: Project,
    refTag: RefTag?,
    context: RewardsCollectionViewContext,
    secretRewardToken: String?
  ) {
    self.configDataProperty.value = (project, refTag, context, secretRewardToken)
  }

  private let confirmedEditRewardProperty = MutableProperty(())
  /// Signals that the user confirmed editing the reward despite losing add-ons.
  public func confirmedEditReward() {
    self.confirmedEditRewardProperty.value = ()
  }

  private let rewardCellShouldShowDividerLineProperty = MutableProperty<Bool>(false)
  /// Updates whether reward cells should show a divider line.
  public func rewardCellShouldShowDividerLine(_ show: Bool) {
    self.rewardCellShouldShowDividerLineProperty.value = show
  }

  private let rewardSelectedWithRewardIdProperty = MutableProperty<Int?>(nil)
  /// Selects the reward with the specified identifier.
  public func rewardSelected(with rewardId: Int) {
    self.rewardSelectedWithRewardIdProperty.value = rewardId
  }

  private let shippingLocationViewDidFailToLoadProperty = MutableProperty(())
  /// Signals that loading the shipping location selector failed.
  public func shippingLocationViewDidFailToLoad() {
    self.shippingLocationViewDidFailToLoadProperty.value = ()
  }

  private let (shippingLocationSelectedSignal, shippingLocationSelectedObserver) = Signal<Location?, Never>
    .pipe()
  /// Updates the selected shipping location.
  public func shippingLocationSelected(_ location: Location?) {
    self.shippingLocationSelectedObserver.send(value: location)
  }

  private let traitCollectionChangedProperty = MutableProperty<UITraitCollection?>(nil)
  /// Updates the current trait collection.
  public func traitCollectionDidChange(_ traitCollection: UITraitCollection) {
    self.traitCollectionChangedProperty.value = traitCollection
  }

  private let viewDidAppearProperty = MutableProperty(())
  /// Signals that the view appeared.
  public func viewDidAppear() {
    self.viewDidAppearProperty.value = ()
  }

  private let viewDidLayoutSubviewsProperty = MutableProperty(())
  /// Signals that the view finished laying out its subviews.
  public func viewDidLayoutSubviews() {
    self.viewDidLayoutSubviewsProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let viewWillAppearProperty = MutableProperty(())
  /// Signals that the view is about to appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  /// Emits the number of reward items for configuring the footer view.
  public let configureRewardsCollectionViewFooterWithCount: Signal<Int, Never>
  /// Emits when scroll indicators should flash on appear.
  public let flashScrollIndicators: Signal<Void, Never>
  /// Emits pledge data when navigating to add-on selection.
  public let goToAddOnSelection: Signal<PledgeViewData, Never>
  /// Emits pledge data when navigating to customize the selected reward.
  public let goToCustomizeYourReward: Signal<PledgeViewData, Never>
  /// Emits whether the navigation bar shadow image should be hidden.
  public let navigationBarShadowImageHidden: Signal<Bool, Never>
  /// Emits card view data items to display in the collection view.
  public let reloadDataWithValues: Signal<[RewardCardViewData], Never>
  /// Emits the number of placeholder reward cards to display while loading.
  public let showPlaceholderRewardCards: Signal<Int, Never>
  /// Emits whether the rewards collection footer should be hidden.
  public let rewardsCollectionViewFooterIsHidden: Signal<Bool, Never>
  /// Emits the initial reward index path to scroll to once loaded.
  public let scrollToRewardIndexPath: Signal<IndexPath, Never>
  /// Emits alert title and message when switching rewards drops previously chosen add-ons.
  public let showEditRewardConfirmationPrompt: Signal<(String, String), Never>
  /// Emits the localized navigation bar title.
  public let title: Signal<String, Never>

  private let selectedRewardProperty = MutableProperty<Reward?>(nil)
  /// Returns the currently selected reward, if any.
  public func selectedReward() -> Reward? {
    return self.selectedRewardProperty.value
  }

  /// View model inputs.
  public var inputs: RewardsCollectionViewModelInputs { return self }
  /// View model outputs.
  public var outputs: RewardsCollectionViewModelOutputs { return self }
}
