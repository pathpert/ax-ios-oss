import Experimentation
import Foundation
import KsApi
import Prelude
import ReactiveSwift

// MARK: - Functions

/// Produces available add-on rewards for the given base reward and shipping rule.
func addOnsProducer(
  slug: String,
  baseReward: Reward?,
  shippingRule: ShippingRule?
) -> SignalProducer<[Reward]?, ErrorEnvelope> {
  // You can't add add-ons to No Reward.
  guard let baseReward, baseReward.isNoReward == false else {
    return SignalProducer(value: nil)
  }

  // Only fetch add-ons if the base reward has add-ons.
  guard baseReward.hasAddOns else {
    return SignalProducer(value: nil)
  }

  let experiment = SpeedyCheckoutExperiment()
  if experiment.boolValue(forKey: .speedy_checkout_enabled) == true {
    // Shipping rule may be nil if the backer selected no reward or a digital reward.
    let shippingCountryCode = shippingRule?.location.country ?? AppEnvironment.current.countryCode

    return AppEnvironment.current.apiService.fastFetchRewardAddOnsSelection(
      baseRewardId: baseReward.id,
      countryCode: shippingCountryCode
    ).map { .some($0) }
  }

  return AppEnvironment.current.apiService.fetchRewardAddOnsSelectionViewRewards(
    slug: slug,
    shippingEnabled: shippingRule?.location.graphID != nil,
    locationId: shippingRule?.location.graphID
  )
  .map { project in
    project.rewardData.addOns
  }
}

/// Flattens the add-on view data tuple with the latest selected quantities map.
func unpackAddOnRewards(
  rewardsData: ([Reward], Project, Reward, PledgeViewContext, ShippingRule?),
  selectedQuantities: SelectedRewardQuantities
) -> ([Reward], Project, Reward, PledgeViewContext, ShippingRule?, SelectedRewardQuantities) {
  return (rewardsData.0, rewardsData.1, rewardsData.2, rewardsData.3, rewardsData.4, selectedQuantities)
}

/// Maps fetched add-ons and selection quantities into table view data source items.
func rewardsData(
  addOns: [Reward],
  project: Project,
  baseReward: Reward,
  context: PledgeViewContext,
  shippingRule: ShippingRule?,
  selectedQuantities: SelectedRewardQuantities
) -> [RewardAddOnSelectionDataSourceItem] {
  let addOnsFilteredByAvailability = addOns.filter { addOnIsAvailable($0, in: project) }

  let addOnsFilteredByExpandedShippingRule = filteredAddOns(
    addOnsFilteredByAvailability,
    filteredBy: shippingRule,
    baseReward: baseReward
  )

  guard !addOnsFilteredByExpandedShippingRule.isEmpty else {
    return [.emptyState(.addOnsUnavailable)]
  }

  return addOnsFilteredByExpandedShippingRule
    .map { reward in
      RewardAddOnCardViewData(
        project: project,
        reward: reward,
        context: context == .pledge ? .pledge : .manage,
        shippingRule: reward.shipping.enabled
          ? reward.shippingRule(matching: shippingRule)
          : nil,
        selectedQuantities: selectedQuantities
      )
    }
    .map(RewardAddOnSelectionDataSourceItem.rewardAddOn)
}

/// Returns whether an add-on is currently available or already part of the user's backing.
func addOnIsAvailable(_ addOn: Reward, in project: Project) -> Bool {
  // If the user is backing this addOn, it's available for editing
  if let backedAddOns = project.personalization.backing?.addOns, backedAddOns.map(\.id).contains(addOn.id) {
    return true
  }

  return addOn.isAvailable ?? false
}

/// Filters add-ons based on the base reward's fulfillment type (digital, local pickup, or shipping).
func filteredAddOns(
  _ addOns: [Reward],
  filteredBy shippingRule: ShippingRule?,
  baseReward: Reward
) -> [Reward] {
  let isBaseRewardDigital = isRewardDigital(baseReward)
  let isBaseRewardLocalPickup = isRewardLocalPickup(baseReward)

  return addOns.filter { addOn in
    var isValidAddonToDisplay = false
    let isAddOnDigital = isRewardDigital(addOn)
    let isAddOnLocalPickup = isRewardLocalPickup(addOn)
    let isAddOnLocalOrDigital = isAddOnDigital || isAddOnLocalPickup

    // For digital-only base rewards only return add-ons that are also digital-only.
    if isBaseRewardDigital, isAddOnDigital {
      isValidAddonToDisplay = true
    } else if isBaseRewardLocalPickup, isAddOnLocalOrDigital {
      isValidAddonToDisplay = true // return all addons that are digital for local base reward

      if isAddOnLocalPickup {
        if let addOnLocationId = addOn.localPickup?.id,
           let baseRewardLocationId = baseReward.localPickup?.id,
           addOnLocationId == baseRewardLocationId {
          // if add on is local for local base, ensure locations are equal before displaying
          isValidAddonToDisplay = true
        } else {
          isValidAddonToDisplay = false
        }
      }
    } else if !isBaseRewardDigital, !isBaseRewardLocalPickup {
      // For restricted or unrestricted shipping base rewards, unrestricted shipping
      // or digital-only add-ons are available.
      isValidAddonToDisplay = isAddOnDigital || addOnReward(addOn, shipsTo: shippingRule?.location.id)
    }

    return isValidAddonToDisplay
  }
}

