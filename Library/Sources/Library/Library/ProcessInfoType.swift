import Foundation

/// Contract defining `ProcessInfoType` capabilities and boundaries.
public protocol ProcessInfoType {
  var environment: [String: String] { get }
}

extension ProcessInfo: ProcessInfoType {}
