import Foundation
import KsApi
import Prelude
import ReactiveSwift

// TODO: Clean up rewards fetch.
// We now fetch the rewards directly in the RewardsCollectionViewController.
// However, other parts of the pledge flow use the rewards attached to the Project to handle other logic -
// like checking to see if the project has rewards that require shipping, or picking the correct shipping rule.
// If we can clean up and decouple that behavior from the rest of the pledge flow, we can eliminate this fetch,
// making the Manage page load substantially faster.
internal func fetchProjectRewards(project: Project) -> SignalProducer<Project, ErrorEnvelope> {
  return AppEnvironment.current.apiService
    .fetchProjectRewards(projectId: project.id)
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    .switchMap { projectRewards -> SignalProducer<Project, ErrorEnvelope> in
      let projectUpdated = projectWithUpdatedRewards(project, rewards: projectRewards)
      return SignalProducer(value: projectUpdated)
    }
}

internal func fetchProjectRewardsAndPledgeOverTimeData(project: Project)
  -> SignalProducer<Project, ErrorEnvelope> {
  return AppEnvironment.current.apiService
    .fetchProjectRewardsAndPledgeOverTimeData(projectId: project.id)
    .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
    .switchMap { envelope -> SignalProducer<Project, ErrorEnvelope> in
      var projectUpdated = projectWithUpdatedRewards(project, rewards: envelope.rewards)

      projectUpdated = projectUpdated
        |> Project.lens.isPledgeOverTimeAllowed .~ envelope.isPledgeOverTimeAllowed
        |> Project.lens
        .pledgeOverTimeCollectionPlanChargeExplanation .~ envelope
        .pledgeOverTimeCollectionPlanChargeExplanation
        |> Project.lens
        .pledgeOverTimeCollectionPlanChargedAsNPayments .~ envelope
        .pledgeOverTimeCollectionPlanChargedAsNPayments
        |> Project.lens
        .pledgeOverTimeCollectionPlanShortPitch .~ envelope.pledgeOverTimeCollectionPlanShortPitch
        |> Project.lens.pledgeOverTimeMinimumExplanation .~ envelope.pledgeOverTimeMinimumExplanation

      return SignalProducer(value: projectUpdated)
    }
}

internal func projectWithUpdatedRewards(_ project: Project, rewards: [Reward]) -> Project {
  let rewardsIncludingNoReward: [Reward]

  if let noReward = project.rewardData.rewards.first {
    rewardsIncludingNoReward = [noReward] + rewards
  } else {
    rewardsIncludingNoReward = rewards
  }

  return project
    |> Project.lens.rewardData.rewards .~ rewardsIncludingNoReward
}

internal func pledgeViewData(
  project: Project,
  backing: Backing,
  rewards: [Reward],
  context: PledgeViewContext
) -> PledgeViewData {
  return PledgeViewData(
    project: project,
    rewards: rewards,
    bonusSupport: nil,
    selectedShippingRule: nil,
    selectedQuantities: selectedRewardQuantities(in: backing),
    selectedLocationId: backing.locationId,
    refTag: nil,
    context: context
  )
}

internal func actionSheetMenuOptionsFor(
  project: Project,
  backing: Backing,
  userIsCreatorOfProject: Bool
) -> [ManagePledgeAlertAction] {
  if userIsCreatorOfProject {
    return [.viewRewards]
  }

  guard project.state == .live else {
    return [.viewRewards, .contactCreator]
  }

  if backing.status == .preauth {
    return [.contactCreator]
  }

  var actions = ManagePledgeAlertAction.allCases
    .filter { $0 != .viewRewards && $0 != .editPledgeOverTimePledge }

  /// Enable the 'Edit pledge' option for all PLOT-enabled projects.
  if isPledgeOverTime(with: backing) || project.isPledgeOverTimeAllowed == true {
    actions = actions.filter { $0 != .chooseAnotherReward }
    actions.insert(.editPledgeOverTimePledge, at: 1)
  }

  return actions
}

internal func navigationBarTitle(
  with project: Project,
  userIsCreatorOfProject: Bool
) -> String {
  if userIsCreatorOfProject {
    return Strings.Pledge_details()
  }

  return project.state == .live ? Strings.Manage_your_pledge() : Strings.Your_pledge()
}

internal func managePledgeMenuCTAType(for managePledgeAlertAction: ManagePledgeAlertAction)
  -> KSRAnalytics.ManagePledgeMenuCTAType {
  switch managePledgeAlertAction {
  case .editPledgeOverTimePledge: return .editPledgeOverTimePledge
  case .cancelPledge: return .cancelPledge
  case .changePaymentMethod: return .changePaymentMethod
  case .chooseAnotherReward: return .chooseAnotherReward
  case .contactCreator: return .contactCreator
  case .viewRewards: return .viewRewards
  }
}

internal func cancelPledgeViewData(
  with project: Project,
  backing: Backing
) -> CancelPledgeViewData {
  return .init(
    project: project,
    projectName: project.name,
    omitUSCurrencyCode: project.stats.omitUSCurrencyCode,
    backingId: backing.graphID,
    pledgeAmount: backing.amount
  )
}

internal func shouldShowFixPaymentMethodButton(for backing: Backing) -> Bool {
  // For PLOT pledges, the fix button is always hidden because the fix action
  // is handled by the `PledgeStatusLabelView`.
  if isPledgeOverTime(with: backing) { return false }
  return backing.status == .errored
}

