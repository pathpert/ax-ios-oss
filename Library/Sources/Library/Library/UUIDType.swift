import Foundation

/// Contract defining `UUIDType` capabilities and boundaries.
public protocol UUIDType {
  var uuidString: String { get }
  init()
}

extension UUID: UUIDType {}
