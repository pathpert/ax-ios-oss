import Foundation
import KsApi

/// `ServerFeature` extensions declared in `ServerFeature+Helpers.swift`.
extension ServerFeature {
  private func isEnabled(in environment: Environment = AppEnvironment.current) -> Bool {
    environment.currentUserServerFeatures?.contains(self) ?? false
  }
}
