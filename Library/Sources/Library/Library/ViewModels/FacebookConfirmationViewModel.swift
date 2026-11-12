import Foundation
import KsApi
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `FacebookConfirmationViewModel`.
public protocol FacebookConfirmationViewModelInputs {
  /// Call when view controller's viewDidLoad() is called
  func viewDidLoad()
  /// Call to set an email address for the user
  func email(_ email: String)
  /// Call to set a facebook token for the user
  func facebookToken(_ token: String)
  /// Call when newsletter switch is toggled
  func sendNewslettersToggled(_ newsletters: Bool)
  /// Call when create new account button is pressed
  func createAccountButtonPressed()
  /// Call when Login with email button is pressed
  func loginButtonPressed()
  /// Call when the environment has been logged into
  func environmentLoggedIn()
  /// Call when link tapped on disclaimer textView
  func tapped(_ url: URL)
}

/// Outputs exposed by `FacebookConfirmationViewModel`.
public protocol FacebookConfirmationViewModelOutputs {
  /// Emits an email address to display
  var displayEmail: Signal<String, Never> { get }
  /// Emits whether to send newsletters with login
  var sendNewsletters: Signal<Bool, Never> { get }
  /// Emits when a login success notification should be posted.
  var postNotification: Signal<Notification, Never> { get }
  /// Emits an access token envelope that can be used to update the environment.
  var logIntoEnvironment: Signal<AccessTokenEnvelope, Never> { get }
  /// Emits to show the Login with Email flow
  var showLogin: Signal<(), Never> { get }
  /// Emits whether a request is loading or not
  var isLoading: Signal<Bool, Never> { get }
  /// Emits when a help link from a disclaimer should be opened.
  var notifyDelegateOpenHelpType: Signal<HelpType, Never> { get }
}

/// Error outputs exposed by `FacebookConfirmationViewModel`.
public protocol FacebookConfirmationViewModelErrors {
  /// Emits an error message when Facebook signup fails.
  var showSignupError: Signal<String, Never> { get }
}

/// Combined inputs, outputs, and errors interface for `FacebookConfirmationViewModel`.
public protocol FacebookConfirmationViewModelType {
  /// The view model's inputs.
  var inputs: FacebookConfirmationViewModelInputs { get }
  /// The view model's outputs.
  var outputs: FacebookConfirmationViewModelOutputs { get }
  /// The view model's error outputs.
  var errors: FacebookConfirmationViewModelErrors { get }
}

/// View model managing account creation confirmation via Facebook.
public final class FacebookConfirmationViewModel: FacebookConfirmationViewModelType,
  FacebookConfirmationViewModelInputs, FacebookConfirmationViewModelOutputs,
  FacebookConfirmationViewModelErrors {
  // MARK: - FacebookConfirmationViewModelType

  /// The inputs interface for this view model.
  public var inputs: FacebookConfirmationViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: FacebookConfirmationViewModelOutputs { return self }
  /// The errors interface for this view model.
  public var errors: FacebookConfirmationViewModelErrors { return self }

  // MARK: - FacebookConfirmationViewModelInputs

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the confirmation view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let sendNewslettersToggledProperty = MutableProperty(false)
  /// Updates whether the user opted in to newsletters.
  public func sendNewslettersToggled(_ newsletters: Bool) {
    self.sendNewslettersToggledProperty.value = newsletters
  }

  fileprivate let emailProperty = MutableProperty("")
  /// Sets the prefilled email address from Facebook.
  public func email(_ email: String) {
    self.emailProperty.value = email
  }

  fileprivate let facebookTokenProperty = MutableProperty("")
  /// Sets the Facebook access token used to register.
  public func facebookToken(_ token: String) {
    self.facebookTokenProperty.value = token
  }

  fileprivate let createAccountButtonProperty = MutableProperty(())
  /// Triggers account creation with the provided email and Facebook token.
  public func createAccountButtonPressed() {
    self.createAccountButtonProperty.value = ()
  }

  fileprivate let loginButtonPressedProperty = MutableProperty(())
  /// Navigates to the standard email login flow.
  public func loginButtonPressed() {
    self.loginButtonPressedProperty.value = ()
  }

  fileprivate let environmentLoggedInProperty = MutableProperty(())
  /// Notifies the view model that the session has been saved into `AppEnvironment`.
  public func environmentLoggedIn() {
    self.environmentLoggedInProperty.value = ()
  }

  private let tappedUrlProperty = MutableProperty<URL?>(nil)
  /// Handles a tap on a disclaimer help link URL.
  public func tapped(_ url: URL) {
    self.tappedUrlProperty.value = url
  }

  // MARK: - FacebookConfirmationViewModelOutputs

  /// Emits the user's email address to display.
  public let displayEmail: Signal<String, Never>
  /// Emits whether to subscribe the user to newsletters.
  public let sendNewsletters: Signal<Bool, Never>
  /// Emits a session-started notification after login completes.
  public let postNotification: Signal<Notification, Never>
  /// Emits the access token envelope to store in the environment.
  public let logIntoEnvironment: Signal<AccessTokenEnvelope, Never>
  /// Emits when the email login screen should be presented.
  public let showLogin: Signal<(), Never>
  /// Emits whether account creation is currently in flight.
  public let isLoading: Signal<Bool, Never>
  /// Emits the `HelpType` corresponding to a tapped disclaimer link.
  public let notifyDelegateOpenHelpType: Signal<HelpType, Never>

  // MARK: - FacebookConfirmationViewModelErrors

  /// Emits a localized error message when signup fails.
  public let showSignupError: Signal<String, Never>

  /// Creates a new `FacebookConfirmationViewModel` and binds reactive signup flows.
  public init() {
    let isLoading = MutableProperty(false)

    self.isLoading = isLoading.signal

    self.displayEmail = self.emailProperty.signal.takeWhen(self.viewDidLoadProperty.signal)

    self.sendNewsletters = Signal.merge([
      self.sendNewslettersToggledProperty.signal,
      self.viewDidLoadProperty.signal.mapConst(false)
    ])

    let signupEvent = Signal.combineLatest(self.facebookTokenProperty.signal, self.sendNewsletters)
      .takeWhen(self.createAccountButtonProperty.signal)
      .switchMap { token, newsletter in
        AppEnvironment.current.apiService.signup(facebookAccessToken: token, sendNewsletters: newsletter)
          .on(
            starting: {
              isLoading.value = true
            },
            terminated: {
              isLoading.value = false
            }
          )
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.logIntoEnvironment = signupEvent.values()

    self.postNotification = self.environmentLoggedInProperty.signal
      .mapConst(Notification(name: .ksr_sessionStarted))

    self.showSignupError = signupEvent.errors()
      .map { error in
        error.errorMessages.first ??
          Strings.facebook_confirmation_could_not_log_in()
      }

    self.showLogin = self.loginButtonPressedProperty.signal

    self.notifyDelegateOpenHelpType = self.tappedUrlProperty.signal.skipNil().map { url -> HelpType? in
      HelpType.allCases.first(where: {
        url.absoluteString == $0.url(
          withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl
        )?.absoluteString
      })
    }
    .skipNil()
  }
}
