import KsApi
import ReactiveExtensions
import ReactiveSwift

/// Input events handled by `ResetPasswordViewModel`.
public protocol ResetPasswordViewModelInputs {
  /// Call when the view loads
  func viewDidLoad()
  /// Call when email textfield input is entered
  func emailChanged(_ email: String?)
  /// Call when reset button is pressed
  func resetButtonPressed()
  /// Call when OK button is pressed on reset confirmation popup
  func confirmResetButtonPressed()
}

/// Output signals exposed by `ResetPasswordViewModel`.
public protocol ResetPasswordViewModelOutputs {
  /// Sets whether the email text field is the first responder.
  var emailTextFieldBecomeFirstResponder: Signal<(), Never> { get }
  /// Emits email address to set email textfield
  var setEmailInitial: Signal<String, Never> { get }
  /// Emits Bool representing form validity
  var formIsValid: Signal<Bool, Never> { get }
  /// Emits email String when reset is successful
  var showResetSuccess: Signal<String, Never> { get }
  /// Emits after user closes popup confirmation
  var returnToLogin: Signal<(), Never> { get }
  /// Emits error message String on reset fail
  var showError: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `ResetPasswordViewModel`.
public protocol ResetPasswordViewModelType {
  /// Input receiver for password reset interactions.
  var inputs: ResetPasswordViewModelInputs { get }
  /// Output signals driving email validation and submission results.
  var outputs: ResetPasswordViewModelOutputs { get }
}

/// View model managing email validation and password reset submission.
public final class ResetPasswordViewModel: ResetPasswordViewModelType, ResetPasswordViewModelInputs,
  ResetPasswordViewModelOutputs {
  /// Initializes the reset password view model.
  public init() {
    self.emailTextFieldBecomeFirstResponder = self.viewDidLoadProperty.signal

    self.setEmailInitial = self.emailProperty.signal.skipNil()
      .takeWhen(self.viewDidLoadProperty.signal)
      .take(first: 1)

    self.formIsValid = self.viewDidLoadProperty.signal
      .flatMap { [email = emailProperty.producer] _ in email }
      .map { $0 ?? "" }
      .map(isValidEmail)
      .skipRepeats()

    let resetEvent = self.emailProperty.signal.skipNil()
      .takeWhen(self.resetButtonPressedProperty.signal)
      .switchMap { email in
        AppEnvironment.current.apiService.resetPassword(email: email)
          .mapConst(email)
          .materialize()
      }

    self.showResetSuccess = resetEvent.values().map { email in
      Strings.forgot_password_we_sent_an_email_to_email_address_with_instructions_to_reset_your_password(
        email: email
      )
    }

    self.showError = resetEvent.errors()
      .map { envelope in
        if envelope.httpCode == 404 {
          return Strings.forgot_password_error()
        } else {
          return Strings.general_error_something_wrong()
        }
      }

    self.returnToLogin = self.confirmResetButtonPressedProperty.signal
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the reset password view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let emailProperty = MutableProperty<String?>(nil)
  /// Updates the current email string typed by the user.
  public func emailChanged(_ email: String?) {
    self.emailProperty.value = email
  }

  fileprivate let resetButtonPressedProperty = MutableProperty(())
  /// Triggers the password reset network request.
  public func resetButtonPressed() {
    self.resetButtonPressedProperty.value = ()
  }

  fileprivate let confirmResetButtonPressedProperty = MutableProperty(())
  /// Dismisses the confirmation dialog back to the login screen.
  public func confirmResetButtonPressed() {
    self.confirmResetButtonPressedProperty.value = ()
  }

  /// Emits when the email field should become first responder.
  public let emailTextFieldBecomeFirstResponder: Signal<(), Never>
  /// Emits whether the entered email address is valid.
  public let formIsValid: Signal<Bool, Never>
  /// Emits a confirmation message with the target email upon success.
  public let showResetSuccess: Signal<String, Never>
  /// Emits when navigation should return to login.
  public var returnToLogin: Signal<(), Never>
  /// Emits an initial email value on load.
  public var setEmailInitial: Signal<String, Never>
  /// Emits a localized error message if resetting fails.
  public let showError: Signal<String, Never>

  /// Returns `self` as `ResetPasswordViewModelInputs`.
  public var inputs: ResetPasswordViewModelInputs { return self }
  /// Returns `self` as `ResetPasswordViewModelOutputs`.
  public var outputs: ResetPasswordViewModelOutputs { return self }
}
