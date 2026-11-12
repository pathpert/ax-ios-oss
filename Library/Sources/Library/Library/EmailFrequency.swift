import UIKit

/// Notification email digest cadence options selectable in Creator Digest settings.
/// - Negative Constraint: Do not pass arbitrary raw integers outside `.dailySummary` / `.twiceADaySummary`.
public enum EmailFrequency: Int {
  case dailySummary
  case twiceADaySummary

  /// All supported email digest frequency cases in display order.
  public static let allCases: [EmailFrequency] = [.dailySummary, .twiceADaySummary]

  /// Fixed table row height (`42` pt) for email frequency option cells.
  public static var rowHeight: CGFloat {
    return Styles.grid(7)
  }

  /// Localized option label shown in the frequency picker UI.
  public var descriptionText: String {
    switch self {
    case .dailySummary:
      return Strings.Daily_summary()
    case .twiceADaySummary:
      return Strings.Twice_a_day_summary()
    }
  }
}
