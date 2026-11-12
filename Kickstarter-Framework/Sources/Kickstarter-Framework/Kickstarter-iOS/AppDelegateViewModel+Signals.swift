import Experimentation
import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Immutable value type representing `AppDelegateNotificationAndTrackingOutputs`.
internal struct AppDelegateNotificationAndTrackingOutputs {
  let pushTokenRegistrationStarted: Signal<(), Never>
  let showAlert: Signal<Notification, Never>
  let pushTokenSuccessfullyRegistered: Signal<String, Never>
  let triggerOnboardingFlow: Signal<(), Never>
  let applicationIconBadgeNumber: Signal<Int, Never>
  let requestATTrackingAuthorizationStatus: Signal<Void, Never>
  let trackingAuthorizationStatus: SignalProducer<AppTrackingAuthorization, Never>
}

internal func makeAppDelegateNotificationAndTrackingSignals(
  launchOptionsSignal: Signal<(application: UIApplication?, options: [UIApplication.LaunchOptionsKey: Any]?)?, Never>,
  willEnterForegroundSignal: Signal<Void, Never>,
  applicationActiveSignal: Signal<Bool, Never>,
  didAcceptRemoteNotificationsSignal: Signal<Void, Never>,
  showNotificationDialogSignal: Signal<Notification?, Never>,
  deviceTokenDataSignal: Signal<Data, Never>,
  didFinishLaunchingReturnValueSignal: Signal<Bool, Never>
) -> AppDelegateNotificationAndTrackingOutputs {
  let launchSignal = launchOptionsSignal.ignoreValues()

  let pushNotificationsPreviouslyAuthorized = launchOptionsSignal
    .flatMap { _ in AppEnvironment.current.pushRegistrationType.hasAuthorizedNotifications() }

  let pushTokenRegistrationStartedValues = Signal.merge(
    didAcceptRemoteNotificationsSignal,
    pushNotificationsPreviouslyAuthorized.filter { $0 }.ignoreValues()
  )
  .flatMap {
    AppEnvironment.current.pushRegistrationType.register(for: [.alert, .sound, .badge]).materialize()
  }
  .values()

  let showAlert = showNotificationDialogSignal.skipNil()
    .filter {
      if let context = $0.userInfo?.values.first as? PushNotificationDialog.Context {
        return PushNotificationDialog.canShowDialog(for: context)
      }
      return false
    }

  let pushTokenSuccessfullyRegistered = deviceTokenDataSignal
    .map(appDelegateDeviceToken(fromData:))
    .on(value: { print("📲 [Push Registration] Push token generated: (\($0))") })
    .ksr_debounce(.seconds(5), on: AppEnvironment.current.scheduler)
    .switchMap { token in
      AppEnvironment.current.apiService.register(pushToken: token)
        .demoteErrors()
        .map { _ in token }
    }

  let triggerOnboardingFlow = Signal.combineLatest(
    launchSignal,
    pushNotificationsPreviouslyAuthorized.filter { isFalse($0) }
  )
  .filter { _ in
    let shouldRequestAppTracking = AppEnvironment.current.appTrackingTransparency
      .shouldRequestAuthorizationStatus() == true
    let hasNotSeenOnboarding = AppEnvironment.current.userDefaults.hasSeenOnboarding == false
    return shouldRequestAppTracking && hasNotSeenOnboarding
  }
  .mapConst(())

  let applicationIconBadgeNumber = Signal.merge(willEnterForegroundSignal, launchSignal)
    .flatMap { AppEnvironment.current.pushRegistrationType.hasAuthorizedNotifications() }
    .filter(isTrue)
    .mapConst(0)

  let requestATTrackingAuthorizationStatus = Signal
    .combineLatest(didFinishLaunchingReturnValueSignal.ignoreValues(), applicationActiveSignal)
    .map(second)
    .skipRepeats()
    .ksr_delay(.seconds(1), on: AppEnvironment.current.scheduler)
    .filter { applicationIsActive in
      applicationIsActive && AppEnvironment.current.userDefaults.hasSeenOnboarding == true
    }
    .map { _ in AppEnvironment.current.appTrackingTransparency }
    .map { appTrackingTransparency in
      if appTrackingTransparency.advertisingIdentifier == nil &&
        appTrackingTransparency.shouldRequestAuthorizationStatus() {
        appTrackingTransparency.requestAndSetAuthorizationStatus(nil)
      }
      return ()
    }

  let trackingAuthorizationStatus = SignalProducer
    .merge(didFinishLaunchingReturnValueSignal.ignoreValues(), applicationActiveSignal.ignoreValues())
    .flatMap { AppEnvironment.current.appTrackingTransparency.authorizationStatus }

  return AppDelegateNotificationAndTrackingOutputs(
    pushTokenRegistrationStarted: pushTokenRegistrationStartedValues.ignoreValues(),
    showAlert: showAlert,
    pushTokenSuccessfullyRegistered: pushTokenSuccessfullyRegistered,
    triggerOnboardingFlow: triggerOnboardingFlow,
    applicationIconBadgeNumber: applicationIconBadgeNumber,
    requestATTrackingAuthorizationStatus: requestATTrackingAuthorizationStatus,
    trackingAuthorizationStatus: trackingAuthorizationStatus
  )
}

