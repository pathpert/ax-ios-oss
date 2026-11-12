import KsApi
import MessageUI
import Prelude
import ReactiveSwift
import WebKit

/// View model managing navigation and deep-linking within the project updates web view.
public final class ProjectUpdatesViewModel: ProjectUpdatesViewModelType, ProjectUpdatesViewModelInputs,
  ProjectUpdatesViewModelOutputs {
  /// Initializes the project updates view model.
  public init() {
    let navigationAction = self.navigationAction.signal.skipNil()

    let canMakePhoneCall = self.canMakePhoneCallProperty.signal.skipNil()

    let canSendEmail = self.canSendEmailProperty.signal.skipNil()

    let project = Signal.combineLatest(self.projectProperty.signal.skipNil(), self.viewDidLoadProperty.signal)
      .map(first)

    let initialUpdatesIndexLoadRequest = project.map { URL(string: $0.urls.web.updates ?? "") }.skipNil()

    let anotherIndexRequest = navigationAction
      .filter { $0.navigationType == .linkActivated && isUpdatesRequest(request: $0.request) }
      .map { $0.request.url }
      .skipNil()

    let goToCommentsRequest = navigationAction
      .filter { isGoToCommentsRequest(request: $0.request) }
      .map { projectUpdateParams(fromRequest: $0.request) }
      .skipNil()

    let goToUpdateRequest = navigationAction
      .filter { isGoToUpdateRequest(request: $0.request) }
      .map { projectUpdateParams(fromRequest: $0.request) }
      .skipNil()
      .switchMap { projectParam, updateId in
        AppEnvironment.current.apiService.fetchUpdate(updateId: updateId, projectParam: projectParam)
          .demoteErrors()
      }

    self.decidedPolicy <~ navigationAction
      .map { action in
        action.navigationType == .other || action.targetFrame?.mainFrame == .some(false)
          ? .allow
          : .cancel
      }

    self.goToSafariBrowser = navigationAction
      .filter {
        $0.navigationType == .linkActivated &&
          !isGoToCommentsRequest(request: $0.request) &&
          !isGoToUpdateRequest(request: $0.request) &&
          !isUpdatesRequest(request: $0.request) &&
          !isPhoneLink(action: $0) &&
          !isEmailLink(action: $0)
      }
      .map { $0.request.url }
      .skipNil()

    let emailLink = navigationAction
      .filter { (action: WKNavigationActionData) in
        action.navigationType == .linkActivated &&
          !isGoToCommentsRequest(request: action.request) &&
          !isGoToUpdateRequest(request: action.request) &&
          !isUpdatesRequest(request: action.request) &&
          isEmailLink(action: action)
      }
      .map(formattedEmailAddress)

    let phoneNumberLink = navigationAction
      .filter { (action: WKNavigationActionData) in
        action.navigationType == .linkActivated &&
          !isGoToCommentsRequest(request: action.request) &&
          !isGoToUpdateRequest(request: action.request) &&
          !isUpdatesRequest(request: action.request) &&
          isPhoneLink(action: action)
      }
      .map { $0.request.url }
      .skipNil()

    self.makePhoneCall = canMakePhoneCall
      .takePairWhen(phoneNumberLink)
      .map { $0.1 }

    self.showMailCompose = canSendEmail
      .takePairWhen(emailLink)
      .filter { canSend, _ in canSend == true }
      .map { $0.1 }

    self.showNoEmailError = canSendEmail
      .takePairWhen(emailLink)
      .filter { canSend, _ in !canSend }
      .map { _ in noEmailError() }

    self.goToUpdate = project.takePairWhen(goToUpdateRequest)

    self.goToUpdateComments = goToCommentsRequest
      .switchMap { projectParam, updateId in
        AppEnvironment.current.apiService.fetchUpdate(updateId: updateId, projectParam: projectParam)
          .demoteErrors()
      }

    self.isActivityIndicatorHidden = Signal.merge(
      self.webViewDidFinishNavigationProperty.signal.mapConst(true),
      self.webViewDidStartProvisionalNavigationProperty.signal.mapConst(false)
    )

    self.webViewLoadRequest = Signal.merge(initialUpdatesIndexLoadRequest, anotherIndexRequest)
      .map { AppEnvironment.current.apiService.preparedRequest(forURL: $0) }

    // Tracking

    project
      .observeValues { project in
        AppEnvironment.current.ksrAnalytics.trackProjectViewed(
          project,
          sectionContext: .updates
        )
      }
  }

  fileprivate let canSendEmailProperty = MutableProperty<Bool?>(nil)
  /// Sets whether the device is configured to send email.
  public func canSendEmail(_ canSend: Bool) {
    self.canSendEmailProperty.value = canSend
  }

  fileprivate let mailComposeCompletionProperty = MutableProperty<MFMailComposeResult?>(nil)
  /// Notifies the view model that the mail composer completed with the given result.
  public func mailComposeCompletion(result: MFMailComposeResult) {
    self.mailComposeCompletionProperty.value = result
  }

  fileprivate let navigationAction = MutableProperty<WKNavigationActionData?>(nil)
  fileprivate let decidedPolicy = MutableProperty(WKNavigationActionPolicy.cancel)
  /// Evaluates a web view navigation action and returns the resulting navigation policy.
  public func decidePolicy(forNavigationAction action: WKNavigationActionData)
    -> WKNavigationActionPolicy {
    self.navigationAction.value = action
    return self.decidedPolicy.value
  }

  fileprivate let projectProperty = MutableProperty<Project?>(nil)
  /// Configures the view model with the displayed project.
  public func configureWith(project: Project) {
    self.projectProperty.value = project
  }

  fileprivate let canMakePhoneCallProperty = MutableProperty<Bool?>(nil)
  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the updates view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
    self.canMakePhoneCallProperty.value = canMakePhoneCall()
  }

  fileprivate let webViewDidFinishNavigationProperty = MutableProperty(())
  /// Signals that the web view finished loading its current navigation.
  public func webViewDidFinishNavigation() {
    self.webViewDidFinishNavigationProperty.value = ()
  }

  fileprivate let webViewDidStartProvisionalNavigationProperty = MutableProperty(())
  /// Signals that the web view began provisional navigation.
  public func webViewDidStartProvisionalNavigation() {
    self.webViewDidStartProvisionalNavigationProperty.value = ()
  }

  /// Emits external URLs to open in Safari.
  public let goToSafariBrowser: Signal<URL, Never>
  /// Emits `(project, update)` pairs when navigating to an update detail screen.
  public let goToUpdate: Signal<(Project, Update), Never>
  /// Emits the target `Update` when navigating to update comments.
  public let goToUpdateComments: Signal<Update, Never>
  /// Emits whether the loading activity indicator should be hidden.
  public let isActivityIndicatorHidden: Signal<Bool, Never>
  /// Emits `tel:` URLs when the user taps a phone link.
  public let makePhoneCall: Signal<URL, Never>
  /// Emits recipient email addresses for `mailto:` links when mail composition is available.
  public let showMailCompose: Signal<String, Never>
  /// Emits an alert controller when email composition is unavailable.
  public let showNoEmailError: Signal<UIAlertController, Never>
  /// Emits prepared URL requests to load in the updates web view.
  public let webViewLoadRequest: Signal<URLRequest, Never>

  /// Returns `self` as `ProjectUpdatesViewModelInputs`.
  public var inputs: ProjectUpdatesViewModelInputs { return self }
  /// Returns `self` as `ProjectUpdatesViewModelOutputs`.
  public var outputs: ProjectUpdatesViewModelOutputs { return self }
}

