import KsApi
import Library
import Prelude
import ReactiveSwift
import UIKit

/// Handles everything that arrives through a `UIWindowScene`'s delegate: URL opens, continued user
/// activities (universal links / Handoff), shortcut-item invocations, and the scene's foreground /
/// background lifecycle. This is the SceneDelegate's counterpart to `AppDelegateViewModel`,
/// which instead handles push-notification and Braze deep links.
/// Both funnel their resolved `Navigation` values through the shared `DeepLinkNavigationRouter`
/// router so the navigation-resolution logic isn't duplicated.
public final class SceneDelegateViewModel: SceneDelegateViewModelType, SceneDelegateViewModelInputs,
  SceneDelegateViewModelOutputs {
  /// Creates a new `SceneDelegateViewModel` and binds scene lifecycle and deep-link navigation signals.
  public init() {
    let openUrl = self.applicationOpenUrlProperty.signal.skipNil()

    let continueUserActivity = self.applicationContinueUserActivityProperty.signal.skipNil()

    let continueUserActivityWithNavigation = continueUserActivity
      .filter { $0.activityType == NSUserActivityTypeBrowsingWeb }
      .map { activity in (activity, activity.webpageURL.flatMap(Navigation.match)) }

    self.continueUserActivityReturnValue <~ continueUserActivityWithNavigation.map(second >>> isNotNil)

    let deepLinkUrl = Signal
      .merge(
        openUrl.map { $0.url },
        self.foundRedirectUrlProperty.signal.skipNil(),
        continueUserActivity
          .filter { $0.activityType == NSUserActivityTypeBrowsingWeb }
          .map { $0.webpageURL }
          .skipNil()
      )

    let deepLinkFromUrl = deepLinkUrl.map(Navigation.match)

    let performShortcutItem = self.performActionForShortcutItemProperty.signal.skipNil()
      .map { ShortcutItem(typeString: $0.type) }
      .skipNil()

    let deepLinkFromShortcut = performShortcutItem
      .switchMap(navigation(fromShortcutItem:))

    let deepLink = Signal
      .merge(
        deepLinkFromUrl,
        deepLinkFromShortcut
      )
      .skipNil()

    let emailVerificationEvent = deepLinkUrl
      .filter { Navigation.match($0) == .profile(.verifyEmail) }
      .map(accessTokenFromUrl)
      .skipNil()
      .switchMap { accessToken in
        AppEnvironment.current.apiService.verifyEmail(withToken: accessToken)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.emailVerificationCompleted = emailVerificationEvent
      .map(emailVerificationCompletionData)
      .skipNil()

    self.findRedirectUrl = deepLinkUrl
      .filter { Navigation.match($0) == .emailClick }

    self.goToMobileSafari = deepLinkUrl
      .filter(shouldOpenUrlInBrowser)

    let deepLinkOutputs = DeepLinkNavigationRouter(deepLink: deepLink)

    self.goToActivity = deepLinkOutputs.goToActivity
    self.goToDiscovery = deepLinkOutputs.goToDiscovery
    self.goToLoginWithIntent = deepLinkOutputs.goToLoginWithIntent
    self.goToMessageThread = deepLinkOutputs.goToMessageThread
    self.goToProfile = deepLinkOutputs.goToProfile
    self.goToSearch = deepLinkOutputs.goToSearch
    self.presentViewController = deepLinkOutputs.presentViewController
    self.updateCurrentUserInEnvironment = deepLinkOutputs.updateCurrentUserInEnvironment

    // MARK: - Scene lifecycle

    // Once an app adopts scenes, UIKit stops calling the `UIApplicationDelegate` foreground /
    // background callbacks entirely. The behavior they drive (refreshing the current user and config,
    // resetting the icon badge, re-reading app-tracking authorization) is app-scoped and still lives
    // in `AppDelegateViewModel`, so these outputs exist purely to be forwarded to it.

    self.applicationDidEnterBackground = self.sceneDidEnterBackgroundProperty.signal

    self.applicationWillEnterForeground = self.sceneWillEnterForegroundProperty.signal
  }

  /// The inputs interface for this view model.
  public var inputs: SceneDelegateViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: SceneDelegateViewModelOutputs { return self }

  fileprivate let applicationContinueUserActivityProperty = MutableProperty<NSUserActivity?>(nil)
  /// Handles a Handoff or universal-link `NSUserActivity` and returns whether it was recognized.
  public func applicationContinueUserActivity(_ userActivity: NSUserActivity) -> Bool {
    self.applicationContinueUserActivityProperty.value = userActivity
    return self.continueUserActivityReturnValue.value
  }

  // swiftlint:disable:next large_tuple
  fileprivate typealias ApplicationOpenUrl = (
    application: UIApplication?,
    url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any]
  )
  fileprivate let applicationOpenUrlProperty = MutableProperty<ApplicationOpenUrl?>(nil)
  /// Processes an incoming URL open request routed to this scene.
  public func applicationOpenUrl(
    application: UIApplication?,
    url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any]
  ) -> Bool {
    self.applicationOpenUrlProperty.value = (application, url, options)
    return true
  }

  fileprivate let performActionForShortcutItemProperty = MutableProperty<UIApplicationShortcutItem?>(nil)
  /// Handles a home-screen quick-action shortcut item.
  public func applicationPerformActionForShortcutItem(_ item: UIApplicationShortcutItem) {
    self.performActionForShortcutItemProperty.value = item
  }

  private let foundRedirectUrlProperty = MutableProperty<URL?>(nil)
  /// Supplies the resolved redirect URL after following a tracked email link.
  public func foundRedirectUrl(_ url: URL) {
    self.foundRedirectUrlProperty.value = url
  }

  fileprivate let sceneDidEnterBackgroundProperty = MutableProperty(())
  /// Signals that the window scene has entered the background.
  public func sceneDidEnterBackground() {
    self.sceneDidEnterBackgroundProperty.value = ()
  }

  fileprivate let sceneWillEnterForegroundProperty = MutableProperty(())
  /// Signals that the window scene will enter the foreground.
  public func sceneWillEnterForeground() {
    self.sceneWillEnterForegroundProperty.value = ()
  }

  /// Emits when the app enters the background.
  public let applicationDidEnterBackground: Signal<(), Never>
  /// Emits when the app returns to the foreground from the background.
  public let applicationWillEnterForeground: Signal<(), Never>
  /// Synchronous return value indicating whether `continueUserActivity` matched a route.
  public let continueUserActivityReturnValue = MutableProperty(false)
  /// Emits the verification status message and success flag after email verification.
  public let emailVerificationCompleted: Signal<(String, Bool), Never>
  /// Emits a URL whose redirect destination should be resolved before routing.
  public let findRedirectUrl: Signal<URL, Never>
  /// Emits when navigating to the Activity tab.
  public let goToActivity: Signal<(), Never>
  /// Emits when navigating to Discovery with optional filter parameters.
  public let goToDiscovery: Signal<DiscoveryParams?, Never>
  /// Emits when presenting the login flow with a specific intent.
  public let goToLoginWithIntent: Signal<LoginIntent, Never>
  /// Emits a message thread to open.
  public let goToMessageThread: Signal<MessageThread, Never>
  /// Emits an external URL to open in Safari.
  public let goToMobileSafari: Signal<URL, Never>
  /// Emits when navigating to the current user's profile tab.
  public let goToProfile: Signal<(), Never>
  /// Emits when navigating to the Search tab.
  public let goToSearch: Signal<(), Never>
  /// Emits a view controller to present modally.
  public let presentViewController: Signal<UIViewController, Never>
  /// Emits an updated `User` model to store in `AppEnvironment`.
  public let updateCurrentUserInEnvironment: Signal<User, Never>
}

