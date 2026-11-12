import Foundation
import KsApi
import Prelude
import ReactiveSwift
import ServerDrivenUI

/// Immutable value type representing `ProjectPageSetupOutputs`.
internal struct ProjectPageSetupOutputs {
  let freshProject: Signal<Project, Never>
  let freshProjectAndRefTag: Signal<(Project, RefTag?), Never>
  let projectFlagged: Signal<Bool, Never>
  let prefetchImageURLs: Signal<([URL], IndexPath), Never>
  let prefetchImageURLsOnFirstLoad: Signal<[ImageViewElement], Never>
  let precreateAudioVideoURLsOnFirstLoad: Signal<[AudioVideoViewElement], Never>
  let configureDataSource: Signal<(NavigationSection, Either<Project, any ProjectPageParam>, RefTag?), Never>
  let updateWatchProjectWithPrelaunchProjectState: Signal<PledgeCTAPrelaunchState, Never>
  let configurePledgeCTAView: Signal<PledgeCTAContainerViewData, Never>
  let showProjectPageTabWithData: Signal<
    (NavigationSection, Project, RefTag?, [Bool], [URL], SimilarProjectsState, ProjectPageContentView),
    Never
  >
  let updateFAQsInDataSource: Signal<(Project, RefTag?, [Bool]), Never>
  let didBlockUser: Signal<(), Never>
  let didBlockUserError: Signal<(), Never>
  let goToRewards: Signal<(Project, RefTag?, String?), Never>
  let goToPledgeManager: Signal<String, Never>
  let rewardsUseCase: RewardsUseCase
  let viewPledgeUseCase: ViewPledgeUseCase
}

