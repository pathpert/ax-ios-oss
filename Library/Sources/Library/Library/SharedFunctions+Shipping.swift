import KsApi
import Prelude

/// Returns the base reward shipping cost in project currency, or `0.0` for digital/local/no-reward pledges.
/// - parameter project: Associated `Project` model.
/// - parameter baseReward: Selected base `Reward`.
/// - parameter shippingRule: Active `ShippingRule` selection for the pledge.
public func getBaseRewardShippingTotal(
  project: Project,
  baseReward: Reward,
  shippingRule: ShippingRule?
) -> Double {
  // If digital or local pickup there is no shipping
  guard !isRewardDigital(baseReward),
        !isRewardLocalPickup(baseReward),
        baseReward != .noReward else { return 0.0 }
  let backing = project.personalization.backing

  // If there is no `Backing` (new pledge), return the rewards shipping rule
  return backing.isNil ?
    baseReward.shippingRule(matching: shippingRule)?.cost ?? 0.0 :
    backing?.shippingAmount.flatMap(Double.init) ?? 0.0
}

/**
 An helper func that calculates  shipping total for base reward

 -  parameter shippingRule: `ShippingRule` information about shipping details of selected rewards.
 - parameter addOnRewards: An array of `Reward` objects representing the available add-ons.
 - parameter quantities: A dictionary that aggregates the quantity of selected add-ons.

 - returns: A `Double` of the shipping value.
 */
func calculateShippingTotal(
  shippingRule: ShippingRule,
  addOnRewards: [Reward],
  quantities: SelectedRewardQuantities
) -> Double {
  let calculatedShippingTotal = addOnRewards.reduce(0.0) { total, reward in
    guard !isRewardDigital(reward), !isRewardLocalPickup(reward), reward != .noReward else { return total }

    let shippingCostForReward = reward.shippingRule(matching: shippingRule)?.cost ?? 0

    let totalShippingForReward = shippingCostForReward
      .multiplyingCurrency(Double(quantities[reward.id] ?? 0))

    return total.addingCurrency(totalShippingForReward)
  }

  return calculatedShippingTotal
}

/// Formats the estimated shipping range string for `reward` and optional `selectedShippingRule` in `project`.
/// Returns `nil` for no-reward, local pickup, or digital rewards with no shipping cost.
public func estimatedShippingText(
  for rewards: [Reward],
  project: Project,
  locationId: Int,
  selectedQuantities: SelectedRewardQuantities? = nil
) -> String? {
  guard project.stats.needsConversion == false else {
    return estimatedShippingConversionText(for: rewards, project: project, locationId: locationId)
  }

  let (estimatedMin, estimatedMax) = estimatedMinMax(
    from: rewards,
    locationId: locationId,
    selectedQuantities: selectedQuantities
  )

  guard estimatedMin > 0, estimatedMax > 0 else { return nil }

  let projectCurrency = project.stats.projectCurrency

  let formattedMin = Format.currency(
    estimatedMin,
    currencyCode: projectCurrency,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    roundingMode: .halfUp
  )

  let formattedMax = Format.currency(
    estimatedMax,
    currencyCode: projectCurrency,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    roundingMode: .halfUp
  )

  let estimatedShippingString: String = formattedMin == formattedMax
    ? "\(formattedMin)"
    : "\(formattedMin)-\(formattedMax)"

  return estimatedShippingString
}


/// Formats the converted estimated shipping range string in the user's preferred currency, or returns `nil` when conversion is unnecessary.
public func estimatedShippingConversionText(
  for rewards: [Reward],
  project: Project,
  locationId: Int,
  selectedQuantities: SelectedRewardQuantities? = nil
) -> String? {
  guard project.stats.needsConversion else { return nil }

  let (estimatedMin, estimatedMax) = estimatedMinMax(
    from: rewards,
    locationId: locationId,
    selectedQuantities: selectedQuantities
  )

  guard estimatedMin > 0, estimatedMax > 0 else { return nil }

  let convertedMin = estimatedMin * Double(project.stats.userCurrencyRate ?? project.stats.staticUsdRate)
  let convertedMax = estimatedMax * Double(project.stats.userCurrencyRate ?? project.stats.staticUsdRate)
  let currencyCode = project.stats.userCurrency ?? Project.Country.us.currencyCode

  let formattedMin = Format.currency(
    convertedMin,
    currencyCode: currencyCode,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    roundingMode: .halfUp
  )

  let formattedMax = Format.currency(
    convertedMax,
    currencyCode: currencyCode,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    roundingMode: .halfUp
  )

  let conversionText: String = formattedMin == formattedMax
    ? Strings.About_reward_amount(reward_amount: formattedMin)
    : Strings.About_reward_amount(reward_amount: "\(formattedMin)-\(formattedMax)")

  return conversionText
}


private func estimatedMinMax(
  from rewards: [Reward],
  locationId: Int,
  selectedQuantities: SelectedRewardQuantities?
) -> (Double, Double) {
  var min: Double = 0
  var max: Double = 0

  rewards.forEach { reward in
    guard reward.shipping.enabled,
          let shippingRules = reward.shippingRulesExpanded else { return }

    var shipping: ShippingRule? = shippingRules.first(where: { $0.location.id == locationId })

    /// Verify there are estimated amounts greater than 0
    guard let estimatedMin = shipping?.estimatedMin?.amount,
          let estimatedMax = shipping?.estimatedMax?.amount,
          estimatedMin > 0 || estimatedMax > 0 else {
      return
    }

    min += estimatedMin * Double(selectedQuantities?[reward.id] ?? 1)
    max += estimatedMax * Double(selectedQuantities?[reward.id] ?? 1)
  }

  return (min, max)
}

