import Apollo
import Combine
import Foundation
import GraphAPI
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

public extension Bundle {
  /// Returns `CFBundleVersion` from Info.plist, falling back to `"1"` if absent.
  var _buildVersion: String {
    return (self.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
  }
}

/// A `ServiceType` that requests data from an API webservice.
/// Implementations are modularized by domain across `Service+Auth.swift`,
/// `Service+Backing.swift`, `Service+Checkout.swift`, `Service+Discovery.swift`,
/// `Service+Messages.swift`, `Service+Projects.swift`, and `Service+UserAndMessages.swift`.
/// - Negative Constraint: Do not instantiate ad-hoc `URLSession` clients bypassing `Service`; route through `ServiceType`.
public struct Service: ServiceType {
  /// Application bundle identifier sent in Kickstarter HTTP request headers.
  public let appId: String
  /// Environment endpoint configuration (production, staging, local).
  public let serverConfig: ServerConfigType
  /// Optional OAuth bearer token authenticating REST and GraphQL requests.
  public let oauthToken: OauthTokenAuthType?
  /// BCP-47 language code sent in `Accept-Language` and GraphQL locale headers.
  public let language: String
  /// Preferred ISO 4217 currency code for server-side formatting.
  public let currency: String
  /// Numeric application build version string.
  public let buildVersion: String
  /// Vendor device identifier used for analytics and attribution headers.
  public let deviceIdentifier: String
  /// Optional injected Apollo client override (reserved for `ServiceType` conformance / testing).
  public let apolloClient: ApolloClientType?

  /// Creates a `Service` instance and configures the shared GraphQL client headers.
  public init(
    appId: String = Bundle.main.bundleIdentifier ?? "com.kickstarter.kickstarter",
    serverConfig: ServerConfigType = ServerConfig.production,
    oauthToken: OauthTokenAuthType? = nil,
    language: String = "en",
    currency: String = "USD",
    buildVersion: String = Bundle.main._buildVersion,
    deviceIdentifier: String = UIDevice.current.identifierForVendor.coalesceWith(UUID()).uuidString,
    apolloClient: ApolloClientType? = nil
  ) {
    self.appId = appId
    self.serverConfig = serverConfig
    self.oauthToken = oauthToken
    self.language = language
    self.currency = currency
    self.buildVersion = buildVersion
    self.deviceIdentifier = deviceIdentifier
    /// Dummy client, only required to satisfy `ApolloClientType` protocol, not used.
    self.apolloClient = apolloClient

    // Global override required for injecting custom User-Agent header in ajax requests
    UserDefaults.standard.register(defaults: ["UserAgent": Service.userAgent])

    // Configure GraphQL Client
    GraphQL.shared.configure(
      with: serverConfig.graphQLEndpointUrl,
      headers: self.defaultHeaders,
      additionalHeaders: { [:] }
    )
  }

  /// Executes a typed GraphQL query and emits its decoded `Data` via `SignalProducer`.
  public func fetch<Q: GraphQLQuery>(query: Q) -> SignalProducer<Q.Data, ErrorEnvelope> {
    GraphQL.shared.client.fetch(query: query)
  }

  /// Executes a typed GraphQL query asynchronously and returns its decoded `Data`, if present.
  public func fetch<Q: GraphQLQuery>(query: Q) async throws -> Q.Data? {
    let client = AsyncApolloClient(client: GraphQL.shared.client)
    return try await client.fetch(query).data
  }

  internal func performEmptyMutation<Mutation: GraphQLMutation>(
    _ mutation: Mutation
  ) -> SignalProducer<EmptyResponseEnvelope, ErrorEnvelope> {
    return GraphQL.shared.client
      .perform(mutation: mutation)
      .flatMap { _ in
        SignalProducer(value: EmptyResponseEnvelope())
      }
  }
}
