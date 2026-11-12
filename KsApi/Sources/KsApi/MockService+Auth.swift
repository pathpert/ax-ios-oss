#if DEBUG
  import Apollo
  import Combine
  import Foundation
  import GraphAPI
  import Prelude
  import ReactiveSwift

/// `MockService` extensions declared in `MockService+Auth.swift`.
  extension MockService {
    internal func login(_ oauthToken: OauthTokenAuthType) -> MockService {
      var copy = self
      copy.oauthToken = oauthToken
      return copy
    }

    internal func logout() -> MockService {
      var copy = self
      copy.oauthToken = nil
      return copy
    }

    internal func facebookConnect(facebookAccessToken _: String)
      -> SignalProducer<User, ErrorEnvelope> {
      if let response = facebookConnectResponse {
        return SignalProducer(value: response)
      } else if let error = facebookConnectError {
        return SignalProducer(error: error)
      }

      return SignalProducer(
        value:
        User.template
          |> \.id .~ 1
          |> \.facebookConnected .~ true
      )
    }

    internal func login(email _: String, password _: String, code _: String?) ->
      SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
      if let error = loginError {
        return SignalProducer(error: error)
      } else if let accessTokenEnvelope = loginResponse {
        return SignalProducer(value: accessTokenEnvelope)
      } else if let resendCodeResponse = resendCodeResponse {
        return SignalProducer(error: resendCodeResponse)
      } else if let resendCodeError = resendCodeError {
        return SignalProducer(error: resendCodeError)
      }

      return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: .template))
    }

    internal func login(facebookAccessToken _: String, code _: String?) ->
      SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
      if let error = loginError {
        return SignalProducer(error: error)
      } else if let accessTokenEnvelope = loginResponse {
        return SignalProducer(value: accessTokenEnvelope)
      } else if let resendCodeResponse = resendCodeResponse {
        return SignalProducer(error: resendCodeResponse)
      } else if let resendCodeError = resendCodeError {
        return SignalProducer(error: resendCodeError)
      }

      return SignalProducer(value: AccessTokenEnvelope(accessToken: "deadbeef", user: .template))
    }

    func resetPassword(email _: String) -> SignalProducer<User, ErrorEnvelope> {
      if let response = resetPasswordResponse {
        return SignalProducer(value: response)
      } else if let error = resetPasswordError {
        return SignalProducer(error: error)
      }
      return SignalProducer(value: .template)
    }

    internal func sendVerificationEmail(input _: EmptyInput)
      -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutationSendVerificationEmail = GraphAPI
        .UserSendEmailVerificationMutation(input: GraphAPI.UserSendEmailVerificationInput())

      return client
        .performWithResult(mutation: mutationSendVerificationEmail, result: self.sendEmailVerificationResult)
    }

    internal func signInWithApple(input: SignInWithAppleInput)
      -> SignalProducer<SignInWithAppleEnvelope, ErrorEnvelope> {
      guard let client = self.apolloClient else {
        return .empty
      }

      let mutationSignInWithApple = GraphAPI
        .SignInWithAppleMutation(input: GraphAPI.SignInWithAppleInput.from(input))

      return client
        .performWithResult(mutation: mutationSignInWithApple, result: self.signInWithAppleResult)
    }

    internal func signup(facebookAccessToken _: String, sendNewsletters _: Bool) ->
      SignalProducer<AccessTokenEnvelope, ErrorEnvelope> {
      if let error = signupError {
        return SignalProducer(error: error)
      } else if let accessTokenEnvelope = signupResponse {
        return SignalProducer(value: accessTokenEnvelope)
      }
      return SignalProducer(
        value:
        AccessTokenEnvelope(
          accessToken: "deadbeef",
          user: .template
        )
      )
    }

    internal func verifyEmail(withToken _: String)
      -> SignalProducer<EmailVerificationResponseEnvelope, ErrorEnvelope> {
      return producer(for: self.verifyEmailResult)
    }

    func exchangeTokenForOAuthToken(params _: OAuthTokenExchangeParams)
      -> AnyPublisher<OAuthTokenExchangeResponse, ErrorEnvelope> {
      if let tokenExchangeResponse = self.tokenExchangeResponse {
        return Just(tokenExchangeResponse).setFailureType(to: ErrorEnvelope.self).eraseToAnyPublisher()
      } else if let loginError = self.loginError {
        return Fail(outputType: OAuthTokenExchangeResponse.self, failure: loginError).eraseToAnyPublisher()
      } else {
        return Empty(completeImmediately: false).eraseToAnyPublisher()
      }
    }

    internal func fetch<Q: GraphQLQuery>(query _: Q) -> SignalProducer<Q.Data, ErrorEnvelope> {
      for (queryType, result) in self.fetchGraphQLResponses ?? [] {
        if queryType == Q.self, let response = result as? Q.Data {
          return SignalProducer(value: response)
        }
      }
      return SignalProducer(error: ErrorEnvelope.graphError("Unimplemented mock"))
    }

    internal func fetch<Q: GraphQLQuery>(query _: Q) async throws -> Q.Data? {
      for (queryType, result) in self.fetchGraphQLResponses ?? [] {
        if queryType == Q.self, let response = result as? Q.Data {
          return response
        }
      }
      throw ErrorEnvelope.graphError("Unimplemented mock")
    }
  }
#endif

