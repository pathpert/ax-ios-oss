import KsApi
import Prelude
import ReactiveSwift
import WebKit

/// Native app destinations that can be intercepted from the Pledge Manager web view.
public enum PledgeManagerNativeNatigationRequest: Equatable {
  /// Opens a project detail page natively.
  case goToProject(param: Param, refTag: RefTag?)
  /// Opens a specific project update natively.
  case goToUpdate(param: Param, updateId: Int)
  /// Opens the native pledge flow for a project.
  case goToPledge(param: Param)
}

/// Input methods accepted by `PledgeManagerWebViewModel`.
public protocol PledgeManagerWebViewModelInputs {
  /// Call when the close button is tapped.
  func closeButtonTapped()

  /// Call to configure with a survey url.
  func configureWith(url: String)

  /// Call when the webview needs to decide a policy for a navigation action. Returns the decision policy.
  func decidePolicyFor(navigationAction: WKNavigationActionData) -> WKNavigationActionPolicy

  /// Call when view model should handle fetching the necessary data and trigger `goToUpdate`.
  func fetchUpdateVCData(param: Param, updateId: Int)

  /// Call when the user session starts.
  func userSessionStarted()

  /// Call when the view loads.
  func viewDidLoad()
}

/// Output signals emitted by `PledgeManagerWebViewModel`.
public protocol PledgeManagerWebViewModelOutputs {
  /// Emits when the view controller should be dismissed.
  var dismissViewController: Signal<Void, Never> { get }

  /// Emits native navigation request for the view controller to handle.
  var goToNativeScreen: Signal<PledgeManagerNativeNatigationRequest, Never> { get }

  /// Emits a project and update that should be used to present the update view controller.
  var presentUpdateVC: Signal<(Project, Update), Never> { get }

  /// Emits a login intent that should be used to log in.
  var goToLoginSignup: Signal<LoginIntent, Never> { get }

  /// Emits a title, if any, that should be shown in the top bar.
  /// `nil` should reset the view to have no title.
  var title: Signal<String?, Never> { get }

  /// Emits a request that should be loaded by the webview.
  var webViewLoadRequest: Signal<URLRequest, Never> { get }
}

/// Interface combining inputs and outputs for `PledgeManagerWebViewModel`.
public protocol PledgeManagerWebViewModelType: PledgeManagerWebViewModelInputs,
  PledgeManagerWebViewModelOutputs {
  /// Input receiver for webview navigation events.
  var inputs: PledgeManagerWebViewModelInputs { get }
  /// Output signals observed by the Pledge Manager web view controller.
  var outputs: PledgeManagerWebViewModelOutputs { get }
}

