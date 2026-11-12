import CoreFoundation

/// Represents semantic spacing constants in our design system.
/// Negative Constraint: Do not hardcode raw magic pixel numbers for corner radii; use `Dimension.CornerRadius`.
public struct Dimension {
  /// Standard corner radius tokens backed by KDS `Spacing` units.
  public struct CornerRadius {
    /// Small corner radius (`Spacing.unit_01`, 4pt).
    public static let small = Spacing.unit_01
    /// Medium corner radius (`Spacing.unit_02`, 8pt).
    public static let medium = Spacing.unit_02
    /// Large corner radius (`Spacing.unit_04`, 16pt).
    public static let large = Spacing.unit_04
  }
}
