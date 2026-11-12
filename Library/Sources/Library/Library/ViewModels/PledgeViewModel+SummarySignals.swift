import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Immutable value type representing `PledgeSummarySetupOutputs`.
internal struct PledgeSummarySetupOutputs {
  let allRewardsTotal: Signal<Double, Never>
  let allRewardsShippingTotal: Signal<Double, Never>
  let additionalPledgeAmount: Signal<Double, Never>
  let pledgeTotal: Signal<Double, Never>
  let descriptionSectionSeparatorHidden: Signal<Bool, Never>
  let localPickupViewHidden: Signal<Bool, Never>
  let configureLocalPickupViewWithData: Signal<PledgeLocalPickupViewData, Never>
  let configurePledgeRewardsSummaryViewWithData: Signal<
    (PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData),
    Never
  >
  let configurePledgeAmountSummaryViewControllerWithData: Signal<PledgeAmountSummaryViewData, Never>
  let configureStripeIntegration: Signal<StripeConfigurationData, Never>
  let configureEstimatedShippingView: Signal<(String?, String?), Never>
  let estimatedShippingViewHidden: Signal<Bool, Never>
}

internal func makePledgeSummarySetupSignals(
  initialData: Signal<PledgeViewData, Never>,
  project: Signal<Project, Never>,
  baseReward: Signal<Reward, Never>,
  rewards: Signal<[Reward], Never>,
  selectedQuantities: Signal<SelectedRewardQuantities, Never>,
  selectedShippingRule: Signal<ShippingRule?, Never>,
  context: Signal<PledgeViewContext, Never>,
  backing: Signal<Backing, Never>
) -> PledgeSummarySetupOutputs {
  let descriptionSectionSeparatorHidden = Signal.combineLatest(context, baseReward)
    .map { context, reward in
      if context.isAny(of: .pledge, .updateReward) {
        return reward.isNoReward == false
      }
      return context.sectionSeparatorsHidden
    }

  let allRewardsTotal = Signal.combineLatest(project, rewards, selectedQuantities, context)
    .map { project, rewards, selectedQuantities, context in
      if context == .fixPaymentMethod,
         let rewardsAmount = project.personalization.backing?.rewardsAmount {
        return rewardsAmount
      }
      return calculateAllRewardsTotal(addOnRewards: rewards, selectedQuantities: selectedQuantities)
    }

  let initialShippingTotal = project.map { $0.personalization.backing?.shippingAmount ?? 0.0 }
  let calculatedShippingTotal = Signal.combineLatest(selectedShippingRule.skipNil(), rewards, selectedQuantities)
    .map(calculateShippingTotal)
  let allRewardsShippingTotal = Signal.merge(initialShippingTotal, calculatedShippingTotal)

  let additionalPledgeAmount = initialData.map {
    if let bonusSupport = $0.bonusSupport {
      return bonusSupport
    } else if let backing = $0.project.personalization.backing {
      return backing.bonusAmount
    } else {
      return 0.0
    }
  }

  let projectAndReward = Signal.zip(project, baseReward)

  let nonLocalPickupShippingLocationViewHidden = Signal.combineLatest(baseReward, rewards, context)
    .map { baseReward, rewards, context in
      [context.shippingLocationViewHidden, !baseReward.shipping.enabled, rewards.count > 1].contains(true)
    }
  let nonLocalPickupShippingSummaryViewHidden = Signal.combineLatest(baseReward, rewards, context)
    .map { baseReward, rewards, context in
      [context.isAny(of: .changePaymentMethod, .fixPaymentMethod), !baseReward.shipping.enabled, rewards.count == 1]
        .contains(true)
    }
  let shippingViewsHiddenForSummary = Signal
    .combineLatest(nonLocalPickupShippingLocationViewHidden, nonLocalPickupShippingSummaryViewHidden)
    .map { pair in pair.0 && pair.1 }

  let configureLocalPickupViewWithData = projectAndReward
    .switchMap { projectAndReward -> SignalProducer<PledgeLocalPickupViewData?, Never> in
      guard let locationName = projectAndReward.1.localPickup?.displayableName else {
        return SignalProducer(value: nil)
      }
      return SignalProducer(value: PledgeLocalPickupViewData(locationName: locationName))
    }
    .skipNil()

  let calculatedPledgeTotal = Signal.combineLatest(
    additionalPledgeAmount,
    allRewardsShippingTotal,
    allRewardsTotal,
    context
  )
  .filter { _, _, _, context in context != .fixPaymentMethod }
  .map { additionalAmount, shippingCost, rewardsTotal, _ in
    calculatePledgeTotal(pledgeAmount: additionalAmount, shippingCost: shippingCost, addOnRewardsTotal: rewardsTotal)
  }

  let pledgeTotal = Signal.merge(backing.map(\.amount), calculatedPledgeTotal)

  let shippingLocation: Signal<String?, Never> = Signal.combineLatest(project, selectedShippingRule)
    .map { project, shippingRule in
      shippingRule?.location.localizedName ?? project.personalization.backing?.locationName
    }

  let shippingSummaryNonnil = Signal.combineLatest(
    shippingLocation.skipNil(),
    project.map { $0.stats.omitUSCurrencyCode },
    project.map { $0.stats.projectCurrency },
    allRewardsShippingTotal
  ).map(PledgeShippingSummaryViewData.init)

  let shippingSummaryViewData = Signal.merge(
    shippingSummaryNonnil.wrapInOptional(),
    shippingLocation.filter(isNil).mapConst(nil)
  )

  let configurePledgeRewardsSummaryViewWithData = Signal.combineLatest(
    initialData,
    pledgeTotal,
    additionalPledgeAmount,
    shippingSummaryViewData,
    rewards
  ).compactMap(makePledgeRewardsSummaryPayload)

  let configurePledgeAmountSummaryViewControllerWithData = Signal.combineLatest(
    projectAndReward,
    allRewardsTotal,
    additionalPledgeAmount,
    shippingViewsHiddenForSummary
  )
  .map { projectAndReward, rewardsTotal, amount, shippingHidden in
    (projectAndReward.0, projectAndReward.1, rewardsTotal, amount, shippingHidden)
  }
  .map(makePledgeAmountSummaryViewData)
  .skipNil()

  let configureStripeIntegration = Signal.combineLatest(initialData, context)
    .filter { !$1.paymentMethodsViewHidden }
    .ignoreValues()
    .map { _ in
      StripeConfigurationData(
        merchantIdentifier: Secrets.ApplePay.merchantIdentifier,
        publishableKey: AppEnvironment.current.environmentType.stripePublishableKey
      )
    }

  let configureEstimatedShippingView = Signal.combineLatest(
    project,
    rewards,
    selectedShippingRule,
    selectedQuantities
  ).map { args -> (String?, String?) in
    makePledgeEstimatedShipping(
      project: args.0,
      rewards: args.1,
      shippingRule: args.2,
      selectedQuantities: args.3
    )
  }

  let estimatedShippingViewHidden = Signal.combineLatest(configureEstimatedShippingView, baseReward)
    .map { args -> Bool in args.1.shipping.enabled == false || args.0.0 == nil }

  return PledgeSummarySetupOutputs(
    allRewardsTotal: allRewardsTotal,
    allRewardsShippingTotal: allRewardsShippingTotal,
    additionalPledgeAmount: additionalPledgeAmount,
    pledgeTotal: pledgeTotal,
    descriptionSectionSeparatorHidden: descriptionSectionSeparatorHidden,
    localPickupViewHidden: baseReward.map(isRewardLocalPickup).negate(),
    configureLocalPickupViewWithData: configureLocalPickupViewWithData,
    configurePledgeRewardsSummaryViewWithData: configurePledgeRewardsSummaryViewWithData,
    configurePledgeAmountSummaryViewControllerWithData: configurePledgeAmountSummaryViewControllerWithData,
    configureStripeIntegration: configureStripeIntegration,
    configureEstimatedShippingView: configureEstimatedShippingView,
    estimatedShippingViewHidden: estimatedShippingViewHidden
  )
}
