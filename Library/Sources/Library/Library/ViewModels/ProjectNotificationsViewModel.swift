import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input actions for `ProjectNotificationsViewModel`.
public protocol ProjectNotificationsViewModelInputs {
  /// Call when the view loads.
  func viewDidLoad()
}

/// Output signals for `ProjectNotificationsViewModel`.
public protocol ProjectNotificationsViewModelOutputs {
  /// Emits a list of project notifications that should be displayed.
  var projectNotifications: Signal<[ProjectNotification], Never> { get }
}

/// Combined inputs/outputs contract for `ProjectNotificationsViewModel`.
public protocol ProjectNotificationsViewModelType {
  /// Input receiver.
  var inputs: ProjectNotificationsViewModelInputs { get }
  /// Signal outputs.
  var outputs: ProjectNotificationsViewModelOutputs { get }
}

/// View model fetching creator project notification settings when the screen loads.
public final class ProjectNotificationsViewModel: ProjectNotificationsViewModelType,
  ProjectNotificationsViewModelInputs, ProjectNotificationsViewModelOutputs {
  /// Initializes the notification list stream triggered on `viewDidLoad()`.
  public init() {
    self.projectNotifications = self.viewDidLoadProperty.signal
      .flatMap {
        AppEnvironment.current.apiService.fetchProjectNotifications()
          .demoteErrors()
      }
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the notifications view loaded and should fetch settings.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits loaded `[ProjectNotification]` records on success.
  public let projectNotifications: Signal<[ProjectNotification], Never>

  /// Concrete input interface.
  public var inputs: ProjectNotificationsViewModelInputs { return self }
  /// Concrete output interface.
  public var outputs: ProjectNotificationsViewModelOutputs { return self }
}
