import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `SettingsNotificationsViewModel`.
public protocol SettingsNotificationsViewModelInputs {
  /// Handles selection of a notification settings row.
  func didSelectRow(cellType: SettingsNotificationCellType)
  /// Updates the creator digest email frequency preference.
  func didSelectEmailFrequency(frequency: EmailFrequency)
  /// Dismisses the email frequency picker.
  func dismissPickerTap()
  /// Surfaces a child cell's save error to the settings screen.
  func failedToUpdateUser(error: String)
  /// Propagates an updated `User` emitted by a child notification row.
  func updateUser(user: User)
  /// Signals that the notifications settings screen has loaded.
  func viewDidLoad()
}

/// Outputs exposed by `SettingsNotificationsViewModel`.
public protocol SettingsNotificationsViewModelOutputs {
  /// Emits when navigating to the per-project notification settings list.
  var goToManageProjectNotifications: Signal<Void, Never> { get }
  /// Emits whether the email frequency picker should be hidden.
  var pickerViewIsHidden: Signal<Bool, Never> { get }
  /// Emits the currently saved `EmailFrequency` for preselecting the picker row.
  var pickerViewSelectedRow: Signal<EmailFrequency, Never> { get }
  /// Emits the latest `User` model for environment updates and row reloads.
  var updateCurrentUser: Signal<User, Never> { get }
  /// Emits an error message when saving notification preferences fails.
  var unableToSaveError: Signal<String, Never> { get }
}

/// Combined interface for `SettingsNotificationsViewModel`.
public protocol SettingsNotificationsViewModelType {
  /// The view model's inputs.
  var inputs: SettingsNotificationsViewModelInputs { get }
  /// The view model's outputs.
  var outputs: SettingsNotificationsViewModelOutputs { get }

  /// Returns `true` if tapping `cellType` should trigger row selection handling.
  func shouldSelectRow(for cellType: SettingsNotificationCellType) -> Bool
}

/// View model managing the top-level Settings > Notifications screen and digest frequency picker.
public final class SettingsNotificationsViewModel: SettingsNotificationsViewModelType,
  SettingsNotificationsViewModelInputs, SettingsNotificationsViewModelOutputs {
  /// Creates a new `SettingsNotificationsViewModel` and binds user fetch and update streams.
  public init() {
    let initialUser = self.viewDidLoadProperty.signal
      .flatMap {
        AppEnvironment.current.apiService.fetchUserSelf()
          .wrapInOptional()
          .prefix(value: AppEnvironment.current.currentUser)
          .demoteErrors()
      }.skipNil()

    let userAttributeChanged = self.emailFrequencyProperty.signal
      .map { frequency -> (UserAttribute, Bool) in
        let digestValue = frequency == .dailySummary ? true : false

        return (UserAttribute.notification(.creatorDigest), digestValue)
      }

    let updatedUser = initialUser.signal
      .switchMap { user in
        userAttributeChanged.scan(user) { user, attributeAndOn in
          let (attribute, on) = attributeAndOn
          return user |> attribute.keyPath .~ on
        }
      }

    let updateEvent = updatedUser
      .switchMap {
        AppEnvironment.current.apiService.updateUserSelf($0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let updateEmailFrequencyError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    let emailFrequencyUpdated = updateEvent.values()

    self.unableToSaveError = Signal.merge(
      self.updateUserErrorProperty.signal.skipNil(),
      updateEmailFrequencyError.signal
    )

    self.updateCurrentUser = Signal.merge(
      initialUser,
      self.updatedUserProperty.signal.skipNil(),
      emailFrequencyUpdated
    )

    let emailFrequencyCellSelected = self.selectedCellType.signal
      .skipNil()
      .filter { $0 == .emailFrequency }

    let projectActivityEmailFrequencyDisabled = self.updateCurrentUser.signal
      .map(isNil)

    self.pickerViewIsHidden = Signal.merge(
      emailFrequencyCellSelected.signal.mapConst(false),
      self.emailFrequencyProperty.signal.mapConst(true),
      self.dismissPickerTapProperty.signal.mapConst(true),
      projectActivityEmailFrequencyDisabled.signal.mapConst(true)
    ).skipRepeats()

    self.pickerViewSelectedRow = self.updateCurrentUser.signal
      .map { $0 |> UserAttribute.notification(.creatorDigest).keyPath.view }
      .skipNil()
      .map { creatorDigest -> EmailFrequency in
        creatorDigest ? EmailFrequency.dailySummary : EmailFrequency.twiceADaySummary
      }

    let manageProjectNotificationsSelected = self.selectedCellType.signal
      .skipNil()
      .filter { $0 == .projectNotifications }

    self.goToManageProjectNotifications = manageProjectNotificationsSelected.signal
      .ignoreValues()

    // MARK: - Tracking

    self.updatedUserProperty.signal.observeValues { user in
      AppEnvironment.current.identify(user: user)
    }
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the notification settings screen has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let dismissPickerTapProperty = MutableProperty(())
  /// Closes the email digest frequency picker.
  public func dismissPickerTap() {
    self.dismissPickerTapProperty.value = ()
  }

  /// Returns whether the row corresponding to `cellType` supports tap selection.
  public func shouldSelectRow(for cellType: SettingsNotificationCellType) -> Bool {
    switch cellType {
    case .projectNotifications, .emailFrequency: return true
    default: return false
    }
  }

  fileprivate let emailFrequencyProperty = MutableProperty<EmailFrequency?>(nil)
  /// Persists the selected creator digest email frequency.
  public func didSelectEmailFrequency(frequency: EmailFrequency) {
    self.emailFrequencyProperty.value = frequency
  }

  fileprivate let selectedCellType = MutableProperty<SettingsNotificationCellType?>(nil)
  /// Handles user tap on the specified notification settings row.
  public func didSelectRow(cellType: SettingsNotificationCellType) {
    self.selectedCellType.value = cellType
  }

  fileprivate let updatedUserProperty = MutableProperty<User?>(nil)
  /// Propagates an updated `User` saved from a child cell.
  public func updateUser(user: User) {
    self.updatedUserProperty.value = user
  }

  fileprivate let updateUserErrorProperty = MutableProperty<String?>(nil)
  /// Forwards an error message reported by a child notification cell.
  public func failedToUpdateUser(error: String) {
    self.updateUserErrorProperty.value = error
  }

  /// Emits when navigating to per-project notification toggles.
  public let goToManageProjectNotifications: Signal<Void, Never>
  /// Emits whether the email frequency picker is hidden.
  public let pickerViewIsHidden: Signal<Bool, Never>
  /// Emits the active `EmailFrequency` to highlight in the picker.
  public let pickerViewSelectedRow: Signal<EmailFrequency, Never>
  /// Emits a localized error message if updating notification settings fails.
  public let unableToSaveError: Signal<String, Never>
  /// Emits the latest `User` model.
  public let updateCurrentUser: Signal<User, Never>

  /// The inputs interface for this view model.
  public var inputs: SettingsNotificationsViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: SettingsNotificationsViewModelOutputs { return self }
}
