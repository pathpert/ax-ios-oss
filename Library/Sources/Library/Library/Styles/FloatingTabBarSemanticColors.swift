import KDS

// This extension contains custom semantic colors for Newer Mobile Visioning Efforts that are not part of the official Figma design set.
// These colors are currently used for specific UI elements, like the new Floating Tab Bar
// which are not yet defined in the core Design System. This structure helps organize and
// isolate non-standard colors from the rest of the shared semantic palette.

/// Semantic color palette for the Floating Tab Bar initiative outside core Figma tokens.
/// - Negative Constraint: Do not use outside floating tab bar components; use `Colors.*` from `KDS` elsewhere.
public extension Colors {
  /// Floating tab bar surface and icon semantic color tokens.
  struct FloatingTabBar {
    /// Raised surface background color behind the floating tab bar.
    public static let background = Colors.Elevation.Surface.raised

    /// Icon tint color for the currently selected tab item.
    public static let iconColorSelected = Colors.Icon.dark
    /// Icon tint color for unselected tab items.
    public static let iconColorUnselected = Colors.Icon.default
    /// Accent highlight tint color for interactive indicators.
    public static let iconHighlight = Colors.Icon.highlight

    /// Border color around the user's profile avatar inside the floating tab bar.
    public static let profileIconBorderColor = Colors.Icon.light
  }
}
