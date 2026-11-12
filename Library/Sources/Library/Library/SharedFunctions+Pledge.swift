import KsApi
import Prelude

/// Typed result returned by `sanitizedPledgeParameters(from:selectedQuantities:pledgeTotal:shippingRule:)`.
internal struct SanitizedPledgeParams: Equatable {
  /// Formatted decimal pledge total string (e.g. `"25.00"`).
  let pledgeTotal: String
  /// Expanded Relay GraphQL IDs matching `selectedQuantities`.
  let rewardIds: [String]
  /// Numeric shipping location identifier serialized as `String`, if shipping applies.
  let locationId: String?
}

internal func sanitizedPledgeParameters(
  from rewards: [Reward],
  selectedQuantities: SelectedRewardQuantities,
  pledgeTotal: Double,
  shippingRule: ShippingRule?
) -> SanitizedPledgeParams {
  let shippingLocationId = (shippingRule?.location.id).flatMap(String.init)

  let formattedPledgeTotal = Format.decimalCurrency(for: pledgeTotal)
  let rewardIds = rewards.map { reward -> [String] in
    guard let selectedRewardQuantity = selectedQuantities[reward.id] else { return [] }
    return Array(0..<selectedRewardQuantity).map { _ in reward.graphID }
  }
  .flatMap { $0 }

  return SanitizedPledgeParams(
    pledgeTotal: formattedPledgeTotal,
    rewardIds: rewardIds,
    locationId: shippingLocationId
  )
}


/**

 An helper func that calculates  pledge total for all rewards

 - parameter pledgeAmount: The amount pledged for a project.
 - parameter shippingCost: The shipping cost for the pledge.
 - parameter addOnRewardsTotal: The total amount of all addOn rewards.

 - returns: A `Double` of the pledge value.
 */
func calculatePledgeTotal(
  pledgeAmount: Double,
  shippingCost: Double,
  addOnRewardsTotal: Double
) -> Double {
  let r = [pledgeAmount, shippingCost, addOnRewardsTotal].reduce(0) { accum, amount in
    accum.addingCurrency(amount)
  }

  return r
}

/// Indicates whether the pledge represents a "no reward" commitment.
/// - parameter rewards: Selected `Reward` array for the pledge.
/// - returns: `true` if `rewards` contains only the no-reward tier.
public func pledgeHasNoRewards(rewards: [Reward]) -> Bool {
  rewards.count == 1 && rewards.first?.isNoReward == true
}

/**
 An helper func that calculates  pledge total for all rewards

 - parameter addOnRewards: The `Project` associated with a group of Rewards.
 - parameter selectedQuantities: A dictionary that aggregates the quantity of selected add-ons.

 - returns: A `Double` of all rewards add-ons total.
 */
func calculateAllRewardsTotal(
  addOnRewards: [Reward],
  selectedQuantities: SelectedRewardQuantities
) -> Double {
  addOnRewards.filter { !$0.isNoReward }
    .reduce(0.0) { total, reward -> Double in
      let totalForReward = reward.minimum
        .multiplyingCurrency(Double(selectedQuantities[reward.id] ?? 0))

      return total.addingCurrency(totalForReward)
    }
}

/// Builds `KSRAnalytics.CheckoutPropertiesData` for checkout and pledge tracking events.
/// - parameter project: Backed `Project` model.
/// - parameter baseReward: Selected base `Reward`.
/// - parameter addOnRewards: Selected add-on `Reward` values.
/// - parameter selectedQuantities: Map of add-on reward IDs to selected quantities.
/// - parameter additionalPledgeAmount: Bonus pledge amount above reward costs.
/// - parameter pledgeTotal: Combined pledge total amount.
/// - parameter shippingTotal: Computed shipping fee total.
/// - parameter checkoutId: Optional checkout graph identifier.
/// - parameter isApplePay: Optional flag indicating Apple Pay payment method.
/// - returns: Populated `KSRAnalytics.CheckoutPropertiesData` payload.
public func checkoutProperties(
  from project: Project,
  baseReward: Reward,
  addOnRewards: [Reward],
  selectedQuantities: SelectedRewardQuantities,
  additionalPledgeAmount: Double,
  pledgeTotal: Double,
  shippingTotal: Double,
  checkoutId: String? = nil,
  isApplePay: Bool?
) -> KSRAnalytics.CheckoutPropertiesData {
  let staticUsdRate = Double(project.stats.staticUsdRate)

  // Two decimal places to represent cent values
  let pledgeTotalUsd = rounded(pledgeTotal.multiplyingCurrency(staticUsdRate), places: 2)

  let bonusAmountUsd = rounded(additionalPledgeAmount.multiplyingCurrency(staticUsdRate), places: 2)

  let addOnRewards = addOnRewards
    .filter { reward in reward.id != baseReward.id }
    .map { reward -> [Reward] in
      guard let selectedRewardQuantity = selectedQuantities[reward.id] else { return [] }
      return Array(0..<selectedRewardQuantity).map { _ in reward }
    }
    .flatMap { $0 }

  let addOnsCountTotal = addOnRewards.map(\.id).count
  let addOnsCountUnique = Set(addOnRewards.map(\.id)).count
  let addOnsMinimumUsd = addOnRewards
    .reduce(0.0) { accum, addOn in accum.addingCurrency(addOn.minimum) }
    .multiplyingCurrency(staticUsdRate)

  let shippingAmount: Double? = baseReward.shipping.enabled ? shippingTotal : nil

  let rewardId = String(baseReward.id)
  let estimatedDelivery = baseReward.estimatedDeliveryOn

  var paymentType: String?
  if let isApplePay = isApplePay {
    paymentType = isApplePay
      ? PaymentType.applePay.trackingString
      : PaymentType.creditCard.trackingString
  }

  let rewardTitle = baseReward.title
  let rewardMinimumUsd = rounded(baseReward.minimum.multiplyingCurrency(staticUsdRate), places: 2)
  let shippingEnabled = baseReward.shipping.enabled
  let shippingAmountUsd = shippingAmount?.multiplyingCurrency(staticUsdRate)

  let userHasEligibleStoredApplePayCard = AppEnvironment.current
    .applePayCapabilities
    .applePayCapable(for: project)

  return KSRAnalytics.CheckoutPropertiesData(
    addOnsCountTotal: addOnsCountTotal,
    addOnsCountUnique: addOnsCountUnique,
    addOnsMinimumUsd: addOnsMinimumUsd,
    bonusAmountInUsd: bonusAmountUsd,
    checkoutId: checkoutId,
    estimatedDelivery: estimatedDelivery,
    paymentType: paymentType,
    revenueInUsd: pledgeTotalUsd,
    rewardId: rewardId,
    rewardMinimumUsd: rewardMinimumUsd,
    rewardTitle: rewardTitle,
    shippingEnabled: shippingEnabled,
    shippingAmountUsd: shippingAmountUsd,
    userHasStoredApplePayCard: userHasEligibleStoredApplePayCard
  )
}
