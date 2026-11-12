import Foundation

extension Bundle {
  /// Swift Package Manager resource bundle for `Kickstarter-Framework`.
  /// - Negative Constraint: Do not use `Bundle.main` when loading framework nibs, storyboards, or image assets.
  public static var framework: Bundle {
    .module
  }
}
