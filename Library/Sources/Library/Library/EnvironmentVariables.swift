import Foundation

/// Process environment variable keys inspected at runtime in debug builds.
public enum VariableName: String {
  case trackingEnabled = "TRACKING_ENABLED"
}

/// Reader for process environment feature overrides such as `TRACKING_ENABLED`.
/// - Negative Constraint: Do not use `EnvironmentVariables` to toggle production flags; non-`DEBUG` builds always return `true` for tracking.
public struct EnvironmentVariables {
  private let processInfo: ProcessInfoType

  /// Creates an environment variable reader backed by `processInfo`.
  public init(processInfo: ProcessInfoType = ProcessInfo.processInfo) {
    self.processInfo = processInfo
  }
}

extension EnvironmentVariables {
  /// Returns whether analytics tracking is enabled (`true` in release; controlled by `TRACKING_ENABLED` in `DEBUG`).
  public var isTrackingEnabled: Bool {
    #if DEBUG
      guard let value = self.processInfo.environment[VariableName.trackingEnabled.rawValue] else {
        return false
      }

      return NSString(string: value).boolValue
    #else
      return true
    #endif
  }
}
