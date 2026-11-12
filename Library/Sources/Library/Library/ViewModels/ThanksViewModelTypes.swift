import KsApi
import ReactiveSwift
import UIKit

/// Display and analytics payload passed when presenting the post-pledge Thank You screen.
public struct ThanksPageData {
  /// Backed Kickstarter project displayed on the Thank You screen.
  public let project: Project
  /// Reward tier selected in the completed pledge.
  public let reward: Reward
  /// Optional analytics checkout metrics associated with the completed pledge.
  public let checkoutData: KSRAnalytics.CheckoutPropertiesData?
  /// Final pledged currency amount shown in post-campaign copy.
  public let pledgeTotal: Double

  /// Creates a `ThanksPageData` payload.
  public init(
    project: Project,
    reward: Reward,
    checkoutData: KSRAnalytics.CheckoutPropertiesData?,
    pledgeTotal: Double
  ) {
    self.project = project
    self.reward = reward
    self.checkoutData = checkoutData
    self.pledgeTotal = pledgeTotal
  }
}

/// Input events handled by `ThanksViewModel`.
public protocol ThanksViewModelInputs {
  /// Call to configure the VM
  func configure(with data: ThanksPageData)

  /// Call when close button is tapped
  func closeButtonTapped()

  /// Call when category cell is tapped
  func categoryCellTapped(_ category: KsApi.Category)

  /// Call when project cell is tapped
  func projectTapped(_ project: Project)

  /// Call when signup button is tapped on games newsletter alert
  func gamesNewsletterSignupButtonTapped()

  /// Call when the current user has been updated in the environment
  func userUpdated()

  /// Call when the view controller view did load
  func viewDidLoad()
}

/// Output signals emitted by `ThanksViewModel`.
public protocol ThanksViewModelOutputs {
  /// Emits backed project subheader text to display
  var backedProjectText: Signal<NSAttributedString, Never> { get }

  /// Emits when view controller should dismiss
  var postProjectBackedNotification: Signal<Notification, Never> { get }

  /// Emits DiscoveryParams when should go to Discovery
  var goToDiscovery: Signal<DiscoveryParams, Never> { get }

  /// Emits project when should go to Project page
  var goToProject: Signal<(Project, [Project], RefTag), Never> { get }

  /// Emits when a user pledges a project for the first time.
  var postContextualNotification: Signal<(), Never> { get }

  /// Emits when a user updated notification should be posted
  var postUserUpdatedNotification: Signal<Notification, Never> { get }

  /// Emits when should show games newsletter alert
  var showGamesNewsletterAlert: Signal<(), Never> { get }

  /// Emits newsletter title when should show games newsletter opt-in alert
  var showGamesNewsletterOptInAlert: Signal<String, Never> { get }

  /// Emits when should show rating alert
  var showRatingAlert: Signal<(), Never> { get }

  /// Emits array of projects and a category when should show recommendations
  var showRecommendations: Signal<([Project], KsApi.Category), Never> { get }

  /// Emits a User that can be used to replace the current user in the environment
  var updateUserInEnvironment: Signal<User, Never> { get }
}

/// View model interface for the post-pledge Thank You screen.
public protocol ThanksViewModelType {
  /// Input receiver for user interactions and screen lifecycle events.
  var inputs: ThanksViewModelInputs { get }
  /// Output signals bound by `ThanksViewController`.
  var outputs: ThanksViewModelOutputs { get }
}

