import Foundation

/// Attempts to JSON-serialize an untyped Foundation primitive (`Dictionary`/`Array`) and decode it as `T`.
/// - Negative Constraint: Do not use for new networking paths that already receive raw `Data` or typed GraphQL fragments.
public func tryDecode<T: Decodable>(_ primitive: Any) -> T? {
  guard
    let data = try? JSONSerialization.data(withJSONObject: primitive, options: []),
    let value = try? JSONDecoder().decode(T.self, from: data)
  else { return nil }

  return value
}
