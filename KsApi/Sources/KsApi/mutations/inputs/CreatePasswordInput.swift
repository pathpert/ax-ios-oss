import Foundation

/// GraphQL mutation input for setting an initial password on an account.
///
/// - Negative constraint: Do not use for changing an existing password; use `ChangePasswordInput` instead.
public struct CreatePasswordInput: GraphMutationInput, Encodable {
  let password: String
  let passwordConfirmation: String

  /// Creates a password creation mutation input.
  public init(password: String, passwordConfirmation: String) {
    self.password = password
    self.passwordConfirmation = passwordConfirmation
  }
}
