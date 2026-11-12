import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveSwift

/// Helper definitions for `makePostCampaignCreateCheckoutInput` in `PostCampaignCheckoutViewModel+Helpers.swift`.
internal func makePostCampaignCreateCheckoutInput(
  project: Project,
  rewards: [Reward],
  selectedQuantities: SelectedRewardQuantities,
  selectedShippingRule: ShippingRule?,
  pledgeTotal: Double,
  refTag: RefTag?
) -> KsApi.CreateCheckoutInput {
  let rewardsIDs: [String] = rewards.first?.isNoReward == true
    ? []
    : rewards.flatMap { reward -> [String] in
      guard let count = selectedQuantities[reward.id] else {
        return []
      }
      return [String](repeating: reward.graphID, count: count)
    }

  let locationId = selectedShippingRule.flatMap { String($0.location.id) }

  return KsApi.CreateCheckoutInput(
    projectId: project.graphID,
    amount: String(format: "%.2f", pledgeTotal),
    locationId: locationId,
    rewardIds: rewardsIDs,
    refParam: refTag?.stringTag
  )
}

internal func decodePostCampaignCheckoutId(_ rawId: String) -> String {
  var checkoutId = rawId
  if let decoded = decodeBase64(checkoutId), let range = decoded.range(of: "Checkout-") {
    checkoutId = String(decoded[range.upperBound...])
  }
  return checkoutId
}

internal func makePostCampaignSummaryPayload(
  data: PledgeViewData,
  shippingTotal: Double,
  pledgeTotal: Double
) -> (PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData) {
  var rewards = data.rewards
  var bonus = data.bonusSupport
  if let reward = rewards.first, reward.isNoReward, let bonusAmount = bonus {
    rewards[0] = reward
      |> Reward.lens.minimum .~ bonusAmount
      |> Reward.lens.title .~ Strings.Pledge_without_a_reward()
    bonus = 0
  }
  let omitUSCurrencyCode = data.project.stats.omitUSCurrencyCode
  let projectCurrency = data.project.statsCurrency
  let shippingSummary = data.selectedShippingRule.flatMap {
    PledgeShippingSummaryViewData(
      locationName: $0.location.localizedName,
      omitUSCurrencyCode: omitUSCurrencyCode,
      currencyCode: projectCurrency,
      total: shippingTotal
    )
  }
  let rewardsData = PostCampaignRewardsSummaryViewData(
    rewards: data.rewards,
    selectedQuantities: data.selectedQuantities,
    currencyCode: projectCurrency,
    omitCurrencyCode: omitUSCurrencyCode,
    shipping: shippingSummary,
    useLatePledgeCosts: true
  )
  let pledgeData = PledgeSummaryViewData(
    project: data.project,
    total: pledgeTotal,
    confirmationLabelHidden: true,
    pledgeHasNoReward: pledgeHasNoRewards(rewards: rewardsData.rewards)
  )
  return (rewardsData, bonus, pledgeData)
}

internal func makePostCampaignEstimatedShipping(
  project: Project,
  rewards: [Reward],
  shippingRule: ShippingRule?,
  selectedQuantities: SelectedRewardQuantities
) -> (String?, String?) {
  guard let rule = shippingRule else { return (nil, nil) }

  return (
    estimatedShippingText(
      for: rewards,
      project: project,
      locationId: rule.location.id,
      selectedQuantities: selectedQuantities
    ),
    estimatedShippingConversionText(
      for: rewards,
      project: project,
      locationId: rule.location.id,
      selectedQuantities: selectedQuantities
    )
  )
}

internal func makePostCampaignApplePayAuthorizationData(
  project: Project,
  baseReward: Reward,
  allRewardsTotal: Double,
  bonusAmount: Double,
  allRewardsShippingTotal: Double,
  pledgeTotal: Double,
  paymentIntent: String
) -> PostCampaignPaymentAuthorizationData {
  PostCampaignPaymentAuthorizationData(
    project: project,
    hasNoReward: baseReward.isNoReward,
    subtotal: baseReward.isNoReward ? bonusAmount : allRewardsTotal,
    bonus: baseReward.isNoReward ? 0.0 : bonusAmount,
    shipping: allRewardsShippingTotal,
    total: pledgeTotal,
    merchantIdentifier: Secrets.ApplePay.merchantIdentifier,
    paymentIntent: paymentIntent
  )
}

