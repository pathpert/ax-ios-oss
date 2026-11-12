import Experimentation
import Foundation
import KsApi
import Prelude
import ReactiveSwift

// MARK: - Functions

/// Returns the navigation bar title matching the project state and reward selection context.
func titleForContext(_ context: RewardsCollectionViewContext, project: Project) -> String {
  if currentUserIsCreator(of: project) {
    return Strings.View_your_rewards()
  }

  guard project.state == .live else {
    if project.isInPostCampaignPledgingPhase {
      return Strings.Back_this_project()
    }

    return Strings.View_rewards()
  }

  return context == .createPledge ? Strings.Pledge_flow_navigation_bar_titles_Rewards() : Strings
    .Edit_reward()
}

/// Returns `true` when changing to the chosen reward drops existing add-ons and needs confirmation.
func shouldTriggerEditRewardPrompt(_ data: PledgeViewData) -> Bool {
  // If the user is not backing the project then there is no need to show the prompt.
  guard
    userIsBackingProject(data.project),
    let backing = data.project.personalization.backing
  else { return false }

  let rewardChanged = data.rewards.first?.id != backing.reward?.id

  // We show the prompt if they have previously backed with add-ons and they are selecting a new reward.
  return backing.addOns?.isEmpty == false && rewardChanged
}

/// Returns the `IndexPath` of the reward to auto-scroll to in the collection view.
/// If a `secretRewardToken` is provided, it returns the first secret reward's index.
/// Otherwise, it returns the index of the backed reward (if the project is backed).
func rewardToScrollIndexPath(
  _ project: Project,
  rewards: [Reward],
  secretRewardToken: String?
) -> IndexPath? {
  if let secretRewardToken = secretRewardToken, !secretRewardToken.isEmpty {
    return firstSecretRewardIndexPath(rewards: rewards)
  }

  return backedRewardIndexPath(project, rewards: rewards)
}

/// Returns the index path of the first available secret reward, if any.
func firstSecretRewardIndexPath(rewards: [Reward]) -> IndexPath? {
  return rewards.firstIndex(where: { $0.isSecretReward && $0.isAvailable == true })
    .flatMap { IndexPath(row: $0, section: 0) }
}

/// Returns the index path of the reward currently backed by the user, if present.
func backedRewardIndexPath(_ project: Project, rewards: [Reward]) -> IndexPath? {
  guard let backing = project.personalization.backing else {
    return nil
  }

  let backedReward = reward(from: backing, inProject: project)
  return rewards
    .firstIndex(where: { $0.id == backedReward.id })
    .flatMap { IndexPath(row: $0, section: 0) }
}

/// Extracts the project's existing backing and shipping total for analytics checkout properties.
func backingAndShippingTotal(for project: Project, and reward: Reward) -> (Backing?, Double?) {
  let backing = project.personalization.backing
  let shippingTotal = reward.shipping.enabled ? backing?.shippingAmount.flatMap(Double.init) : 0.0

  return (backing, shippingTotal)
}

/// Filters rewards to exclude items whose start date has not yet been reached.
func filteredRewards(_ rewards: [Reward]) -> [Reward] {
  return rewards.filter { shouldShowReward($0) }
}

/// Returns whether a reward's start date is at or before today.
func shouldShowReward(_ reward: Reward) -> Bool {
  // Check if the reward isn't available yet.
  // These are usually filtered out by the backend, but may be visible if you're the project creator.
  // We filter these out so that creators aren't concerned that backers may see them.
  return isStartDateBeforeToday(for: reward)
}

/// Resolves the matching `ShippingRule` for a reward at the given shipping location.
func shippingRule(forReward reward: Reward, selectedLocation location: Location?) -> ShippingRule? {
  guard let selectedLocation = location else {
    return nil
  }

  // Whether or not this is a "shippable" reward.
  // "No Reward", digital rewards and local pickup rewards are not shippable.
  let hasShipping = reward.isRestrictedShippingPreference || reward.isUnRestrictedShippingPreference

  guard let rules = reward.shippingRulesExpanded else {
    assert(
      !hasShipping,
      "This reward is shippable, but no shipping rules were included on the reward. The backer may not be able to complete this pledge."
    )

    return nil
  }

  guard let rule = rules.first(where: { $0.location.id == selectedLocation.id }) else {
    assert(
      !hasShipping,
      "This reward is shippable, but no shipping rule matched the selected location. The backer may not be able to complete this pledge."
    )

    return nil
  }

  return rule
}

