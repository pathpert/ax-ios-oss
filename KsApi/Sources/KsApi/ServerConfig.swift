import Foundation

/// A type that knows the location of a Kickstarter API and web server.
/// - Negative Constraint: Do not hardcode environment hosts directly in feature views; inject `ServerConfigType`.
public protocol ServerConfigType {
  var apiBaseUrl: URL { get }
  var webBaseUrl: URL { get }
  var apiClientAuth: ClientAuthType { get }
  var basicHTTPAuth: BasicHTTPAuthType? { get }
  var graphQLEndpointUrl: URL { get }
  var environment: EnvironmentType { get }
}

/// Equality operator comparing two `ServerConfigType` values.
public func == (lhs: ServerConfigType, rhs: ServerConfigType) -> Bool {
  return
    type(of: lhs) == type(of: rhs) &&
    lhs.apiBaseUrl == rhs.apiBaseUrl &&
    lhs.webBaseUrl == rhs.webBaseUrl &&
    lhs.apiClientAuth == rhs.apiClientAuth &&
    lhs.basicHTTPAuth == rhs.basicHTTPAuth &&
    lhs.graphQLEndpointUrl == rhs.graphQLEndpointUrl &&
    lhs.environment == rhs.environment
}

private let gqlPath = "graph"

/// Concrete server endpoint configuration implementing `ServerConfigType`.
public struct ServerConfig: ServerConfigType {
  /// Base REST API endpoint URL.
  public var apiBaseUrl: URL
  /// Base Kickstarter web URL.
  public var webBaseUrl: URL
  /// OAuth client credentials attached to API requests.
  public var apiClientAuth: ClientAuthType
  /// Optional HTTP Basic Auth credentials for non-production environments.
  public var basicHTTPAuth: BasicHTTPAuthType?
  /// GraphQL API endpoint URL.
  public var graphQLEndpointUrl: URL
  /// Target deployment environment.
  public var environment: EnvironmentType

  /// Production server configuration.
  public static let production: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.production)")!,
    webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.production)")!,
    apiClientAuth: ClientAuth.production,
    basicHTTPAuth: nil,
    graphQLEndpointUrl: URL(string: "https://\(Secrets.WebEndpoint.production)")!
      .appendingPathComponent(gqlPath),
    environment: EnvironmentType.production
  )

  /// Staging server configuration.
  public static let staging: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.staging)")!,
    webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.staging)")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: BasicHTTPAuth.development,
    graphQLEndpointUrl: URL(string: "https://\(Secrets.WebEndpoint.staging)")!
      .appendingPathComponent(gqlPath),
    environment: EnvironmentType.staging
  )

  /// Development server configuration.
  public static let development: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: "https://\(Secrets.Api.Endpoint.development)")!,
    webBaseUrl: URL(string: "https://\(Secrets.WebEndpoint.development)")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: BasicHTTPAuth.development,
    graphQLEndpointUrl: URL(string: "https://\(Secrets.WebEndpoint.development)")!
      .appendingPathComponent(gqlPath),
    environment: EnvironmentType.development
  )

  /// Local development server configuration.
  public static let local: ServerConfigType = ServerConfig(
    apiBaseUrl: URL(string: "http://api.ksr.test")!,
    webBaseUrl: URL(string: "http://ksr.test")!,
    apiClientAuth: ClientAuth.development,
    basicHTTPAuth: BasicHTTPAuth.development,
    graphQLEndpointUrl: URL(string: "http://ksr.test")!.appendingPathComponent(gqlPath),
    environment: EnvironmentType.local
  )

  /// Initializes a server configuration with explicit endpoint URLs and auth credentials.
  public init(
    apiBaseUrl: URL,
    webBaseUrl: URL,
    apiClientAuth: ClientAuthType,
    basicHTTPAuth: BasicHTTPAuthType?,
    graphQLEndpointUrl: URL,
    environment: EnvironmentType = .production
  ) {
    self.apiBaseUrl = apiBaseUrl
    self.webBaseUrl = webBaseUrl
    self.apiClientAuth = apiClientAuth
    self.basicHTTPAuth = basicHTTPAuth
    self.graphQLEndpointUrl = graphQLEndpointUrl
    self.environment = environment
  }

  /// Resolves the `ServerConfigType` corresponding to the given `EnvironmentType`.
  public static func config(for environment: EnvironmentType) -> ServerConfigType {
    switch environment {
    case let .custom(url):
      guard let url = url else {
        return ServerConfig.development
      }
      return ServerConfig(
        apiBaseUrl: URL(string: "https://api-\(url).dev.kickstarter.com")!,
        webBaseUrl: URL(string: "https://\(url).dev.kickstarter.com")!,
        apiClientAuth: ClientAuth.development,
        basicHTTPAuth: BasicHTTPAuth.development,
        graphQLEndpointUrl: URL(string: "https://\(url).dev.kickstarter.com")!
          .appendingPathComponent(gqlPath),
        environment: EnvironmentType.custom(url)
      )
    case .local:
      return ServerConfig.local
    case .development:
      return ServerConfig.development
    case .staging:
      return ServerConfig.staging
    case .production:
      return ServerConfig.production
    }
  }
}
