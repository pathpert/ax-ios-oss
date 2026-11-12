import KsApi
import ReactiveSwift
import UIKit

/// Input events accepted by `DiscoveryPageViewModel`.
public protocol DiscoveryPageViewModelInputs {
  /// Call when the Config has been updated in the AppEnvironment.
  func configUpdated()

  /// Call with the sort provided to the view.
  func configureWith(sort: DiscoveryParams.Sort)

  /// Call when the current environment has changed.
  func currentEnvironmentChanged(environment: EnvironmentType)

  /// Call when the logged in user has blocked another user.
  func blockedUser()

  /// Call when onboarding has been completed.
  func onboardingCompleted()

  /// Call when the personalization cell is tapped.
  func personalizationCellTapped()

  /// Call when the personalization cell dismiss button is tapped.
  func personalizationCellDismissTapped()

  /// Call when the user pulls tableView to refresh.
  func pulledToRefresh()

  /// Call when the scrollViewDidScroll with its current contentOffset.
  func scrollViewDidScroll(toContentOffset offset: CGPoint)

  /// Call when the filter is changed.
  func selectedFilter(_ params: DiscoveryParams)

  /// Call when the onboarding login/signup button is tapped.
  func signupLoginButtonTapped()

  /// Call when the user taps on the activity sample.
  func tapped(activity: Activity)

  /// Call when the user taps on a project.
  func tapped(project: Project)

  /// Call when the controller has received a user session ended notification.
  func userSessionEnded()

  /// Call when the controller has received a user session started notification.
  func userSessionStarted()

  /// Call when the view appears.
  func viewDidAppear()

  /// Call when the view disappears.
  func viewDidDisappear(animated: Bool)

  /// Call when the view will appear.
  func viewWillAppear()

  /**
   Call from the controller's `tableView:willDisplayCell:forRowAtIndexPath` method.

   - parameter row:       The 0-based index of the row displaying.
   - parameter totalRows: The total number of rows in the table view.
   */
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

/// Output signals exposed by `DiscoveryPageViewModel`.
public protocol DiscoveryPageViewModelOutputs {
  /// Emits a list of activities to be displayed in the sample.
  var activitiesForSample: Signal<[Activity], Never> { get }

  /// Hack to emit when we should asynchronously reload the table view's data to properly display postcards.
  /// Hopefully in the future we can remove this when we can resolve postcard display issues.
  var asyncReloadData: Signal<Void, Never> { get }

  /// Emits the contentInset for the UITableView.
  var contentInset: Signal<UIEdgeInsets, Never> { get }

  /// Emits when the personalization cell should be deleted.
  var dismissPersonalizationCell: Signal<Void, Never> { get }

  /// Emits a project and ref tag that we should go to from the activity sample.
  var goToActivityProject: Signal<(Project, RefTag), Never> { get }

  /// Emits an array of KsApi.Category objects used to generate a curated list of projects.
  var goToCuratedProjects: Signal<[KsApi.Category], Never> { get }

  /// Emits a LoginIntent for the LoginToutViewController to be configured with.
  var goToLoginSignup: Signal<LoginIntent, Never> { get }

  /// Emits a project, playlist, ref tag that we should go to from discovery.
  var goToProjectPlaylist: Signal<(Project, [Project], RefTag), Never> { get }

  /// Emits a project and update when should go to update.
  var goToProjectUpdate: Signal<(Project, Update), Never> { get }

  /// Emits when we should dismiss the empty state controller.
  var hideEmptyState: Signal<(), Never> { get }

  /// Emits with the current contentOffset.
  var notifyDelegateContentOffsetChanged: Signal<CGPoint, Never> { get }

  /// Emits a list of projects that should be shown, and the corresponding filter request params.
  var projectsLoaded: Signal<([Project], DiscoveryParams?), Never> { get }

  /// Emits a boolean that determines if projects are currently loading or not.
  var projectsAreLoadingAnimated: Signal<(Bool, Bool), Never> { get }

  /// Emits a bool to allow status bar tap to scroll the table view to the top.
  var setScrollsToTop: Signal<Bool, Never> { get }

  /// Emits to show the empty state controller.
  var showEmptyState: Signal<EmptyState, Never> { get }

  /// Emits a boolean that determines if the onboarding should be shown.
  var showOnboarding: Signal<Bool, Never> { get }

  /// Emits to show the personalization section.
  var showPersonalization: Signal<Bool, Never> { get }

  /// Emits to show the video feed banner.
  var showVideoFeedBanner: Signal<Bool, Never> { get }
}

/// Protocol grouping inputs and outputs for `DiscoveryPageViewModel`.
public protocol DiscoveryPageViewModelType {
  /// View model inputs.
  var inputs: DiscoveryPageViewModelInputs { get }
  /// View model outputs.
  var outputs: DiscoveryPageViewModelOutputs { get }
}

