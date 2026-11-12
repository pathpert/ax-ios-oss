import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `ChangeEmailViewModel`.
public protocol ChangeEmailViewModelInputs {
  /// Updates candidate replacement email address text.
  func emailFieldTextDidChange(text: String?)
  /// Updates current password confirmation text.
  func passwordFieldTextDidChange(text: String?)
  /// Requests another verification email to be dispatched to the current address.
  func resendVerificationEmailButtonTapped()
  /// Submits the email change mutation.
  func saveButtonTapped()
  /// Mirrors current save button enabled state for return-key gating.
  func saveButtonIsEnabled(_ enabled: Bool)
  /// Handles keyboard return key (`next` vs `done`).
  func textFieldShouldReturn(with returnKeyType: UIReturnKeyType)
  /// Notifies the view model that the view loaded and should fetch account email status.
  func viewDidLoad()
}

/// Reactive outputs emitted by `ChangeEmailViewModel`.
public protocol ChangeEmailViewModelOutputs {
  /// Emits loading spinner visibility while changing email.
  var activityIndicatorShouldShow: Signal<Bool, Never> { get }
  /// Emits when the email address update succeeds.
  var didChangeEmail: Signal<Void, Never> { get }
  /// Emits localized error text when changing email fails.
  var didFailToChangeEmail: Signal<String, Never> { get }
  /// Emits localized error text when resending verification fails.
  var didFailToSendVerificationEmail: Signal<String, Never> { get }
  /// Emits when verification email delivery succeeds.
  var didSendVerificationEmail: Signal<Void, Never> { get }
  /// Emits when the software keyboard should dismiss.
  var dismissKeyboard: Signal<Void, Never> { get }
  /// Emits the account's active email address string.
  var emailText: Signal<String, Never> { get }
  /// Emits whether the verification/bounce status message banner is hidden.
  var messageLabelViewHidden: Signal<Bool, Never> { get }
  /// Emits when the password field should become first responder.
  var passwordFieldBecomeFirstResponder: Signal<Void, Never> { get }
  /// Emits whether the resend-verification section is hidden.
  var resendVerificationEmailViewIsHidden: Signal<Bool, Never> { get }
  /// Emits empty string to clear input fields after a successful update.
  var resetFields: Signal<String, Never> { get }
  /// Emits whether the save action is enabled.
  var saveButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits whether form text fields remain editable during requests.
  var textFieldsAreEnabled: Signal<Bool, Never> { get }
  /// Emits whether the unverified-email notice label is hidden.
  var unverifiedEmailLabelHidden: Signal<Bool, Never> { get }
  /// Emits whether the undeliverable-email warning label is hidden.
  var warningMessageLabelHidden: Signal<Bool, Never> { get }
  /// Emits localized title for the send/resend verification email button.
  var verificationEmailButtonTitle: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for changing account email and resending verification.
public protocol ChangeEmailViewModelType {
  /// Input receiver.
  var inputs: ChangeEmailViewModelInputs { get }
  /// Output signal provider.
  var outputs: ChangeEmailViewModelOutputs { get }
}

/// View model managing email validation, verification banner visibility, and email update mutations.
public final class ChangeEmailViewModel: ChangeEmailViewModelType, ChangeEmailViewModelInputs,
  ChangeEmailViewModelOutputs {
  /// Creates a new `ChangeEmailViewModel`.
  public init() {
    self.dismissKeyboard = Signal.merge(
      self.textFieldShouldReturnProperty.signal.skipNil()
        .filter { $0 == .done }
        .ignoreValues(),
      self.saveButtonTappedProperty.signal
    )

    let triggerSaveAction = self.saveButtonEnabledProperty.signal
      .takeWhen(self.dismissKeyboard)
      .filter(isTrue)
      .ignoreValues()

    let changeEmailEvent = Signal.combineLatest(
      self.newEmailProperty.signal.skipNil(),
      self.passwordProperty.signal.skipNil()
    )
    .takeWhen(triggerSaveAction)
    .map(ChangeEmailInput.init(email:currentPassword:))
    .switchMap { input in
      AppEnvironment.current.apiService.changeEmail(input: input)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .map { _ in input.email }
        .materialize()
    }

    let clearValues = changeEmailEvent.values().map { _ -> String? in nil }
    self.newEmailProperty <~ clearValues
    self.passwordProperty <~ clearValues

    let userEmailEvent = self.viewDidLoadProperty.signal
      .switchMap { _ in
        AppEnvironment.current
          .apiService
          .fetchGraphUser(withStoredCards: false)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    let resendEmailVerificationEvent = self.resendVerificationEmailButtonProperty.signal
      .switchMap { _ in
        AppEnvironment.current.apiService.sendVerificationEmail(input: EmptyInput())
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.didSendVerificationEmail = resendEmailVerificationEvent.values().ignoreValues()

    self.didFailToSendVerificationEmail = resendEmailVerificationEvent.errors()
      .map { $0.localizedDescription }

    self.emailText = Signal.merge(
      changeEmailEvent.values(),
      userEmailEvent.values().map { $0.me.email ?? "" }
    )

    let isEmailVerified = userEmailEvent.values().map { $0.me.isEmailVerified }.skipNil()
    let isEmailDeliverable = userEmailEvent.values().map { $0.me.isDeliverable }.skipNil()
    let emailVerifiedAndDeliverable: Signal<Bool, Never> = Signal
      .combineLatest(isEmailVerified, isEmailDeliverable)
      .map { isEmailVerified, isEmailDeliverable -> Bool in
        let r = isEmailVerified && isEmailDeliverable
        return r
      }

    self.resendVerificationEmailViewIsHidden = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(true),
      emailVerifiedAndDeliverable
    ).skipRepeats()

    self.unverifiedEmailLabelHidden = Signal
      .combineLatest(isEmailVerified, isEmailDeliverable)
      .map { isEmailVerified, isEmailDeliverable -> Bool in
        guard isEmailVerified else { return !isEmailDeliverable }

        return true
      }

    self.warningMessageLabelHidden = isEmailDeliverable

    self.messageLabelViewHidden = Signal
      .merge(self.unverifiedEmailLabelHidden, self.warningMessageLabelHidden)
      .filter(isFalse)

    self.saveButtonIsEnabled = Signal.combineLatest(
      self.emailText,
      self.newEmailProperty.signal,
      self.passwordProperty.signal
    )
    .map(shouldEnableSaveButton(email:newEmail:password:))

    self.passwordFieldBecomeFirstResponder = self.textFieldShouldReturnProperty.signal
      .skipNil()
      .filter { $0 == .next }
      .ignoreValues()

    self.didChangeEmail = changeEmailEvent.values().ignoreValues()

    self.resetFields = changeEmailEvent.values()
      .ignoreValues()
      .mapConst("")

    self.didFailToChangeEmail = changeEmailEvent.errors()
      .map { $0.localizedDescription }

    self.verificationEmailButtonTitle = self.viewDidLoadProperty.signal.map { _ in
      guard let user = AppEnvironment.current.currentUser else { return "" }
      return user.isCreator ? Strings.Resend_verification_email() : Strings.Send_verfication_email()
    }

    self.activityIndicatorShouldShow = Signal.merge(
      self.saveButtonTappedProperty.signal.ignoreValues().mapConst(true),
      changeEmailEvent.filter { $0.isTerminating }.mapConst(false)
    )

    self.textFieldsAreEnabled = self.activityIndicatorShouldShow.map { $0 }.negate()
  }

  private let newEmailProperty = MutableProperty<String?>(nil)
  /// Updates candidate email address text.
  public func emailFieldTextDidChange(text: String?) {
    self.newEmailProperty.value = text
  }

  private let passwordProperty = MutableProperty<String?>(nil)
  /// Updates current password confirmation text.
  public func passwordFieldTextDidChange(text: String?) {
    self.passwordProperty.value = text
  }

  private let resendVerificationEmailButtonProperty = MutableProperty(())
  /// Triggers resending the account email verification message.
  public func resendVerificationEmailButtonTapped() {
    self.resendVerificationEmailButtonProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the view loaded and begins fetching user email status.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let saveButtonEnabledProperty = MutableProperty(false)
  /// Records whether the save button is enabled.
  public func saveButtonIsEnabled(_ enabled: Bool) {
    self.saveButtonEnabledProperty.value = enabled
  }

  private let saveButtonTappedProperty = MutableProperty(())
  /// Submits the email change mutation.
  public func saveButtonTapped() {
    self.saveButtonTappedProperty.value = ()
  }

  private let textFieldShouldReturnProperty = MutableProperty<UIReturnKeyType?>(nil)
  /// Routes return key presses based on keyboard `returnKeyType`.
  public func textFieldShouldReturn(with returnKeyType: UIReturnKeyType) {
    self.textFieldShouldReturnProperty.value = returnKeyType
  }

  /// Emits loading spinner visibility while changing email.
  public let activityIndicatorShouldShow: Signal<Bool, Never>
  /// Emits when the email address update succeeds.
  public let didChangeEmail: Signal<Void, Never>
  /// Emits localized error text when changing email fails.
  public let didFailToChangeEmail: Signal<String, Never>
  /// Emits localized error text when resending verification fails.
  public let didFailToSendVerificationEmail: Signal<String, Never>
  /// Emits when verification email delivery succeeds.
  public let didSendVerificationEmail: Signal<Void, Never>
  /// Emits when the software keyboard should dismiss.
  public let dismissKeyboard: Signal<Void, Never>
  /// Emits the account's active email address string.
  public let emailText: Signal<String, Never>
  /// Emits whether the verification/bounce status message banner is hidden.
  public let messageLabelViewHidden: Signal<Bool, Never>
  /// Emits when the password field should become first responder.
  public let passwordFieldBecomeFirstResponder: Signal<Void, Never>
  /// Emits whether the resend-verification section is hidden.
  public let resendVerificationEmailViewIsHidden: Signal<Bool, Never>
  /// Emits empty string to clear input fields after a successful update.
  public let resetFields: Signal<String, Never>
  /// Emits whether the save action is enabled.
  public let saveButtonIsEnabled: Signal<Bool, Never>
  /// Emits whether form text fields remain editable during requests.
  public let textFieldsAreEnabled: Signal<Bool, Never>
  /// Emits whether the unverified-email notice label is hidden.
  public let unverifiedEmailLabelHidden: Signal<Bool, Never>
  /// Emits localized title for the send/resend verification email button.
  public let verificationEmailButtonTitle: Signal<String, Never>
  /// Emits whether the undeliverable-email warning label is hidden.
  public let warningMessageLabelHidden: Signal<Bool, Never>

  /// Inputs receiver (`self`).
  public var inputs: ChangeEmailViewModelInputs {
    return self
  }

  /// Outputs provider (`self`).
  public var outputs: ChangeEmailViewModelOutputs {
    return self
  }
}

private func shouldEnableSaveButton(email: String?, newEmail: String?, password: String?) -> Bool {
  guard
    let newEmail = newEmail,
    isValidEmail(newEmail),
    email != newEmail,
    password != nil

  else { return false }

  return ![newEmail, password]
    .compact()
    .map { !$0.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty }
    .contains(false)
}