internal func managePledgePaymentMethodViewData(
  with backing: Backing
) -> ManagePledgePaymentMethodViewData {
  ManagePledgePaymentMethodViewData(
    showFixPaymentButton: shouldShowFixPaymentMethodButton(for: backing),
    expirationDate: backing.paymentSource?.expirationDate,
    lastFour: backing.paymentSource?.lastFour,
    creditCardType: backing.paymentSource?.type,
    paymentType: backing.paymentSource?.paymentType
  )
}

internal func isPledgeOverTime(with backing: Backing) -> Bool {
  return !backing.paymentIncrements.isEmpty
}

internal func managePledgeSummaryViewData(
  with projectAndReward: (Project, Reward),
  backing: Backing,
  rewardReceivedWithData: ManageViewPledgeRewardReceivedViewData,
  rewardReceivedViewControllerViewIsHidden: Bool
) -> ManagePledgeSummaryViewData? {
  let (project, backedReward) = projectAndReward

  guard let backer = backing.backer,
        let deadline = project.dates.deadline else { return nil }

  let isRewardLocalPickup = isRewardLocalPickup(backing.reward)

  return ManagePledgeSummaryViewData(
    backerId: backer.id,
    backerName: backer.name,
    backerSequence: backing.sequence,
    backingState: backing.status,
    bonusAmount: backing.bonusAmount,
    currentUserIsCreatorOfProject: currentUserIsCreator(of: project),
    isNoReward: backedReward.id == Reward.noReward.id,
    locationName: backing.locationName,
    needsConversion: project.stats.needsConversion,
    omitUSCurrencyCode: project.stats.omitUSCurrencyCode,
    pledgeAmount: backing.amount,
    pledgedOn: backing.pledgedAt,
    currencyCode: project.statsCurrency,
    projectDeadline: deadline,
    projectState: project.state,
    rewardMinimum: backing.rewardsAmount ?? allRewardsTotal(for: backing),
    rewardReceivedViewControllerViewIsHidden: rewardReceivedViewControllerViewIsHidden,
    rewardReceivedWithData: rewardReceivedWithData,
    shippingAmount: backing.shippingAmount.flatMap(Double.init),
    shippingAmountHidden: backing.reward?.shipping.enabled == false || backing.shippingAmount == 0,
    rewardIsLocalPickup: isRewardLocalPickup,
    paymentIncrements: backing.paymentIncrements,
    project: project
  )
}

internal func allRewardsTotal(for backing: Backing) -> Double {
  let baseRewardAmount = backing.reward?.minimum ?? 0

  guard let addOns = backing.addOns else { return baseRewardAmount }

  return baseRewardAmount + addOns.reduce(0.0) { total, addOn in total.addingCurrency(addOn.minimum) }
}

internal func distinctRewards(_ rewards: [Reward]) -> [Reward] {
  var rewardIds: Set<Int> = []
  return rewards.filter { reward in
    defer { rewardIds.insert(reward.id) }
    return !rewardIds.contains(reward.id)
  }
}

internal func managePledgeFetchSignals(
  projectParam: Signal<Param, Never>,
  backingParamFromConfigData: Signal<Param, Never>,
  shouldBeginRefresh: Signal<Void, Never>
) -> (
  fetchProjectEvent: Signal<Signal<Project, ErrorEnvelope>.Event, Never>,
  graphBackingEvent: Signal<Signal<Backing, ErrorEnvelope>.Event, Never>,
  project: Signal<Project, Never>,
  backing: Signal<Backing, Never>
) {
  let projectLoaded = MutableProperty<Bool>(false)

  let shouldFetchProjectWithParam = Signal.merge(
    projectParam,
    projectParam.takeWhen(shouldBeginRefresh)
  )

  let fetchProjectEvent = shouldFetchProjectWithParam
    // Only fetch the project if it hasn't yet succeeded, to avoid this call occurring with each refresh.
    .filter { [projectLoaded] _ in projectLoaded.value == false }
    .switchMap { param in
      AppEnvironment.current.apiService.fetchProject(param: param)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .switchMap { project in
          fetchProjectRewardsAndPledgeOverTimeData(project: project)
        }
        .materialize()
    }

  let initialProject = fetchProjectEvent.values()
    // Once we know we have a project value, keep track of that.
    .on(value: { [projectLoaded] _ in projectLoaded.value = true })

  let backingParamFromProject = initialProject.map { $0.personalization.backing?.id }
    .skipNil()
    .map(Param.id)

  let backingParam = Signal.merge(
    backingParamFromConfigData,
    backingParamFromProject.take(until: backingParamFromConfigData.ignoreValues())
  )

  let shouldFetchGraphBackingWithParam = Signal.merge(
    backingParam,
    backingParam.takeWhen(shouldBeginRefresh)
  )

  let graphBackingEvent = shouldFetchGraphBackingWithParam
    .map { $0.id }
    .skipNil()
    .switchMap { backingId in
      AppEnvironment.current.apiService
        .fetchBackingForManagePledge(id: backingId)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

  let backing = graphBackingEvent.values()

  let project: Signal<Project, Never> = initialProject.combineLatest(with: backing)
    .map { project, backing -> Project in
      /**
       Here we are updating the `Project`'s `Backing` with an updated one from GraphQL.
       This is because, at the time of writing, v1 does not return add-ons or bonus amount but GraphQL does.
       */
      project |> Project.lens.personalization.backing .~ backing
    }

  return (fetchProjectEvent, graphBackingEvent, project, backing)
}

