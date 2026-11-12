import Foundation

/// Notification name string constants for user session, environment, and project state changes.
public enum CurrentUserNotifications {
  /// Posted when remote server configuration refreshes.
  public static let configUpdated = "CurrentUserNotifications.configUpdated"
  /// Posted when user data reload is requested.
  public static let dataRequested = "CurrentUserNotifications.dataRequested"
  /// Posted when `AppEnvironment` swaps active configuration.
  public static let environmentChanged = "CurrentUserNotification.environmentChanged"
  /// Posted when the user changes locale preferences.
  public static let localePreferencesChanged = "CurrentUserNotification.localePreferencesChanged"
  /// Posted after user onboarding finishes.
  public static let onboardingCompleted = "CurrentUserNotifications.onboardingCompleted"
  /// Posted when Firebase Remote Config completes setup.
  public static let remoteConfigClientConfigured = "CurrentUserNotification.remoteConfigClientConfigured"
  /// Posted when Firebase Remote Config initialization fails.
  public static let remoteConfigClientConfigurationFailed =
    "CurrentUserNotification.remoteConfigClientConfigurationFailed"
  /// Posted after backing a project completes.
  public static let projectBacked = "CurrentUserNotifications.projectBacked"
  /// Posted when a project's watch/save status changes.
  public static let projectSaved = "CurrentUserNotifications.projectSaved"
  /// Posted when personalized recommendations opt-out setting changes.
  public static let recommendationsSettingChanged = "CurrentUserNotifications.recommendationsSettingChanged"
  /// Posted when the saved projects empty-state CTA is tapped.
  public static let savedProjectEmptyStateTapped = "CurrentUserNotifications.savedProjectEmptyStateTapped"
  /// Posted when an authenticated user session ends.
  public static let sessionEnded = "CurrentUserNotifications.sessionEnded"
  /// Posted when an authenticated user session starts.
  public static let sessionStarted = "CurrentUserNotifications.sessionStarted"
  /// Posted to request presenting the contextual push-notification opt-in dialog.
  public static let showNotificationsDialog = "CurrentUserNotifications.showNotificationsDialog"
  /// Posted when the current user model updates.
  public static let userUpdated = "CurrentUserNotifications.userUpdated"
  /// Posted after blocking another user.
  public static let blockedUser = "CurrentUserNotifications.blockedUser"
  /// Posted to navigate from onboarding into the login flow.
  public static let ksr_goToLoginFromOnboarding = "CurrentUserNotifications.ksr_goToLoginFromOnboarding"
}

/// Notification name string constants for application lifecycle transitions.
public enum AppStateNotifications {
  /// Posted when the app enters the background.
  public static let didEnterBackground = "AppStateNotifications.didEnterBackground"
}

/// Standard `Notification.userInfo` dictionary keys shared across modules.
public enum UserInfoKeys {
  /// Context key for notification opt-in prompts.
  public static let context = "UserInfoKeys.context"
  /// Host view controller key for in-app banner or sheet presentation.
  public static let viewController = "UserInfoKeys.viewController"
}

extension Notification.Name {
  /// Typed `Notification.Name` for `AppStateNotifications.didEnterBackground`.
  public static let ksr_applicationDidEnterBackground = Notification
    .Name(rawValue: AppStateNotifications.didEnterBackground)
  /// Typed `Notification.Name` for `CurrentUserNotifications.configUpdated`.
  public static let ksr_configUpdated = Notification.Name(rawValue: CurrentUserNotifications.configUpdated)
  /// Typed `Notification.Name` for `CurrentUserNotifications.dataRequested`.
  public static let ksr_dataRequested = Notification.Name(rawValue: CurrentUserNotifications.dataRequested)
  /// Typed `Notification.Name` for `CurrentUserNotifications.environmentChanged`.
  public static let ksr_environmentChanged = Notification.Name(
    rawValue: CurrentUserNotifications.environmentChanged
  )
  /// Typed `Notification.Name` for `CurrentUserNotifications.onboardingCompleted`.
  public static let ksr_onboardingCompleted = Notification.Name(
    rawValue: CurrentUserNotifications.onboardingCompleted
  )
  /// Typed `Notification.Name` for `CurrentUserNotifications.remoteConfigClientConfigured`.
  public static let ksr_remoteConfigClientConfigured = Notification.Name(
    rawValue: CurrentUserNotifications.remoteConfigClientConfigured
  )
  /// Typed `Notification.Name` for `CurrentUserNotifications.remoteConfigClientConfigurationFailed`.
  public static let ksr_remoteConfigClientConfigurationFailed = Notification.Name(
    rawValue: CurrentUserNotifications.remoteConfigClientConfigurationFailed
  )
  /// Typed `Notification.Name` for `CurrentUserNotifications.projectBacked`.
  public static let ksr_projectBacked = Notification.Name(rawValue: CurrentUserNotifications.projectBacked)
  /// Typed `Notification.Name` for `CurrentUserNotifications.projectSaved`.
  public static let ksr_projectSaved = Notification.Name(rawValue: CurrentUserNotifications.projectSaved)
  /// Typed `Notification.Name` for `CurrentUserNotifications.recommendationsSettingChanged`.
  public static let ksr_recommendationsSettingChanged =
    Notification.Name(rawValue: CurrentUserNotifications.recommendationsSettingChanged)
  /// Typed `Notification.Name` for `CurrentUserNotifications.savedProjectEmptyStateTapped`.
  public static let ksr_savedProjectEmptyStateTapped =
    Notification.Name(rawValue: CurrentUserNotifications.savedProjectEmptyStateTapped)
  /// Typed `Notification.Name` for `CurrentUserNotifications.sessionStarted`.
  public static let ksr_sessionStarted = Notification.Name(rawValue: CurrentUserNotifications.sessionStarted)
  /// Typed `Notification.Name` for `CurrentUserNotifications.sessionEnded`.
  public static let ksr_sessionEnded = Notification.Name(rawValue: CurrentUserNotifications.sessionEnded)
  /// Typed `Notification.Name` for `CurrentUserNotifications.showNotificationsDialog`.
  public static let ksr_showNotificationsDialog =
    Notification.Name(rawValue: CurrentUserNotifications.showNotificationsDialog)
  /// Typed `Notification.Name` for `CurrentUserNotifications.localePreferencesChanged`.
  public static let ksr_userLocalePreferencesChanged = Notification.Name(
    rawValue: CurrentUserNotifications.localePreferencesChanged
  )
  /// Typed `Notification.Name` for `CurrentUserNotifications.userUpdated`.
  public static let ksr_userUpdated = Notification.Name(rawValue: CurrentUserNotifications.userUpdated)
  /// Typed `Notification.Name` for `CurrentUserNotifications.blockedUser`.
  public static let ksr_blockedUser = Notification.Name(rawValue: CurrentUserNotifications.blockedUser)
  /// Typed `Notification.Name` for `CurrentUserNotifications.ksr_goToLoginFromOnboarding`.
  public static let ksr_goToLoginFromOnboarding = Notification
    .Name(rawValue: CurrentUserNotifications.ksr_goToLoginFromOnboarding)
}