internal func makeProjectPageSetupSignals(
  configDataSignal: Signal<(Either<Project, any ProjectPageParam>, RefInfo?, String?), Never>,
  viewDidLoadSignal: Signal<Void, Never>,
  userSessionStartedSignal: Signal<Void, Never>,
  didBackProjectSignal: Signal<Void, Never>,
  managePledgeFinishedSignal: Signal<String?, Never>,
  pledgeRetryButtonTappedSignal: Signal<Void, Never>,
  prepareImageAtSignal: Signal<IndexPath?, Never>,
  navSelectorSignal: Signal<Int?, Never>,
  ctaButtonTappedSignal: Signal<PledgeStateCTAType?, Never>,
  didSelectFAQsRowAtSignal: Signal<(Int, [Bool])?, Never>,
  blockUserSignal: Signal<Int, Never>,
  similarProjectsProperty: Property<SimilarProjectsState>
) -> ProjectPageSetupOutputs {
  let isLoading = MutableProperty(false)

  let freshProjectAndRefTagEvent = configDataSignal
    .takeWhen(Signal.merge(
      viewDidLoadSignal.ignoreValues(),
      userSessionStartedSignal.ignoreValues(),
      didBackProjectSignal.ignoreValues(),
      managePledgeFinishedSignal.ignoreValues(),
      pledgeRetryButtonTappedSignal.ignoreValues()
    ))
    .switchMap { projectOrParam, refInfo, secretRewardToken in
      fetchProjectPage(
        projectOrParam: projectOrParam,
        afterAddingSecretRewardToken: secretRewardToken
      )
      .on(starting: { isLoading.value = true }, terminated: { isLoading.value = false })
      .map { ($0, refInfo?.refTag.map(cleanUp(refTag:))) }
      .materialize()
    }

  let freshProjectAndRefTag = freshProjectAndRefTagEvent.values()
  let freshProject = freshProjectAndRefTag.map(first)

  let prefetchImageURLs = freshProject
    .compactMap { $0.extendedProjectProperties }
    .combineLatest(with: prepareImageAtSignal.skipNil())
    .filterWhenLatestFrom(
      navSelectorSignal.skipNil(),
      satisfies: { NavigationSection(rawValue: $0) == .campaign }
    )
    .switchMap { properties, indexPath -> SignalProducer<([URL], IndexPath)?, Never> in
      let imageViewElements = properties.story.htmlViewElements.compactMap { $0 as? ImageViewElement }
      guard !imageViewElements.isEmpty else { return SignalProducer(value: nil) }
      return SignalProducer(value: (imageViewElements.compactMap { URL(string: $0.src) }, indexPath))
    }
    .skipNil()

  let prefetchImageURLsOnFirstLoad = freshProject
    .compactMap { $0.extendedProjectProperties }
    .switchMap { SignalProducer<[ImageViewElement], Never>(value: $0.story.htmlViewElements.compactMap { $0 as? ImageViewElement }) }

  let precreateAudioVideoURLsOnFirstLoad = freshProject
    .compactMap { $0.extendedProjectProperties }
    .switchMap { SignalProducer<[AudioVideoViewElement], Never>(value: $0.story.htmlViewElements.compactMap { $0 as? AudioVideoViewElement }) }

  let staleProjectDataSource = configDataSignal
    .takeWhen(viewDidLoadSignal)
    .filter { $0.0.canDisplayProjectPreview }
    .map { (NavigationSection.overview, $0.0, $0.1?.refTag) }

  let configureDataSource: Signal<(NavigationSection, Either<Project, any ProjectPageParam>, RefTag?), Never> =
    freshProjectAndRefTag
      .combineLatest(with: viewDidLoadSignal)
      .map { projectAndRefTag, _ in
        (.overview, Either<Project, any ProjectPageParam>.left(projectAndRefTag.0), projectAndRefTag.1)
      }
      .merge(with: staleProjectDataSource)

  let projectAndBacking = freshProject
    .filter { $0.personalization.isBacking ?? false }
    .compactMap { project in project.personalization.backing.map { (project, $0) } }

  let ctaButtonTappedWithType = ctaButtonTappedSignal.skipNil()
  let updateWatchProjectWithPrelaunchProjectState = ctaButtonTappedWithType
    .compactMap { pledgeCTAType -> PledgeCTAPrelaunchState? in
      guard case let .prelaunch(saved, watchesCount) = pledgeCTAType else { return nil }
      return PledgeCTAPrelaunchState(prelaunch: true, saved: saved, watchesCount: watchesCount)
    }

  let configurePledgeCTAView: Signal<PledgeCTAContainerViewData, Never> = Signal.merge(
    freshProject.map { .project($0) },
    freshProjectAndRefTagEvent.errors().map { .error($0) },
    isLoading.signal.filter { $0 == true }.mapConst(.loading)
  ).skipRepeats()

  let dataSourceUpdate = navSelectorSignal
    .skipNil()
    .skipRepeats()
    .compactMap { NavigationSection(rawValue: $0) }
    .combineLatest(with: freshProjectAndRefTag)
    .map { makeProjectPageTabData(navSection: $0, project: $1.0, refTag: $1.1) }

  let similarProjectsState = similarProjectsProperty.signal
    .merge(with: similarProjectsProperty.producer.takeWhen(viewDidLoadSignal))

  let showProjectPageTabWithData = Signal.combineLatest(dataSourceUpdate, similarProjectsState)
    .map { tabData, similarProjects in
      (tabData.0, tabData.1, tabData.2, tabData.3, tabData.4, similarProjects, tabData.5)
    }

  let updateFAQsInDataSource = freshProjectAndRefTag
    .combineLatest(with: didSelectFAQsRowAtSignal.skipNil())
    .map { projectAndRefTag, indexAndValues in
      var updatedValues = indexAndValues.1
      updatedValues[indexAndValues.0].toggle()
      return (projectAndRefTag.0, projectAndRefTag.1, updatedValues)
    }

  let blockUserEvent = blockUserSignal
    .map { BlockUserInput(blockUserId: "\($0)") }
    .switchMap { input in
      AppEnvironment.current.apiService.blockUser(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }
  let didBlockUser = blockUserEvent.values().ignoreValues()
    .map { _ in NotificationCenter.default.post(.init(name: .ksr_blockedUser)) }

  let secretRewardToken = configDataSignal.map { $0.2 }
  let shouldGoToRewards = ctaButtonTappedWithType.filter { state in
    switch state {
    case .pledge, .viewRewards, .viewYourRewards:
      return true
    default:
      return false
    }
  }.ignoreValues()

  let rewardsUseCase = RewardsUseCase(
    secretRewardToken: secretRewardToken,
    userSessionStarted: userSessionStartedSignal,
    goToRewardsTapped: shouldGoToRewards
  )
  let goToRewards = freshProjectAndRefTag
    .combineLatest(with: secretRewardToken)
    .map(unpack)
    .takeWhen(rewardsUseCase.goToRewards)

  let goToPledgeManager = freshProject
    .takeWhen(ctaButtonTappedWithType.filter { $0 == .pledgeManager })
    .compactMap { AppEnvironment.current.apiService.serverConfig.webBaseUrl.absoluteString + $0.redemptionPageUrl }

  let viewPledgeUseCase = ViewPledgeUseCase(with: projectAndBacking)
  ctaButtonTappedWithType
    .filter(shouldGoToManagePledge(with:))
    .observeValues { _ in viewPledgeUseCase.goToPledgeViewTapped() }

  return ProjectPageSetupOutputs(
    freshProject: freshProject,
    freshProjectAndRefTag: freshProjectAndRefTag,
    projectFlagged: freshProject.map { $0.flagging ?? false },
    prefetchImageURLs: prefetchImageURLs,
    prefetchImageURLsOnFirstLoad: prefetchImageURLsOnFirstLoad,
    precreateAudioVideoURLsOnFirstLoad: precreateAudioVideoURLsOnFirstLoad,
    configureDataSource: configureDataSource,
    updateWatchProjectWithPrelaunchProjectState: updateWatchProjectWithPrelaunchProjectState,
    configurePledgeCTAView: configurePledgeCTAView,
    showProjectPageTabWithData: showProjectPageTabWithData,
    updateFAQsInDataSource: updateFAQsInDataSource,
    didBlockUser: didBlockUser,
    didBlockUserError: blockUserEvent.errors().ignoreValues(),
    goToRewards: goToRewards,
    goToPledgeManager: goToPledgeManager,
    rewardsUseCase: rewardsUseCase,
    viewPledgeUseCase: viewPledgeUseCase
  )
}
