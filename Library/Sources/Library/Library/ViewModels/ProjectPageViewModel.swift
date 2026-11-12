import Foundation
import KsApi
import Prelude
import ReactiveSwift
import ServerDrivenUI

/// Drives project page loading, tab switching, campaign prefetching, pledge CTAs, and user blocking actions.
public final class ProjectPageViewModel: ProjectPageViewModelType, ProjectPageViewModelInputs,
  ProjectPageViewModelOutputs {
  /// Creates a project page view model and binds project loading, navigation, and analytics signals.
  public init() {
    let configSignal = self.configDataProperty.signal.skipNil()
    let setup = makeProjectPageSetupSignals(
      configDataSignal: configSignal,
      viewDidLoadSignal: self.viewDidLoadProperty.signal,
      userSessionStartedSignal: self.userSessionStartedProperty.signal,
      didBackProjectSignal: self.didBackProjectProperty.signal,
      managePledgeFinishedSignal: self.managePledgeViewControllerFinishedWithMessageProperty.signal,
      pledgeRetryButtonTappedSignal: self.pledgeRetryButtonTappedProperty.signal,
      prepareImageAtSignal: self.prepareImageAtProperty.signal,
      navSelectorSignal: self.projectNavigationSelectorViewDidSelectProperty.signal,
      ctaButtonTappedSignal: self.pledgeCTAButtonTappedProperty.signal,
      didSelectFAQsRowAtSignal: self.didSelectFAQsRowAtProperty.signal,
      blockUserSignal: self.blockUserProperty.signal,
      similarProjectsProperty: self.similarProjectsUseCase.similarProjects
    )

    self.navigateBackToProjectPage = self.didBackProjectProperty.signal.ignoreValues()
    self.projectFlagged = setup.projectFlagged
    self.prefetchImageURLs = setup.prefetchImageURLs
    self.prefetchImageURLsOnFirstLoad = setup.prefetchImageURLsOnFirstLoad
    self.precreateAudioVideoURLsOnFirstLoad = setup.precreateAudioVideoURLsOnFirstLoad
    self.precreateAudioVideoURLs = self.prepareAudioVideoAtProperty.signal.skipNil()
    self.configureDataSource = setup.configureDataSource
    self.updateWatchProjectWithPrelaunchProjectState = setup.updateWatchProjectWithPrelaunchProjectState
    self.configurePledgeCTAView = setup.configurePledgeCTAView
    self.configureChildViewControllersWithProject = setup.freshProjectAndRefTag.map { ($0.0, $0.1) }
    self.dismissManagePledgeAndShowMessageBannerWithMessage = self.managePledgeViewControllerFinishedWithMessageProperty
      .signal.skipNil()
    self.goToComments = setup.freshProject.takeWhen(self.tappedCommentsProperty.signal)
    self.goToUpdates = setup.freshProject.takeWhen(self.tappedUpdatesProperty.signal)
    self.goToReportProject = setup.freshProject
      .map { ($0.flagging ?? false, "\($0.graphID)", $0.urls.web.project) }
      .takeWhen(self.tappedReportProjectProperty.signal)
    self.configureProjectNavigationSelectorView = setup.freshProjectAndRefTag.map { ($0.0, $0.1) }
    self.presentMessageDialog = setup.freshProject.takeWhen(self.askAQuestionCellTappedProperty.signal)
    self.showHelpWebViewController = Signal.merge(
      self.projectTabDisclaimerCellDidTapURLProperty.signal,
      self.projectRisksDisclaimerCellDidTapURLProperty.signal
    ).skipNil().map(HelpType.helpType).skipNil()
    self.showProjectPageTabWithData = setup.showProjectPageTabWithData
    self.updateFAQsInDataSource = setup.updateFAQsInDataSource
    self.pauseMedia = self.applicationDidEnterBackgroundProperty.signal
    self.reloadCampaignData = self.projectNavigationSelectorViewDidSelectProperty.signal.skipNil()
      .takeWhen(self.viewWillTransitionProperty.signal)
      .filter { NavigationSection(rawValue: $0) == .campaign }
      .ignoreValues()
    self.goToURL = self.didSelectCampaignImageLinkProperty.signal.skipNil()
    self.goToRestrictedCreator = setup.freshProject
      .takeWhen(self.projectNoticeDetailsRequestedProperty.signal)
      .map(\.extendedProjectProperties?.projectNotice)
      .skipNil()
    self.didBlockUser = setup.didBlockUser
    self.didBlockUserError = setup.didBlockUserError
    self.rewardsUseCase = setup.rewardsUseCase
    self.goToRewards = setup.goToRewards
    self.goToPledgeManager = setup.goToPledgeManager
    self.viewPledgeUseCase = setup.viewPledgeUseCase

    bindProjectPageTracking(
      configDataSignal: configSignal,
      freshProject: setup.freshProject,
      freshProjectAndRefTag: setup.freshProjectAndRefTag,
      viewDidAppearAnimatedSignal: self.viewDidAppearAnimatedProperty.signal,
      blockUserSignal: self.blockUserProperty.signal,
      blockUserSuccessSignal: setup.didBlockUser
    )

    setup.freshProjectAndRefTag
      .map { project, _ in "\(project.id)" }
      .skipRepeats()
      .observeForControllerAction()
      .observeValues { [weak self] projectID in
        self?.similarProjectsUseCase.inputs.projectIDLoaded(projectID: projectID)
      }
  }

  fileprivate let askAQuestionCellTappedProperty = MutableProperty(())
  /// Handles tapping the "Ask a question" FAQ cell.
  public func askAQuestionCellTapped() { self.askAQuestionCellTappedProperty.value = () }
  fileprivate let applicationDidEnterBackgroundProperty = MutableProperty(())
  /// Pauses active media when the app enters the background.
  public func applicationDidEnterBackground() { self.applicationDidEnterBackgroundProperty.value = () }
  fileprivate let blockUserProperty = MutableProperty<Int>(0)
  /// Requests blocking the creator with the given identifier.
  public func blockUser(id: Int) { self.blockUserProperty.value = id }
  private let configDataProperty = MutableProperty<(Either<Project, any ProjectPageParam>, RefInfo?, String?)?>(nil)
  /// Configures the view model with a project or parameter, referral info, and secret reward token.
  public func configureWith(
    projectOrParam: Either<Project, any ProjectPageParam>,
    refInfo: RefInfo?,
    secretRewardToken: String?
  ) {
    self.configDataProperty.value = (projectOrParam, refInfo, secretRewardToken)
  }

  /// Convenience overload for `configureWith` that defaults `secretRewardToken` to `nil`.
  public func configureWith(projectOrParam: Either<Project, any ProjectPageParam>, refInfo: RefInfo?) {
    self.configureWith(projectOrParam: projectOrParam, refInfo: refInfo, secretRewardToken: nil)
  }

  private let didBackProjectProperty = MutableProperty<Void>(())
  /// Refreshes the project page after backing completes.
  public func didBackProject() { self.didBackProjectProperty.value = () }
  fileprivate let didSelectFAQsRowAtProperty = MutableProperty<(Int, [Bool])?>(nil)
  /// Toggles expansion state for the selected FAQ row.
  public func didSelectFAQsRowAt(row: Int, values: [Bool]) { self.didSelectFAQsRowAtProperty.value = (row, values) }
  fileprivate let didSelectCampaignImageLinkProperty = MutableProperty<URL?>(nil)
  /// Opens a tapped campaign image link URL.
  public func didSelectCampaignImageLink(url: URL) { self.didSelectCampaignImageLinkProperty.value = url }
  private let managePledgeViewControllerFinishedWithMessageProperty = MutableProperty<String?>(nil)
  /// Refreshes the project page after pledge management finishes with an optional banner message.
  public func managePledgeViewControllerFinished(with message: String?) {
    self.managePledgeViewControllerFinishedWithMessageProperty.value = message
  }
  private let pledgeCTAButtonTappedProperty = MutableProperty<PledgeStateCTAType?>(nil)
  /// Handles tapping the project pledge call-to-action button.
  public func pledgeCTAButtonTapped(with state: PledgeStateCTAType) { self.pledgeCTAButtonTappedProperty.value = state }
  private let pledgeRetryButtonTappedProperty = MutableProperty(())
  /// Retries loading the project page after an error.
  public func pledgeRetryButtonTapped() { self.pledgeRetryButtonTappedProperty.value = () }
  private let prepareImageAtProperty = MutableProperty<IndexPath?>(nil)
  /// Triggers prefetching of campaign images starting at `indexPath`.
  public func prepareImageAt(_ indexPath: IndexPath) { self.prepareImageAtProperty.value = indexPath }
  private let prepareAudioVideoAtProperty = MutableProperty<(AudioVideoViewElement, IndexPath)?>(nil)
  /// Triggers preparation of an audio/video element at `indexPath`.
  public func prepareAudioVideoAt(_ indexPath: IndexPath, with audioVideoViewElement: AudioVideoViewElement) {
    self.prepareAudioVideoAtProperty.value = (audioVideoViewElement, indexPath)
  }
  fileprivate let projectNoticeDetailsRequestedProperty = MutableProperty(())
  /// Requests displaying restricted creator notice details.
  public func projectNoticeDetailsRequested() { self.projectNoticeDetailsRequestedProperty.value = () }
  fileprivate let projectTabDisclaimerCellDidTapURLProperty = MutableProperty<URL?>(nil)
  /// Handles tapping a URL in the project tab disclaimer cell.
  public func projectTabDisclaimerCellDidTapURL(_ url: URL) { self.projectTabDisclaimerCellDidTapURLProperty.value = url }
  private let projectNavigationSelectorViewDidSelectProperty = MutableProperty<Int?>(nil)
  /// Handles selecting a section tab in `ProjectNavigationSelectorView`.
  public func projectNavigationSelectorViewDidSelect(index: Int) { self.projectNavigationSelectorViewDidSelectProperty.value = index }
  fileprivate let projectRisksDisclaimerCellDidTapURLProperty = MutableProperty<URL?>(nil)
  /// Handles tapping a URL in the risks disclaimer cell.
  public func projectRisksDisclaimerCellDidTapURL(_ url: URL) { self.projectRisksDisclaimerCellDidTapURLProperty.value = url }
  fileprivate let tappedCommentsProperty = MutableProperty(())
  /// Handles tapping the comments row.
  public func tappedComments() { self.tappedCommentsProperty.value = () }
  fileprivate let tappedUpdatesProperty = MutableProperty(())
  /// Handles tapping the updates row.
  public func tappedUpdates() { self.tappedUpdatesProperty.value = () }
  fileprivate let tappedReportProjectProperty = MutableProperty(())
  /// Handles tapping the report project row.
  public func tappedReportProject() { self.tappedReportProjectProperty.value = () }
  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Reloads the project page after a user signs in.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }
  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }
  fileprivate let viewDidAppearAnimatedProperty = MutableProperty(false)
  /// Notifies the view model that the view appeared.
  public func viewDidAppear(animated: Bool) { self.viewDidAppearAnimatedProperty.value = animated }
  fileprivate let viewWillTransitionProperty = MutableProperty(())
  /// Notifies the view model before an orientation transition.
  public func viewWillTransition() { self.viewWillTransitionProperty.value = () }

  private let viewPledgeUseCase: ViewPledgeUseCase
  private let similarProjectsUseCase = SimilarProjectsUseCase()
  private let rewardsUseCase: RewardsUseCase

  /// Configures the project table data source for a section.
  public let configureDataSource: Signal<(NavigationSection, Either<Project, any ProjectPageParam>, RefTag?), Never>
  /// Configures child view controllers with the loaded project.
  public let configureChildViewControllersWithProject: Signal<(Project, RefTag?), Never>
  /// Configures the sticky pledge CTA view.
  public let configurePledgeCTAView: Signal<PledgeCTAContainerViewData, Never>
  /// Configures the section selector view.
  public let configureProjectNavigationSelectorView: Signal<(Project, RefTag?), Never>
  /// Dismisses manage pledge and presents a status banner message.
  public let dismissManagePledgeAndShowMessageBannerWithMessage: Signal<String, Never>
  /// Opens the project comments screen.
  public let goToComments: Signal<Project, Never>
  /// Opens the login screen with the required intent.
  public var goToLoginWithIntent: Signal<LoginIntent, Never> { self.rewardsUseCase.goToLoginWithIntent }
  /// Opens the native manage pledge screen.
  public var goToManagePledge: Signal<ManagePledgeViewParamConfigData, Never> { self.viewPledgeUseCase.goToNativePledgeView }
  /// Opens the web pledge manager URL.
  public let goToPledgeManager: Signal<String, Never>
  /// Opens the pledge management web details URL.
  public var goToPledgeManagementPledgeView: Signal<String, Never> { self.viewPledgeUseCase.goToPledgeManagementPledgeView }
  /// Presents restricted creator notice text.
  public let goToRestrictedCreator: Signal<String, Never>
  /// Opens the reward selection screen.
  public let goToRewards: Signal<(Project, RefTag?, String?), Never>
  /// Opens the project updates screen.
  public let goToUpdates: Signal<Project, Never>
  /// Opens the report project screen.
  public let goToReportProject: Signal<(Bool, String, String), Never>
  /// Opens an external campaign URL.
  public let goToURL: Signal<URL, Never>
  /// Pauses active media playback.
  public let pauseMedia: Signal<Void, Never>
  /// Returns navigation back to the project page.
  public let navigateBackToProjectPage: Signal<(), Never>
  /// Presents the creator message dialog.
  public let presentMessageDialog: Signal<Project, Never>
  /// Prepares an audio/video element at an index path.
  public let precreateAudioVideoURLs: Signal<(AudioVideoViewElement, IndexPath), Never>
  /// Preloads campaign audio/video elements on first load.
  public let precreateAudioVideoURLsOnFirstLoad: Signal<[AudioVideoViewElement], Never>
  /// Prefetches campaign image URLs at an index path.
  public let prefetchImageURLs: Signal<([URL], IndexPath), Never>
  /// Prefetches campaign image elements on first load.
  public let prefetchImageURLsOnFirstLoad: Signal<[ImageViewElement], Never>
  /// Emits whether the project is flagged.
  public let projectFlagged: Signal<Bool, Never>
  /// Reloads campaign data after an orientation change.
  public let reloadCampaignData: Signal<Void, Never>
  /// Presents a help web view controller.
  public let showHelpWebViewController: Signal<HelpType, Never>
  /// Switches or updates the active project page tab data.
  public let showProjectPageTabWithData: Signal<(NavigationSection, Project, RefTag?, [Bool], [URL], SimilarProjectsState, ProjectPageContentView), Never>
  /// Updates FAQ expansion states in the data source.
  public let updateFAQsInDataSource: Signal<(Project, RefTag?, [Bool]), Never>
  /// Updates prelaunch watch project button state.
  public let updateWatchProjectWithPrelaunchProjectState: Signal<PledgeCTAPrelaunchState, Never>
  /// Emits when user blocking succeeds.
  public let didBlockUser: Signal<(), Never>
  /// Emits when user blocking fails.
  public let didBlockUserError: Signal<(), Never>
  /// Input interface.
  public var inputs: ProjectPageViewModelInputs { return self }
  /// Output interface.
  public var outputs: ProjectPageViewModelOutputs { return self }
  /// Notifies the view model that a similar project card was tapped.
  public func similarProjectTapped(project: ProjectCardProperties) { self.similarProjectsUseCase.projectTapped(project: project) }
  /// Current state of similar projects.
  public var similarProjects: Property<SimilarProjectsState> { self.similarProjectsUseCase.similarProjects }
  /// Navigates to the tapped similar project.
  public var navigateToSimilarProject: Signal<ProjectCardProperties, Never> { self.similarProjectsUseCase.navigateToProject }
}
