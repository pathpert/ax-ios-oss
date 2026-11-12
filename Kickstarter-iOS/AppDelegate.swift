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

/// Application delegate bootstrapping third-party SDKs, push notifications, and app lifecycle hooks.
@UIApplicationMain
internal final class AppDelegate: UIResponder, UIApplicationDelegate {
  internal let viewModel: AppDelegateViewModelType = AppDelegateViewModel()
  internal var disposables: [any Disposable] = []
  // Custom Braze cancellable type. As long as we keep a reference to this active, Braze will
  // use this to tell us about any Braze push notifications the app handles.
  internal var brazeSubscription: BrazeKit.Braze.Cancellable?

  internal var analytics: Segment.Analytics?
  internal weak var braze: Braze?

  internal var rootTabBarController: RootTabBarViewController? {
    // Search the scene's windows rather than using `keyWindow`: during cold launch, deep-link inputs
    // can be forwarded to the view model before the window has been marked key, which would
    // otherwise make this resolve to nil. Match on the root view controller's type rather than taking
    // the first window, because `UIWindowScene.windows` has no guaranteed order and also holds system
    // windows — the keyboard's `UITextEffectsWindow`, alert presentation windows — any of which can
    // sit at index 0.
    return UIApplication.shared.connectedScenes
      .compactMap { $0 as? UIWindowScene }
      .flatMap { $0.windows }
      .compactMap { $0.rootViewController as? RootTabBarViewController }
      .first
  }

  func application(
    _ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) -> Bool {
    // FBSDK initialization
    let facebookAppID = Bundle.main.infoDictionary?["FacebookAppID"] as? String
    AppEnvironment.configureFacebookSDK(
      appID: facebookAppID,
      application: application,
      launchOptions: launchOptions
    )

    // Braze expects to be configured immediately, but segment destination plugins are initialized
    // async. This method bridges that gap.
    // https://www.braze.com/docs/developer_guide/sdk_integration#swift_step-2-set-up-delayed-initialization-optional
    Braze.prepareForDelayedInitialization(pushAutomation: self.configuredBrazePushAutomation())

    UIView.doBadSwizzleStuff()
    UIViewController.doBadSwizzleStuff()

    UIImageView.appearance(whenContainedInInstancesOf: [UITabBar.self])
      .accessibilityIgnoresInvertColors = true

    InterFont.registerFontIfUnregistered()

    AppEnvironment.replaceCurrentEnvironment(
      AppEnvironment.fromStorage(
        ubiquitousStore: NSUbiquitousKeyValueStore.default,
        userDefaults: UserDefaults.standard
      )
    )

    #if DEBUG
      if KsApi.Secrets.isOSS {
        AppEnvironment.replaceCurrentEnvironment(apiService: MockService())
      }
    #endif

    self.bindViewModelOutputs()
    self.registerNotificationCenterObservers()

    self.viewModel.inputs.applicationDidFinishLaunching(
      application: application,
      launchOptions: launchOptions
    )

    UNUserNotificationCenter.current().delegate = self

    return self.viewModel.outputs.applicationDidFinishLaunchingReturnValue
  }

  func application(
    _: UIApplication,
    configurationForConnecting connectingSceneSession: UISceneSession,
    options _: UIScene.ConnectionOptions
  ) -> UISceneConfiguration {
    return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
  }

  // MARK: - Scene lifecycle

  // UIKit does not call the `UIApplicationDelegate` foreground / background callbacks in an app that
  // adopts scenes. `SceneDelegate` receives the scene equivalents and calls through to these methods,
  // which forward to the app-scoped view model that still owns the work they drive. The active /
  // resign-active state is tracked in `AppDelegate` through `UIApplication` notifications instead.

  internal func applicationWillEnterForeground() {
    self.viewModel.inputs.applicationWillEnterForeground()
  }

  internal func applicationDidEnterBackground() {
    self.viewModel.inputs.applicationDidEnterBackground()
  }

  // MARK: - Remote notifications

  internal func application(
    _: UIApplication,
    didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data
  ) {
    self.viewModel.inputs.didRegisterForRemoteNotifications(withDeviceTokenData: deviceToken)
  }

  internal func application(
    _: UIApplication,
    didFailToRegisterForRemoteNotificationsWithError error: Error
  ) {
    print("🔴 Failed to register for remote notifications: \(error.localizedDescription)")
  }

  internal func applicationDidReceiveMemoryWarning(_: UIApplication) {
    self.viewModel.inputs.applicationDidReceiveMemoryWarning()
  }
}