private func canMakePhoneCall() -> Bool {
  guard let url = URL(string: "tel://") else {
    return false
  }
  return UIApplication.shared.canOpenURL(url)
}

// Returns project and update params for update and comments requests.
private func projectUpdateParams(fromRequest request: URLRequest) -> (projectParam: Param, updateId: Int)? {
  guard let nav = Navigation.match(request) else { return nil }
  switch nav {
  case .project(_, .update(_, .comments), _, _):
    return Navigation.Project.updateCommentsWithRequest(request)
  case .project(_, .update(_, .root), _, _):
    return Navigation.Project.updateWithRequest(request)
  default:
    return nil
  }
}

private func formattedEmailAddress(_ action: WKNavigationActionData) -> String {
  return action.request.url?.absoluteString.replacingOccurrences(of: "mailto:", with: "") ?? ""
}

private func isEmailLink(action: WKNavigationActionData) -> Bool {
  return action.request.url?.scheme == "mailto"
}

private func isGoToCommentsRequest(request: URLRequest) -> Bool {
  if let nav = Navigation.match(request), case .project(_, .update(_, .comments), _, _) = nav { return true }
  return false
}

private func isGoToUpdateRequest(request: URLRequest) -> Bool {
  if let nav = Navigation.match(request), case .project(_, .update(_, .root), _, _) = nav { return true }
  return false
}

private func isPhoneLink(action: WKNavigationActionData) -> Bool {
  return action.request.url?.scheme == "tel" ? true : false
}

private func isUpdatesRequest(request: URLRequest) -> Bool {
  if let nav = Navigation.match(request), case .project(_, .updates, _, _) = nav { return true }
  return false
}

private func noEmailError() -> UIAlertController {
  let alertController = UIAlertController(
    title: Strings.support_email_noemail_title(),
    message: Strings.support_email_noemail_message(),
    preferredStyle: .alert
  )
  alertController.addAction(
    UIAlertAction(
      title: Strings.general_alert_buttons_ok(),
      style: .cancel,
      handler: nil
    )
  )

  return alertController
}
