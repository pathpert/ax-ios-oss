import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `ChangePasswordViewModel`.
public protocol ChangePasswordViewModelInputs {
  /// Updates the current password text as the user types.
  func currentPasswordFieldTextChanged(text: String)
  /// Stores current password and advances focus to the new password field.
  func currentPasswordFieldDidReturn(currentPassword: String)
  /// Updates the desired new password text.
  func newPasswordFieldTextChanged(text: String)
  /// Stores new password and advances focus to the confirmation field.
  func newPasswordFieldDidReturn(newPassword: String)
  /// Updates the new password confirmation text.
  func newPasswordConfirmationFieldTextChanged(text: String)
  /// Stores confirmation text and auto-submits when the form is valid.
  func newPasswordConfirmationFieldDidReturn(newPasswordConfirmed: String)
  /// Submits the password change mutation.
  func saveButtonTapped()
  /// Notifies the view model that the view appeared.
  func viewDidAppear()
}

/// Reactive outputs emitted by `ChangePasswordViewModel`.
public protocol ChangePasswordViewModelOutputs {
  /// Emits when VoiceOver should move focus to the validation error label.
  var accessibilityFocusValidationErrorLabel: Signal<Void, Never> { get }
  /// Emits loading indicator visibility during the password change request.
  var activityIndicatorShouldShow: Signal<Bool, Never> { get }
  /// Emits localized server error message when changing password fails.
  var changePasswordFailure: Signal<String, Never> { get }
  /// Emits when the password change mutation succeeds.
  var changePasswordSuccess: Signal<Void, Never> { get }
  /// Emits when the confirmation password field should become first responder.
  var confirmNewPasswordBecomeFirstResponder: Signal<Void, Never> { get }
  /// Emits when the current password field should become first responder.
  var currentPasswordBecomeFirstResponder: Signal<Void, Never> { get }
  /// Emits when the keyboard should dismiss.
  var dismissKeyboard: Signal<Void, Never> { get }
  /// Emits when the new password field should become first responder.
  var newPasswordBecomeFirstResponder: Signal<Void, Never> { get }
  /// Emits whether the save action is enabled.
  var saveButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits whether the inline validation error label is hidden.
  var validationErrorLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits the localized validation error message string.
  var validationErrorLabelMessage: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for changing an existing password.
public protocol ChangePasswordViewModelType {
  /// Input receiver.
  var inputs: ChangePasswordViewModelInputs { get }
  /// Output signal provider.
  var outputs: ChangePasswordViewModelOutputs { get }
}

/// View model validating current/new/confirmation passwords and submitting `ChangePasswordInput`.
public class ChangePasswordViewModel: ChangePasswordViewModelType,
  ChangePasswordViewModelInputs, ChangePasswordViewModelOutputs {
  /// Creates a new `ChangePasswordViewModel`.
  public init() {
    let currentPasswordSignal = self.currentPasswordProperty.signal

    let combinedPasswords = Signal.combineLatest(
      self.newPasswordProperty.signal,
      self.confirmNewPasswordProperty.signal
    )

    let fieldsMatch = combinedPasswords.map(==)
    let fieldLengthIsValid = self.newPasswordProperty.signal.map(passwordLengthValid)
    let fieldsNotEmpty = Signal.combineLatest(
      currentPasswordSignal,
      self.newPasswordProperty.signal,
      self.confirmNewPasswordProperty.signal
    )
    .map(formFieldsNotEmpty)

    let formIsValid = Signal.combineLatest(fieldsNotEmpty, fieldsMatch, fieldLengthIsValid)
      .map(passwordFormValid)
      .skipRepeats()

    self.saveButtonIsEnabled = formIsValid

    let autoSaveSignal = self.saveButtonIsEnabled
      .takeWhen(self.confirmNewPasswordDoneEditingProperty.signal)
      .filter(isTrue)
      .ignoreValues()

    let triggerSaveAction = Signal.merge(autoSaveSignal, self.saveButtonTappedProperty.signal)

    let combinedInput = Signal.combineLatest(currentPasswordSignal, combinedPasswords)

    let passwordUpdateEvent = combinedInput
      .takeWhen(triggerSaveAction)
      .map(unpack)
      .map { ChangePasswordInput(currentPassword: $0.0, newPassword: $0.1, newPasswordConfirmation: $0.2) }
      .flatMap {
        AppEnvironment.current.apiService.changePassword(input: $0)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.changePasswordSuccess = passwordUpdateEvent.values().ignoreValues()
    self.changePasswordFailure = passwordUpdateEvent.errors().map { $0.localizedDescription }

    self.activityIndicatorShouldShow = Signal.merge(
      triggerSaveAction.signal.mapConst(true),
      self.changePasswordSuccess.mapConst(false),
      self.changePasswordFailure.mapConst(false)
    )

    self.dismissKeyboard = Signal.merge(
      self.saveButtonTappedProperty.signal,
      self.confirmNewPasswordDoneEditingProperty.signal
    )

    self.currentPasswordBecomeFirstResponder = self.viewDidAppearProperty.signal
    self.newPasswordBecomeFirstResponder = self.currentPasswordDoneEditingProperty.signal
    self.confirmNewPasswordBecomeFirstResponder = self.newPasswordDoneEditingProperty.signal

    let newPasswordValidationText = fieldLengthIsValid
      .map(passwordValidationText)
      .skipRepeats()

    let newPasswordAndConfirmationValidationText = Signal.combineLatest(fieldLengthIsValid, fieldsMatch)
      .map(passwordValidationText)
      .skipRepeats()

    let validationLabelText = Signal.merge(
      self.viewDidAppearProperty.signal.mapConst(String()),
      newPasswordValidationText,
      newPasswordAndConfirmationValidationText
    )

    self.validationErrorLabelMessage = validationLabelText
      .map { $0 ?? String() }

    let validationLabelTextIsEmpty = self.validationErrorLabelMessage
      .map { $0.isEmpty }

    self.validationErrorLabelIsHidden = validationLabelTextIsEmpty

    let inputsChanged = Signal.merge(
      self.newPasswordProperty.signal, self.confirmNewPasswordProperty.signal
    )

    self.accessibilityFocusValidationErrorLabel = validationLabelTextIsEmpty
      .takeWhen(inputsChanged)
      .filter { _ in AppEnvironment.current.isVoiceOverRunning() }
      .filter(isFalse)
      .ignoreValues()
  }

  private var currentPasswordDoneEditingProperty = MutableProperty(())
  /// Stores current password and advances focus on return.
  public func currentPasswordFieldDidReturn(currentPassword: String) {
    self.currentPasswordProperty.value = currentPassword
    self.currentPasswordDoneEditingProperty.value = ()
  }

  private var currentPasswordProperty = MutableProperty<String>("")
  /// Updates current password text.
  public func currentPasswordFieldTextChanged(text: String) {
    self.currentPasswordProperty.value = text
  }

  private var newPasswordDoneEditingProperty = MutableProperty(())
  /// Stores new password and advances focus on return.
  public func newPasswordFieldDidReturn(newPassword: String) {
    self.newPasswordProperty.value = newPassword
    self.newPasswordDoneEditingProperty.value = ()
  }

  private var newPasswordProperty = MutableProperty<String>("")
  /// Updates new password text.
  public func newPasswordFieldTextChanged(text: String) {
    self.newPasswordProperty.value = text
  }

  private var confirmNewPasswordDoneEditingProperty = MutableProperty(())
  /// Stores confirmation password and attempts save on return.
  public func newPasswordConfirmationFieldDidReturn(newPasswordConfirmed: String) {
    self.confirmNewPasswordProperty.value = newPasswordConfirmed
    self.confirmNewPasswordDoneEditingProperty.value = ()
  }

  private var confirmNewPasswordProperty = MutableProperty<String>("")
  /// Updates confirmation password text.
  public func newPasswordConfirmationFieldTextChanged(text: String) {
    self.confirmNewPasswordProperty.value = text
  }

  private var saveButtonTappedProperty = MutableProperty(())
  /// Triggers the password change submission.
  public func saveButtonTapped() {
    self.saveButtonTappedProperty.value = ()
  }

  private var viewDidAppearProperty = MutableProperty(())
  /// Signals that the view appeared on screen.
  public func viewDidAppear() {
    self.viewDidAppearProperty.value = ()
  }

  /// Emits when VoiceOver should move focus to the validation error label.
  public let accessibilityFocusValidationErrorLabel: Signal<Void, Never>
  /// Emits loading indicator visibility during the password change request.
  public let activityIndicatorShouldShow: Signal<Bool, Never>
  /// Emits localized server error message when changing password fails.
  public let changePasswordFailure: Signal<String, Never>
  /// Emits when the password change mutation succeeds.
  public let changePasswordSuccess: Signal<Void, Never>
  /// Emits when the confirmation password field should become first responder.
  public let confirmNewPasswordBecomeFirstResponder: Signal<Void, Never>
  /// Emits when the current password field should become first responder.
  public let currentPasswordBecomeFirstResponder: Signal<Void, Never>
  /// Emits when the keyboard should dismiss.
  public let dismissKeyboard: Signal<Void, Never>
  /// Emits whether the inline validation error label is hidden.
  public let validationErrorLabelIsHidden: Signal<Bool, Never>
  /// Emits the localized validation error message string.
  public let validationErrorLabelMessage: Signal<String, Never>
  /// Emits when the new password field should become first responder.
  public let newPasswordBecomeFirstResponder: Signal<Void, Never>
  /// Emits whether the save action is enabled.
  public let saveButtonIsEnabled: Signal<Bool, Never>

  /// Inputs receiver (`self`).
  public var inputs: ChangePasswordViewModelInputs { return self }

  /// Outputs provider (`self`).
  public var outputs: ChangePasswordViewModelOutputs { return self }
}

// MARK: - Functions

private func formFieldsNotEmpty(_ pwds: (first: String, second: String, third: String)) -> Bool {
  return !pwds.first.isEmpty && !pwds.second.isEmpty && !pwds.third.isEmpty
}
