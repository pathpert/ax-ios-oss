import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs for `ProjectNotificationCellViewModel`.
public protocol ProjectNotificationCellViewModelInputs {
  /// Call with the initial cell notification value.
  func configureWith(notification: ProjectNotification)

  /// Call when the notification switch is tapped.
  func notificationTapped(on: Bool)
}

/// Outputs for `ProjectNotificationCellViewModel`.
public protocol ProjectNotificationCellViewModelOutputs {
  /// Emits the project name.
  var name: Signal<String, Never> { get }

  /// Emits true when the notification is turned on, false otherwise.
  var notificationOn: Signal<Bool, Never> { get }

  /// Emits when an update error has occurred and a message should be displayed.
  var notifyDelegateOfSaveError: Signal<String, Never> { get }
}

/// Type interface for `ProjectNotificationCellViewModel`.
public protocol ProjectNotificationCellViewModelType {
  /// View model inputs.
  var inputs: ProjectNotificationCellViewModelInputs { get }
  /// View model outputs.
  var outputs: ProjectNotificationCellViewModelOutputs { get }
}

/// View model for toggling per-project email/push notifications in settings.
public final class ProjectNotificationCellViewModel: ProjectNotificationCellViewModelType,
  ProjectNotificationCellViewModelInputs, ProjectNotificationCellViewModelOutputs {
  /// Initializes the notification cell view model and binds toggle update requests.
  public init() {
    let notification = self.notificationProperty.signal.skipNil()
      .map(cached(notification:))

    self.name = notification.map { $0.project.name }

    let toggledNotification: Signal<ProjectNotification, Never> = notification
      .takePairWhen(self.notificationTappedProperty.signal)
      .map { notification, on -> ProjectNotification in
        let n = (
          notification
            |> ProjectNotification.lens.email .~ on
            |> ProjectNotification.lens.mobile .~ on
        )

        return n
      }

    let updateEvent = toggledNotification
      .switchMap {
        AppEnvironment.current.apiService.updateProjectNotification($0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.notifyDelegateOfSaveError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    let previousNotificationOnError = notification
      .switchMap {
        .merge(
          SignalProducer(value: $0),
          SignalProducer(toggledNotification.skipRepeats())
        )
      }
      .combinePrevious()
      .takeWhen(self.notifyDelegateOfSaveError)
      .map { previous, _ in previous }

    Signal.merge(updateEvent.values(), previousNotificationOnError)
      .observeValues(cache(notification:))

    self.notificationOn = Signal.merge(
      notification,
      toggledNotification,
      previousNotificationOnError
    )
    .map { $0.email && $0.mobile }
    .skipRepeats()
  }

  fileprivate let notificationProperty = MutableProperty<ProjectNotification?>(nil)
  /// Configures the cell with a project notification model.
  public func configureWith(notification: ProjectNotification) {
    self.notificationProperty.value = notification
  }

  fileprivate let notificationTappedProperty = MutableProperty(false)
  /// Called when the notification switch is toggled.
  public func notificationTapped(on: Bool) {
    self.notificationTappedProperty.value = on
  }

  /// Emits the project name.
  public let name: Signal<String, Never>
  /// Emits whether notifications are enabled for the project.
  public let notificationOn: Signal<Bool, Never>
  /// Emits an error message when saving the notification preference fails.
  public let notifyDelegateOfSaveError: Signal<String, Never>

  /// View model inputs.
  public var inputs: ProjectNotificationCellViewModelInputs { return self }
  /// View model outputs.
  public var outputs: ProjectNotificationCellViewModelOutputs { return self }
}

private func cacheKey(forNotification notification: ProjectNotification) -> String {
  return "project_notification_view_model_notification_\(notification.id)"
}

private func cache(notification: ProjectNotification) {
  let key = cacheKey(forNotification: notification)
  AppEnvironment.current.cache[key] = notification.email && notification.mobile
}

private func cached(notification: ProjectNotification) -> ProjectNotification {
  let key = cacheKey(forNotification: notification)
  let on = AppEnvironment.current.cache[key] as? Bool
  return notification
    |> ProjectNotification.lens.email .~ (on ?? notification.email)
    |> ProjectNotification.lens.mobile .~ (on ?? notification.mobile)
}
