import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Helper definitions for `pledgeRequiresSCA` in `PledgeViewModel+Helpers.swift`.
internal func pledgeRequiresSCA(_ envelope: StripeSCARequiring) -> Bool {
  return envelope.requiresSCAFlow
}

internal func allPledgeValuesChangedAndValid(
  paymentSourceValid: Bool,
  pledgeOverTimeIsLoading: Bool,
  context _: PledgeViewContext
) -> Bool {
  return paymentSourceValid && !pledgeOverTimeIsLoading
}

internal func makePledgeRewardsSummaryPayload(
  data: PledgeViewData,
  pledgeTotal: Double,
  additionalPledgeAmount: Double,
  shipping: PledgeShippingSummaryViewData?,
  rewards: [Reward]
) -> (PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData) {
  let isLatePledge = data.context == .latePledge ||
    (
      data.context == .fixPaymentMethod &&
        data.project.personalization.backing?.isLatePledge == true
    )

  let rewardsData = PostCampaignRewardsSummaryViewData(
    rewards: data.rewards,
    selectedQuantities: data.selectedQuantities,
    currencyCode: data.project.statsCurrency,
    omitCurrencyCode: data.project.stats.omitUSCurrencyCode,
    shipping: shipping,
    useLatePledgeCosts: isLatePledge
  )
  let pledgeData = PledgeSummaryViewData(
    project: data.project,
    total: pledgeTotal,
    confirmationLabelHidden: false,
    pledgeHasNoReward: pledgeHasNoRewards(rewards: rewards)
  )
  return (rewardsData, additionalPledgeAmount, pledgeData)
}

internal func makePledgeEstimatedShipping(
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

internal func makePledgeAmountSummaryViewData(
  with project: Project,
  reward _: Reward,
  allRewardsTotal: Double,
  additionalPledgeAmount: Double,
  shippingViewsHidden: Bool
) -> PledgeAmountSummaryViewData? {
  guard let backing = project.personalization.backing else { return nil }

  let rewardIsLocalPickup = isRewardLocalPickup(backing.reward)

  return .init(
    bonusAmount: additionalPledgeAmount,
    bonusAmountHidden: false,
    isNoReward: backing.reward?.isNoReward ?? false,
    locationName: backing.locationName,
    omitUSCurrencyCode: project.stats.omitUSCurrencyCode,
    currencyCode: project.statsCurrency,
    pledgedOn: backing.pledgedAt,
    rewardMinimum: allRewardsTotal,
    shippingAmount: backing.shippingAmount.flatMap(Double.init),
    shippingAmountHidden: !shippingViewsHidden,
    rewardIsLocalPickup: rewardIsLocalPickup
  )
}

internal func makePledgeThanksPageData(
  data: CreateBackingData,
  isApplePay: Bool,
  checkoutId: Int?,
  baseReward: Reward,
  additionalPledgeAmount: Double,
  shippingTotal: Double
) -> ThanksPageData {
  let checkoutPropsData = checkoutProperties(
    from: data.project,
    baseReward: baseReward,
    addOnRewards: data.rewards,
    selectedQuantities: data.selectedQuantities,
    additionalPledgeAmount: additionalPledgeAmount,
    pledgeTotal: data.pledgeTotal,
    shippingTotal: shippingTotal,
    checkoutId: checkoutId.map(String.init),
    isApplePay: isApplePay
  )

  return ThanksPageData(
    project: data.project,
    reward: baseReward,
    checkoutData: checkoutPropsData,
    pledgeTotal: data.pledgeTotal
  )
}

internal func bindPledgeTracking(
  project: Signal<Project, Never>,
  baseReward: Signal<Reward, Never>,
  rewards: Signal<[Reward], Never>,
  selectedQuantities: Signal<SelectedRewardQuantities, Never>,
  refTag: Signal<RefTag?, Never>,
  additionalPledgeAmount: Signal<Double, Never>,
  pledgeTotal: Signal<Double, Never>,
  context: Signal<PledgeViewContext, Never>,
  createBackingData: Signal<CreateBackingData, Never>,
  submitTapped: Signal<Void, Never>,
  applePayTapped: Signal<Void, Never>
) {
  let trackPageViewData = Signal.zip(
    project,
    baseReward,
    rewards,
    selectedQuantities,
    refTag,
    additionalPledgeAmount,
    pledgeTotal,
    context
  )

  trackPageViewData
    .observeValues { project, baseReward, rewards, selectedQuantities, refTag, additionalPledgeAmount, pledgeTotal, pledgeViewContext in
      let checkoutData = checkoutProperties(
        from: project,
        baseReward: baseReward,
        addOnRewards: rewards,
        selectedQuantities: selectedQuantities,
        additionalPledgeAmount: additionalPledgeAmount,
        pledgeTotal: pledgeTotal,
        shippingTotal: 0,
        checkoutId: nil,
        isApplePay: false
      )

      AppEnvironment.current.ksrAnalytics.trackCheckoutPaymentPageViewed(
        project: project,
        reward: baseReward,
        pledgeViewContext: pledgeViewContext,
        checkoutData: checkoutData,
        refTag: refTag
      )
    }

  let pledgeSubmitEventsSignal = Signal.combineLatest(
    createBackingData,
    baseReward,
    additionalPledgeAmount
  )

  let trackSubmit: (Bool, KSRAnalytics.TypeContext) -> ((CreateBackingData, Reward, Double)) -> Void = {
    isApplePay, typeContext in
    { args in
      let (data, baseReward, additionalPledgeAmount) = args
      let checkoutData = checkoutProperties(
        from: data.project,
        baseReward: baseReward,
        addOnRewards: data.rewards,
        selectedQuantities: data.selectedQuantities,
        additionalPledgeAmount: additionalPledgeAmount,
        pledgeTotal: data.pledgeTotal,
        shippingTotal: 0,
        checkoutId: nil,
        isApplePay: isApplePay
      )
      AppEnvironment.current.ksrAnalytics.trackPledgeSubmitButtonClicked(
        project: data.project,
        reward: baseReward,
        typeContext: typeContext,
        checkoutData: checkoutData,
        refTag: data.refTag
      )
    }
  }

  pledgeSubmitEventsSignal
    .takeWhen(submitTapped)
    .observeValues(trackSubmit(false, .creditCard))

  pledgeSubmitEventsSignal
    .takeWhen(applePayTapped)
    .observeValues(trackSubmit(true, .applePay))
}
