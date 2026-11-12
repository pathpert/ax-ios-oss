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
  // MARK: - View Model & Notification Bindings

  internal func bindViewModelOutputs() {
    self.viewModel.outputs.updateCurrentUserInEnvironment
      .observeForUI()
      .observeValues { [weak self] user in
        AppEnvironment.updateCurrentUser(user)
        // Update user in Braze.
        self?.braze?.changeUser(userId: String(user.id))

        // Update user in Segment and Statsig.
        AppEnvironment.current.identify(user: user)

        self?.viewModel.inputs.currentUserUpdatedInEnvironment()
      }

    self.viewModel.outputs.forceLogout
      .observeForUI()
      .observeValues {
        AppEnvironment.logout()
        NotificationCenter.default.post(.init(name: .ksr_sessionEnded, object: nil))
      }

    self.viewModel.outputs.updateConfigInEnvironment
      .observeForUI()
      .observeValues { [weak self] config in
        AppEnvironment.updateConfig(config)

        self?.viewModel.inputs.didUpdateConfig(config)
      }

    self.viewModel.outputs.postNotification
      .observeForUI()
      .observeValues(NotificationCenter.default.post)

    self.viewModel.outputs.presentViewController
      .observeForUI()
      .observeValues { [weak self] in
        self?.rootTabBarController?.dismiss(animated: true, completion: nil)
        self?.rootTabBarController?.present($0, animated: true, completion: nil)
      }

    self.viewModel.outputs.goToDiscovery
      .observeForUI()
      .observeValues { [weak self] in self?.rootTabBarController?.switchToDiscovery(params: $0) }

    self.viewModel.outputs.goToActivity
      .observeForUI()
      .observeValues { [weak self] in self?.rootTabBarController?.switchToActivities() }

    self.viewModel.outputs.goToLoginWithIntent
      .observeForControllerAction()
      .observeValues { [weak self] intent in
        self?.rootTabBarController?.goToLoginWithIntent(intent)
      }

    self.viewModel.outputs.goToMessageThread
      .observeForUI()
      .observeValues { [weak self] in self?.goToMessageThread($0) }

    self.viewModel.outputs.goToMobileSafari
      .observeForUI()
      .observeValues { UIApplication.shared.open($0) }

    self.viewModel.outputs.applicationIconBadgeNumber
      .observeForUI()
      .observeValues { UIApplication.shared.applicationIconBadgeNumber = $0 }

    self.viewModel.outputs.pushTokenRegistrationStarted
      .observeForUI()
      .observeValues {
        print("📲 [Push Registration] Push token registration started 🚀")
      }

    self.viewModel.outputs.pushTokenSuccessfullyRegistered
      .observeForUI()
      .observeValues { token in
        print("📲 [Push Registration] Push token successfully registered (\(token)) ✨")
      }

    self.viewModel.outputs.registerPushTokenInBraze
      .observeForUI()
      .observeValues { token in
        self.braze?.notifications.register(deviceToken: token)
      }

    self.viewModel.outputs.triggerOnboardingFlow
      .observeForUI()
      .observeValues { [weak self] in
        guard let rootTabBarController = self?.rootTabBarController else { return }

        let onboardingVC = UIHostingController(rootView: OnboardingView(viewModel: OnboardingViewModel()))
        /// Onboarding flow should not respond to light/dark mode preference.
        onboardingVC.overrideUserInterfaceStyle = .light
        onboardingVC.modalPresentationStyle = .fullScreen

        rootTabBarController.navigationController?.isNavigationBarHidden = true
        rootTabBarController.present(onboardingVC, animated: true, completion: nil)
      }

    self.viewModel.outputs.showAlert
      .observeForUI()
      .observeValues { [weak self] in
        self?.presentContextualPermissionAlert($0)
      }

    self.viewModel.outputs.unregisterForRemoteNotifications
      .observeForUI()
      .observeValues(UIApplication.shared.unregisterForRemoteNotifications)

    #if RELEASE || INTERNAL_BUILD
      self.viewModel.outputs.configureFirebase
        .observeForUI()
        .observeValues { [weak self] in
          guard let strongSelf = self else { return }

          FirebaseApp.configure()
          AppEnvironment.current.ksrAnalytics.logEventCallback = { event, _ in
            Crashlytics.crashlytics().log(format: "%@", arguments: getVaList([event]))
          }

          strongSelf.configureRemoteConfig()
        }
    #endif

    self.viewModel.outputs.configureStatsig
      .observeForUI()
      .observeValues { [weak self] key in
        self?.configureStatsig(with: key)
      }

    self.disposables.append(
      self.viewModel.outputs.trackingAuthorizationStatus
        .observeForUI()
        .startWithValues { status in
          self.appTrackingAuthorizationChanged(status: status)
        }
    )

    self.viewModel.outputs.synchronizeUbiquitousStore
      .observeForUI()
      .observeValues {
        _ = AppEnvironment.current.ubiquitousStore.synchronize()
      }

    self.viewModel.outputs.setApplicationShortcutItems
      .observeForUI()
      .observeValues { shortcutItems in
        UIApplication.shared.shortcutItems = shortcutItems.map { $0.applicationShortcutItem }
      }

    self.viewModel.outputs.configureSegmentWithBraze
      .observeValues { [weak self] writeKey in
        guard let self else { return }

        let configuration = Analytics.configuredClient(withWriteKey: writeKey)
        let brazeDestination = self.configuredBrazeDestination(for: configuration)
        configuration.add(plugin: brazeDestination)

        let middleware = BrazeDebounceMiddlewarePlugin()
        configuration.add(plugin: middleware)

        self.analytics = configuration

        AppEnvironment.current.ksrAnalytics.configureSegmentClient(configuration)

        // Once Segment loads, update the Statsig Client with segment's anonymous identifier.
        AppEnvironment.current.statsigClient?.reload(withUser: AppEnvironment.current.statsigUser())
      }

    self.viewModel.outputs.segmentIsEnabled
      .observeValues { enabled in
        self.analytics?.enabled = enabled
      }
  }

  internal func registerNotificationCenterObservers() {
    NotificationCenter.default
      .addObserver(
        forName: Notification.Name.ksr_goToLoginFromOnboarding,
        object: nil,
        queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.goToLoginSignup(from: .onboarding)
      }

    NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_sessionStarted, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionStarted()
      }

    NotificationCenter.default
      .addObserver(
        forName: UIApplication.didBecomeActiveNotification,
        object: nil,
        queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.applicationActive(state: true)
      }

    NotificationCenter.default
      .addObserver(
        forName: UIApplication.willResignActiveNotification,
        object: nil,
        queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.applicationActive(state: false)
      }

    NotificationCenter.default
      .addObserver(
        forName: Notification.Name.ksr_showNotificationsDialog, object: nil, queue: nil
      ) { [weak self] in
        self?.viewModel.inputs.showNotificationDialog(notification: $0)
      }

    NotificationCenter.default
      .addObserver(forName: Notification.Name.ksr_sessionEnded, object: nil, queue: nil) { [weak self] _ in
        self?.viewModel.inputs.userSessionEnded()
      }

    NotificationCenter.default
      .addObserver(
        forName: Notification.Name.ksr_configUpdated,
        object: nil,
        queue: nil
      ) { [weak self] _ in
        self?.viewModel.inputs.configUpdatedNotificationObserved()
      }
  }
}

