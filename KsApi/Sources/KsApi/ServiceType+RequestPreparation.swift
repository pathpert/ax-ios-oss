import CoreFoundation
import Foundation
import Prelude
import UIKit

extension ServiceType {
  /// Prepares a URL request without extra query parameters.
  /// - parameter originalRequest: The request that should be prepared.
  /// - returns: A new URL request configured for the server.
  public func preparedRequest(forRequest originalRequest: URLRequest) -> URLRequest {
    return self.preparedRequest(forRequest: originalRequest, params: EmptyQueryParams())
  }

  /// Prepares a URL request using a strongly-typed `EncodableQueryParams` contract.
  /// - parameter originalRequest: The request that should be prepared.
  /// - parameter params: Strongly-typed query/body parameters.
  /// - returns: A new URL request configured for the server.
  public func preparedRequest<P: EncodableQueryParams>(forRequest originalRequest: URLRequest, params: P)
    -> URLRequest {
    return self.applyQueryParams(params, to: originalRequest)
  }

  /// Prepares a URL request using an existential `EncodableQueryParams` contract (e.g. from `Route`).
  /// - parameter originalRequest: The request that should be prepared.
  /// - parameter params: Strongly-typed query/body parameters.
  /// - returns: A new URL request configured for the server.
  public func preparedRequest(forRequest originalRequest: URLRequest, params: any EncodableQueryParams)
    -> URLRequest {
    return self.applyQueryParams(params, to: originalRequest)
  }

  private func applyQueryParams<P: EncodableQueryParams>(_ params: P, to originalRequest: URLRequest)
    -> URLRequest {
    var request = originalRequest
    guard let URL = request.url else {
      return originalRequest
    }

    var headers = self.defaultHeaders

    let method = request.httpMethod?.uppercased()
    var components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    var queryItems = components.queryItems ?? []
    queryItems.append(contentsOf: self.defaultQueryParams.map(URLQueryItem.init(name:value:)))

    if method == .some("POST") || method == .some("PUT") {
      if request.httpBody == nil {
        headers["Content-Type"] = "application/json; charset=utf-8"
        request.httpBody = params.encodedJSONData()
      }
    } else {
      queryItems.append(contentsOf: params.encodedQueryItems())
    }
    components.queryItems = queryItems.sorted { $0.name < $1.name }
    request.url = components.url

    let currentHeaders = request.allHTTPHeaderFields ?? [:]
    request.allHTTPHeaderFields = currentHeaders.withAllValuesFrom(headers)

    return request
  }

  /// Prepares a request without extra query parameters.
  /// - parameter url: The URL to turn into a request and prepare.
  /// - parameter method: The HTTP verb to use for the request.
  /// - returns: A new URL request configured for the server.
  public func preparedRequest(forURL url: URL, method: Method = .GET) -> URLRequest {
    return self.preparedRequest(forURL: url, method: method, params: EmptyQueryParams())
  }

  /// Prepares a request to be sent to the server using strongly-typed `EncodableQueryParams`.
  /// - parameter url: The URL to turn into a request and prepare.
  /// - parameter method: The HTTP verb to use for the request.
  /// - parameter params: Strongly-typed query/body parameters.
  /// - returns: A new URL request configured for the server.
  public func preparedRequest<P: EncodableQueryParams>(
    forURL url: URL,
    method: Method = .GET,
    params: P
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return self.preparedRequest(forRequest: request, params: params)
  }

