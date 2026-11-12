/// A type that holds an API client id, which provides anonymous authentication to the API.
///
/// Negative Constraint: Do not confuse with `OauthTokenAuthType`, which authenticates an individual signed-in user session.
public protocol ClientAuthType {
  var clientId: String { get }
}

/// Compares two `ClientAuthType` values by concrete dynamic type and `clientId`.
public func == (lhs: ClientAuthType, rhs: ClientAuthType) -> Bool {
  return type(of: lhs) == type(of: rhs) &&
    lhs.clientId == rhs.clientId
}

/// Concrete API client identifier credentials used for anonymous/unauthenticated API requests.
public struct ClientAuth: ClientAuthType {
  /// OAuth client identifier string sent in API headers/params.
  public let clientId: String

  /// Initializes client credentials with an explicit `clientId`.
  public init(clientId: String) {
    self.clientId = clientId
  }

  /// Production API client credentials sourced from `Secrets.Api.Client`.
  public static let production: ClientAuthType = ClientAuth(
    clientId: Secrets.Api.Client.production
  )

  /// Staging/development API client credentials sourced from `Secrets.Api.Client`.
  public static let development: ClientAuthType = ClientAuth(
    clientId: Secrets.Api.Client.staging
  )
}
