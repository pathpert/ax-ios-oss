import Combine
import Foundation
import GraphAPI
import ReactiveSwift

/// Domain-scoped protocol for authentication, session management, OAuth token exchange, and email verification.
public protocol ServiceAuthType {
  /// Returns a new service with the oauth token replaced.
  /// - Returns: A copy of `Self` authenticated with `oauthToken`.
  func login(_ oauthToken: OauthTokenAuthType) -> Self

  /// Returns a new service with the oauth token set to `nil`.
  /// - Returns: An unauthenticated copy of `Self`.
  func logout() -> Self

  /// Request to connect user to Facebook with access token.
  /// - Returns: `SignalProducer` emitting the updated `User` or an `ErrorEnvelope`.
  func facebookConnect(facebookAccessToken token: String) -> SignalProducer<User, ErrorEnvelope>

  /// Attempt a login with an email, password and optional 2FA code.
  /// - Returns: `SignalProducer` emitting `AccessTokenEnvelope` or an `ErrorEnvelope` (e.g. `.TfaRequired`).
  func login(email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Attempt a login with Facebook access token and optional code.
  /// - Returns: `SignalProducer` emitting `AccessTokenEnvelope` or an `ErrorEnvelope`.
  func login(facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Reset user password with email address.
  /// - Returns: `SignalProducer` emitting the target `User` account or an `ErrorEnvelope`.
  func resetPassword(email: String) -> SignalProducer<User, ErrorEnvelope>

  /// Sends a verification email (after updating the email from account settings).
  /// - Returns: `SignalProducer` emitting `EmptyResponseEnvelope` or an `ErrorEnvelope`.
  func sendVerificationEmail(input: EmptyInput)
    -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope>

  /// Signin with Apple.
  /// - Returns: `SignalProducer` emitting `SignInWithAppleEnvelope` or an `ErrorEnvelope`.
  func signInWithApple(input: SignInWithAppleInput)
    -> SignalProducer<SignInWithAppleEnvelope, ErrorEnvelope>

  /// Signup with Facebook access token and newsletter opt-in flag.
  /// - Returns: `SignalProducer` emitting `AccessTokenEnvelope` or an `ErrorEnvelope`.
  func signup(facebookAccessToken: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope>

  /// Verifies an email address with a given access token.
  /// - Returns: `SignalProducer` emitting `EmailVerificationResponseEnvelope` or an `ErrorEnvelope`.
  func verifyEmail(withToken token: String)
    -> SignalProducer<EmailVerificationResponseEnvelope, ErrorEnvelope>

  /// Exchanges an authorization code/token for an OAuth access token.
  /// - Returns: `AnyPublisher` emitting `OAuthTokenExchangeResponse` or an `ErrorEnvelope`.
  func exchangeTokenForOAuthToken(params: OAuthTokenExchangeParams)
    -> AnyPublisher<OAuthTokenExchangeResponse, ErrorEnvelope>
}

