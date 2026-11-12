import Experimentation
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Authorization states for system push notifications.
public enum NotificationAuthorizationStatus {
  /// Notifications are authorized by the user.
  case authorized
  /// Notifications were explicitly denied by the user.
  case denied
  /// Notification permission has not yet been requested.
  case notDetermined
  /// Provisional quiet notification authorization is active.
  case provisional
}

/// Input events handled by `AppDelegateViewModel`.
public protocol AppDelegateViewModelInputs {
  /// Call when the application finishes launching.
  func applicationDidFinishLaunching(
    application: UIApplication?, launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  )
  /// Call when the application will enter foreground.
  func applicationWillEnterForeground()
  /// Call when the application enters background.
  func applicationDidEnterBackground()
  /// Call when the application becomes active `UIApplicationStateActive` and `UIApplicationStateInactive`.
  func applicationActive(state: Bool)
  /// Call when the application receives a memory warning from the system.
  func applicationDidReceiveMemoryWarning()
  /// Call after having invoked AppEnvironment.updateCurrentUser with a fresh user.
  func currentUserUpdatedInEnvironment()
  /// Call when the `ksr_configUpdated` notification is observed.
  func configUpdatedNotificationObserved()
  /// Call when the user taps "OK" from the contextual alert.
  func didAcceptReceivingRemoteNotifications()
  /// Call when the app delegate receives a remote notification.
  func didReceive(remoteNotification notification: [AnyHashable: Any])
  /// Call when the app delegate gets notice of a successful notification registration.
  func didRegisterForRemoteNotifications(withDeviceTokenData data: Data)
  /// Call when the config has been updated in `AppEnvironment`.
  func didUpdateConfig(_ config: Config)
  /// Call when the Remote Config client has been updated in `AppEnvironment`.
  func didUpdateRemoteConfigClient()
  /// Call when the user taps 'Log in or Sign up' from the onboarding flow.
  func goToLoginSignup(from intent: LoginIntent)
  /// Call when Remote Config configuration has failed.
  func remoteConfigClientConfigurationFailed()
  /// Call when the contextual push notification dialog should be presented.
  func showNotificationDialog(notification: Notification)
  /// Call when Braze in-app notifications send a valid URL.
  func urlFromBrazeNotification(_ url: URL?)
  /// Call when the controller has received a user session ended notification.
  func userSessionEnded()
  /// Call when the controller has received a user session started notification.
  func userSessionStarted()
}

/// Output signals emitted by `AppDelegateViewModel`.
public protocol AppDelegateViewModelOutputs {
  /// The value to return from the delegate's `application:didFinishLaunchingWithOptions:` method.
  var applicationDidFinishLaunchingReturnValue: Bool { get }
  /// Emits the application icon badge number.
  var applicationIconBadgeNumber: Signal<Int, Never> { get }
  /// Emits when the application should configure Firebase.
  var configureFirebase: Signal<(), Never> { get }
  /// Emits when the application should configure Segment with an instance of Braze.
  var configureSegmentWithBraze: Signal<String, Never> { get }
  /// Emits when the application should configure Statsig.
  var configureStatsig: Signal<StatsigClientSDKKey, Never> { get }
  /// Emits when opening the app with an invalid access token.
  var forceLogout: Signal<(), Never> { get }
  /// Emits when the root view controller should navigate to activity.
  var goToActivity: Signal<(), Never> { get }
  /// Emits when the root view controller should navigate to the discovery screen.
  var goToDiscovery: Signal<DiscoveryParams?, Never> { get }
  /// Emits when the root view controller should present the login modal.
  var goToLoginWithIntent: Signal<LoginIntent, Never> { get }
  /// Emits a message thread when we should navigate to it.
  var goToMessageThread: Signal<MessageThread, Never> { get }
  /// Emits a URL when we should open it in the Safari browser.
  var goToMobileSafari: Signal<URL, Never> { get }
  /// Emits a notification that should be immediately posted.
  var postNotification: Signal<Notification, Never> { get }
  /// Emits when a view controller should be presented.
  var presentViewController: Signal<UIViewController, Never> { get }
  /// Emits when the push token registration begins.
  var pushTokenRegistrationStarted: Signal<(), Never> { get }
  /// Emits the push token that has been successfully registered on the server.
  var pushTokenSuccessfullyRegistered: Signal<String, Never> { get }
  /// Emits when we should register the device push token in Braze.
  var registerPushTokenInBraze: Signal<Data, Never> { get }
  /// Emits when `applicationDidFinishLaunchingWithOptions` requests tracking authorization.
  var requestATTrackingAuthorizationStatus: Signal<Void, Never> { get }
  /// Emits when our config updates with the enabled state for Segment Analytics.
  var segmentIsEnabled: Signal<Bool, Never> { get }
  /// Emits an array of shortcut items to put into the shared application.
  var setApplicationShortcutItems: Signal<[ShortcutItem], Never> { get }
  /// Emits when an alert should be shown.
  var showAlert: Signal<Notification, Never> { get }
  /// Emits to synchronize iCloud on app launch.
  var synchronizeUbiquitousStore: Signal<(), Never> { get }
  /// Emits immediately and when the user's tracking authorization status changes.
  var trackingAuthorizationStatus: SignalProducer<AppTrackingAuthorization, Never> { get }
  /// Emits when `applicationDidFinishLaunchingWithOptions` should trigger onboarding.
  var triggerOnboardingFlow: Signal<(), Never> { get }
  /// Emits when we should unregister the user from notifications.
  var unregisterForRemoteNotifications: Signal<(), Never> { get }
  /// Emits a fresh user to be updated in the app environment.
  var updateCurrentUserInEnvironment: Signal<User, Never> { get }
  /// Emits a config value that should be updated in the environment.
  var updateConfigInEnvironment: Signal<Config, Never> { get }
}

/// Protocol unifying inputs and outputs for `AppDelegateViewModel`.
public protocol AppDelegateViewModelType {
  /// Input handler for application lifecycle and notification events.
  var inputs: AppDelegateViewModelInputs { get }
  /// Output signal provider for navigation and configuration updates.
  var outputs: AppDelegateViewModelOutputs { get }
}