internal func makeCompleteOnSessionCheckoutInput(
  checkoutId: String,
  clientSecret: String,
  paymentSourceId: String?,
  reusable: Bool
) -> GraphAPI.CompleteOnSessionCheckoutInput {
  // ApplePay params are omitted (`nil`) because Stripe Tokens are deprecated for PaymentIntent flows.
  GraphAPI.CompleteOnSessionCheckoutInput(
    applePay: nil,
    checkoutId: encodeToBase64("Checkout-\(checkoutId)"),
    paymentIntentClientSecret: clientSecret,
    paymentSourceId: GraphQLNullable.someOrNil(paymentSourceId),
    paymentSourceReusable: .some(reusable)
  )
}

internal func mapPostCampaignCheckoutError(_ error: ErrorEnvelope) -> String {
  switch error.ksrCode {
  case .ValidateCheckoutError:
    return error.errorMessages.first ?? Strings.Something_went_wrong_please_try_again()
  default:
    return Strings.Something_went_wrong_please_try_again()
  }
}

private func trackingDataFromCheckoutParams(
  _ data: PledgeViewData,
  baseReward: Reward,
  pledgeTotal: Double,
  shippingTotal: Double,
  checkoutId: String?,
  isApplePay: Bool = false
) -> KSRAnalytics.CheckoutPropertiesData {
  return checkoutProperties(
    from: data.project,
    baseReward: baseReward,
    addOnRewards: data.rewards,
    selectedQuantities: data.selectedQuantities,
    additionalPledgeAmount: data.bonusSupport ?? 0,
    pledgeTotal: pledgeTotal,
    shippingTotal: shippingTotal,
    checkoutId: checkoutId,
    isApplePay: isApplePay
  )
}

internal func bindPostCampaignCheckoutTracking(
  checkoutData: Signal<(PledgeViewData, Reward, Double, Double, String?), Never>,
  submitTapped: Signal<Void, Never>,
  applePayTapped: Signal<Void, Never>
) {
  checkoutData.take(first: 1)
    .observeValues { data, baseReward, pledgeTotal, shippingTotal, checkoutId in
      let analyticsData = trackingDataFromCheckoutParams(
        data,
        baseReward: baseReward,
        pledgeTotal: pledgeTotal,
        shippingTotal: shippingTotal,
        checkoutId: checkoutId
      )
      AppEnvironment.current.ksrAnalytics.trackCheckoutPaymentPageViewed(
        project: data.project,
        reward: data.rewards[0],
        pledgeViewContext: data.context,
        checkoutData: analyticsData,
        refTag: data.refTag
      )
    }

  let trackSubmit: (Bool, KSRAnalytics.TypeContext) -> ((PledgeViewData, Reward, Double, Double, String?)) -> Void = {
    isApplePay, typeContext in
    { args in
      let (data, baseReward, pledgeTotal, shippingTotal, checkoutId) = args
      let analyticsData = trackingDataFromCheckoutParams(
        data,
        baseReward: baseReward,
        pledgeTotal: pledgeTotal,
        shippingTotal: shippingTotal,
        checkoutId: checkoutId,
        isApplePay: isApplePay
      )
      AppEnvironment.current.ksrAnalytics.trackPledgeSubmitButtonClicked(
        project: data.project,
        reward: baseReward,
        typeContext: typeContext,
        checkoutData: analyticsData,
        refTag: data.refTag
      )
    }
  }

  checkoutData
    .takeWhen(submitTapped)
    .observeValues(trackSubmit(false, .creditCard))

  checkoutData
    .takeWhen(applePayTapped)
    .observeValues(trackSubmit(true, .applePay))
}
