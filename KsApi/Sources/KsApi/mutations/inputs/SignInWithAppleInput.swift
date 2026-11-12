import Foundation

/// @deprecated Legacy Apple Sign-In input primitive.
/// Prefer `SignInWithAppleRequestSchema` and `AuthController.handleSignInWithApple(payload:headers:)`
/// in `KsApi/modules/auth`.
///
/// Negative Constraint: Do not construct new Sign in with Apple calls with this legacy struct; route through `AuthController`.
public struct SignInWithAppleInput: GraphMutationInput {
  /// Bundle / iOS App identifier serialized as `iosAppId`.
  public let appId: String
  /// Short-lived Apple authorization code returned by `ASAuthorizationAppleIDCredential`.
  public let authCode: String
  /// Optional first name supplied by Apple on first sign-in only.
  public let firstName: String?
  /// Optional last name supplied by Apple on first sign-in only.
  public let lastName: String?

  /// Creates a legacy Apple Sign-In mutation input.
  public init(appId: String, authCode: String, firstName: String?, lastName: String?) {
    self.appId = appId
    self.authCode = authCode
    self.firstName = firstName
    self.lastName = lastName
  }
}

extension SignInWithAppleInput: Encodable {
  enum CodingKeys: String, CodingKey {
    case appId = "iosAppId"
    case authCode
    case firstName
    case lastName
  }
}
