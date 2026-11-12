import KsApi
import MessageUI
import ReactiveSwift
import UIKit
import WebKit

/// Inputs accepted by `ProjectUpdatesViewModel`.
public protocol ProjectUpdatesViewModelInputs {
  /// Call to set whether Mail can be composed.
  func canSendEmail(_ canSend: Bool)

  /// Call with the project given to the view.
  func configureWith(project: Project)

  /// Call with the navigation action given to the webview's delegate method. Returns the policy that can
  /// be returned from the delegate method.
  func decidePolicy(forNavigationAction action: WKNavigationActionData) -> WKNavigationActionPolicy

  /// Call when mail compose view controller has closed with a result.
  func mailComposeCompletion(result: MFMailComposeResult)

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when webview did finish navigation.
  func webViewDidFinishNavigation()

  /// Call when webview did start navigation.
  func webViewDidStartProvisionalNavigation()
}

/// Outputs emitted by `ProjectUpdatesViewModel`.
public protocol ProjectUpdatesViewModelOutputs {
  /// Emits when we should open a safari browser with the URL.
  var goToSafariBrowser: Signal<URL, Never> { get }

  /// Emits with the project and update when we should go to the update.
  var goToUpdate: Signal<(Project, Update), Never> { get }

  /// Emits with the project when we should go to the update comments.
  var goToUpdateComments: Signal<Update, Never> { get }

  /// Emits when the webview content is loading.
  var isActivityIndicatorHidden: Signal<Bool, Never> { get }

  /// Emits when app should make phone call.
  var makePhoneCall: Signal<URL, Never> { get }

  /// Emits to show a MFMailComposeViewController.
  var showMailCompose: Signal<String, Never> { get }

  /// Emits to show an alert when device can not send emails.
  var showNoEmailError: Signal<UIAlertController, Never> { get }

  /// Emits a request that should be loaded into the web view.
  var webViewLoadRequest: Signal<URLRequest, Never> { get }
}

/// Interface combining inputs and outputs for `ProjectUpdatesViewModel`.
public protocol ProjectUpdatesViewModelType {
  /// Input receiver for project updates web view events.
  var inputs: ProjectUpdatesViewModelInputs { get }
  /// Output signals driving navigation and loading state.
  var outputs: ProjectUpdatesViewModelOutputs { get }
}

