import Foundation

/// Request parameters for exchanging a PKCE authorization code for an OAuth access token.
///
/// Negative Constraint: `temporaryToken` and `codeVerifier` must both be non-empty strings from the active PKCE session.
public struct OAuthTokenExchangeParams: EncodableQueryParams, Equatable, Sendable {
  /// Creates typed PKCE token-exchange parameters.
  public init(temporaryToken: String, codeVerifier: String) {
    self.temporaryToken = temporaryToken
    self.codeVerifier = codeVerifier
  }

  let temporaryToken: String
  let codeVerifier: String

  enum CodingKeys: String, CodingKey {
    case temporaryToken = "code"
    case codeVerifier = "code_verifier"
  }
}

/// Response payload containing the exchanged OAuth bearer token.
public struct OAuthTokenExchangeResponse: Decodable {
  /// Exchanged OAuth access token string.
  public let token: String

  /// Creates an `OAuthTokenExchangeResponse` from a decoded token.
  public init(token: String) {
    self.token = token
  }
}
