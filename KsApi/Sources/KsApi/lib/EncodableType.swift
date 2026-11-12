import Foundation

/// A type that can encode itself into a `[String: Any]` dictionary for JSON serialization.
/// - Negative Constraint: `@deprecated` Untyped `[String: Any]` encoding is deprecated under AX Modernization Rule 3 & Rule 6; prefer `Swift.Codable` and AX Request Schemas under `KsApi/modules/{feature}`.
public protocol EncodableType {
  func encode() -> [String: Any]
}

public extension EncodableType {
  /**
   Returns `NSData` form of encoding.

   - returns: `NSData`
   */
  func toJSONData() -> Data? {
    return try? JSONSerialization.data(withJSONObject: encode(), options: [])
  }

  /**
   Returns `String` form of encoding.

   - returns: `String`
   */
  func toJSONString() -> String? {
    return self.toJSONData().flatMap { String(data: $0, encoding: .utf8) }
  }
}
