import Foundation

/// @deprecated Legacy change-password input primitive.
/// Prefer `ChangePasswordRequestSchema` and `AccountController.handleChangePassword(payload:headers:)`
/// in `KsApi/modules/account`.
/// - Negative Constraint: Do not use for new password update callers; migrate to `ChangePasswordRequestSchema`.
public struct ChangePasswordInput: GraphMutationInput, Encodable {
  let currentPassword: String
  let newPassword: String
  let newPasswordConfirmation: String

  private enum CodingKeys: String, CodingKey {
    case currentPassword
    case newPassword = "password"
    case newPasswordConfirmation = "passwordConfirmation"
  }

  /// Creates a legacy change-password mutation input.
  ///
  /// - Negative constraint: Do not pass mismatched `newPassword` and `newPasswordConfirmation` values.
  public init(currentPassword: String, newPassword: String, newPasswordConfirmation: String) {
    self.currentPassword = currentPassword
    self.newPassword = newPassword
    self.newPasswordConfirmation = newPasswordConfirmation
  }
}
