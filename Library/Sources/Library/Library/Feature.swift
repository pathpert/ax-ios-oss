import Foundation

/// Client-side `Feature` flags tracked by the application.
public enum Feature: String, CaseIterable {
  /// Segment analytics SDK integration flag (`"ios_segment"`).
  case segment = "ios_segment"
}

extension Feature: CustomStringConvertible {
  /// Human-readable display name for debugging and beta tools.
  public var description: String {
    switch self {
    case .segment: return "Segment"
    }
  }
}
