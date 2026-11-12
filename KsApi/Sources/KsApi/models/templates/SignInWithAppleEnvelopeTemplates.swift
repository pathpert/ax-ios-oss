import Foundation

extension SignInWithAppleEnvelope {
  /// Reusable fixture template for Sign in with Apple response unit tests.
  /// - Negative Constraint: Do not use in production builds.
  public static let template = SignInWithAppleEnvelope(
    signInWithApple: SignInWithAppleEnvelope.SignInWithApple(
      apiAccessToken: "api_access_token",
      user: SignInWithAppleEnvelope.User(uid: "1")
    )
  )
}
