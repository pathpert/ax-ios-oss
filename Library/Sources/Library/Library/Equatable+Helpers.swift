import Foundation

/// `Equatable` extensions declared in `Equatable+Helpers.swift`.
extension Equatable {
  func isAny(of elements: Self...) -> Bool {
    return elements.contains(self)
  }
}
