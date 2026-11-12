import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `FacebookResetPasswordViewModel`.
public protocol FacebookResetPasswordViewModelInputs {
  /// Signals that the reset password view has loaded.
  func viewDidLoad()
  /// Signals that the reset password view will appear.
  func viewWillAppear()
  /// Updates the email text field input.
  func emailTextFieldFieldDidChange(_ text: String)
  /// Handles pressing the keyboard return key in the email text field.
  func emailTextFieldFieldDidReturn()
  /// Submits the password reset request when the primary button is pressed.
  func setPasswordButtonPressed()
}

/// Outputs emitted by `FacebookResetPasswordViewModel`.
public protocol FacebookResetPasswordViewModelOutputs {
  /// Emits whether the loading indicator should be visible.
  var shouldShowActivityIndicator: Signal<Bool, Never> { get }
  /// Emits whether the submit button is enabled.
  var setPasswordButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits localized explanatory copy for simplifying Facebook login.
  var contextLabelText: Signal<String, Never> { get }
  /// Emits localized placeholder/label copy for the email field.
  var emailLabel: Signal<String, Never> { get }
  /// Emits an error message string if the reset request fails.
  var setPasswordFailure: Signal<String, Never> { get }
  /// Emits a confirmation message string with the target email upon success.
  var setPasswordSuccess: Signal<String, Never> { get }
  /// Emits whether form inputs are currently interactive.
  var textFieldAndSetPasswordButtonAreEnabled: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `FacebookResetPasswordViewModel`.
public protocol FacebookResetPasswordViewModelType {
  /// Input receiver for Facebook password-reset form events.
  var inputs: FacebookResetPasswordViewModelInputs { get }
  /// Output signals driving form validation, loading state, and feedback alerts.
  var outputs: FacebookResetPasswordViewModelOutputs { get }
}

/// View model guiding former Facebook-login users through requesting a password reset email.
public final class FacebookResetPasswordViewModel: FacebookResetPasswordViewModelType,
  FacebookResetPasswordViewModelInputs,
  FacebookResetPasswordViewModelOutputs {
  /// Initializes the Facebook password reset view model.
  public init() {
    self.contextLabelText = self.viewWillAppearProperty.signal
      .map { Strings.We_re_simplifying_our_login_process_To_log_in() }
    self.emailLabel = self.viewWillAppearProperty.signal
      .map { Strings.forgot_password_placeholder_email() }

    let formIsValid = Signal.combineLatest(
      self.viewDidLoadProperty.signal,
      self.emailTextFieldProperty.signal.skipNil()
    )
    .map(second)
    .map(isValidEmail)
    .skipRepeats()

    self.setPasswordButtonIsEnabled = formIsValid

    let submitFormEvent = Signal.merge(
      self.emailTextFieldReturnProperty.signal,
      self.setPasswordButtonPressedProperty.signal
    )

    let submitAction = formIsValid
      .takeWhen(submitFormEvent)
      .filter(isTrue)
      .ignoreValues()

    let setPasswordEvent = self.emailTextFieldProperty.signal.skipNil()
      .takeWhen(submitAction)
      .switchMap { email in
        AppEnvironment.current.apiService.resetPassword(email: email)
          .mapConst(email)
          .materialize()
      }

    self.setPasswordFailure = setPasswordEvent.errors()
      .map { envelope in
        envelope.errorMessages.last ?? Strings.general_error_something_wrong()
      }

    self.setPasswordSuccess = setPasswordEvent.values().map { email in
      Strings.forgot_password_we_sent_an_email_to_email_address_with_instructions_to_reset_your_password(
        email: email
      )
    }

    self.shouldShowActivityIndicator = Signal.merge(
      submitAction.signal.ignoreValues().mapConst(true),
      setPasswordEvent.filter { $0.isTerminating }.mapConst(false)
    )

    self.textFieldAndSetPasswordButtonAreEnabled = self.shouldShowActivityIndicator.map { $0 }.negate()
  }

  /// Returns `self` as `FacebookResetPasswordViewModelInputs`.
  public var inputs: FacebookResetPasswordViewModelInputs { return self }
  /// Returns `self` as `FacebookResetPasswordViewModelOutputs`.
  public var outputs: FacebookResetPasswordViewModelOutputs { return self }

  // MARK: - Input Methods

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let viewWillAppearProperty = MutableProperty(())
  /// Signals that the view is about to appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  private let emailTextFieldProperty = MutableProperty<String?>(nil)
  /// Updates the current email address entered by the user.
  public func emailTextFieldFieldDidChange(_ text: String) {
    self.emailTextFieldProperty.value = text
  }

  private let emailTextFieldReturnProperty = MutableProperty(())
  /// Handles pressing return on the email field.
  public func emailTextFieldFieldDidReturn() {
    self.emailTextFieldReturnProperty.value = ()
  }

  private let setPasswordButtonPressedProperty = MutableProperty(())
  /// Triggers submission of the reset password request.
  public func setPasswordButtonPressed() {
    self.setPasswordButtonPressedProperty.value = ()
  }

  // MARK: - Output Properties

  /// Emits whether the loading activity indicator is shown.
  public var shouldShowActivityIndicator: Signal<Bool, Never>
  /// Emits whether the Set Password button is enabled.
  public var setPasswordButtonIsEnabled: Signal<Bool, Never>
  /// Emits explanatory header copy.
  public var contextLabelText: Signal<String, Never>
  /// Emits placeholder copy for the email field.
  public var emailLabel: Signal<String, Never>
  /// Emits an error message when resetting fails.
  public var setPasswordFailure: Signal<String, Never>
  /// Emits a success confirmation message after resetting.
  public var setPasswordSuccess: Signal<String, Never>
  /// Emits whether the text field and submit button accept interaction.
  public var textFieldAndSetPasswordButtonAreEnabled: Signal<Bool, Never>
}
