import KsApi
import Prelude

/// Selects the default shipping location from a list of available `Location` values.
/// Returns the first location in `locations`, or `nil` when empty.
public func defaultShippingLocation(fromLocations locations: [Location]) -> Location? {
  let environmentCountry = AppEnvironment.current.config?.countryCode
  if let currentLocation = locations
    .first(where: { $0.country == environmentCountry }) {
    return currentLocation
  }

  if let usaLocation = locations.first(where: { $0.country == "US" }) {
    return usaLocation
  }

  return locations.first
}


/// Returns `true` if the reward can currently be backed (`isAvailable == true` or no-reward tier).
public func rewardIsAvailable(_ reward: Reward) -> Bool {
  reward.isAvailable == true || reward.isNoReward
}


/// Computes the remaining quantity of a limited reward available to a backer, including their existing backing quantity.
/// Returns `nil` when the reward has no global limit.
public func rewardLimitRemainingForBacker(project: Project, reward: Reward) -> Int? {
  guard let remaining = reward.remaining else {
    return nil
  }

  // If the reward is limited, determine the currently backed quantity.
  var backedQuantity: Int = 0
  if let backing = project.personalization.backing {
    let rewardQuantities = selectedRewardQuantities(in: backing)
    backedQuantity = rewardQuantities[reward.id] ?? 0
  }

  /**
   Remaining limit for the backer is the minimum of the total remaining quantity
   (including what has been backed).

   For example, let `remaining` be 1 and `backedQuantity` be 3:

   `remainingForBacker` will be 4 as the backer as already backed 3, 1 is available.
   */

  return remaining + backedQuantity
}


/// Computes the remaining quantity a specific backer may still claim given `limitPerBacker` and overall stock.
/// Returns `nil` when `limitPerBacker` is unset.
public func rewardLimitPerBackerRemainingForBacker(project: Project, reward: Reward) -> Int? {
  /// Be sure that there is a `limitPerBacker` set
  guard let limitPerBacker = reward.limitPerBacker else { return nil }

  /**
   If this is not a limited reward, the `limitPerBacker` is remaining when creating/editing a pledge.
   This amount will include any backed quantity as the user is able to edit their pledge.
   */
  guard let remaining = reward.remaining else {
    return limitPerBacker
  }

  // If the reward is limited, determine the currently backed quantity.
  var backedQuantity: Int = 0
  if let backing = project.personalization.backing {
    let rewardQuantities = selectedRewardQuantities(in: backing)
    backedQuantity = rewardQuantities[reward.id] ?? 0
  }

  /**
   Remaining for the backer is the minimum of the total remaining quantity
   (including what has been backed) or `limitPerBacker`.

   For example, let `remaining` be 1, `limitPerBacker` be 5 and `backedQuantity` be 3:

   `remainingForBacker` will be 4 as the backer as already backed 3, 1 is available and this amount is less
   than `limitPerBacker`.
   */

  let remainingPlusBacked = remaining + backedQuantity

  return min(remainingPlusBacked, limitPerBacker)
}


/// Returns a mapping of reward IDs to quantities currently backed by the user (base reward plus add-ons).
public func selectedRewardQuantities(in backing: Backing) -> SelectedRewardQuantities {
  var quantities: [SelectedRewardId: SelectedRewardQuantity] = [:]

  let rewards = [backing.reward].compact() + (backing.addOns ?? [])

  rewards.forEach { reward in
    quantities[reward.id] = (quantities[reward.id] ?? 0) + 1
  }

  return quantities
}


private func rewardRequiresShippingLocation(_ reward: Reward) -> Bool {
  let isRewardDigital = isRewardDigital(reward)
  let isRewardLocal = isRewardLocalPickup(reward)
  let isNoRewardReward = reward.isNoReward

  // Return all rewards that are no reward, digital, local pickup.
  if isNoRewardReward || isRewardDigital || isRewardLocal {
    return false
  }

  assert(
    reward.isUnRestrictedShippingPreference || reward.isRestrictedShippingPreference,
    "A reward should be unrestricted, restricted, digital, local, or no reward."
  )

  return true
}


