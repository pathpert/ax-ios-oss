import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input methods accepted by `LoginViewModel`.
public protocol LoginViewModelInputs {
  /// String value of email textfield text
  func emailChanged(_ email: String?)

  /// Call when email textfield keyboard returns.
  func emailTextFieldDoneEditing()

  /// Call when the environment has been logged into.
  func environmentLoggedIn()

  /// Call when login button is pressed.
  func loginButtonPressed()

  /// String value of password textfield text
  func passwordChanged(_ password: String?)

  /// Call when password textfield keyboard returns.
  func passwordTextFieldDoneEditing()

  /// Call when reset password button is pressed.
  func resetPasswordButtonPressed()

  /// Call when the show/hide password button is pressed.
  func showHidePasswordButtonTapped()

  /// Call when the view did load.
  func viewDidLoad()

  /// Call when the view will appear.
  func viewWillAppear()

  /// Call when the trait collection did change.
  func traitCollectionDidChange()
}

/// Output signals emitted by `LoginViewModel`.
public protocol LoginViewModelOutputs {
  /// Emits when to dismiss a textfield keyboard
  var dismissKeyboard: Signal<(), Never> { get }

  /// Sets whether the email text field is the first responder.
  var emailTextFieldBecomeFirstResponder: Signal<(), Never> { get }

  /// Bool value whether form is valid
  var isFormValid: Signal<Bool, Never> { get }

  /// Emits an access token envelope that can be used to update the environment.
  var logIntoEnvironment: Signal<AccessTokenEnvelope, Never> { get }

  /// Emits when the password textfield should become the first responder
  var passwordTextFieldBecomeFirstResponder: Signal<(), Never> { get }

  /// Emits when a login success notification should be posted.
  var postNotification: Signal<(Notification, Notification), Never> { get }

  /// Emits when a login error has occurred and a message should be displayed.
  var showError: Signal<String, Never> { get }

  /// Emits when the reset password screen should be shown
  var showResetPassword: Signal<(), Never> { get }

  /// Emits when the show/hide password button is toggled
  var showHidePasswordButtonToggled: Signal<Bool, Never> { get }

  /// Emits when TFA is required for login.
  var tfaChallenge: Signal<(email: String, password: String), Never> { get }
}

/// Interface combining inputs and outputs for `LoginViewModel`.
public protocol LoginViewModelType {
  /// Input receiver for login form interactions.
  var inputs: LoginViewModelInputs { get }
  /// Output signals observed by `LoginViewController`.
  var outputs: LoginViewModelOutputs { get }
}

/// View model managing email/password validation, authentication requests, and 2FA handoff.
public final class LoginViewModel: LoginViewModelType, LoginViewModelInputs, LoginViewModelOutputs {
  /// Creates a new `LoginViewModel`.
  public init() {
    let emailAndPassword = Signal.combineLatest(
      self.emailChangedProperty.signal.skipNil(),
      self.passwordChangedProperty.signal.skipNil()
    )

    self.emailTextFieldBecomeFirstResponder = self.viewDidLoadProperty.signal

    self.isFormValid = self.viewWillAppearProperty.signal.mapConst(false).take(first: 1)
      .mergeWith(emailAndPassword.map(isValid))

    let tryLogin = Signal.merge(
      self.loginButtonPressedProperty.signal,
      self.passwordTextFieldDoneEditingProperty.signal
    )

    let loginEvent = emailAndPassword
      .takeWhen(tryLogin)
      .switchMap { email, password in
        AppEnvironment.current.apiService.login(email: email, password: password, code: nil)
          .materialize()
      }

    self.logIntoEnvironment = loginEvent.values()

    let tfaError = loginEvent.errors()
      .filter { $0.ksrCode == .TfaRequired }
      .ignoreValues()

    self.tfaChallenge = emailAndPassword
      .takeWhen(tfaError)
      .map { (email: $0, password: $1) }

    self.postNotification = self.environmentLoggedInProperty.signal
      .mapConst(
        (
          Notification(name: .ksr_sessionStarted),
          Notification(
            name: .ksr_showNotificationsDialog,
            userInfo: [UserInfoKeys.context: PushNotificationDialog.Context.login]
          )
        )
      )

    self.dismissKeyboard = self.passwordTextFieldDoneEditingProperty.signal
    self.passwordTextFieldBecomeFirstResponder = self.emailTextFieldDoneEditingProperty.signal

    self.showError = loginEvent.errors()
      .filter { $0.ksrCode != .TfaRequired }
      .map { env in
        env.errorMessages.first ?? Strings.login_errors_unable_to_log_in()
      }

    self.showResetPassword = self.resetPasswordPressedProperty.signal

    self.showHidePasswordButtonToggled = Signal.merge(
      self.shouldShowPasswordProperty.signal,
      self.shouldShowPasswordProperty.signal.takeWhen(self.traitCollectionDidChangeProperty.signal)
    )

    // Tracking

    self.viewDidLoadProperty.signal
      .observeValues { AppEnvironment.current.ksrAnalytics.trackLoginPageViewed() }

    tryLogin
      .observeValues { AppEnvironment.current.ksrAnalytics.trackLoginSubmitButtonClicked() }
  }

