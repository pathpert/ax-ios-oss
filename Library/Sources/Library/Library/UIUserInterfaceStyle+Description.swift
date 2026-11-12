import UIKit

/// `UIUserInterfaceStyle` extensions declared in `UIUserInterfaceStyle+Description.swift`.
extension UIUserInterfaceStyle {
  /// Human-readable string representation (`"dark"`, `"light"`, or `"unspecified"`) for analytics/logging.
  public var description: String {
    switch self {
    case .dark:
      return "dark"
    case .light:
      return "light"
    case .unspecified:
      return "unspecified"
    @unknown default:
      assertionFailure("Unhandled UIUserInterfaceStyle case encountered.")
      return "unknown"
    }
  }
}
