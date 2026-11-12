

/// OAuth response envelope containing a bearer access token and the authenticated user.
public struct AccessTokenEnvelope {
  /// Bearer OAuth token for authenticated Kickstarter REST and GraphQL requests.
  public let accessToken: String
  /// Authenticated `User` model returned by the sign-in or signup endpoint.
  public let user: User

  /// Creates an `AccessTokenEnvelope`.
  public init(accessToken: String, user: User) {
    self.accessToken = accessToken
    self.user = user
  }
}

extension AccessTokenEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case user
  }
}
