import SwiftUI
import UIKit

/// Protocol for colors that resolve dynamically for light and dark interface styles.
public protocol AdaptiveColor {
  /// Returns a dynamically-provided `UIColor`, which responds to light/dark mode.
  var dynamicColor: UIColor { get }
}

public extension AdaptiveColor {
  /// Returns the dynamic `UIColor` with default opacity.
  func uiColor() -> UIColor {
    return self.dynamicColor
  }

  /// Returns a SwiftUI `Color` with default opacity.
  func swiftUIColor() -> Color {
    Color(uiColor: self.uiColor())
  }

  /// Returns the dynamic `UIColor` with the specified alpha opacity.
  func uiColor(opacity alpha: CGFloat) -> UIColor {
    return self.dynamicColor.withAlphaComponent(alpha)
  }

  /// Returns a SwiftUI `Color` with the specified opacity.
  func swiftUIColor(opacity: CGFloat) -> Color {
    Color(uiColor: self.uiColor(opacity: opacity))
  }
}

/// A semantic color from the Kickstarter design system, like "surface/primary".
/// Includes a light and dark mode color pair, as well as an identifying title.
public struct SemanticColor: AdaptiveColor {
  /// Trait-resolving `UIColor` switching between light and dark palette entries.
  public let dynamicColor: UIColor

  /// Canonical token identifier (for example `"text/primary"`).
  public let name: String

  /// Creates a semantic color with full opacity for both light and dark modes.
  public init(_ name: String, lightMode: CoreColor, darkMode: CoreColor) {
    self.init(name, lightMode: lightMode, lightModeAlpha: 1.0, darkMode: darkMode, darkModeAlpha: 1.0)
  }

  /// Creates a semantic color with explicit alpha values for light and dark modes.
  public init(
    _ name: String,
    lightMode: CoreColor,
    lightModeAlpha: Double,
    darkMode: CoreColor,
    darkModeAlpha: Double
  ) {
    self.name = name

    let lightModeColor = UIColor(coreColor: lightMode, alpha: lightModeAlpha)
    let darkModeColor = UIColor(coreColor: darkMode, alpha: darkModeAlpha)

    self.dynamicColor = UIColor { traits in
      if traits.userInterfaceStyle == .dark {
        return darkModeColor
      } else {
        return lightModeColor
      }
    }
  }
}

/// Used for old design system colors which can't be mapped directly to the Kickstarter color palette.
public struct LegacyColor: AdaptiveColor {
  /// Legacy color identifier name.
  public let name: String
  /// Trait-resolving `UIColor` switching between light and dark `UIColor` values.
  public let dynamicColor: UIColor

  init(_ name: String, lightMode: UIColor, darkMode: UIColor) {
    self.name = name
    self.dynamicColor = UIColor { traits in
      if traits.userInterfaceStyle == .dark {
        return darkMode
      } else {
        return lightMode
      }
    }
  }
}
