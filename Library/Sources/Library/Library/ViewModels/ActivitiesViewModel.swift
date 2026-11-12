import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// View model driving the user's activity feed, unanswered surveys, and badge clearing.
public final class ActivitiesViewModel: ActivitiesViewModelType, ActitiviesViewModelInputs,
  ActivitiesViewModelOutputs {
  /// Initializes the activities view model.
  public init() {
    let isCloseToBottom = self.willDisplayRowProperty.signal.skipNil()
      .map { row, total in total > 3 && row >= total - 2 }
      .skipRepeats()
      .filter(isTrue)
      .ignoreValues()

    let requestFirstPage = Signal
      .merge(
        self.userSessionStartedProperty.signal,
        self.viewWillAppearProperty.signal.skipNil().filter(isTrue).ignoreValues(),
        self.refreshProperty.signal
      )
      .filter { AppEnvironment.current.currentUser != nil }

    let (paginatedActivities, isLoading, _, _) = paginate(
      requestFirstPageWith: requestFirstPage,
      requestNextPageWhen: isCloseToBottom,
      clearOnNewRequest: false,
      skipRepeats: false,
      valuesFromEnvelope: { $0.activities },
      cursorFromEnvelope: { $0.urls.api.moreActivities },
      requestFromParams: { _ in AppEnvironment.current.apiService.fetchActivities(count: nil) },
      requestFromCursor: { AppEnvironment.current.apiService.fetchActivities(paginationUrl: $0) }
    )

    let activities = paginatedActivities
      .scan([Activity]()) { acc, next in
        !next.isEmpty
          ? (acc + next).distincts().sorted { $0.id > $1.id }
          : next
      }

    self.isRefreshing = isLoading

    let clearedActivitiesOnSessionEnd = self.userSessionEndedProperty.signal.mapConst([Activity]())
    let activityToUpdate: Signal<Activity?, Never> = self.viewWillAppearProperty.signal.skipNil()
      .take(first: 1).mapConst(nil)

    let updatedActivities = Signal.combineLatest(activities, activityToUpdate)
      .map { currentActivities, updatedActivity in
        currentActivities
          .map { $0 == updatedActivity ? updatedActivity : $0 }
          .compact()
      }

    self.activities = Signal.merge(clearedActivitiesOnSessionEnd, updatedActivities)
    self.clearBadgeValue = Signal.zip(self.refreshProperty.signal, updatedActivities.skip(first: 1))
      .ignoreValues()

    let userClearingBadgeCountEvent = self.clearBadgeValue
      .filter { _ in AppEnvironment.current.currentUser != nil }
      .switchMap { _ in
        updatedUserWithClearedActivityCountProducer()
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let refreshUserEvent = self.managePledgeViewControllerDidFinishProperty.signal
      .switchMap { _ in AppEnvironment.current.apiService.fetchUserSelf().materialize() }

    self.updateUserInEnvironment = Signal.merge(
      userClearingBadgeCountEvent.values(),
      refreshUserEvent.values()
    )

    let currentUser = Signal
      .merge(
        self.currentUserUpdatedProperty.signal.ignoreValues(),
        self.viewDidLoadProperty.signal,
        self.userSessionStartedProperty.signal,
        self.userSessionEndedProperty.signal
      )
      .map { _ in AppEnvironment.current.currentUser }

    // TODO: Remove this whole set of Signals as these live in Backings Dashboard now.
    // https://kickstarter.atlassian.net/browse/MBL-2255
    self.erroredBackings = Signal<[ProjectAndBackingEnvelope], Never>.never

    let loggedInForEmptyState = self.activities
      .filter { AppEnvironment.current.currentUser != nil && $0.isEmpty }
      .skipRepeats(==)
      .mapConst(true)

    let loggedOutForEmptyState = currentUser
      .takeWhen(self.viewWillAppearProperty.signal.skipNil())
      .skipRepeats(==)
      .filter(isNil)
      .mapConst(false)

    self.showEmptyStateIsLoggedIn = Signal.merge(loggedInForEmptyState, loggedOutForEmptyState)

    self.hideEmptyState = Signal.merge(
      self.viewDidLoadProperty.signal.ignoreValues(),
      self.activities
        .combinePrevious([])
        .filter { previousActivities, currentActivities in
          previousActivities.isEmpty
            && !currentActivities.isEmpty
            && AppEnvironment.current.currentUser != nil
        }.ignoreValues()
    )

    let projectActivities = self.tappedActivityProperty.signal.skipNil().filter { $0.category != .update }

    self.goToProject = Signal
      .merge(
        self.tappedActivityProjectImage.signal.map { $0?.project },
        projectActivities.map { $0.project }
      )
      .skipNil()
      .map { ($0, .activity) }

    let surveyEvents = currentUser
      .takeWhen(
        Signal.merge(
          self.viewWillAppearProperty.signal.skipNil().ignoreValues(),
          self.surveyResponseViewControllerDismissedProperty.signal
        )
      )
      .filter { $0 != nil }
      .switchMap { _ in AppEnvironment.current.apiService.fetchUnansweredSurveyResponses().materialize() }

    self.unansweredSurveys = surveyEvents.values()
    self.goToSurveyResponse = self.tappedSurveyResponseProperty.signal.skipNil()

    self.goToUpdate = self.tappedActivityProperty.signal.skipNil()
      .filter { $0.category == .update }
      .map { ($0.project, $0.update) }
      .flatMap { project, update -> SignalProducer<(Project, Update), Never> in
        guard let project = project, let update = update else { return .empty }
        return SignalProducer(value: (project, update))
      }

    self.goToManagePledge = self.erroredBackingViewDidTapManageWithBackingProperty.signal
      .skipNil()
      .map { env -> ManagePledgeViewParamConfigData? in
        ManagePledgeViewParamConfigData(
          projectParam: Param.id(env.project.id),
          backingParam: Param.id(env.backing.id)
        )
      }
      .skipNil()

    self.goToProject.signal.map(first).observeValues { project in
      AppEnvironment.current.ksrAnalytics.trackProjectCardClicked(page: .activities, project: project)
    }

    self.goToTrackShipping = self.tappedTrackShippingProperty.signal.skipNil()
  }

  fileprivate let currentUserUpdatedProperty = MutableProperty(())
  /// Signals that the current user profile was updated.
  public func currentUserUpdated() { self.currentUserUpdatedProperty.value = () }

  fileprivate let erroredBackingViewDidTapManageWithBackingProperty
    = MutableProperty<ProjectAndBackingEnvelope?>(nil)
  /// Notifies the view model that Manage was tapped for an errored backing.
  public func erroredBackingViewDidTapManage(with backing: ProjectAndBackingEnvelope) {
    self.erroredBackingViewDidTapManageWithBackingProperty.value = backing
  }

  fileprivate let managePledgeViewControllerDidFinishProperty = MutableProperty(())
  /// Signals that `ManagePledgeViewController` dismissed after changes.
  public func managePledgeViewControllerDidFinish() { self.managePledgeViewControllerDidFinishProperty.value = () }

  fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
  /// Signals `viewWillAppear(animated:)` lifecycle transition.
  public func viewWillAppear(animated: Bool) { self.viewWillAppearProperty.value = animated }

  fileprivate let refreshProperty = MutableProperty(())
  /// Requests refreshing the activities feed.
  public func refresh() { self.refreshProperty.value = () }

  fileprivate let surveyResponseViewControllerDismissedProperty = MutableProperty(())
  /// Signals that the survey response controller was dismissed.
  public func surveyResponseViewControllerDismissed() {
    self.surveyResponseViewControllerDismissedProperty.value = ()
  }

  fileprivate let tappedActivityProjectImage = MutableProperty<Activity?>(nil)
  /// Handles tapping the project image inside an update activity cell.
  public func activityUpdateCellTappedProjectImage(activity: Activity) {
    self.tappedActivityProjectImage.value = activity
  }

  fileprivate let tappedSurveyResponseProperty = MutableProperty<SurveyResponse?>(nil)
  /// Handles tapping Respond Now on an unanswered survey banner.
  public func tappedRespondNow(forSurveyResponse surveyResponse: SurveyResponse) {
    self.tappedSurveyResponseProperty.value = surveyResponse
  }

  fileprivate let tappedActivityProperty = MutableProperty<Activity?>(nil)
  /// Handles tapping an activity cell.
  public func tappedActivity(_ activity: Activity) { self.tappedActivityProperty.value = activity }

  fileprivate let tappedTrackShippingProperty = MutableProperty<URL?>(nil)
  /// Handles tapping Track Shipping with a carrier tracking URL.
  public func tappedTrackShipping(with trackingURL: URL) { self.tappedTrackShippingProperty.value = trackingURL }

  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Signals that a user session started.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }

  fileprivate let userSessionEndedProperty = MutableProperty(())
  /// Signals that the user session ended.
  public func userSessionEnded() { self.userSessionEndedProperty.value = () }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals `viewDidLoad()` lifecycle readiness.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
  /// Reports the currently displaying table row for pagination.
  public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
    self.willDisplayRowProperty.value = (row, totalRows)
  }

  /// Emits the current activity feed list.
  public let activities: Signal<[Activity], Never>
  /// Emits when the tab bar badge count should be cleared.
  public let clearBadgeValue: Signal<(), Never>
  /// Emits errored backings (legacy output kept empty).
  public let erroredBackings: Signal<[ProjectAndBackingEnvelope], Never>
  /// Emits when the empty state overlay should be hidden.
  public let hideEmptyState: Signal<(), Never>
  /// Emits whether the feed is currently refreshing.
  public let isRefreshing: Signal<Bool, Never>
  /// Emits pledge configuration when managing an errored backing.
  public let goToManagePledge: Signal<ManagePledgeViewParamConfigData, Never>
  /// Emits project and ref tag to present a project screen.
  public let goToProject: Signal<(Project, RefTag), Never>
  /// Emits survey response to open.
  public let goToSurveyResponse: Signal<SurveyResponse, Never>
  /// Emits project and update to open an update detail screen.
  public let goToUpdate: Signal<(Project, Update), Never>
  /// Emits tracking URL to open shipment tracking.
  public let goToTrackShipping: Signal<URL, Never>
  /// Emits login state when the empty state controller should be presented.
  public let showEmptyStateIsLoggedIn: Signal<Bool, Never>
  /// Emits unanswered backer survey responses.
  public let unansweredSurveys: Signal<[SurveyResponse], Never>
  /// Emits refreshed `User` to update the active environment.
  public let updateUserInEnvironment: Signal<User, Never>

  /// Input interface for this view model.
  public var inputs: ActitiviesViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: ActivitiesViewModelOutputs { return self }
}
