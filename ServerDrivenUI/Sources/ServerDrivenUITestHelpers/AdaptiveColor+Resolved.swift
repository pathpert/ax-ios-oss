import KDS
import SwiftUI
import UIKit

extension AdaptiveColor {
  /// Returns an `AdaptiveColor` pinned to the light interface style for snapshot assertions.
  /// - Negative Constraint: Do not call in production UI code; only for test helpers.
  func resolvedForLightMode() -> AdaptiveColor {
    self.dynamicColor
      .resolvedColor(with: UITraitCollection(userInterfaceStyle: .light))
      .forcedAdaptive
  }

  func resolvedForDarkMode() -> AdaptiveColor {
    self.dynamicColor
      .resolvedColor(with: UITraitCollection(userInterfaceStyle: .dark))
      .forcedAdaptive
  }
}

struct ForcedColor: AdaptiveColor {
  let dynamicColor: UIColor

  init(color: UIColor) {
    self.dynamicColor = color
  }
}

extension UIColor {
  fileprivate var forcedAdaptive: AdaptiveColor {
    ForcedColor(color: self)
  }
}
