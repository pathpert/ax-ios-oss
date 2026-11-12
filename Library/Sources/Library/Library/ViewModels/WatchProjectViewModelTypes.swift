import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Strongly-typed configuration payload for `WatchProjectViewModel` save/watch controls.
///
/// Negative Constraint: `discoveryParams` should be `nil` when invoked outside discovery feeds.
public struct WatchProjectValue {
  /// Target project whose watch/save state is toggled.
  public let project: Project
  /// Analytics page context where the watch control is hosted.
  public let context: KSRAnalytics.PageContext
  /// Active discovery filters when invoked from discovery; otherwise `nil`.
  public let discoveryParams: DiscoveryParams?

  /// Creates a typed `WatchProjectValue` contract.
  public init(
    project: Project,
    context: KSRAnalytics.PageContext,
    discoveryParams: DiscoveryParams?
  ) {
    self.project = project
    self.context = context
    self.discoveryParams = discoveryParams
  }
}

/// Input methods accepted by `WatchProjectViewModel`.
public protocol WatchProjectViewModelInputs {
  /// Notifies that the save control awoke from nib.
  func awakeFromNib()
  /// Configures the view model with a target project and analytics context.
  func configure(with value: WatchProjectValue)
  /// Updates watch state when a project save notification is posted.
  func projectFromNotification(project: Project?)
  /// Notifies that the save button was tapped with its resulting `selected` state.
  func saveButtonTapped(selected: Bool)
  /// Notifies that the user touched down on the save button.
  func saveButtonTouched()
  /// Notifies that the user session ended.
  func userSessionEnded()
  /// Notifies that the user session started.
  func userSessionStarted()
  /// Notifies that the host view loaded.
  func viewDidLoad()
}

/// Output signals emitted by `WatchProjectViewModel`.
public protocol WatchProjectViewModelOutputs {
  /// Emits when haptic feedback should be generated.
  var generateImpactFeedback: Signal<(), Never> { get }

  /// Emits when haptic feedback should be generated.
  var generateSelectionFeedback: Signal<(), Never> { get }

  /// Emits when haptic feedback should be generated.
  var generateNotificationSuccessFeedback: Signal<(), Never> { get }

  /// Emits when the login tout should be shown to the user.
  var goToLoginTout: Signal<(), Never> { get }

  /// Emits a project.
  var postNotificationWithProject: Signal<Project, Never> { get }

  /// Emits the accessibility hint for the star button.
  var saveButtonAccessibilityValue: Signal<String, Never> { get }

  /// Emits a boolean that determines if the save button is selected.
  var saveButtonSelected: Signal<Bool, Never> { get }

  /// Emits when a contextual Push Notification dialog should be shown.
  var showNotificationDialog: Signal<Notification, Never> { get }

  /// Emits when the project has been successfully saved and a prompt should be shown to the user.
  var showProjectSavedAlert: Signal<Void, Never> { get }
}

/// Interface combining inputs and outputs for `WatchProjectViewModel`.
public protocol WatchProjectViewModelType {
  /// Input receiver for watch/save events.
  var inputs: WatchProjectViewModelInputs { get }
  /// Output signals observed by watch/save controls.
  var outputs: WatchProjectViewModelOutputs { get }
}

// MARK: - Helpers

internal func watchProjectProducer(
  with project: Project,
  shouldWatch: Bool
) -> SignalProducer<WatchProjectResponseEnvelope, ErrorEnvelope> {
  guard shouldWatch else {
    return AppEnvironment.current.apiService.unwatchProject(input: .init(id: project.graphID))
  }

  return AppEnvironment.current.apiService.watchProject(input: .init(id: project.graphID))
}

internal func watchCached(project: Project) -> Project {
  guard
    let projectCache = AppEnvironment.current.cache[KSCache.ksr_projectSaved] as? [Int: Bool],
    let isSaved = projectCache[project.id] ?? project.personalization.isStarred
  else { return project }

  return project |> Project.lens.personalization.isStarred .~ isSaved
}

internal func watchAndCacheProject(_ project: Project, shouldWatch: Bool) -> (Project, Bool) {
  // create cache if it doesn't exist yet
  let tryCache = AppEnvironment.current.cache[KSCache.ksr_projectSaved]
  AppEnvironment.current.cache[KSCache.ksr_projectSaved] = tryCache ?? [Int: Bool]()

  // prepare result
  let result = (project |> Project.lens.personalization.isStarred .~ shouldWatch, shouldWatch)

  guard var cache = AppEnvironment.current.cache[KSCache.ksr_projectSaved] as? [Int: Bool] else {
    return result
  }

  // write to cache
  cache[project.id] = shouldWatch
  AppEnvironment.current.cache[KSCache.ksr_projectSaved] = cache

  return result
}

internal func shouldShowWatchNotificationDialog() -> Bool {
  return PushNotificationDialog.canShowDialog(for: .save) &&
    AppEnvironment.current.currentUser?.stats.starredProjectsCount == 0
}

