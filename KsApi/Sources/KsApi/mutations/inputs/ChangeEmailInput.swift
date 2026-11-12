import Foundation

/// @deprecated Legacy change-email input primitive.
/// Prefer `ChangeEmailRequestSchema` and `AccountController.handleChangeEmail(payload:headers:)`
/// in `KsApi/modules/account`.
/// - Negative Constraint: Do not use for new email update callers; migrate to `ChangeEmailRequestSchema`.
public struct ChangeEmailInput: GraphMutationInput, Encodable {
  /// New email address requested for the account.
  ///
  /// - Negative constraint: Do not pass unvalidated empty strings.
  public let email: String
  /// Current account password used to authorize the email update.
  ///
  /// - Negative constraint: Do not log or persist this plaintext secret.
  public let currentPassword: String

  /// Creates a legacy change-email mutation input.
  public init(email: String, currentPassword: String) {
    self.currentPassword = currentPassword
    self.email = email
  }
}