// Figures out a `Navigation` to route the user to from a shortcut item.
private func navigation(fromShortcutItem shortcutItem: ShortcutItem) -> SignalProducer<Navigation?, Never> {
  switch shortcutItem {
  case .recommendedForYou:
    let params = .defaults
      |> DiscoveryParams.lens.recommended .~ true
      |> DiscoveryParams.lens.sort .~ .magic
    return SignalProducer(value: .tab(.discovery(params.queryParams)))

  case .projectsWeLove:
    let params = .defaults
      |> DiscoveryParams.lens.staffPicks .~ true
      |> DiscoveryParams.lens.sort .~ .magic
    return SignalProducer(value: .tab(.discovery(params.queryParams)))

  case .search:
    return SignalProducer(value: .tab(.search))
  }
}

private func accessTokenFromUrl(_ url: URL?) -> String? {
  return url.flatMap { url in
    URLComponents(url: url, resolvingAgainstBaseURL: false)?.queryItems
  }?
    .first { item in item.name == "at" }?
    .value
}

private func emailVerificationCompletionData(
  event: Signal<EmailVerificationResponseEnvelope, ErrorEnvelope>.Event
) -> (String, Bool)? {
  guard !event.isCompleted else { return nil }

  guard isNil(event.error), let message = event.value?.message else {
    let message = event.error?.errorMessages.first ?? Strings.Something_went_wrong_please_try_again()

    return (message, false)
  }

  return (message, true)
}
