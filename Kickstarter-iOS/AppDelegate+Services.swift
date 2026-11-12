import BrazeKit
import BrazeUI
import Firebase
import Foundation
import KDS
#if DEBUG
  @testable import KsApi
#else
  import KsApi
#endif
import Experimentation
import Kickstarter_Framework
import Library
import Prelude
import ReactiveExtensions
import ReactiveSwift
import SafariServices
import Segment
import SegmentBrazeUI
import SwiftUI
import UIKit
import UserNotifications

extension AppDelegate {
  // MARK: - Functions

  internal func presentContextualPermissionAlert(_ notification: Notification) {
    guard let context = notification.userInfo?.values.first as? PushNotificationDialog.Context else {
      return
    }

    let alert = UIAlertController(title: context.title, message: context.message, preferredStyle: .alert)

    alert.addAction(
      UIAlertAction(title: Strings.project_star_ok(), style: .default) { [weak self] _ in
        self?.viewModel.inputs.didAcceptReceivingRemoteNotifications()
      }
    )

    alert.addAction(
      UIAlertAction(title: PushNotificationDialog.titleForDismissal, style: .cancel, handler: { _ in
        PushNotificationDialog.didDenyAccess(for: context)
      })
    )

    // Sometimes, the "sign up for push" popup doesn't appear when you sign in via web authentication session.
    // My best guess is that this happens because the dismissal of the web login screen accidentally dismisses this popup, too.
    // The delay isn't pretty, but it works.

    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
      if let viewController = notification.userInfo?[UserInfoKeys.viewController] as? UIViewController {
        viewController.present(alert, animated: true, completion: nil)
      } else {
        self.rootTabBarController?.present(alert, animated: true, completion: nil)
      }
    }
  }

  internal func goToMessageThread(_ messageThread: MessageThread) {
    self.rootTabBarController?.switchToMessageThread(messageThread)
  }

  internal func appTrackingAuthorizationChanged(status: AppTrackingAuthorization) {
    self.updateFirebaseConsent(status: status)

    // We only pass the Segment identifier to Statsig if tracking consent is enabled.
    // Update Statsig if tracking authorization changes.
    let statsigUser = AppEnvironment.current.statsigUser()
    AppEnvironment.current.statsigClient?.reload(withUser: statsigUser)
  }

  private func updateFirebaseConsent(status: AppTrackingAuthorization) {
    // https://developers.google.com/tag-platform/security/guides/app-consent?platform=ios&consentmode=advanced
    let consentStatus: ConsentStatus = if case .authorized = status {
      .granted
    } else {
      .denied
    }
    Analytics.setConsent([
      .analyticsStorage: consentStatus,
      .adStorage: consentStatus,
      .adUserData: consentStatus,
      .adPersonalization: consentStatus
    ])
  }

  internal func configureRemoteConfig() {
    let remoteConfigClient = RemoteConfigClient(with: RemoteConfig.remoteConfig())

    AppEnvironment.updateRemoteConfigClient(remoteConfigClient)

    self.fetchAndActivateRemoteConfig()

    _ = AppEnvironment.current.remoteConfigClient?
      .addOnConfigUpdateListener { configUpdate, error in
        guard let realtimeUpdateError = error else {
          print("🔮 Remote Config Keys Update: \(String(describing: configUpdate?.updatedKeys))")

          return
        }

        print(
          "🔴 Remote Config SDK Config Update Listener Failure: \(realtimeUpdateError.localizedDescription)"
        )
      }
  }

  internal func configureStatsig(with key: StatsigClientSDKKey) {
    let client = StatsigWrapper(sdkKey: key, user: AppEnvironment.current.statsigUser())
    AppEnvironment.updateStatsigClient(client)
  }

  private func fetchAndActivateRemoteConfig() {
    AppEnvironment.current.remoteConfigClient?.fetchAndActivate { _, error in
      guard let remoteConfigActivationError = error else {
        print("🔮 Remote Config SDK Successfully Activated")

        self.viewModel.inputs.didUpdateRemoteConfigClient()
        return
      }

      let errorAsNSError = remoteConfigActivationError as NSError

      if errorAsNSError.domain == RemoteConfigErrorDomain,
         errorAsNSError.code == RemoteConfigError.internalError.rawValue {
        // This is (almost certainly) just a connection error; we won't log it.
      } else {
        Crashlytics.crashlytics().record(error: remoteConfigActivationError)
      }

      print(
        "🔴 Remote Config SDK Activation Failed with Error: \(remoteConfigActivationError.localizedDescription)"
      )

      self.viewModel.inputs.remoteConfigClientConfigurationFailed()
    }
  }

  internal func configuredBrazeDestination(for configuration: Segment.Analytics) -> BrazeDestination {
    return BrazeDestination(
      additionalConfiguration: { configuration in
        configuration.triggerMinimumTimeInterval = 5
        configuration.push.automation = self.configuredBrazePushAutomation()
        // TODO(MBL-2742): Change the logger level to `info` or `error` if it gets tedious.
        configuration.logger.level = .debug
      }
    ) { [weak self] braze in
      guard let self else { return }
      braze.delegate = self
      self.braze = braze

      braze.inAppMessagePresenter = BrazeUI.BrazeInAppMessageUI()

      if let userId = AppEnvironment.current.currentUser?.id {
        braze.changeUser(userId: String(userId))
      }

      // This block of code gets called anytime a Braze notification is opened.
      // AWS notifications will not trigger this code.
      self.brazeSubscription = braze.notifications
        .subscribeToUpdates(payloadTypes: [.opened]) { [weak self] payload in
          guard let self else { return }
          // TODO(MBL-2742): Once the migration is stable, revisit if Braze should update the
          // rootTabBar. If not, this block can be deleted.
          if let rootTabBarController = self.rootTabBarController {
            rootTabBarController.didReceiveBadgeValue(payload.badge)
          }
        }
    }
  }

  // This configuration object defines how much automation Braze does. It gets set both when
  // we configure `BrazeDestination` and when we call `Braze.prepareForDelayedInitialization`.
  // https://braze-inc.github.io/braze-swift-sdk/documentation/brazekit/braze/configuration-swift.class/push-swift.class/automation-swift.class/
  internal func configuredBrazePushAutomation() -> BrazeKit.Braze.Configuration.Push.Automation {
    let automation: BrazeKit.Braze.Configuration.Push.Automation = true
    automation.automaticSetup = false
    automation.requestAuthorizationAtLaunch = false
    automation.registerDeviceToken = false
    return automation
  }
}

