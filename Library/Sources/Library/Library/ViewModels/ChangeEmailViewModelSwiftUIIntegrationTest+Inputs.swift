import Foundation

extension ChangeEmailViewModelSwiftUIIntegrationTest {
  /// Submits updated email and current password credentials for saving.
  public func updateEmail(newEmail: String, currentPassword: String) {
    self.updateEmailAndPasswordProperty.value = (newEmail, currentPassword)
  }

  /// Records edits to the new-email input field.
  public func emailFieldTextDidChange(text: String?) {
    self.newEmailProperty.value = text
  }

  /// Records edits to the current-password input field.
  public func passwordFieldTextDidChange(text: String?) {
    self.passwordProperty.value = text
  }

  /// Triggers resending the account email verification message.
  public func resendVerificationEmailButtonTapped() {
    self.resendVerificationEmailButtonProperty.value = ()
  }

  /// Signals that the change-email view finished loading and should fetch user email state.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Sends a save trigger event through `saveTriggered`.
  public func didTapSaveButton() {
    self.saveTriggered.send(true)
  }

  /// Type-safe inputs interface for this view model.
  public var inputs: ChangeEmailViewModelInputsSwiftUIIntegrationTest {
    return self
  }

  /// Type-safe outputs interface for this view model.
  public var outputs: ChangeEmailViewModelOutputsSwiftUIIntegrationTest {
    return self
  }
}

