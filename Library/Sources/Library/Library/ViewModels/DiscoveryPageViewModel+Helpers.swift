import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Returns `true` when the given activity has not already been shown in the discovery activity sample.
func hasNotSeen(activity: Activity) -> Bool {
  return activity.id != AppEnvironment.current.userDefaults.lastSeenActivitySampleId
}

/// Persists the identifier of seen discovery sample activities to user defaults.
func saveSeen(activities: [Activity]) {
  activities.forEach { activity in
    AppEnvironment.current.userDefaults.lastSeenActivitySampleId = activity.id
  }
}

/// Returns whether the discovery personalization card should be displayed.
func shouldShowDiscoveryPersonalization() -> Bool {
  return false
}

/// Decodes cached onboarding category selections from user defaults.
func cachedDiscoveryCategories() -> [KsApi.Category]? {
  guard let data = AppEnvironment.current.userDefaults.onboardingCategories,
        let categories = try? JSONDecoder().decode([KsApi.Category].self, from: data)
  else {
    return []
  }

  return categories
}

/// Maps active discovery filter parameters to an appropriate empty state, if applicable.
func discoveryEmptyState(forParams params: DiscoveryParams) -> EmptyState? {
  if params.starred == .some(true) {
    return .starred
  } else if params.recommended == .some(true) {
    return .recommended
  } else if params.social == .some(true) {
    return AppEnvironment.current.currentUser?.social == .some(true) ? .socialNoPledges : .socialDisabled
  }

  return nil
}

/// Produces the discovery activity-sample banner signal and related navigation events.
func makeDiscoveryActivitySampleSignals(
  viewDidAppear: Signal<Void, Never>,
  viewWillAppear: Signal<Void, Never>,
  viewDidDisappear: Signal<Bool, Never>,
  paramsChanged: Signal<DiscoveryParams, Never>,
  tappedActivity: Signal<Activity, Never>
) -> (
  activitiesForSample: Signal<[Activity], Never>,
  goToActivityProject: Signal<(Project, RefTag), Never>,
  goToProjectUpdate: Signal<(Project, Update), Never>
) {
  let fetchActivityEvent = viewDidAppear
    .filter { _ in AppEnvironment.current.currentUser != nil }
    .switchMap { _ in
      AppEnvironment.current.apiService.fetchActivities(count: 1)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

  let goToActivityProject = tappedActivity
    .filter { $0.category != .update }
    .map { $0.project }
    .skipNil()
    .map { ($0, RefTag.activitySample) }

  let goToProjectUpdate = tappedActivity
    .filter { $0.category == .update }
    .flatMap { activity -> SignalProducer<(Project, Update), Never> in
      guard let project = activity.project, let update = activity.update else {
        return .empty
      }
      return SignalProducer(value: (project, update))
    }

  let activities = fetchActivityEvent.values()
    .map { $0.activities }
    .skipRepeats(==)
    .map { $0.filter { hasNotSeen(activity: $0) } }
    .on(value: { saveSeen(activities: $0) })

  let clearActivitySampleOnLogout = viewWillAppear
    .filter { _ in AppEnvironment.current.currentUser == nil }

  let clearActivitySampleOnNavigate = Signal.merge(
    paramsChanged.mapConst(true),
    goToActivityProject.mapConst(false),
    goToProjectUpdate.mapConst(false),
    viewDidDisappear.filter(isFalse),
    viewDidAppear.mapConst(true)
  )
  .takeWhen(viewDidDisappear)
  .filter(isTrue)

  let activitiesForSample = Signal.merge(
    activities,
    clearActivitySampleOnLogout.mapConst([]),
    clearActivitySampleOnNavigate.mapConst([])
  )
  .skipRepeats(==)

  return (activitiesForSample, goToActivityProject, goToProjectUpdate)
}

/// Builds personalization/video-feed banner outputs and wires discovery analytics events.
func makeDiscoveryBannerAndTrackingSignals(
  sort: Signal<DiscoveryParams.Sort, Never>,
  selectedFilter: Signal<DiscoveryParams, Never>,
  viewDidAppear: Signal<Void, Never>,
  viewWillAppear: Signal<Void, Never>,
  onboardingCompleted: Signal<Void, Never>,
  configUpdated: Signal<Void, Never>,
  reachabilityChanged: Signal<Void, Never>,
  requestFirstPageWith: Signal<DiscoveryParams, Never>,
  paramsChanged: Signal<DiscoveryParams, Never>,
  tappedProject: Signal<Project, Never>
) -> (showPersonalization: Signal<Bool, Never>, showVideoFeedBanner: Signal<Bool, Never>) {
  let filtersUpdated = sort.takePairWhen(selectedFilter.skipRepeats())
  let viewReady = Signal.combineLatest(viewDidAppear, filtersUpdated)

  let showPersonalization = Signal.merge(
    viewReady,
    viewReady.takeWhen(onboardingCompleted)
  )
  .ignoreValues()
  .map(shouldShowDiscoveryPersonalization)

  let showVideoFeedBanner = Signal.merge(
    viewWillAppear,
    configUpdated,
    reachabilityChanged
  )
  .map { featureVideoFeedEnabled() && Reachability.current != .none }
  .skipRepeats()

  Signal.combineLatest(requestFirstPageWith, viewWillAppear)
    .observeValues { params, _ in AppEnvironment.current.ksrAnalytics.trackDiscovery(params: params) }

  paramsChanged
    .takePairWhen(tappedProject)
    .observeValues { params, project in
      AppEnvironment.current.ksrAnalytics.trackProjectCardClicked(
        page: .discovery,
        project: project,
        typeContext: .init(params: params),
        location: .discoverAdvanced,
        params: params
      )
    }

  return (showPersonalization, showVideoFeedBanner)
}