// MARK: - UNUserNotificationCenterDelegate

extension AppDelegate: UNUserNotificationCenterDelegate {
  /// Displays foreground notification banners and updates the root tab bar badge count.
  public func userNotificationCenter(
    _: UNUserNotificationCenter,
    willPresent notification: UNNotification,
    withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void
  ) {
    // Handle AWS foreground notification.
    // Braze notifications will not trigger this delegate method.
    self.rootTabBarController?.didReceiveBadgeValue(notification.request.content.badge as? Int)
    completionHandler([.banner, .list])
  }

  func userNotificationCenter(
    _: UNUserNotificationCenter,
    didReceive response: UNNotificationResponse,
    withCompletionHandler completion: @escaping () -> Void
  ) {
    // Handle AWS notification opened.
    // Braze notifications will not trigger this delegate method.
    guard let rootTabBarController = self.rootTabBarController else {
      completion()
      return
    }

    self.viewModel.inputs.didReceive(remoteNotification: response.notification.request.content.userInfo)
    rootTabBarController.didReceiveBadgeValue(response.notification.request.content.badge as? Int)
    completion()
  }
}

// MARK: - BrazeDelegate

extension AppDelegate: BrazeDelegate {
  // Intercept all URLs from Braze in-app messages or push notifications.
  // AWS notifications will not trigger this delegate method.
  func braze(_: BrazeKit.Braze, shouldOpenURL context: BrazeKit.Braze.URLContext) -> Bool {
    // Custom handle all urls instead of letting braze try to open them.
    self.viewModel.inputs.urlFromBrazeNotification(context.url)
    return false
  }
}