  /// Input receiver (`self`).
  public var inputs: LoginViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: LoginViewModelOutputs { return self }

  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the login screen will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  fileprivate let emailChangedProperty = MutableProperty<String?>(nil)
  /// Updates the current email field input text.
  public func emailChanged(_ email: String?) {
    self.emailChangedProperty.value = email
  }

  fileprivate let passwordChangedProperty = MutableProperty<String?>(nil)
  /// Updates the current password field input text.
  public func passwordChanged(_ password: String?) {
    self.passwordChangedProperty.value = password
  }

  fileprivate let loginButtonPressedProperty = MutableProperty(())
  /// Submits the login form when the log-in button is tapped.
  public func loginButtonPressed() {
    self.loginButtonPressedProperty.value = ()
  }

  fileprivate let emailTextFieldDoneEditingProperty = MutableProperty(())
  /// Moves focus from email field to password field on Return key.
  public func emailTextFieldDoneEditing() {
    self.emailTextFieldDoneEditingProperty.value = ()
  }

  fileprivate let passwordTextFieldDoneEditingProperty = MutableProperty(())
  /// Submits login when Return is pressed in the password field.
  public func passwordTextFieldDoneEditing() {
    self.passwordTextFieldDoneEditingProperty.value = ()
  }

  fileprivate let environmentLoggedInProperty = MutableProperty(())
  /// Completes login analytics and notifications after environment user persistence.
  public func environmentLoggedIn() {
    self.environmentLoggedInProperty.value = ()
  }

  fileprivate let resetPasswordPressedProperty = MutableProperty(())
  /// Navigates to the forgot-password reset flow.
  public func resetPasswordButtonPressed() {
    self.resetPasswordPressedProperty.value = ()
  }

  fileprivate let shouldShowPasswordProperty = MutableProperty(false)
  /// Toggles password visibility in the secure input field.
  public func showHidePasswordButtonTapped() {
    self.shouldShowPasswordProperty.value = self.shouldShowPasswordProperty.negate().value
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the login view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let traitCollectionDidChangeProperty = MutableProperty(())
  /// Notifies that interface traits changed.
  public func traitCollectionDidChange() {
    self.traitCollectionDidChangeProperty.value = ()
  }

  /// Emits when active text input focus should resign.
  public let dismissKeyboard: Signal<(), Never>
  /// Emits when the email text field should become first responder.
  public let emailTextFieldBecomeFirstResponder: Signal<(), Never>
  /// Emits whether email and password satisfy basic submission validity.
  public let isFormValid: Signal<Bool, Never>
  /// Emits access token credentials upon successful login.
  public let logIntoEnvironment: Signal<AccessTokenEnvelope, Never>
  /// Emits when focus should advance to the password field.
  public let passwordTextFieldBecomeFirstResponder: Signal<(), Never>
  /// Emits session-started notifications to post after environment update.
  public let postNotification: Signal<(Notification, Notification), Never>
  /// Emits localized authentication failure messages.
  public let showError: Signal<String, Never>
  /// Emits when presenting the password reset screen.
  public let showResetPassword: Signal<(), Never>
  /// Emits toggled secure-text visibility state.
  public let showHidePasswordButtonToggled: Signal<Bool, Never>
  /// Emits credentials when two-factor verification is required.
  public let tfaChallenge: Signal<(email: String, password: String), Never>
}

private func isValid(email: String, password: String) -> Bool {
  return isValidEmail(email) && !password.isEmpty
}
