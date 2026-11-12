import Experimentation
import FirebaseCrashlytics
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit
import UserNotifications

/// Coordinates app lifecycle startup, remote config/user syncing, push notification registration, and deep-link routing.
public final class AppDelegateViewModel: AppDelegateViewModelType, AppDelegateViewModelInputs,
  AppDelegateViewModelOutputs {
  /// Initializes the app delegate view model and binds lifecycle, push, deep link, and config signals.
  public init() {
    let launchOrSessionTrigger = Signal.merge(
      self.applicationWillEnterForegroundProperty.signal,
      self.applicationLaunchOptionsProperty.signal.ignoreValues(),
      self.userSessionEndedProperty.signal,
      self.userSessionStartedProperty.signal
    )

    let currentUserEvent = launchOrSessionTrigger
      .ksr_debounce(.seconds(5), on: AppEnvironment.current.scheduler)
      .switchMap { _ -> SignalProducer<Signal<User?, ErrorEnvelope>.Event, Never> in
        AppEnvironment.current.apiService.isAuthenticated || AppEnvironment.current.currentUser != nil
          ? AppEnvironment.current.apiService.fetchUserSelf().wrapInOptional().materialize()
          : SignalProducer(value: .value(nil))
      }

    let fetchUserSetupEvent = Signal.merge(
      self.applicationWillEnterForegroundProperty.signal,
      self.applicationLaunchOptionsProperty.signal.ignoreValues(),
      self.userSessionStartedProperty.signal
    )
    .switchMap { _ -> SignalProducer<Signal<UserEnvelope<GraphUserSetup>?, ErrorEnvelope>.Event, Never> in
      AppEnvironment.current.apiService.fetchGraphUserSetup().wrapInOptional().materialize()
    }

    self.fetchUserEmail = fetchUserSetupEvent.values()
      .map { user in
        guard let email = user?.me.email, let features = user?.me.enabledFeatures else { return }
        let ppoSettings = PPOUserSettings(
          hasAction: user?.me.ppoHasAction ?? false,
          backingActionCount: user?.me.backingActionCount ?? 0
        )
        AppEnvironment.replaceCurrentEnvironment(
          currentUserEmail: email,
          currentUserPPOSettings: ppoSettings,
          currentUserServerFeatures: features
        )
        NotificationCenter.default.post(.init(name: .ksr_userUpdated))
      }

    self.forceLogout = currentUserEvent.errors().filter { $0.ksrCode == .AccessTokenInvalid }.ignoreValues()
    self.updateConfigInEnvironment = launchOrSessionTrigger
      .switchMap { _ -> SignalProducer<Config, Never> in
        visitorCookies().forEach(AppEnvironment.current.cookieStorage.setCookie)
        return AppEnvironment.current.apiService.fetchConfig().demoteErrors()
      }
      .map(configRetainingDebugFeatureFlags)

    self.postNotification = Signal.merge(
      self.currentUserUpdatedInEnvironmentProperty.signal.mapConst(Notification(name: .ksr_userUpdated, object: nil)),
      self.didUpdateConfigProperty.signal.skipNil().mapConst(Notification(name: .ksr_configUpdated, object: nil)),
      self.didUpdateRemoteConfigClientProperty.signal.mapConst(Notification(name: .ksr_remoteConfigClientConfigured, object: nil)),
      self.remoteConfigClientConfigurationFailedProperty.signal.mapConst(Notification(name: .ksr_remoteConfigClientConfigurationFailed, object: nil)),
      self.applicationDidEnterBackgroundProperty.signal.mapConst(Notification(name: .ksr_applicationDidEnterBackground, object: nil))
    )

    self.synchronizeUbiquitousStore = self.applicationLaunchOptionsProperty.signal.ignoreValues()
    self.unregisterForRemoteNotifications = self.userSessionEndedProperty.signal
    self.registerPushTokenInBraze = self.deviceTokenDataProperty.signal

    let pushAndTracking = makeAppDelegateNotificationAndTrackingSignals(
      launchOptionsSignal: self.applicationLaunchOptionsProperty.signal,
      willEnterForegroundSignal: self.applicationWillEnterForegroundProperty.signal,
      applicationActiveSignal: self.applicationActiveProperty.signal,
      didAcceptRemoteNotificationsSignal: self.didAcceptReceivingRemoteNotificationsProperty.signal,
      showNotificationDialogSignal: self.showNotificationDialogProperty.signal,
      deviceTokenDataSignal: self.deviceTokenDataProperty.signal,
      didFinishLaunchingReturnValueSignal: self.applicationDidFinishLaunchingReturnValueProperty.signal
    )
    self.pushTokenRegistrationStarted = pushAndTracking.pushTokenRegistrationStarted
    self.showAlert = pushAndTracking.showAlert
    self.pushTokenSuccessfullyRegistered = pushAndTracking.pushTokenSuccessfullyRegistered
    self.triggerOnboardingFlow = pushAndTracking.triggerOnboardingFlow
    self.applicationIconBadgeNumber = pushAndTracking.applicationIconBadgeNumber
    self.requestATTrackingAuthorizationStatus = pushAndTracking.requestATTrackingAuthorizationStatus
    self.trackingAuthorizationStatus = pushAndTracking.trackingAuthorizationStatus

    let deepLinkFromNotification = self.remoteNotificationProperty.signal.skipNil()
      .map(PushEnvelope.decodeJSONDictionary).skipNil().map(navigation(fromPushEnvelope:))
    let urlFromBraze = self.brazeNotificationURLProperty.signal.skipNil()
    let deepLink = Signal.merge(deepLinkFromNotification, urlFromBraze.map(Navigation.deepLinkMatch)).skipNil()
    let deepLinkOutputs = DeepLinkNavigationRouter(deepLink: deepLink)

    self.updateCurrentUserInEnvironment = Signal.merge(
      currentUserEvent.values().skipNil(),
      deepLinkOutputs.updateCurrentUserInEnvironment
    )
    self.goToMobileSafari = urlFromBraze.filter(shouldOpenUrlInBrowser)
    self.goToDiscovery = deepLinkOutputs.goToDiscovery
    self.goToActivity = deepLinkOutputs.goToActivity
    self.goToLoginWithIntent = Signal.merge(
      deepLinkOutputs.goToLoginWithIntent,
      self.goToLoginSignupProperty.signal.skipNil()
    )
    self.goToMessageThread = deepLinkOutputs.goToMessageThread
    self.presentViewController = deepLinkOutputs.presentViewController
    self.configureFirebase = self.applicationLaunchOptionsProperty.signal.ignoreValues()
    self.configureStatsig = self.applicationLaunchOptionsProperty.signal.ignoreValues().map { _ in statsigSDKKey() }
    self.setApplicationShortcutItems = currentUserEvent.values().switchMap(shortcutItems(forUser:))
    self.applicationDidFinishLaunchingReturnValueProperty <~ self.applicationLaunchOptionsProperty.signal
      .skipNil().mapConst(true)
    self.configureSegmentWithBraze = self.applicationLaunchOptionsProperty.signal.skipNil().map { _ in
      AppEnvironment.current.mainBundle.isRelease ? Secrets.Segment.production : Secrets.Segment.staging
    }
    self.segmentIsEnabled = Signal.merge(
      self.didUpdateConfigProperty.signal.skipNil().ignoreValues(),
      self.configUpdatedNotificationObservedProperty.signal
    ).map { _ in featureSegmentIsEnabled() }.skipRepeats()
  }

  /// Input interface.
  public var inputs: AppDelegateViewModelInputs { return self }
  /// Output interface.
  public var outputs: AppDelegateViewModelOutputs { return self }

  fileprivate typealias ApplicationWithOptions = (application: UIApplication?, options: [UIApplication.LaunchOptionsKey: Any]?)
  fileprivate let applicationLaunchOptionsProperty = MutableProperty<ApplicationWithOptions?>(nil)
  /// Handles app launch completion.
  public func applicationDidFinishLaunching(application: UIApplication?, launchOptions: [UIApplication.LaunchOptionsKey: Any]?) {
    self.applicationLaunchOptionsProperty.value = (application, launchOptions)
  }
  fileprivate let applicationWillEnterForegroundProperty = MutableProperty(())
  /// Handles entering foreground.
  public func applicationWillEnterForeground() { self.applicationWillEnterForegroundProperty.value = () }
  fileprivate let applicationActiveProperty = MutableProperty<Bool>(false)
  /// Updates application active state.
  public func applicationActive(state: Bool) { self.applicationActiveProperty.value = state }
  fileprivate let applicationDidEnterBackgroundProperty = MutableProperty(())
  /// Handles entering background.
  public func applicationDidEnterBackground() { self.applicationDidEnterBackgroundProperty.value = () }
  fileprivate let applicationDidReceiveMemoryWarningProperty = MutableProperty(())
  /// Handles memory warning events.
  public func applicationDidReceiveMemoryWarning() { self.applicationDidReceiveMemoryWarningProperty.value = () }
  fileprivate let currentUserUpdatedInEnvironmentProperty = MutableProperty(())
  /// Emits user-updated notification after current user changes.
  public func currentUserUpdatedInEnvironment() { self.currentUserUpdatedInEnvironmentProperty.value = () }
  private let configUpdatedNotificationObservedProperty = MutableProperty(())
  /// Records that config-updated notification was observed.
  public func configUpdatedNotificationObserved() { self.configUpdatedNotificationObservedProperty.value = () }
  fileprivate let remoteNotificationProperty = MutableProperty<[AnyHashable: Any]?>(nil)
  /// Handles an incoming remote notification payload.
  public func didReceive(remoteNotification notification: [AnyHashable: Any]) { self.remoteNotificationProperty.value = notification }
  fileprivate let deviceTokenDataProperty = MutableProperty(Data())
  /// Registers the APNs device token payload.
  public func didRegisterForRemoteNotifications(withDeviceTokenData data: Data) { self.deviceTokenDataProperty.value = data }
  fileprivate let didAcceptReceivingRemoteNotificationsProperty = MutableProperty(())
  /// Begins push registration after user acceptance.
  public func didAcceptReceivingRemoteNotifications() { self.didAcceptReceivingRemoteNotificationsProperty.value = () }
  fileprivate let didUpdateConfigProperty = MutableProperty<Config?>(nil)
  /// Posts config update notification.
  public func didUpdateConfig(_ config: Config) { self.didUpdateConfigProperty.value = config }
  fileprivate let didUpdateRemoteConfigClientProperty = MutableProperty(())
  /// Posts notification that Remote Config client updated.
  public func didUpdateRemoteConfigClient() { self.didUpdateRemoteConfigClientProperty.value = () }
  private let goToLoginSignupProperty = MutableProperty<LoginIntent?>(nil)
  /// Requests presenting login/signup from onboarding.
  public func goToLoginSignup(from intent: LoginIntent) { self.goToLoginSignupProperty.value = intent }
  fileprivate let showNotificationDialogProperty = MutableProperty<Notification?>(nil)
  /// Evaluates showing a contextual push dialog.
  public func showNotificationDialog(notification: Notification) { self.showNotificationDialogProperty.value = notification }
  fileprivate let userSessionEndedProperty = MutableProperty(())
  /// Handles user sign-out session event.
  public func userSessionEnded() { self.userSessionEndedProperty.value = () }
  fileprivate let userSessionStartedProperty = MutableProperty(())
  /// Handles user sign-in session event.
  public func userSessionStarted() { self.userSessionStartedProperty.value = () }
  fileprivate let brazeNotificationURLProperty = MutableProperty<URL?>(nil)
  /// Routes a URL received from a Braze in-app notification.
  public func urlFromBrazeNotification(_ url: URL?) { self.brazeNotificationURLProperty.value = url }
  fileprivate let applicationDidFinishLaunchingReturnValueProperty = MutableProperty(true)
  /// Return value for `application(_:didFinishLaunchingWithOptions:)`.
  public var applicationDidFinishLaunchingReturnValue: Bool { self.applicationDidFinishLaunchingReturnValueProperty.value }
  fileprivate let remoteConfigClientConfigurationFailedProperty = MutableProperty(())
  /// Posts notification that Remote Config setup failed.
  public func remoteConfigClientConfigurationFailed() { self.remoteConfigClientConfigurationFailedProperty.value = () }

  /// Badge count to set on launch or foreground.
  public let applicationIconBadgeNumber: Signal<Int, Never>
  /// Triggers Firebase configuration on launch.
  public let configureFirebase: Signal<(), Never>
  /// Triggers Segment Braze configuration with write key.
  public let configureSegmentWithBraze: Signal<String, Never>
  /// Triggers Statsig configuration with tier key.
  public let configureStatsig: Signal<StatsigClientSDKKey, Never>
  /// Triggers forced logout when token is invalid.
  public let forceLogout: Signal<(), Never>
  private let fetchUserEmail: Signal<(), Never>
  /// Navigates to activity tab from deep link or push.
  public let goToActivity: Signal<(), Never>
  /// Navigates to discovery from deep link or push.
  public let goToDiscovery: Signal<DiscoveryParams?, Never>
  /// Presents login modal for the given intent.
  public let goToLoginWithIntent: Signal<LoginIntent, Never>
  /// Navigates to a message thread.
  public let goToMessageThread: Signal<MessageThread, Never>
  /// Opens a Braze notification URL in external Safari.
  public let goToMobileSafari: Signal<URL, Never>
  /// Posts an environment notification on NotificationCenter.
  public let postNotification: Signal<Notification, Never>
  /// Presents a routed view controller.
  public let presentViewController: Signal<UIViewController, Never>
  /// Emits when APNs push registration begins.
  public let pushTokenRegistrationStarted: Signal<(), Never>
  /// Emits registered APNs push token string.
  public let pushTokenSuccessfullyRegistered: Signal<String, Never>
  /// Forwards device push token data to Braze.
  public let registerPushTokenInBraze: Signal<Data, Never>
  /// Triggers AppTrackingTransparency authorization outside onboarding.
  public let requestATTrackingAuthorizationStatus: Signal<Void, Never>
  /// Emits whether Segment analytics is enabled.
  public let segmentIsEnabled: Signal<Bool, Never>
  /// Sets home screen application shortcut items.
  public let setApplicationShortcutItems: Signal<[ShortcutItem], Never>
  /// Emits contextual notification alert to present.
  public let showAlert: Signal<Notification, Never>
  /// Triggers iCloud ubiquitous store synchronization.
  public let synchronizeUbiquitousStore: Signal<(), Never>
  /// Emits current and updated AppTrackingTransparency status.
  public let trackingAuthorizationStatus: SignalProducer<AppTrackingAuthorization, Never>
  /// Triggers the onboarding flow on launch when eligible.
  public let triggerOnboardingFlow: Signal<(), Never>
  /// Unregisters the device from remote notifications on sign-out.
  public let unregisterForRemoteNotifications: Signal<(), Never>
  /// Updates the current user in `AppEnvironment`.
  public let updateCurrentUserInEnvironment: Signal<User, Never>
  /// Updates the app configuration in `AppEnvironment`.
  public let updateConfigInEnvironment: Signal<Config, Never>
}
