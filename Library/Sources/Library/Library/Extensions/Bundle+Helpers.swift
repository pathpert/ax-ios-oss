import Foundation

/// `Bundle` extensions declared in `Bundle+Helpers.swift`.
public extension Bundle {
  static var library: Bundle {
    Bundle.module
  }
}
