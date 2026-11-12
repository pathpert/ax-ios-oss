/// A type that can provide oauth token authentication, i.e. a user's personal token.
///
/// Negative Constraint: Treat as sensitive secret material; never log raw tokens.
public protocol OauthTokenAuthType {
  var token: String { get }
}

/// Compares two `OauthTokenAuthType` instances by concrete dynamic type and `token`.
public func == (lhs: OauthTokenAuthType, rhs: OauthTokenAuthType) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs.token == rhs.token
}

/// Compares two optional `OauthTokenAuthType` instances by concrete dynamic type and `token`.
public func == (lhs: OauthTokenAuthType?, rhs: OauthTokenAuthType?) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs?.token == rhs?.token
}

/// Concrete bearer OAuth access token container for an authenticated Kickstarter user.
public struct OauthToken: OauthTokenAuthType {
  /// Raw bearer OAuth token string.
  public let token: String

  /// Creates an `OauthToken` wrapping a bearer access token string.
  public init(token: String) {
    self.token = token
  }
}
