import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `SettingsNotificationCellViewModel`.
public protocol SettingsNotificationCellViewModelInputs {
  /// Updates the user's push notification setting when toggled.
  func didTapPushNotificationsButton(selected: Bool)
  /// Updates the user's email notification setting when toggled.
  func didTapEmailNotificationsButton(selected: Bool)
  /// Configures the cell with the notification row type and user settings.
  func configure(with cellValue: SettingsNotificationCellValue)
}

/// Outputs exposed by `SettingsNotificationCellViewModel`.
public protocol SettingsNotificationCellViewModelOutputs {
  /// Emits whether toggle animations are enabled for this row.
  var enableButtonAnimation: Signal<Bool, Never> { get }
  /// Emits the accessibility label for the email notifications toggle button.
  var emailNotificationsButtonAccessibilityLabel: Signal<String, Never> { get }
  /// Emits whether email notifications are currently enabled.
  var emailNotificationsEnabled: Signal<Bool, Never> { get }
  /// Emits whether the email notification toggle button should be hidden.
  var emailNotificationButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits the formatted count of backed projects displayed in the cell.
  var projectCountText: Signal<String, Never> { get }
  /// Emits the accessibility label for the push notifications toggle button.
  var pushNotificationsButtonAccessibilityLabel: Signal<String, Never> { get }
  /// Emits whether the push notification toggle button should be hidden.
  var pushNotificationButtonIsHidden: Signal<Bool, Never> { get }
  /// Emits whether push notifications are currently enabled.
  var pushNotificationsEnabled: Signal<Bool, Never> { get }
  /// Emits an error message if persisting the notification preference fails.
  var unableToSaveError: Signal<String, Never> { get }
  /// Emits the updated `User` model after saving notification preferences.
  var updateCurrentUser: Signal<User, Never> { get }
}

/// Combined inputs and outputs interface for `SettingsNotificationCellViewModel`.
public protocol SettingsNotificationCellViewModelType {
  /// The view model's inputs.
  var inputs: SettingsNotificationCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: SettingsNotificationCellViewModelOutputs { get }
}

