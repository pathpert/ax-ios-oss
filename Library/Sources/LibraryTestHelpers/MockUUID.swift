import Foundation
import Library

/// Immutable value type representing `MockUUID`.
internal struct MockUUID: UUIDType {
  var uuidString: String = "ABCD-123"
}
