import Foundation
import KsApi

/// `ServerFeature` extensions declared in `ServerFeature+Helpers.swift`.
extension ServerFeature {
  private func isEnabled(in environment: Environment = AppEnvironment.current) -> Bool {
    environment.currentUserServerFeatures?.contains(self) ?? false
  }
}

extension Set: KsApi.EncodableType where Element == ServerFeature {
  /// Encodes this set of server feature flags into a `["features": [String]]` JSON payload.
  public func encode() -> [String: Any] {
    ["features": Array(self).map { $0.rawValue }]
  }
}