/// Builds `PledgeViewData` and an add-on flag tuple for navigating to pledge customization.
func makePledgeViewDataAndHasAddOns(
  project: Project,
  reward: Reward,
  refTag: RefTag?,
  selectedShippingRule: ShippingRule?
) -> (PledgeViewData, Bool) {
  let pledgeContext =
    project.isInPostCampaignPledgingPhase
      ? PledgeViewContext.latePledge
      : PledgeViewContext.pledge

  /// Differentiating between updating a reward for a regular pledge and updating a Pledge Over Time pledge.
  let isPledgeOverTime = project.isPledgeOverTimeAllowed == true
  let updatePledgeContext = isPledgeOverTime
    ? PledgeViewContext.editPledgeOverTime
    : PledgeViewContext.updateReward

  let data = PledgeViewData(
    project: project,
    rewards: [reward],
    bonusSupport: nil,
    selectedShippingRule: selectedShippingRule,
    selectedQuantities: [reward.id: 1],
    selectedLocationId: nil, // Set during add-ons selection.
    refTag: refTag,
    context: project.personalization.backing == nil ? pledgeContext : updatePledgeContext
  )

  return (data, reward.hasAddOns)
}

/// Tracks the reward selection view or reward clicked analytics event for a project.
func trackRewardsEvent(
  project: Project,
  reward: Reward,
  refTag: RefTag?,
  isSelection: Bool
) {
  let (backing, shippingTotal) = backingAndShippingTotal(for: project, and: reward)
  let selectedQuantities = isSelection ? [reward.id: 1] : [:]
  let checkoutPropertiesData = checkoutProperties(
    from: project,
    baseReward: reward,
    addOnRewards: backing?.addOns ?? [],
    selectedQuantities: selectedQuantities,
    additionalPledgeAmount: backing?.bonusAmount ?? 0,
    pledgeTotal: backing?.amount ?? reward.minimum,
    shippingTotal: shippingTotal ?? 0,
    isApplePay: nil
  )

  if isSelection {
    AppEnvironment.current.ksrAnalytics.trackRewardClicked(
      project: project,
      reward: reward,
      checkoutPropertiesData: checkoutPropertiesData,
      refTag: refTag
    )
  } else {
    AppEnvironment.current.ksrAnalytics.trackRewardsViewed(
      project: project,
      checkoutPropertiesData: checkoutPropertiesData,
      refTag: refTag
    )
  }
}

/// Sends a third-party reward-selection-viewed conversion event when ATT identifier is available.
func triggerRewardSelectionViewedThirdPartyEvent(for project: Project) {
  AppEnvironment.current.appTrackingTransparency.updateAdvertisingIdentifier()

  guard let externalId = AppEnvironment.current.appTrackingTransparency.advertisingIdentifier else {
    return
  }

  let userId = AppEnvironment.current.currentUser.map { "\($0.id)" } ?? ""
  let projectId = "\(project.id)"

  var extInfo = Array(repeating: "", count: 16)
  extInfo[0] = "i2"
  extInfo[4] = AppEnvironment.current.mainBundle.platformVersion

  _ = AppEnvironment
    .current
    .apiService
    .triggerThirdPartyEventInput(
      input: .init(
        deviceId: externalId,
        eventName: ThirdPartyEventInputName.RewardSelectionViewed.rawValue,
        projectId: projectId,
        pledgeAmount: nil,
        shipping: nil,
        transactionId: nil,
        userId: userId,
        appData: .init(
          advertiserTrackingEnabled: true,
          applicationTrackingEnabled: true,
          extinfo: extInfo
        ),
        clientMutationId: ""
      )
    )
}

// MARK: - Signal Extension

extension Signal where Error == Never {
  // Combines a value signal with a boolean signal, returning filtered results.
  //
  // This will fire when _either_ the value signal, or the boolean signal, fires -
  // unlike filterWhenLatestFrom(someSignal, satisfies: isTrue), which will only fire
  // when the value signal changes.
  func combineLatestAndFilterOn(_ signal: Signal<Bool, Never>) -> Signal<Value, Never> {
    return self.combineLatest(with: signal)
      .filter { _, test in test == true }
      .map { value, _ in value }
  }
}

// MARK: - Experiments

/// Returns whether the "No Reward" tier should be positioned after the last available reward.
func shouldMoveNoReward_afterLastAvailableReward() -> Bool {
  let experiment = MoveNoRewardOptionExperiment()
  return experiment.boolValue(forKey: .show_no_reward_after_available_rewards) ?? false
}

/// Fetches project rewards sorted for the selected shipping country code.
func fetchRewards(
  forProject project: Project,
  sortedForShippingLocation location: Location?
) -> SignalProducer<[Reward], ErrorEnvelope> {
  let inserter: NoRewardInserter = shouldMoveNoReward_afterLastAvailableReward()
    ? NoRewardAfterLastAvailableReward(shippingLocation: location, project: project)
    : NoRewardFirst()

  return AppEnvironment.current.apiService
    .fetchProjectRewards(
      projectId: project.id,
      sortedForShippingCountryCode: location?.country,
      withNoReward: inserter
    )
}