/// For base rewards that have restricted or unrestricted shipping, only return
/// add-ons that can ship to the selected shipping location.
func addOnReward(
  _ addOn: Reward,
  shipsTo locationId: Int?
) -> Bool {
  guard let selectedLocationId = locationId else { return false }

  let addOnShippingLocationIds: Set<Int> = Set(
    addOn.shippingRulesExpanded?.map(\.location).map(\.id) ?? []
  )

  return addOnShippingLocationIds.contains(selectedLocationId)
}

/// Returns whether the bonus pledge amount and add-on/shipping selections are valid to continue.
func isAddOnSelectionValid(
  project: Project,
  initialAdditionalPledgeAmount: Double,
  pledgeAmountData: PledgeAmountData,
  latestSelectedQuantities: SelectedRewardQuantities,
  selectedShippingRule: ShippingRule?
) -> Bool {
  if !pledgeAmountData.isValid { return false }

  guard let backing = project.personalization.backing else { return true }

  let addOnChanged = latestSelectedQuantities != selectedRewardQuantities(in: backing)
    || backing.locationId != selectedShippingRule?.location.id
  let bonusChanged = pledgeAmountData.amount != initialAdditionalPledgeAmount

  return addOnChanged || bonusChanged
}

/// Tracks add-ons page view or continue button click events with checkout properties.
func trackAddOnsEvent(
  project: Project,
  baseReward: Reward,
  selectedRewards: [Reward],
  selectedQuantities: SelectedRewardQuantities,
  additionalPledgeAmount: Double,
  pledgeTotal: Double,
  refTag: RefTag?,
  didContinue: Bool
) {
  let checkoutData = checkoutProperties(
    from: project,
    baseReward: baseReward,
    addOnRewards: selectedRewards,
    selectedQuantities: selectedQuantities,
    additionalPledgeAmount: additionalPledgeAmount,
    pledgeTotal: pledgeTotal,
    shippingTotal: 0,
    isApplePay: nil
  )

  if didContinue {
    AppEnvironment.current.ksrAnalytics.trackAddOnsContinueButtonClicked(
      project: project,
      reward: baseReward,
      checkoutData: checkoutData,
      refTag: refTag
    )
  } else {
    AppEnvironment.current.ksrAnalytics.trackAddOnsPageViewed(
      project: project,
      reward: baseReward,
      checkoutData: checkoutData,
      refTag: refTag
    )
  }
}

/// Wires initial add-on page view and continue button click analytics tracking.
func wireAddOnTrackingSignals(
  project: Signal<Project, Never>,
  baseReward: Signal<Reward, Never>,
  selectedRewards: Signal<[Reward], Never>,
  selectedQuantities: Signal<SelectedRewardQuantities, Never>,
  refTag: Signal<RefTag?, Never>,
  configData: Signal<PledgeViewData, Never>,
  additionalPledgeAmount: Signal<Double, Never>,
  pledgeTotal: Signal<Double, Never>,
  continueTapped: Signal<Void, Never>
) {
  Signal.zip(project, baseReward, selectedRewards, refTag, configData, additionalPledgeAmount, pledgeTotal)
    .take(first: 1)
    .observeForUI()
    .observeValues { project, baseReward, selectedRewards, refTag, configData, additionalPledgeAmount, pledgeTotal in
      trackAddOnsEvent(
        project: project,
        baseReward: baseReward,
        selectedRewards: selectedRewards,
        selectedQuantities: configData.selectedQuantities,
        additionalPledgeAmount: additionalPledgeAmount,
        pledgeTotal: pledgeTotal,
        refTag: refTag,
        didContinue: false
      )
    }

  Signal.combineLatest(
    project,
    baseReward,
    selectedRewards,
    selectedQuantities,
    additionalPledgeAmount,
    pledgeTotal,
    refTag
  )
  .takeWhen(continueTapped)
  .observeValues { project, baseReward, selectedRewards, selectedQuantities, additionalPledgeAmount, pledgeTotal, refTag in
    trackAddOnsEvent(
      project: project,
      baseReward: baseReward,
      selectedRewards: selectedRewards,
      selectedQuantities: selectedQuantities,
      additionalPledgeAmount: additionalPledgeAmount,
      pledgeTotal: pledgeTotal,
      refTag: refTag,
      didContinue: true
    )
  }
}
