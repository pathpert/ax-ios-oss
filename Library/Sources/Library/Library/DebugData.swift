import Foundation
import KsApi

/// Immutable value type representing `DebugData`.
public struct DebugData {
  public let config: Config?

  public init(config: Config?) {
    self.config = config
  }
}
