import Experimentation
import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// View model coordinating add-on reward fetching, quantity updates, bonus support, and navigation.
public final class RewardAddOnSelectionViewModel: RewardAddOnSelectionViewModelType,
  RewardAddOnSelectionViewModelInputs,
  RewardAddOnSelectionViewModelOutputs {
  /// Initializes the view model and wires add-on loading, totals, and analytics signals.
  public init() {
    let configData = Signal.combineLatest(
      self.configureWithDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let project = configData.map(\.project)
    let baseReward = configData.map(\.rewards).map(\.first).skipNil()
    let baseRewardQuantities = configData.map(\.selectedQuantities)
    let refTag = configData.map(\.refTag)
    let context = configData.map(\.context)
    let initialLocationId = configData.map(\.selectedLocationId)
    let selectedShippingRule = configData.map(\.selectedShippingRule)
    let hasAddOns = baseReward.map(\.hasAddOns)

    let refreshAddons = Signal.merge(
      configData,
      configData.takeWhen(self.beginRefreshSignal)
    )

    self.headerTitle = hasAddOns.map { (hasAddons: Bool) -> String in
      hasAddons
        ? Strings.Customize_your_reward_with_optional_addons()
        : Strings.Customize_your_reward()
    }

    self.pageTitle = hasAddOns.map { (hasAddOns: Bool) -> String in
      hasAddOns
        ? Strings.Pledge_flow_navigation_bar_titles_Addons()
        : Strings.Pledge_flow_navigation_bar_titles_Bonus_support()
    }

    let shippingRule = Signal.merge(
      selectedShippingRule,
      baseReward.filter { reward in !reward.shipping.enabled }.mapConst(nil)
    )

    let addOnsEvent = refreshAddons.switchMap { data in
      addOnsProducer(
        slug: data.project.slug,
        baseReward: data.rewards.first,
        shippingRule: data.selectedShippingRule
      )
      .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      .materialize()
    }

    self.startRefreshing = self.beginRefreshSignal
    self.endRefreshing = addOnsEvent.filter { $0.isTerminating }.ignoreValues()

    let addOns = addOnsEvent.values().skipNil()
    let requestErrored = addOnsEvent.map(\.error).map(isNotNil)

    let updatedSelectedQuantities = Signal.merge(
      self.rewardAddOnCardViewDidSelectQuantityProperty.signal
        .skipNil()
        .scan([:]) { current, new -> SelectedRewardQuantities in
          let (quantity, rewardId) = new
          var mutableCurrent = current
          mutableCurrent[rewardId] = quantity
          return mutableCurrent
        },
      configData.mapConst([:])
    )

    let backedQuantities = project.map { project -> SelectedRewardQuantities in
      guard let backing = project.personalization.backing else { return [:] }
      return selectedRewardQuantities(in: backing)
    }

    let selectedAddOnQuantities = Signal.combineLatest(updatedSelectedQuantities, backedQuantities)
      .map { args in args.1.withAllValuesFrom(args.0) }

    let selectedQuantities = Signal.combineLatest(selectedAddOnQuantities, baseRewardQuantities)
      .map { args in args.0.withAllValuesFrom(args.1) }

    let latestSelectedQuantities = Signal.merge(baseRewardQuantities, selectedQuantities)

    let rewardAddOnCardsViewData = Signal.combineLatest(addOns, project, baseReward, context, shippingRule)

    let reloadRewardsIntoDataSource = rewardAddOnCardsViewData
      .withLatest(from: latestSelectedQuantities)
      .map(unpackAddOnRewards)
      .map(rewardsData)

    self.loadAddOnRewardsIntoDataSourceAndReloadTableView = Signal.merge(
      reloadRewardsIntoDataSource,
      requestErrored.filter(isTrue).mapConst([.emptyState(.errorPullToRefresh)])
    )

    self.loadAddOnRewardsIntoDataSource = rewardAddOnCardsViewData
      .takePairWhen(latestSelectedQuantities)
      .map(unpackAddOnRewards)
      .map(rewardsData)

    let dataSourceItems = Signal.merge(
      self.loadAddOnRewardsIntoDataSourceAndReloadTableView,
      self.loadAddOnRewardsIntoDataSource
    )

    let allAddOnRewards = Signal.merge(
      dataSourceItems.map { items in items.compactMap { $0.rewardAddOnCardViewData?.reward } },
      hasAddOns.filter(isFalse).mapConst([])
    )

    let baseRewardAndAddOnRewards = Signal.combineLatest(baseReward, allAddOnRewards)

    // MARK: - Bonus support

    let initialAdditionalPledgeAmount = project.map { $0.personalization.backing?.bonusAmount ?? 0.0 }

    self.configurePledgeAmountViewWithData = Signal.combineLatest(
      project,
      baseReward,
      initialAdditionalPledgeAmount
    )
    .map { args in (args.0, args.1, args.2) }

    let additionalPledgeAmount = Signal.merge(
      initialAdditionalPledgeAmount,
      self.pledgeAmountDataSignal.map { $0.amount }
    )

    let totalSelectedAddOnsQuantity = Signal.combineLatest(
      latestSelectedQuantities,
      baseReward.map(\.id),
      allAddOnRewards.map { $0.map(\.id) }
    )
    .map { args -> Int in
      let (quantities, baseRewardId, addOnRewardIds) = args
      return quantities
        .filter { key, _ in key != baseRewardId && addOnRewardIds.contains(key) }
        .reduce(0) { accum, keyValue in accum + keyValue.value }
    }

    let enableContinueButton = Signal.combineLatest(
      project,
      initialAdditionalPledgeAmount,
      self.pledgeAmountDataSignal,
      latestSelectedQuantities,
      shippingRule
    )
    .map(isAddOnSelectionValid)

    let selectedRewards = baseRewardAndAddOnRewards
      .combineLatest(with: latestSelectedQuantities)
      .map { args in (args.0.0, args.0.1, args.1) }
      .map { args -> [Reward] in
        let (baseReward, addOnRewards, selectedQuantities) = args
        let selectedRewardIds = selectedQuantities.filter { _, qty in qty > 0 }.keys
        return [baseReward] + addOnRewards.filter { reward in selectedRewardIds.contains(reward.id) }
      }

    let selectedLocationId = Signal.merge(initialLocationId, shippingRule.map { $0?.location.id })

    self.goToPledge = Signal.combineLatest(
      project,
      selectedRewards,
      additionalPledgeAmount,
      shippingRule,
      selectedQuantities,
      selectedLocationId,
      refTag,
      context
    )
    .map(PledgeViewData.init)
    .takeWhen(self.continueButtonTappedProperty.signal)

    let allRewardsTotal = Signal.combineLatest(selectedRewards, selectedQuantities)
      .map(calculateAllRewardsTotal)

    let combinedPledgeTotal = Signal.combineLatest(
      additionalPledgeAmount,
      additionalPledgeAmount.mapConst(0),
      allRewardsTotal
    )
    .map(calculatePledgeTotal)

    let pledgeTotal = Signal.merge(
      project.map { $0.personalization.backing }.skipNil().map(\.amount),
      combinedPledgeTotal
    )

    let attibutedPledgeTotal = Signal.combineLatest(project, pledgeTotal).map(attributedCurrency)

    self.configureContinueCTAViewWithData = Signal.merge(
      Signal.combineLatest(totalSelectedAddOnsQuantity, enableContinueButton, attibutedPledgeTotal)
        .map { args in
          RewardAddOnSelectionContinueCTAViewData(
            selectedQuantity: args.0,
            isValid: args.1,
            isLoading: false,
            pledgeAmount: args.2
          )
        },
      Signal.combineLatest(hasAddOns, attibutedPledgeTotal)
        .map { args in
          RewardAddOnSelectionContinueCTAViewData(
            selectedQuantity: 0,
            isValid: true,
            isLoading: args.0,
            pledgeAmount: args.1
          )
        }
        .take(first: 1)
    )

    // MARK: - Tracking

    wireAddOnTrackingSignals(
      project: project,
      baseReward: baseReward,
      selectedRewards: selectedRewards,
      selectedQuantities: selectedQuantities,
      refTag: refTag,
      configData: configData,
      additionalPledgeAmount: additionalPledgeAmount,
      pledgeTotal: pledgeTotal,
      continueTapped: self.continueButtonTappedProperty.signal
    )
  }

  // MARK: - Inputs

  private let (beginRefreshSignal, beginRefreshObserver) = Signal<Void, Never>.pipe()
  /// Triggers a refresh of add-on rewards.
  public func beginRefresh() { self.beginRefreshObserver.send(value: ()) }

  private let configureWithDataProperty = MutableProperty<PledgeViewData?>(nil)
  /// Configures the view model with pledge view data.
  public func configure(with data: PledgeViewData) { self.configureWithDataProperty.value = data }

  private let continueButtonTappedProperty = MutableProperty(())
  /// Signals that the continue CTA button was tapped.
  public func continueButtonTapped() { self.continueButtonTappedProperty.value = () }

  private let (pledgeAmountDataSignal, pledgeAmountObserver) = Signal<PledgeAmountData, Never>.pipe()
  /// Updates the bonus pledge amount from the embedded pledge amount controller.
  public func pledgeAmountViewControllerDidUpdate(with data: PledgeAmountData) {
    self.pledgeAmountObserver.send(value: data)
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  private let rewardAddOnCardViewDidSelectQuantityProperty
    = MutableProperty<(SelectedRewardQuantity, SelectedRewardId)?>(nil)
  /// Updates the quantity selected for an add-on reward.
  public func rewardAddOnCardViewDidSelectQuantity(
    quantity: SelectedRewardQuantity,
    rewardId: SelectedRewardId
  ) {
    self.rewardAddOnCardViewDidSelectQuantityProperty.value = (quantity, rewardId)
  }

  // MARK: - Outputs

  /// Emits continue CTA button state and formatted pledge total.
  public let configureContinueCTAViewWithData: Signal<RewardAddOnSelectionContinueCTAViewData, Never>
  /// Emits project, base reward, and initial bonus amount to configure the pledge amount view.
  public let configurePledgeAmountViewWithData: Signal<PledgeAmountViewConfigData, Never>
  /// Emits when pull-to-refresh or initial loading completes.
  public let endRefreshing: Signal<(), Never>
  /// Emits updated `PledgeViewData` when advancing to checkout or pledge confirmation.
  public let goToPledge: Signal<PledgeViewData, Never>
  /// Emits the localized section header title.
  public let headerTitle: Signal<String, Never>
  /// Emits the localized navigation bar title.
  public let pageTitle: Signal<String, Never>
  /// Emits updated add-on items without triggering a full table reload.
  public let loadAddOnRewardsIntoDataSource: Signal<[RewardAddOnSelectionDataSourceItem], Never>
  /// Emits add-on items and triggers a full table view reload.
  public let loadAddOnRewardsIntoDataSourceAndReloadTableView:
    Signal<[RewardAddOnSelectionDataSourceItem], Never>
  /// Emits when pull-to-refresh begins.
  public let startRefreshing: Signal<(), Never>

  /// View model inputs.
  public var inputs: RewardAddOnSelectionViewModelInputs { return self }
  /// View model outputs.
  public var outputs: RewardAddOnSelectionViewModelOutputs { return self }
}
