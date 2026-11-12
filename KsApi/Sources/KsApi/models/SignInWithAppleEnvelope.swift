import Foundation

/// GraphQL response envelope returned after Sign in with Apple authentication.
public struct SignInWithAppleEnvelope: Decodable {
  /// Nested authentication payload containing token and user identity.
  public var signInWithApple: SignInWithApple

  /// Signed-in session credentials returned by `signInWithApple`.
  public struct SignInWithApple: Decodable {
    /// Kickstarter API OAuth access token.
    public var apiAccessToken: String
    /// Minimal authenticated user identity.
    public var user: SignInWithAppleEnvelope.User
  }

  /// Minimal user identifier returned inside `SignInWithAppleEnvelope`.
  public struct User: Decodable {
    /// String user ID (`uid`) of the authenticated account.
    public var uid: String
  }
}