  /// Prepares a request using an existential `EncodableQueryParams` value.
  public func preparedRequest(
    forURL url: URL,
    method: Method = .GET,
    params: any EncodableQueryParams
  ) -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = method.rawValue
    return self.preparedRequest(forRequest: request, params: params)
  }

  /// Prepares a URL request to be sent to the server for GraphQL mutations.
  /// - parameter url: GraphQL endpoint URL.
  /// - parameter queryString: GraphQL mutation query document.
  /// - parameter input: Mutation input dictionary passed under `variables.input`.
  /// - returns: Prepared `POST` `URLRequest` with JSON body and default headers.
  public func preparedGraphRequest<Input: Encodable>(
    forURL url: URL,
    queryString: String,
    input: Input
  ) throws -> URLRequest {
    var request = URLRequest(url: url)
    request.httpMethod = Method.POST.rawValue

    guard let URL = request.url else {
      return request
    }

    let requestBody = self.graphMutationRequestBody(mutation: queryString, input: input)
    let jsonData = try JSONEncoder().encode(requestBody)

    request.httpBody = jsonData

    var headers = self.defaultHeaders
    headers["Content-Type"] = "application/json; charset=utf-8"

    let components = URLComponents(url: URL, resolvingAgainstBaseURL: false)!
    request.url = components.url
    request.allHTTPHeaderFields = headers

    return request
  }

  /// Returns whether `request` already carries the service's authorization and Kickstarter app headers.
  public func isPrepared(request: URLRequest) -> Bool {
    return request.value(forHTTPHeaderField: "Authorization") == self.authorizationHeader
      && request.value(forHTTPHeaderField: "Kickstarter-iOS-App") != nil
  }

  /// Injects v1 OAuth bearer token header (`X-Auth`) into a mutable `URLRequest`.
  /// - Negative Constraint: Do not pass raw unauthenticated tokens in query parameters.
  public func addV1AuthenticationToRequest(_ request: inout URLRequest, oauthToken: String) {
    var headers = request.allHTTPHeaderFields ?? [:]
    headers["X-Auth"] = "token \(oauthToken)"
    request.allHTTPHeaderFields = headers
  }

  internal var defaultHeaders: [String: String] {
    var headers: [String: String] = [:]
    headers["Accept-Language"] = self.language
    headers["Kickstarter-App-Id"] = self.appId
    headers["Kickstarter-iOS-App"] = self.buildVersion
    headers["User-Agent"] = Self.userAgent
    headers["X-KICKSTARTER-CLIENT"] = self.serverConfig.apiClientAuth.clientId
    headers["Kickstarter-iOS-App-UUID"] = self.deviceIdentifier

    headers["Authorization"] = self.authorizationHeader
    if let oAuthHeader = self.oAuthAuthorizationHeader {
      headers["X-Auth"] = oAuthHeader
    }

    return headers
  }

  func graphMutationRequestBody<Input: Encodable>(
    mutation: String,
    input: Input
  ) -> AXGraphMutationBody<Input> {
    return AXGraphMutationBody(query: mutation, input: input)
  }

  /// Computed `User-Agent` header string combining app bundle name, build version, device model, and OS scale.
  public static var userAgent: String {
    let executable = Bundle.main.infoDictionary?["CFBundleExecutable"] as? String
    let bundleIdentifier = Bundle.main.infoDictionary?["CFBundleIdentifier"] as? String
    let app: String = executable ?? bundleIdentifier ?? "Kickstarter"
    let bundleVersion: String = (Bundle.main.infoDictionary?["CFBundleVersion"] as? String) ?? "1"
    let model = UIDevice.current.model
    let systemVersion = UIDevice.current.systemVersion
    let scale = UIScreen.main.scale

    return "\(app)/\(bundleVersion) (\(model); iOS \(systemVersion) Scale/\(scale))"
  }

  private var oAuthAuthorizationHeader: String? {
    guard let token = self.oauthToken?.token else {
      return nil
    }

    return "token \(token)"
  }

  private var authorizationHeader: String? {
    if let header = oAuthAuthorizationHeader {
      return header
    } else {
      return self.serverConfig.basicHTTPAuth?.authorizationHeader
    }
  }

  private var defaultQueryParams: [String: String] {
    var query: [String: String] = [:]
    query["client_id"] = self.serverConfig.apiClientAuth.clientId
    query["currency"] = self.currency
    return query
  }
}

/// Strongly typed GraphQL mutation request envelope eliminating untyped dictionary input serialization.
internal struct AXGraphMutationBody<Input: Encodable>: Encodable {
  internal struct Variables<Value: Encodable>: Encodable {
    internal let input: Value
  }

  internal let query: String
  internal let variables: Variables<Input>

  internal init(query: String, input: Input) {
    self.query = query
    self.variables = Variables(input: input)
  }
}

