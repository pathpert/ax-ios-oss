import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Immutable value type representing `ManagePledgeSummaryOutputs`.
internal struct ManagePledgeSummaryOutputs {
  let rewardReceivedWithData: Signal<ManageViewPledgeRewardReceivedViewData, Never>
  let rewardReceivedViewIsHidden: Signal<Bool, Never>
}

internal struct ManagePledgeNavigationOutputs {
  let showActionSheetMenuWithOptions: Signal<[ManagePledgeAlertAction], Never>
  let goToRewards: Signal<Project, Never>
  let goToEditPledgeOverTime: Signal<Project, Never>
  let goToCancelPledge: Signal<CancelPledgeViewData, Never>
  let goToContactCreator: Signal<(MessageSubject, KSRAnalytics.MessageDialogContext), Never>
  let goToChangePaymentMethod: Signal<PledgeViewData, Never>
  let goToFixPaymentMethod: Signal<PledgeViewData, Never>
  let cancelPledgeSelected: Signal<Void, Never>
}

internal func buildManagePledgeSummaryOutputs(
  project: Signal<Project, Never>,
  backing: Signal<Backing, Never>,
  loadProjectAndRewardsIntoDataSource: Signal<(Project, [Reward]), Never>,
  userIsCreatorOfProject: Signal<Bool, Never>
) -> ManagePledgeSummaryOutputs {
  let pledgeDisclaimerViewHidden = Signal.combineLatest(
    loadProjectAndRewardsIntoDataSource,
    userIsCreatorOfProject
  )
  .map(unpack)
  .map { _, rewards, userIsCreatorOfProject in
    rewards.map { $0.estimatedDeliveryOn }.allSatisfy(isNil) || userIsCreatorOfProject
  }

  let latestRewardDeliveryDate = loadProjectAndRewardsIntoDataSource.map { _, rewards in
    rewards
      .compactMap { $0.estimatedDeliveryOn }
      .reduce(0) { accum, value in max(accum, value) }
  }

  let estimatedShipping = Signal.combineLatest(
    backing,
    loadProjectAndRewardsIntoDataSource
  )
  .map(unpack)
  .map { backing, project, rewards -> String? in
    guard let locationId = backing.locationId,
          let range = estimatedShippingText(
            for: rewards,
            project: project,
            locationId: locationId,
            selectedQuantities: selectedRewardQuantities(in: backing)
          )
    else { return nil }

    return Strings.About_reward_amount(reward_amount: range)
  }

  let rewardReceivedWithData = Signal.combineLatest(
    project,
    backing,
    latestRewardDeliveryDate,
    estimatedShipping,
    pledgeDisclaimerViewHidden
  )
  .map { project, backing, latestRewardDeliveryDate, estimatedShipping, pledgeDisclaimerViewHidden in
    ManageViewPledgeRewardReceivedViewData(
      project: project,
      backerCompleted: backing.backerCompleted ?? false,
      estimatedDeliveryOn: latestRewardDeliveryDate,
      backingState: backing.status,
      estimatedShipping: estimatedShipping,
      pledgeDisclaimerViewHidden: pledgeDisclaimerViewHidden
    )
  }

  return ManagePledgeSummaryOutputs(
    rewardReceivedWithData: rewardReceivedWithData,
    rewardReceivedViewIsHidden: latestRewardDeliveryDate.map { $0 == 0 }
  )
}

internal func buildManagePledgeNavigationOutputs(
  project: Signal<Project, Never>,
  backing: Signal<Backing, Never>,
  backedRewards: Signal<[Reward], Never>,
  userIsCreatorOfProject: Signal<Bool, Never>,
  menuButtonTappedSignal: Signal<Void, Never>,
  menuOptionSelectedSignal: Signal<ManagePledgeAlertAction, Never>,
  fixButtonTappedSignal: Signal<Void, Never>
) -> ManagePledgeNavigationOutputs {
  let menuOptions = Signal.combineLatest(project, backing, userIsCreatorOfProject)
    .map(actionSheetMenuOptionsFor(project:backing:userIsCreatorOfProject:))

  let cancelPledgeSelected = menuOptionSelectedSignal
    .filter { $0 == .cancelPledge }
    .ignoreValues()

  return ManagePledgeNavigationOutputs(
    showActionSheetMenuWithOptions: menuOptions.takeWhen(menuButtonTappedSignal),
    goToRewards: project
      .takeWhen(menuOptionSelectedSignal.filter { $0 == .chooseAnotherReward || $0 == .viewRewards }),
    goToEditPledgeOverTime: project
      .takeWhen(menuOptionSelectedSignal.filter { $0 == .editPledgeOverTimePledge }),
    goToCancelPledge: Signal.combineLatest(project, backing)
      .takeWhen(cancelPledgeSelected)
      .filter { _, backing in backing.cancelable }
      .map(cancelPledgeViewData(with:backing:)),
    goToContactCreator: project
      .takeWhen(menuOptionSelectedSignal.filter { $0 == .contactCreator })
      .map { project in (MessageSubject.project(id: project.id, name: project.name), .backerModal) },
    goToChangePaymentMethod: Signal.combineLatest(project, backing, backedRewards)
      .takeWhen(menuOptionSelectedSignal.filter { $0 == .changePaymentMethod })
      .map { project, backing, rewards in (project, backing, rewards, .changePaymentMethod) }
      .map(pledgeViewData),
    goToFixPaymentMethod: Signal.combineLatest(project, backing, backedRewards)
      .takeWhen(fixButtonTappedSignal)
      .map { project, backing, rewards in (project, backing, rewards, .fixPaymentMethod) }
      .map(pledgeViewData),
    cancelPledgeSelected: cancelPledgeSelected
  )
}

