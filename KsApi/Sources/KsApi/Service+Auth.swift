import Combine
import Foundation
import GraphAPI
import ReactiveSwift

extension Service {
  /// Returns a new `Service` instance authenticated with `oauthToken` without mutating `self`.
  public func login(_ oauthToken: OauthTokenAuthType) -> Service {
    return Service(
      appId: self.appId,
      serverConfig: self.serverConfig,
      oauthToken: oauthToken,
      language: self.language,
      buildVersion: self.buildVersion
    )
  }

  /// Returns an anonymous `Service` instance with `oauthToken` cleared without mutating `self`.
  public func logout() -> Service {
    return Service(
      appId: self.appId,
      serverConfig: self.serverConfig,
      oauthToken: nil,
      language: self.language,
      buildVersion: self.buildVersion
    )
  }

  /// Links a Facebook access token to the authenticated user's account.
  public func facebookConnect(facebookAccessToken token: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.facebookConnect(facebookAccessToken: token))
  }

  /// Authenticates an account with email, password, and optional 2FA verification code.
  /// - Negative Constraint: Pass `code: nil` only on initial attempt before a two-factor challenge is raised.
  public func login(email: String, password: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return request(.login(email: email, password: password, code: code))
  }

  /// Authenticates an existing user via Facebook OAuth access token and optional 2FA code.
  public func login(facebookAccessToken: String, code: String?) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return request(.facebookLogin(facebookAccessToken: facebookAccessToken, code: code))
  }

  /// Requests a password-reset email for the specified Kickstarter account email.
  public func resetPassword(email: String) -> SignalProducer<User, ErrorEnvelope> {
    return request(.resetPassword(email: email))
  }

  /// Triggers a verification email to the authenticated user's primary email address.
  public func sendVerificationEmail(input _: EmptyInput) ->
    SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return self.performEmptyMutation(
      GraphAPI.UserSendEmailVerificationMutation(input: GraphAPI.UserSendEmailVerificationInput())
    )
  }

  /// Authenticates or registers a user via Sign in with Apple GraphQL mutation.
  public func signInWithApple(input: SignInWithAppleInput)
    -> SignalProducer<SignInWithAppleEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: GraphAPI.SignInWithAppleMutation(input: GraphAPI.SignInWithAppleInput.from(input)))
      .flatMap(SignInWithAppleEnvelope.producer(from:))
  }

  /// Registers a new Kickstarter account backed by a Facebook OAuth token.
  public func signup(facebookAccessToken token: String, sendNewsletters: Bool) ->
    SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
    return request(.facebookSignup(facebookAccessToken: token, sendNewsletters: sendNewsletters))
  }

  /// Confirms the user's email address using an email verification access token.
  public func verifyEmail(withToken token: String)
    -> SignalProducer<EmailVerificationResponseEnvelope, ErrorEnvelope> {
    request(.verifyEmail(accessToken: token))
  }

  /// Exchanges an authorization code (PKCE) for a Kickstarter OAuth bearer token via Combine.
  public func exchangeTokenForOAuthToken(params: OAuthTokenExchangeParams)
    -> AnyPublisher<OAuthTokenExchangeResponse, ErrorEnvelope> {
    return request(.exchangeToken(params: params))
  }
}

