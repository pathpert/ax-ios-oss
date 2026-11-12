import Foundation

/// Bridges integer REST model IDs to Base64-encoded Relay/GraphQL global node identifiers (`"<modelName>-<id>"`).
///
/// Negative Constraint: Do not use when the backend global ID format is non-numeric or opaque.
public protocol GraphIDBridging {
  static var modelName: String { get }
  var graphID: String { get }
  var id: Int { get }
}

extension GraphIDBridging {
  /// Base64-encoded GraphQL global node ID derived from `modelName` and `id`.
  public var graphID: String {
    return Data("\(type(of: self).modelName)-\(self.id)".utf8).base64EncodedString()
  }
}
