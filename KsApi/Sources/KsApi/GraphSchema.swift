import Foundation
import GraphAPI
import Prelude

// MARK: - Base Query Types

extension Never: CustomStringConvertible {
  /// Unreachable string conversion required for `CustomStringConvertible` conformance on `Never`.
  public var description: String {
    fatalError()
  }
}

/// Decodes a Base64-encoded UTF-8 string into plain text.
///
/// Negative Constraint: Do not pass raw unpadded URL-safe Base64 without padding normalization.
public func decodeBase64(_ input: String) -> String? {
  return Data(base64Encoded: input)
    .flatMap { String(data: $0, encoding: .utf8) }
}

/// Extracts the trailing integer database identifier from a Base64 GraphQL global node ID (e.g. `"Project-123"`).
///
/// Format: Base64 UTF-8 string `"<TypeName>-<Int>"`.
/// Negative Constraint: Returns `nil` for malformed or non-hyphenated IDs; do not force-unwrap.
public func decompose(id: String) -> Int? {
  return decodeBase64(id)
    .flatMap { id -> Int? in
      let pair = id.split(separator: "-", maxSplits: 1)
      return pair.last.flatMap { Int($0) }
    }
}

/// Encodes a plain UTF-8 string (such as `"Project-123"`) to standard Base64.
public func encodeToBase64(_ input: String) -> String {
  return Data(input.utf8).base64EncodedString()
}

/// Single GraphQL error message entry decoded from an API `errors` array.
public struct GraphResponseError: Decodable {
  /// Server-provided human-readable error message.
  public let message: String
}

/// Errors emitted by `ApolloClientType` / GraphQL request execution and JSON decoding.
public enum GraphError: Error {
  case invalidInput
  case invalidJson(responseString: String?)
  case requestError(Error, URLResponse?)
  case emptyResponse(URLResponse?)
  case decodeError(GraphResponseError)
  case jsonDecodingError(responseString: String?, error: Error?)
}

/// Type alias bridging the generated `GraphAPI.Feature` enum into `KsApi`.
public typealias ServerFeature = GraphAPI.Feature
extension ServerFeature: Decodable {}
