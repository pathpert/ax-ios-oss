import Foundation
import KsApi

/// Immutable value type representing `DebugData`.
public struct DebugData {
  /// Current remote server configuration loaded for debugging, if available.
  public let config: Config?

  /// Creates a `DebugData` snapshot with optional server configuration.
  public init(config: Config?) {
    self.config = config
  }
}
