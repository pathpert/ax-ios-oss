import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// View model managing project watch/save toggling, optimistic caching, haptics, and login prompting.
public final class WatchProjectViewModel: WatchProjectViewModelType,
  WatchProjectViewModelInputs, WatchProjectViewModelOutputs {
  /// Creates a new `WatchProjectViewModel`.
  public init() {
    let viewReady = Signal.merge(self.viewDidLoadProperty.signal, self.awakeFromNibProperty.signal)
    let projectProperty = self.configureWithValueProperty.signal.skipNil().map { $0.project }

    let configuredProject = Signal.combineLatest(
      projectProperty,
      viewReady
    )
    .map(first)
    .map(watchCached(project:))

    let currentUser = Signal.merge([
      viewReady,
      self.userSessionStartedProperty.signal,
      self.userSessionEndedProperty.signal
    ])
    .map { AppEnvironment.current.currentUser }
    .skipRepeats(==)

    let loggedInUserTappedSaveButton = currentUser
      .takePairWhen(self.saveButtonTappedProperty.signal)
      .filter { user, _ in user != nil }
      .map(second)

    let loggedOutUserTappedSaveButton = currentUser
      .takePairWhen(self.saveButtonTappedProperty.signal)
      .filter { user, _ in user == nil }
      .map(second)

    // Emits only when a user logs in after having tapped the save/heart while logged out.
    let userLoginAfterTappingSaveButton = Signal.combineLatest(
      self.userSessionStartedProperty.signal,
      loggedOutUserTappedSaveButton
    )

    let saveButtonTapped = Signal.merge(
      loggedInUserTappedSaveButton,
      userLoginAfterTappingSaveButton.map(second)
    )

    let projectOnSaveButtonToggle = configuredProject
      .takePairWhen(saveButtonTapped)

    let watchProjectToggle = projectOnSaveButtonToggle
      .map { project, selected in (project, !selected) }
      // immediately cache and return the project with the correct watch value
      .map(watchAndCacheProject(_:shouldWatch:))

    // make the mutation request to the watch/unwatch and flip the result only if the call fails
    let watchProjectResult = watchProjectToggle
      .ksr_debounce(.milliseconds(500), on: AppEnvironment.current.scheduler)
      .switchMap { project, shouldWatch in
        watchProjectProducer(with: project, shouldWatch: shouldWatch)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map { watchProjectEnvelope in
            let updatedWatchCount = watchProjectEnvelope.watchProject.project.watchesCount

            let updatedProjectWithWatchCount = project
              |> \.watchesCount .~ updatedWatchCount

            return (
              updatedProjectWithWatchCount,
              updatedProjectWithWatchCount.personalization.isStarred ?? false,
              success: true
            )
          }
          .flatMapError { _ in .init(value: (project, !shouldWatch, success: false)) }
          .take(until: saveButtonTapped.ignoreValues())
      }

    // update the cache with the result and return it
    let projectResultUpdatingCache = watchProjectResult
      .map { project, shouldWatch, _ in (project, shouldWatch) }
      .map(watchAndCacheProject(_:shouldWatch:))

    let projectSavedFromNotification = configuredProject
      .takePairWhen(self.projectFromNotificationProperty.signal.skipNil())
      .filter { $0.id == $1.id }
      .map { $0.1 }

    // Project emits with initial configured value, immediately when watched, again on watch result
    let project = Signal.merge(
      configuredProject,
      projectSavedFromNotification,
      watchProjectToggle.map(first),
      projectResultUpdatingCache.map(first)
    )

    self.goToLoginTout = loggedOutUserTappedSaveButton.ignoreValues()

    self.showProjectSavedAlert = project
      .takeWhen(saveButtonTapped)
      .filter { !$0.endsIn48Hours(today: AppEnvironment.current.dateType.init().date) }
      .filter { _ in
        !AppEnvironment.current.ubiquitousStore.hasSeenSaveProjectAlert ||
          !AppEnvironment.current.userDefaults.hasSeenSaveProjectAlert
      }
      .on(value: { _ in
        AppEnvironment.current.ubiquitousStore.hasSeenSaveProjectAlert = true
        AppEnvironment.current.userDefaults.hasSeenSaveProjectAlert = true
      })
      .ignoreValues()

    self.showNotificationDialog = project
      .takeWhen(saveButtonTapped)
      .filter { _ in shouldShowWatchNotificationDialog() }
      .on(value: { _ in
        AppEnvironment.current.ubiquitousStore.hasSeenSaveProjectAlert = true
        AppEnvironment.current.userDefaults.hasSeenSaveProjectAlert = true
      })
      .ignoreValues()
      .map { _ in
        Notification(
          name: .ksr_showNotificationsDialog,
          userInfo: [UserInfoKeys.context: PushNotificationDialog.Context.save]
        )
      }

    self.saveButtonSelected = project
      .map { $0.personalization.isStarred == true }
      .skipRepeats()

    self.generateImpactFeedback = self.saveButtonTouchedProperty.signal
    self.generateNotificationSuccessFeedback = saveButtonTapped.signal.filter(isFalse).ignoreValues()
    self.generateSelectionFeedback = saveButtonTapped.signal.filter(isTrue).ignoreValues()

    self.saveButtonAccessibilityValue = self.saveButtonSelected
      .map { starred in starred ? Strings.Saved() : Strings.Unsaved() }

    self.postNotificationWithProject = project

    // Tracking

    self.configureWithValueProperty.signal.skipNil()
      .takeWhen(self.saveButtonTappedProperty.signal)
      .observeValues { value in
        AppEnvironment.current.ksrAnalytics.trackWatchProjectButtonClicked(
          project: value.project,
          page: value.context,
          params: value.discoveryParams,
          typeContext: self.saveButtonTappedProperty.value ? .unwatch : .watch
        )
      }
  }

  private let awakeFromNibProperty = MutableProperty(())
  /// Signals that the watch control awoke from nib.
  public func awakeFromNib() {
    self.awakeFromNibProperty.value = ()
  }

  fileprivate let configureWithValueProperty = MutableProperty<WatchProjectValue?>(nil)
  /// Configures the view model with a target project, page context, and optional discovery parameters.
  public func configure(with value: WatchProjectValue) {
    self.configureWithValueProperty.value = value
  }

  fileprivate let projectFromNotificationProperty = MutableProperty<Project?>(nil)
  /// Syncs watch state when a project save notification provides an updated project.
  public func projectFromNotification(project: Project?) {
    self.projectFromNotificationProperty.value = project
  }

  fileprivate let saveButtonTappedProperty = MutableProperty(false)
  /// Triggers a watch or unwatch mutation for the configured project.
  public func saveButtonTapped(selected: Bool) {
    self.saveButtonTappedProperty.value = selected
  }

  fileprivate let saveButtonTouchedProperty = MutableProperty(())
  /// Fires impact haptic feedback when the user touches down on the save button.
  public func saveButtonTouched() {
    self.saveButtonTouchedProperty.value = ()
  }

  fileprivate let userSessionEndedProperty = MutableProperty(())
  /// Updates watch state after the current user logs out.
  public func userSessionEnded() {
    self.userSessionEndedProperty.value = ()
  }

  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Updates watch state after a user signs in.
  public func userSessionStarted() {
    self.userSessionStartedProperty.value = ()
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the hosting view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits when impact haptic feedback should be generated.
  public let generateImpactFeedback: Signal<(), Never>
  /// Emits when notification success haptic feedback should be generated.
  public let generateNotificationSuccessFeedback: Signal<(), Never>
  /// Emits when selection haptic feedback should be generated.
  public let generateSelectionFeedback: Signal<(), Never>
  /// Emits when the user must sign in before saving a project.
  public let goToLoginTout: Signal<(), Never>
  /// Emits the updated project to broadcast save-state notifications.
  public let postNotificationWithProject: Signal<Project, Never>
  /// Emits the accessibility value for the save control (`Saved` / `Unsaved`).
  public let saveButtonAccessibilityValue: Signal<String, Never>
  /// Emits whether the save button should render in selected state.
  public let saveButtonSelected: Signal<Bool, Never>
  /// Emits a notification prompting for push notification permission.
  public let showNotificationDialog: Signal<Notification, Never>
  /// Emits when the saved-project confirmation alert should be presented.
  public let showProjectSavedAlert: Signal<Void, Never>

  /// Input receiver (`self`).
  public var inputs: WatchProjectViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: WatchProjectViewModelOutputs { return self }
}
