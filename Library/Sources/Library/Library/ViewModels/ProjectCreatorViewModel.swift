import KsApi
import Prelude
import ReactiveSwift
import WebKit

/// A type capable of providing minimal project creator properties.
public protocol HasProjectCreatorProperties {
  /// Minimal creator metadata derived from the project.
  var projectCreatorProperties: ProjectCreatorProperties { get }
}

/// Minimal project metadata required by `ProjectCreatorViewModel`.
public struct ProjectCreatorProperties {
  /// The numeric project identifier.
  public let id: Int
  /// The display name of the project.
  public let name: String
  /// The canonical web URL string for the project page.
  public let projectWebURL: String

  /// Initializes a `ProjectCreatorProperties` value.
  public init(id: Int, name: String, projectWebURL: String) {
    self.id = id
    self.name = name
    self.projectWebURL = projectWebURL
  }
}

extension Project: HasProjectCreatorProperties {
  /// Adapts `Project` to `ProjectCreatorProperties`.
  public var projectCreatorProperties: ProjectCreatorProperties {
    return ProjectCreatorProperties(
      id: self.id,
      name: self.name,
      projectWebURL: self.urls.web.project
    )
  }
}

/// Configuration requirement combining `HasProjectCreatorProperties` and `HasProjectWebURL`.
public typealias ProjectCreatorConfiguration = HasProjectCreatorProperties & HasProjectWebURL

/// Inputs accepted by `ProjectCreatorViewModel`.
public protocol ProjectCreatorViewModelInputs {
  /// Call with the project given to the view.
  func configureWith(project: any ProjectCreatorConfiguration)

  /// Call with the navigation action given to the webview's delegate method. Returns the policy that can
  /// be returned from the delegate method.
  func decidePolicy(forNavigationAction action: WKNavigationActionData) -> WKNavigationActionPolicy

  /// Call when the view loads.
  func viewDidLoad()
}

/// Outputs exposed by `ProjectCreatorViewModel`.
public protocol ProjectCreatorViewModelOutputs {
  /// Emits when we should return to project page.
  var goBackToProject: Signal<(), Never> { get }

  /// Emits when the LoginToutViewController should be presented.
  var goToLoginTout: Signal<LoginIntent, Never> { get }

  /// Emits when we should navigate to the message dialog.
  var goToMessageDialog: Signal<(MessageSubject, KSRAnalytics.MessageDialogContext), Never> { get }

  /// Emits when we should open a safari browser with the URL.
  var goToSafariBrowser: Signal<URL, Never> { get }

  /// Emits a request that should be loaded into the web view.
  var loadWebViewRequest: Signal<URLRequest, Never> { get }
}

/// Combined inputs and outputs interface for `ProjectCreatorViewModel`.
public protocol ProjectCreatorViewModelType {
  /// The view model's inputs.
  var inputs: ProjectCreatorViewModelInputs { get }
  /// The view model's outputs.
  var outputs: ProjectCreatorViewModelOutputs { get }
}

/// View model managing the project creator bio web view and message-creator links.
public final class ProjectCreatorViewModel: ProjectCreatorViewModelType, ProjectCreatorViewModelInputs,
  ProjectCreatorViewModelOutputs {
  /// Creates a new `ProjectCreatorViewModel` and binds web navigation signals.
  public init() {
    let navigationAction = self.navigationAction.signal.skipNil()
    let project = Signal.combineLatest(self.projectProperty.signal.skipNil(), self.viewDidLoadProperty.signal)
      .map(first)

    let properties = project.map { $0.projectCreatorProperties }

    let messageCreatorRequest = navigationAction
      .filter { $0.navigationType == .linkActivated }
      .filter { isMessageCreator(request: $0.request) }
      .map { $0.request }

    self.loadWebViewRequest = properties.map {
      URL(string: $0.projectWebURL)?.appendingPathComponent("creator_bio")
    }
    .skipNil()
    .map { AppEnvironment.current.apiService.preparedRequest(forURL: $0) }

    self.decidedPolicy <~ navigationAction
      .map { $0.navigationType == .other ? .allow : .cancel }

    self.goToLoginTout = messageCreatorRequest.ignoreValues()
      .filter { AppEnvironment.current.currentUser == nil }
      .map { .messageCreator }

    self.goToMessageDialog = properties
      .takeWhen(messageCreatorRequest)
      .filter { _ in AppEnvironment.current.currentUser != nil }
      .map { (MessageSubject.project(id: $0.id, name: $0.name), .projectPage) }

    self.goBackToProject = Signal.combineLatest(properties, navigationAction)
      .filter { $1.navigationType == .linkActivated }
      .filter { properties, navigation in
        properties.projectWebURL == navigation.request.url?.absoluteString
      }
      .ignoreValues()

    self.goToSafariBrowser = Signal.combineLatest(properties, navigationAction)
      .filter { $1.navigationType == .linkActivated }
      .filter { !isMessageCreator(request: $1.request) }
      .filter { properties, navigation in
        properties.projectWebURL != navigation.request.url?.absoluteString
      }
      .map { $1.request.url }
      .skipNil()
  }

  fileprivate let projectProperty = MutableProperty<(any ProjectCreatorConfiguration)?>(nil)
  /// Configures the view model with the target project's creator metadata.
  public func configureWith(project: any ProjectCreatorConfiguration) {
    self.projectProperty.value = project
  }

  fileprivate let navigationAction = MutableProperty<WKNavigationActionData?>(nil)
  fileprivate let decidedPolicy = MutableProperty(WKNavigationActionPolicy.cancel)
  /// Evaluates web view link clicks and routes message-creator or external URLs natively.
  public func decidePolicy(forNavigationAction action: WKNavigationActionData) -> WKNavigationActionPolicy {
    self.navigationAction.value = action
    return self.decidedPolicy.value
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the creator bio view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits when navigating back to the main project page.
  public let goBackToProject: Signal<(), Never>
  /// Emits when the user must log in before messaging the creator.
  public let goToLoginTout: Signal<LoginIntent, Never>
  /// Emits message subject and analytics context to present the message composer.
  public let goToMessageDialog: Signal<(MessageSubject, KSRAnalytics.MessageDialogContext), Never>
  /// Emits external URLs to open in Safari.
  public let goToSafariBrowser: Signal<URL, Never>
  /// Emits the prepared request to load the creator bio page.
  public let loadWebViewRequest: Signal<URLRequest, Never>

  /// The inputs interface for this view model.
  public var inputs: ProjectCreatorViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: ProjectCreatorViewModelOutputs { return self }
}

private func isMessageCreator(request: URLRequest) -> Bool {
  if let nav = Navigation.match(request), case .project(_, .messageCreator, _, _) = nav { return true }
  return false
}
