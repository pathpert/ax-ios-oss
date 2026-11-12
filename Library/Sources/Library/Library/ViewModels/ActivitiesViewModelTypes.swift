import Foundation
import KsApi
import ReactiveSwift

/// Input actions supported by `ActivitiesViewModel`.
public protocol ActitiviesViewModelInputs {
  /// Called when the project image in an update activity cell is tapped.
  func activityUpdateCellTappedProjectImage(activity: Activity)

  /// Call when the controller has received a user updated notification.
  func currentUserUpdated()

  /// Called when the user tapped to fix an errored pledge.
  func erroredBackingViewDidTapManage(with backing: ProjectAndBackingEnvelope)

  /// Call when the ManagePledgeViewController made changes.
  func managePledgeViewControllerDidFinish()

  /// Call when the feed should be refreshed, e.g. pull-to-refresh.
  func refresh()

  /// Call when the SurveyResponseViewController has been dismissed.
  func surveyResponseViewControllerDismissed()

  /// Call when an activity is tapped.
  func tappedActivity(_ activity: Activity)

  /// Call when the respond button is tapped in a survey cell.
  func tappedRespondNow(forSurveyResponse surveyResponse: SurveyResponse)

  /// Call when the Track shipping button is tapped in a TrackingActivitiesCell.
  func tappedTrackShipping(with trackingURL: URL)

  /// Call when a user session ends.
  func userSessionEnded()

  /// Call when a user session has started.
  func userSessionStarted()

  /// Call when the view did load.
  func viewDidLoad()

  /// Call when the view will appear with animated property.
  func viewWillAppear(animated: Bool)

  /**
   Call from the controller's `tableView:willDisplayCell:forRowAtIndexPath` method.

   - parameter row:       The 0-based index of the row displaying.
   - parameter totalRows: The total number of rows in the table view.
   */
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

/// UI and navigation outputs emitted by `ActivitiesViewModel`.
public protocol ActivitiesViewModelOutputs {
  /// Emits an array of activities that should be displayed.
  var activities: Signal<[Activity], Never> { get }
  /// Emits when the tab bar item's badge value should be cleared.
  var clearBadgeValue: Signal<(), Never> { get }
  /// Emits an array of errored backings to be displayed on the top of the list of projects.
  var erroredBackings: Signal<[ProjectAndBackingEnvelope], Never> { get }
  /// Emits when we should dismiss the empty state controller.
  var hideEmptyState: Signal<(), Never> { get }
  /// Emits a project and backing Param to navigate to ManagePledgeViewController.
  var goToManagePledge: Signal<ManagePledgeViewParamConfigData, Never> { get }
  /// Emits a project and ref tag that should be used to present a project controller.
  var goToProject: Signal<(Project, RefTag), Never> { get }
  /// Emits a survey response when we should navigate to the survey to fill it out.
  var goToSurveyResponse: Signal<SurveyResponse, Never> { get }
  /// Emits a project and update when we should navigate to that update.
  var goToUpdate: Signal<(Project, Update), Never> { get }
  /// Emits a tracking URL when we should navigate to a shipping tracking page.
  var goToTrackShipping: Signal<URL, Never> { get }
  /// Emits a boolean that indicates if the activities are refreshing.
  var isRefreshing: Signal<Bool, Never> { get }
  /// Emits `true` when logged-in, `false` when logged-out, when we should show the empty state controller.
  var showEmptyStateIsLoggedIn: Signal<Bool, Never> { get }
  /// Emits a non-`nil` survey response if there is an unanswered one available, and `nil` otherwise.
  var unansweredSurveys: Signal<[SurveyResponse], Never> { get }
  /// Emits a User that can be used to replace the current user in the environment.
  var updateUserInEnvironment: Signal<User, Never> { get }
}

/// View model interface for the activity feed screen.
public protocol ActivitiesViewModelType {
  /// Input interface for the activities view model.
  var inputs: ActitiviesViewModelInputs { get }
  /// Output interface for the activities view model.
  var outputs: ActivitiesViewModelOutputs { get }
}

