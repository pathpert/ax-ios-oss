import Apollo
import ApolloAPI
import Combine
import GraphAPI
import Prelude
import ReactiveSwift
import UIKit

/// Mailbox folder filter for user/creator messaging queries.
public enum Mailbox: String {
  /// Incoming messages addressed to the current user.
  case inbox
  /// Outgoing messages sent by the current user.
  case sent
}

/// A type that knows how to perform requests for Kickstarter data.
/// Composed from domain-scoped sub-protocols (`ServiceAuthType`, `ServiceBackingType`,
/// `ServiceCheckoutType`, `ServiceDiscoveryType`, `ServiceProjectsType`, `ServiceUserType`,
/// `ServiceMessagingAndCommentsType`) so each protocol file stays concise (< 300 lines) while
/// preserving full witness-table dispatch on `any ServiceType`.
/// - Negative Constraint: Do not add unrelated domain methods directly here; extend the matching `Service*Type` sub-protocol.
public protocol ServiceType:
  ServiceAuthType,
  ServiceBackingType,
  ServiceCheckoutType,
  ServiceDiscoveryType,
  ServiceProjectsType,
  ServiceUserType,
  ServiceMessagingAndCommentsType {
  /// Application bundle identifier sent with API requests.
  var appId: String { get }
  /// Target server configuration (hosts, Basic Auth, GraphQL endpoint).
  var serverConfig: ServerConfigType { get }
  /// Optional OAuth bearer token authenticating user-scoped requests.
  var oauthToken: OauthTokenAuthType? { get }
  /// Preferred BCP-47 locale identifier.
  var language: String { get }
  /// Preferred ISO 4217 currency code.
  var currency: String { get }
  /// Client bundle build version string.
  var buildVersion: String { get }
  /// Device UUID string used for attribution and push requests.
  var deviceIdentifier: String { get }
  /// Optional injected Apollo client override for GraphQL operations.
  var apolloClient: ApolloClientType? { get }

  /// Creates a configured `ServiceType` instance.
  init(
    appId: String,
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?,
    language: String,
    currency: String,
    buildVersion: String,
    deviceIdentifier: String,
    apolloClient: ApolloClientType?
  )

  /// Fetches a GraphQL query and returns the data.
  func fetch<Q: GraphQLQuery>(query: Q) -> SignalProducer<Q.Data, ErrorEnvelope>

  /// Fetches a GraphQL query with async/await and returns the data.
  func fetch<Q: GraphQLQuery>(query: Q) async throws -> Q.Data?
}

extension ServiceType {
  /// Returns `true` if an oauth token is present, and `false` otherwise.
  public var isAuthenticated: Bool {
    return self.oauthToken != nil
  }
}

/// Compares two `ServiceType` instances by concrete dynamic type, server config, token, language, and build version.
public func == (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return
    type(of: lhs) == type(of: rhs) &&
    lhs.serverConfig == rhs.serverConfig &&
    lhs.oauthToken == rhs.oauthToken &&
    lhs.language == rhs.language &&
    lhs.buildVersion == rhs.buildVersion
}

/// Returns `true` when two `ServiceType` instances differ in configuration, token, or build version.
public func != (lhs: ServiceType, rhs: ServiceType) -> Bool {
  return !(lhs == rhs)
}