/// Returns `true` when `reward` can be shipped to `selectedShippingRule` for `project`.
/// Evaluates digital, unrestricted, and shipping-rule-matched tiers; returns `false` when location is required but missing.
public func rewardCanShip(
  _ reward: Reward,
  toLocation location: Location?
) -> Bool {
  // If the reward is digital, local, or no reward, return true.
  // We don't need to check if it is available for a particular location because it's available anywhere.
  // If a project has only digital or local rewards, we won't show the location picker,
  // so the selected location will always be nil.
  if !rewardRequiresShippingLocation(reward) {
    return true
  }

  // Otherwise, the reward requires a shipping location.
  // This makes a `nil` selected location invalid.
  guard let selectedLocationId = location?.id else {
    return false
  }

  // An unrestricted shipping reward can ship to any selected location.
  // We don't need to check its shipping rules.
  if reward.isUnRestrictedShippingPreference {
    return true
  }

  assert(
    reward.isRestrictedShippingPreference,
    "A reward should be unrestricted, restricted, digital, local, or no reward."
  )

  guard let rules = reward.shippingRulesExpanded, rules.count > 0 else {
    assert(
      false,
      "Checking a restricted reward for valid shipping locations, but it is missing expanded shipping rules."
    )
    return false
  }

  return rules.contains(where: { rule in
    rule.location.id == selectedLocationId
  })
}


/// Determines whether the rewards carousel can open the pledge flow for `reward` in `project`.
/// Existing backers can always edit their current reward; unavailable rewards or non-live non-late-pledge projects return `false`.
public func rewardsCarouselCanNavigateToReward(
  _ reward: Reward,
  in project: Project,
  selectedShippingLocation location: Location?
) -> Bool {
  guard !currentUserIsCreator(of: project) else { return false }

  let rewardCanShipToSelectedLocation = rewardCanShip(reward, toLocation: location)
  let isBacking = userIsBacking(reward: reward, inProject: project)
  let isAvailableForNewBacker = rewardIsAvailable(reward) && rewardCanShipToSelectedLocation && !isBacking
  /// Backers should always be able to edit the currently backed reward. It's the only path to update the pledge/bonus amount.
  let isAvailableForExistingBackerToEdit = isBacking

  if project.isInPostCampaignPledgingPhase {
    return [
      project.state == .successful,
      isAvailableForNewBacker
    ]
    .allSatisfy(isTrue)
  }

  return [
    project.state == .live,
    isAvailableForNewBacker || isAvailableForExistingBackerToEdit
  ]
  .allSatisfy(isTrue)
}


/// Determines if a start date from a given reward/add-on predates the current date.
/// - parameter reward: The reward being evaluated.
/// - returns: `true` if `startsAt` is nil or `<=` the current timestamp.
public func isStartDateBeforeToday(for reward: Reward) -> Bool {
  return reward.startsAt == nil || (reward.startsAt ?? 0) <= AppEnvironment.current.dateType.init()
    .timeIntervalSince1970
}

/// Determines if an end date from a given reward/add-on is on or after the current date.
/// - parameter reward: The reward being evaluated.
/// - returns: `true` if `endsAt` is nil or `>=` the current timestamp.
public func isEndDateAfterToday(for reward: Reward) -> Bool {
  return reward.endsAt == nil || (reward.endsAt ?? 0) >= AppEnvironment.current.dateType.init()
    .timeIntervalSince1970
}

/// Returns `true` when `reward` specifies local pickup fulfillment.
/// - parameter reward: A `Reward` object.
public func isRewardLocalPickup(_ reward: Reward?) -> Bool {
  guard let existingReward = reward else {
    return false
  }

  return !existingReward.shipping.enabled &&
    existingReward.localPickup != nil &&
    existingReward.shipping
    .preference.isAny(of: Reward.Shipping.Preference.local)
}

/// Returns `true` when `reward` is digital (shipping disabled and `.none` preference).
/// - parameter reward: A `Reward` object.
public func isRewardDigital(_ reward: Reward?) -> Bool {
  guard let existingReward = reward else {
    return false
  }

  return !existingReward.shipping.enabled &&
    existingReward.shipping.preference
    .isAny(of: Reward.Shipping.Preference.none)
}