/// View model managing push and email toggles inside a settings notification row.
public final class SettingsNotificationCellViewModel: SettingsNotificationCellViewModelInputs,
  SettingsNotificationCellViewModelOutputs,
  SettingsNotificationCellViewModelType {
  /// Creates a new `SettingsNotificationCellViewModel` and binds toggle update requests.
  public init() {
    let initialUser = self.initialUserProperty.signal.skipNil()

    let cellType = self.cellTypeProperty.signal.skipNil().skipRepeats()

    let initialPushNotificationValue = Signal.zip(initialUser, cellType)
      .map { user, cellType -> Bool? in
        guard let notification = SettingsNotificationCellViewModel
          .notificationFor(
            cellType: cellType,
            notificationType: .push
          ) else {
          return nil
        }

        return user |> UserAttribute.notification(notification).keyPath.view
      }.skipNil()

    let pushNotificationValueToggled = self.pushNotificationValueChangedProperty.signal.negate()

    let initialEmailNotificationsValue = Signal.zip(initialUser, cellType)
      .map { user, cellType -> Bool? in
        guard let notification = SettingsNotificationCellViewModel
          .notificationFor(
            cellType: cellType,
            notificationType: .email
          ) else {
          return nil
        }

        return user |> UserAttribute.notification(notification).keyPath.view
      }.skipNil()

    let emailNotificationValueToggled = self.emailNotificationValueChangedProperty.signal.negate()

    let updatedNotificationSetting = Signal.merge(
      pushNotificationValueToggled.signal.skipRepeats().map { (NotificationType.push, $0) },
      emailNotificationValueToggled.signal.skipRepeats().map { (NotificationType.email, $0) }
    )

    let userAttributeChanged: Signal<(UserAttribute.Notification?, Bool), Never> = cellType
      .takePairWhen(updatedNotificationSetting)
      .map(unpack)
      .map { cellType, notificationType, enabled -> (UserAttribute.Notification?, Bool) in
        let notification = SettingsNotificationCellViewModel.notificationFor(
          cellType: cellType,
          notificationType: notificationType
        )
        return (notification, enabled)
      }

    let updatedUser = initialUser
      .takePairWhen(userAttributeChanged)
      .map { user, notificationAndOn -> User? in
        let (notification, on) = notificationAndOn

        guard let notificationType = notification else {
          return nil
        }

        return user |> UserAttribute.notification(notificationType).keyPath .~ on
      }.skipNil()

    let updateEvent = updatedUser
      .switchMap {
        AppEnvironment.current.apiService.updateUserSelf($0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.unableToSaveError = updateEvent.errors()
      .map { env in
        env.errorMessages.first ?? Strings.profile_settings_error()
      }

    self.updateCurrentUser = updateEvent.values()

    let previousPushNotificationValue = initialPushNotificationValue.signal
      .takeWhen(self.unableToSaveError)

    let previousEmailNotificationValue = initialEmailNotificationsValue.signal
      .takeWhen(self.unableToSaveError)

    self.pushNotificationsEnabled = Signal.merge(
      initialPushNotificationValue.signal,
      pushNotificationValueToggled,
      previousPushNotificationValue
    )

    self.emailNotificationsEnabled = Signal.merge(
      initialEmailNotificationsValue,
      emailNotificationValueToggled,
      previousEmailNotificationValue
    )

    self.pushNotificationsButtonAccessibilityLabel =
      Signal.combineLatest(self.pushNotificationsEnabled, cellType)
        .map { pushNotificationEnabled, cellType in
          pushNotificationEnabled ? Strings.Notification_push_notification_on(notification: cellType.title)
            : Strings.Notification_push_notification_off(notification: cellType.title)
        }

    self.emailNotificationsButtonAccessibilityLabel =
      Signal.combineLatest(self.emailNotificationsEnabled, cellType)
        .map { emailNotificationEnabled, cellType in
          emailNotificationEnabled ? Strings.Notification_email_notification_on(notification: cellType.title)
            : Strings.Notification_email_notification_off(notification: cellType.title)
        }

    self.emailNotificationButtonIsHidden = cellType
      .map { $0.shouldShowEmailNotificationButton }
      .negate()

    self.pushNotificationButtonIsHidden = cellType
      .map { $0.shouldShowPushNotificationButton }
      .negate()

    self.enableButtonAnimation = Signal.combineLatest(
      self.emailNotificationButtonIsHidden,
      self.pushNotificationButtonIsHidden
    ).map { !$0.0 || !$0.1 }

    self.projectCountText = initialUser
      .map { Format.wholeNumber($0.stats.backedProjectsCount ?? 0) }
  }

  fileprivate let pushNotificationValueChangedProperty = MutableProperty(false)
  /// Handles tapping the push notifications toggle button.
  public func didTapPushNotificationsButton(selected: Bool) {
    self.pushNotificationValueChangedProperty.value = selected
  }

  fileprivate let emailNotificationValueChangedProperty = MutableProperty(false)
  /// Handles tapping the email notifications toggle button.
  public func didTapEmailNotificationsButton(selected: Bool) {
    self.emailNotificationValueChangedProperty.value = selected
  }

  fileprivate let initialUserProperty = MutableProperty<User?>(nil)
  fileprivate let cellTypeProperty = MutableProperty<SettingsNotificationCellType?>(nil)
  /// Configures the view model with a `SettingsNotificationCellValue`.
  public func configure(with cellValue: SettingsNotificationCellValue) {
    self.cellTypeProperty.value = cellValue.cellType
    self.initialUserProperty.value = cellValue.user
  }

  /// Emits whether button selection transitions should animate.
  public let enableButtonAnimation: Signal<Bool, Never>
  /// Emits the email button accessibility label.
  public let emailNotificationsButtonAccessibilityLabel: Signal<String, Never>
  /// Emits whether email notifications are enabled.
  public let emailNotificationsEnabled: Signal<Bool, Never>
  /// Emits whether the email toggle button is hidden.
  public let emailNotificationButtonIsHidden: Signal<Bool, Never>
  /// Emits the push button accessibility label.
  public var pushNotificationsButtonAccessibilityLabel: Signal<String, Never>
  /// Emits whether the push toggle button is hidden.
  public let pushNotificationButtonIsHidden: Signal<Bool, Never>
  /// Emits whether push notifications are enabled.
  public let pushNotificationsEnabled: Signal<Bool, Never>
  /// Emits the backed projects count text.
  public let projectCountText: Signal<String, Never>
  /// Emits an error message when saving notification preferences fails.
  public let unableToSaveError: Signal<String, Never>
  /// Emits the updated `User` returned after saving preferences.
  public let updateCurrentUser: Signal<User, Never>

  /// The inputs interface for this view model.
  public var inputs: SettingsNotificationCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: SettingsNotificationCellViewModelOutputs { return self }
}

/// Notification delivery channels supported in settings rows.
public enum NotificationType {
  /// Email notifications channel.
  case email
  /// Mobile push notifications channel.
  case push
}

extension SettingsNotificationCellViewModel {
  /// Maps a notification settings row and delivery channel to its corresponding `UserAttribute.Notification` key.
  public static func notificationFor(
    cellType: SettingsNotificationCellType,
    notificationType: NotificationType
  ) -> UserAttribute.Notification? {
    switch cellType {
    case .projectUpdates:
      return notificationType == .email
        ? UserAttribute.Notification.updates : UserAttribute.Notification.mobileUpdates
    case .pledgeActivity:
      return notificationType == .email
        ? UserAttribute.Notification.pledgeActivity : UserAttribute.Notification.mobilePledgeActivity
    case .newComments:
      return notificationType == .email
        ? UserAttribute.Notification.comments : UserAttribute.Notification.mobileComments
    case .newLikes:
      return notificationType == .email
        ? UserAttribute.Notification.postLikes : UserAttribute.Notification.mobilePostLikes
    case .creatorTips:
      return notificationType == .email
        ? UserAttribute.Notification.creatorTips : nil
    case .marketingUpdate:
      return notificationType == .email
        ? nil : UserAttribute.Notification.mobileMarketingUpdate
    case .messages:
      return notificationType == .email
        ? UserAttribute.Notification.messages : UserAttribute.Notification.mobileMessages
    case .newFollowers:
      return notificationType == .email
        ? UserAttribute.Notification.follower : UserAttribute.Notification.mobileFollower
    case .friendBacksProject:
      return notificationType == .email
        ? UserAttribute.Notification.friendActivity : UserAttribute.Notification.mobileFriendActivity
    case .commentReplyDigest:
      return notificationType == .email
        ? UserAttribute.Notification.commentReplies : nil
    default:
      return nil
    }
  }
}
