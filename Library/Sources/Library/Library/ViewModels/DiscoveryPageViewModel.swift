import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// View model managing pagination, sorting/filtering, activity sample banners, and analytics for a discovery page.
public final class DiscoveryPageViewModel: DiscoveryPageViewModelType, DiscoveryPageViewModelInputs,
  DiscoveryPageViewModelOutputs {
  /// Initializes the discovery page view model and binds pagination, empty states, and tracking signals.
  public init() {
    let currentUser = Signal.merge(
      self.userSessionStartedProperty.signal,
      self.userSessionEndedProperty.signal,
      self.viewWillAppearProperty.signal
    )
    .map { AppEnvironment.current.currentUser }
    .skipRepeats(==)

    let paramsChanged = Signal.combineLatest(
      self.sortProperty.signal.skipNil(),
      self.selectedFilterProperty.signal.skipNil()
    )
    .map(DiscoveryParams.lens.sort.set)

    let isCloseToBottom = self.willDisplayRowProperty.signal.skipNil()
      .map { row, total in row >= total - 3 && row > 0 }
      .skipRepeats()
      .filter(isTrue)
      .ignoreValues()

    let isVisible = Signal.merge(
      self.viewDidAppearProperty.signal.mapConst(true),
      self.viewDidDisappearProperty.signal.mapConst(false)
    )
    .skipRepeats()

    let environmentChanged = self.currentEnvironmentChangedProperty.signal
      .skipNil()
      .skipRepeats()

    let firstPageParams = Signal.combineLatest(currentUser, paramsChanged, isVisible)
      .filter { _, _, visible in visible }
      .skipRepeats { lhs, rhs in lhs.0 == rhs.0 && lhs.1 == rhs.1 }
      .map { $0.1 }

    let requestFirstPageWith = Signal.merge(
      firstPageParams,
      firstPageParams.takeWhen(environmentChanged),
      firstPageParams.takeWhen(self.pulledToRefreshProperty.signal),
      firstPageParams.takeWhen(self.blockedUserProperty.signal)
    )

    let paginatedProjects: Signal<[Project], Never>
    let isLoading: Signal<Bool, Never>
    (paginatedProjects, isLoading, _, _) = paginate(
      requestFirstPageWith: requestFirstPageWith,
      requestNextPageWhen: isCloseToBottom,
      clearOnNewRequest: false,
      skipRepeats: false,
      valuesFromEnvelope: { $0.projects },
      cursorFromEnvelope: { $0.urls.api.moreProjects },
      requestFromParams: { AppEnvironment.current.apiService.fetchDiscovery(params: $0) },
      requestFromCursor: { AppEnvironment.current.apiService.fetchDiscovery(paginationUrl: $0) },
      concater: { ($0 + $1).distincts() }
    )

    let projects = Signal.merge(
      paginatedProjects,
      self.selectedFilterProperty.signal.skipNil().skipRepeats().mapConst([])
    )
    .skip { $0.isEmpty }
    .skipRepeats(==)

    self.projectsLoaded = paramsChanged.takePairWhen(projects)
      .map { args in (args.1, args.0) }

    self.asyncReloadData = self.projectsLoaded.take(first: 1).ignoreValues()
    self.contentInset = self.viewWillAppearProperty.signal.map { .zero }

    let isRefreshing = isLoading
      .combineLatest(with: self.pulledToRefreshProperty.signal)
      .map(first)
      .skipRepeats()

    let projectsLoadingNoRefresh = Signal.merge(
      isLoading,
      isLoading.takeWhen(isRefreshing).mapConst(false)
    )
    .skipRepeats()

    self.projectsAreLoadingAnimated = Signal.merge(
      isRefreshing.map { ($0, true) },
      projectsLoadingNoRefresh.map { ($0, false) },
      self.viewWillAppearProperty.signal.take(first: 1).mapConst((true, false))
    )
    .skipRepeats(==)

    self.showEmptyState = Signal.combineLatest(
      paramsChanged,
      self.projectsAreLoadingAnimated.map(first),
      paginatedProjects
    )
    .filter { _, projectsAreLoading, projects in projectsAreLoading == false && projects.isEmpty }
    .map { args in discoveryEmptyState(forParams: args.0) }
    .skipNil()
    .skipRepeats()

    self.hideEmptyState = Signal.merge(
      self.viewWillAppearProperty.signal.take(first: 1),
      self.asyncReloadData,
      paginatedProjects.filter { !$0.isEmpty }.ignoreValues(),
      paramsChanged.skip(first: 1).ignoreValues()
    )

    let activitySignals = makeDiscoveryActivitySampleSignals(
      viewDidAppear: self.viewDidAppearProperty.signal,
      viewWillAppear: self.viewWillAppearProperty.signal,
      viewDidDisappear: self.viewDidDisappearProperty.signal,
      paramsChanged: paramsChanged,
      tappedActivity: self.tappedActivity.signal.skipNil()
    )
    self.activitiesForSample = activitySignals.activitiesForSample
    self.goToActivityProject = activitySignals.goToActivityProject
    self.goToProjectUpdate = activitySignals.goToProjectUpdate

    let projectCardTapped = paramsChanged
      .takePairWhen(self.tappedProject.signal.skipNil())
      .map { args in (args.1, RefTag.fromParams(args.0)) }

    self.goToProjectPlaylist = projects
      .takePairWhen(projectCardTapped)
      .map(unpack)
      .map { args in (args.1, args.0, args.2) }

    self.showOnboarding = Signal.combineLatest(currentUser, paramsChanged)
      .map { args in args.0 == nil && args.1.sort == .magic }
      .skipRepeats()

    self.setScrollsToTop = Signal.merge(
      self.viewDidAppearProperty.signal.mapConst(true),
      self.viewDidDisappearProperty.signal.mapConst(false)
    )

    self.reachabilityProperty <~ Reachability.signalProducer

    (self.showPersonalization, self.showVideoFeedBanner) = makeDiscoveryBannerAndTrackingSignals(
      sort: self.sortProperty.signal.skipNil(),
      selectedFilter: self.selectedFilterProperty.signal.skipNil(),
      viewDidAppear: self.viewDidAppearProperty.signal,
      viewWillAppear: self.viewWillAppearProperty.signal,
      onboardingCompleted: self.onboardingCompletedProperty.signal,
      configUpdated: self.configUpdatedSignal,
      reachabilityChanged: self.reachabilityProperty.signal.ignoreValues(),
      requestFirstPageWith: requestFirstPageWith,
      paramsChanged: paramsChanged,
      tappedProject: self.tappedProject.signal.skipNil()
    )

    self.goToCuratedProjects = self.personalizationCellTappedProperty.signal
      .map(cachedDiscoveryCategories)
      .skipNil()

    self.dismissPersonalizationCell = self.personalizationCellDismissTappedProperty.signal
      .on(value: { _ in AppEnvironment.current.userDefaults.hasDismissedPersonalizationCard = true })

    self.notifyDelegateContentOffsetChanged = Signal.combineLatest(
      self.scrollViewDidScrollToContentOffsetProperty.signal.skipNil(),
      self.projectsAreLoadingAnimated.map(first)
    )
    .filter(second >>> isFalse)
    .map(first)

    self.goToLoginSignup = self.signupLoginButtonTappedProperty.signal
      .mapConst(LoginIntent.discoveryOnboarding)
  }

  fileprivate let (configUpdatedSignal, configUpdatedObserver) = Signal<Void, Never>.pipe()
  /// Signals that remote configuration values finished updating.
  public func configUpdated() { self.configUpdatedObserver.send(value: ()) }
  fileprivate let currentEnvironmentChangedProperty = MutableProperty<EnvironmentType?>(nil)
  /// Signals that the server environment switched.
  public func currentEnvironmentChanged(environment: EnvironmentType) {
    self.currentEnvironmentChangedProperty.value = environment
  }
  fileprivate let blockedUserProperty = MutableProperty(())
  /// Signals that the current user blocked another user and discovery should reload.
  public func blockedUser() { self.blockedUserProperty.value = () }
  fileprivate let onboardingCompletedProperty = MutableProperty(())
  /// Signals that onboarding completed.
  public func onboardingCompleted() { self.onboardingCompletedProperty.value = () }
  fileprivate let personalizationCellTappedProperty = MutableProperty(())
  /// Signals that the personalization callout cell was tapped.
  public func personalizationCellTapped() { self.personalizationCellTappedProperty.value = () }
  fileprivate let personalizationCellDismissTappedProperty = MutableProperty(())
  /// Signals that the personalization callout dismiss button was tapped.
  public func personalizationCellDismissTapped() { self.personalizationCellDismissTappedProperty.value = () }
  fileprivate let pulledToRefreshProperty = MutableProperty(())
  /// Signals that pull-to-refresh was triggered.
  public func pulledToRefresh() { self.pulledToRefreshProperty.value = () }
  fileprivate let sortProperty = MutableProperty<DiscoveryParams.Sort?>(nil)
  /// Configures the discovery page with the assigned sort option.
  public func configureWith(sort: DiscoveryParams.Sort) { self.sortProperty.value = sort }
  private let scrollViewDidScrollToContentOffsetProperty = MutableProperty<CGPoint?>(nil)
  /// Reports scroll view content offset updates.
  public func scrollViewDidScroll(toContentOffset offset: CGPoint) {
    self.scrollViewDidScrollToContentOffsetProperty.value = offset
  }
  fileprivate let selectedFilterProperty = MutableProperty<DiscoveryParams?>(nil)
  /// Updates the active discovery filter parameters.
  public func selectedFilter(_ params: DiscoveryParams) { self.selectedFilterProperty.value = params }
  fileprivate let signupLoginButtonTappedProperty = MutableProperty(())
  /// Signals that the onboarding login/signup CTA was tapped.
  public func signupLoginButtonTapped() { self.signupLoginButtonTappedProperty.value = () }
  fileprivate let tappedActivity = MutableProperty<Activity?>(nil)
  /// Signals that an activity sample card was tapped.
  public func tapped(activity: Activity) { self.tappedActivity.value = activity }
  fileprivate let tappedProject = MutableProperty<Project?>(nil)
  /// Signals that a project card was tapped.
  public func tapped(project: Project) { self.tappedProject.value = project }
  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Signals that a user session started.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }
  fileprivate let userSessionEndedProperty = MutableProperty(())
  /// Signals that a user session ended.
  public func userSessionEnded() { self.userSessionEndedProperty.value = () }
  fileprivate let viewDidAppearProperty = MutableProperty(())
  /// Signals that the discovery page appeared.
  public func viewDidAppear() { self.viewDidAppearProperty.value = () }
  fileprivate let viewDidDisappearProperty = MutableProperty(false)
  /// Signals that the discovery page disappeared.
  public func viewDidDisappear(animated: Bool) { self.viewDidDisappearProperty.value = animated }
  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the discovery page will appear.
  public func viewWillAppear() { self.viewWillAppearProperty.value = () }
  fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
  /// Reports table row display progress for pagination triggers.
  public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
    self.willDisplayRowProperty.value = (row, totalRows)
  }

  private let reachabilityProperty = MutableProperty(Reachability.current)

  /// Emits activities to display in the sample card.
  public let activitiesForSample: Signal<[Activity], Never>
  /// Triggers an initial asynchronous table reload.
  public let asyncReloadData: Signal<Void, Never>
  /// Emits the content inset for the discovery table view.
  public let contentInset: Signal<UIEdgeInsets, Never>
  /// Emits when the personalization callout should be deleted.
  public let dismissPersonalizationCell: Signal<Void, Never>
  /// Emits project and ref tag when navigating from an activity sample.
  public let goToActivityProject: Signal<(Project, RefTag), Never>
  /// Emits cached categories for curated project discovery.
  public let goToCuratedProjects: Signal<[KsApi.Category], Never>
  /// Emits login intent for presenting the login tout flow.
  public let goToLoginSignup: Signal<LoginIntent, Never>
  /// Emits project, loaded playlist, and ref tag for project navigation.
  public let goToProjectPlaylist: Signal<(Project, [Project], RefTag), Never>
  /// Emits project and update when navigating to a creator update.
  public let goToProjectUpdate: Signal<(Project, Update), Never>
  /// Emits when the empty state overlay should be hidden.
  public let hideEmptyState: Signal<Void, Never>
  /// Emits table content offset updates to the parent container.
  public let notifyDelegateContentOffsetChanged: Signal<CGPoint, Never>
  /// Emits loaded discovery projects paired with the active filter parameters.
  public let projectsLoaded: Signal<([Project], DiscoveryParams?), Never>
  /// Emits loading state and animation flag pairs.
  public let projectsAreLoadingAnimated: Signal<(Bool, Bool), Never>
  /// Emits whether status-bar scroll-to-top should be enabled.
  public let setScrollsToTop: Signal<Bool, Never>
  /// Emits the empty state variant to display.
  public let showEmptyState: Signal<EmptyState, Never>
  /// Emits whether the logged-out onboarding banner should appear.
  public let showOnboarding: Signal<Bool, Never>
  /// Emits whether the personalization callout should appear.
  public let showPersonalization: Signal<Bool, Never>
  /// Emits whether the video feed banner should appear.
  public let showVideoFeedBanner: Signal<Bool, Never>

  /// View model inputs.
  public var inputs: DiscoveryPageViewModelInputs { return self }
  /// View model outputs.
  public var outputs: DiscoveryPageViewModelOutputs { return self }
}
