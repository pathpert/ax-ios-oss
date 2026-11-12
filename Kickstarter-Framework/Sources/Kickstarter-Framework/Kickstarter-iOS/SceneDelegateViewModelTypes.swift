import KsApi
import Library
import ReactiveSwift
import UIKit

/// Inputs accepted by `SceneDelegateViewModel`.
public protocol SceneDelegateViewModelInputs {
  /// Call when the application is handed off to.
  func applicationContinueUserActivity(_ userActivity: NSUserActivity) -> Bool

  /// Call to open a url that was sent to the app
  func applicationOpenUrl(
    application: UIApplication?,
    url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any]
  ) -> Bool

  /// Call when the scene receives a request to perform a shortcut action.
  func applicationPerformActionForShortcutItem(_ item: UIApplicationShortcutItem)

  /// Call when the redirect URL has been found, see `findRedirectUrl` for more information.
  func foundRedirectUrl(_ url: URL)

  /// Call when the scene enters the background.
  func sceneDidEnterBackground()

  /// Call when the scene is about to enter the foreground.
  func sceneWillEnterForeground()
}

/// Outputs exposed by `SceneDelegateViewModel`.
public protocol SceneDelegateViewModelOutputs {
  /// Emits when the app has entered the background, to be forwarded to `AppDelegateViewModel`.
  var applicationDidEnterBackground: Signal<(), Never> { get }

  /// Emits when the app is entering the foreground from the background, to be forwarded to
  /// `AppDelegateViewModel`. Does not emit for the foreground event UIKit sends while the scene is
  /// first connecting, which duplicates work already driven by `applicationDidFinishLaunching`.
  var applicationWillEnterForeground: Signal<(), Never> { get }

  /// Return this value in the delegate method.
  var continueUserActivityReturnValue: MutableProperty<Bool> { get }

  /// Emits the response from email verification with a message and success/failure.
  var emailVerificationCompleted: Signal<(String, Bool), Never> { get }

  /// Emits when the view needs to figure out the redirect URL for the emitted URL.
  /// Required in order to handle email links.
  var findRedirectUrl: Signal<URL, Never> { get }

  /// Emits when the root view controller should navigate to activity.
  var goToActivity: Signal<(), Never> { get }

  /// Emits when the root view controller should navigate to the discovery screen.
  var goToDiscovery: Signal<DiscoveryParams?, Never> { get }

  /// Emits when the root view controller should present the login modal.
  var goToLoginWithIntent: Signal<LoginIntent, Never> { get }

  /// Emits a message thread when we should navigate to it.
  var goToMessageThread: Signal<MessageThread, Never> { get }

  /// Emits a URL when we should open it in the safari browser.
  var goToMobileSafari: Signal<URL, Never> { get }

  /// Emits when the root view controller should navigate to the user's profile.
  var goToProfile: Signal<(), Never> { get }

  /// Emits when the root view controller should navigate to search.
  var goToSearch: Signal<(), Never> { get }

  /// Emits when a view controller should be presented.
  var presentViewController: Signal<UIViewController, Never> { get }

  /// Emits the current user when a deep link has updated their notification settings.
  var updateCurrentUserInEnvironment: Signal<User, Never> { get }
}

/// Combined inputs and outputs interface for `SceneDelegateViewModel`.
public protocol SceneDelegateViewModelType {
  /// The view model's inputs.
  var inputs: SceneDelegateViewModelInputs { get }
  /// The view model's outputs.
  var outputs: SceneDelegateViewModelOutputs { get }
}

