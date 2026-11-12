import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Tabs displayed in `BackerDashboardViewController`.
public enum BackerDashboardTab {
  /// Projects backed by the signed-in user.
  case backed
  /// Projects saved/watched by the signed-in user.
  case saved

  /// All dashboard tabs in display order.
  public static let allTabs: [BackerDashboardTab] = [.backed, .saved]
}

/// Input methods accepted by `BackerDashboardViewModel`.
public protocol BackerDashboardViewModelInputs {
  /// Call when backed projects button is tapped.
  func backedProjectsButtonTapped()

  /// Call when the pan gesture begins with header top constraint constant and scroll view y offset values
  /// to calculate the starting point constant for the pan gesture.
  func beganPanGestureWith(headerTopConstant: CGFloat, scrollViewYOffset: CGFloat)

  /// Call after having invoked AppEnvironemt.updateCurrentUser with a fresh user.
  func currentUserUpdatedInEnvironment()

  /// Call when messages button is tapped.
  func messagesButtonTapped()

  /// Call when the UIPageViewController finishes transitioning.
  func pageTransition(completed: Bool)

  /// Call when the ksr_projectSaved notification is posted.
  func projectSaved()

  /// Call when saved projects button is tapped.
  func savedProjectsButtonTapped()

  /// Call when settings button is tapped.
  func settingsButtonTapped()

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view will appear.
  func viewWillAppear(_ animated: Bool)

  /// Call when the UIPageViewController begins a transition sequence.
  func willTransition(toPage nextPage: Int)
}

/// Output signals and properties emitted by `BackerDashboardViewModel`.
public protocol BackerDashboardViewModelOutputs {
  /// Emits a URL for the avatar image view.
  var avatarURL: Signal<URL?, Never> { get }

  /// Emits a string for the backed button title label.
  var backedButtonTitleText: Signal<String, Never> { get }

  /// Emits a string for the backer name label.
  var backerNameText: Signal<String, Never> { get }

  /// Emits the initial BackerDashboardTab to configure the page view controller.
  var configurePagesDataSource: Signal<BackerDashboardTab, Never> { get }

  /// The currently selected tab.
  var currentSelectedTab: BackerDashboardTab { get }

  /// Emits when to present Messages.
  var goToMessages: Signal<(), Never> { get }

  /// Emits when to navigate to Settings.
  var goToSettings: Signal<(), Never> { get }

  /// The starting value of the header top constraint that is needed to calculate the distance panned.
  var initialTopConstant: CGFloat { get }

  /// Emits a BackerDashboardTab to navigate to.
  var navigateToTab: Signal<BackerDashboardTab, Never> { get }

  /// Emits a BackerDashboardTab to pin the indicator view to with or without animation.
  var pinSelectedIndicatorToTab: Signal<(BackerDashboardTab, Bool), Never> { get }

  /// Emits an Notification that should be immediately posted.
  var postNotification: Signal<Notification, Never> { get }

  /// Emits a string for the saved button title label.
  var savedButtonTitleText: Signal<String, Never> { get }

  /// Emits the selected BackerDashboardTab to set the selected button and update all button selected states.
  var setSelectedButton: Signal<BackerDashboardTab, Never> { get }

  /// Emits a fresh user to be updated in the app environment.
  var updateCurrentUserInEnvironment: Signal<User, Never> { get }
}

/// Interface combining inputs and outputs for `BackerDashboardViewModel`.
public protocol BackerDashboardViewModelType {
  /// Input receiver for profile dashboard events.
  var inputs: BackerDashboardViewModelInputs { get }
  /// Output signals observed by `BackerDashboardViewController`.
  var outputs: BackerDashboardViewModelOutputs { get }
}

