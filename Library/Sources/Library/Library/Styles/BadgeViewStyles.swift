import KDS
import UIKit

/// Semantic visual variants for `BadgeView`.
public enum BadgeStyle: Equatable {
  /// Positive / confirmation status badge.
  case success
  /// Informational / neutral status badge.
  case neutral
  /// Alert / failure status badge.
  case error
  /// Custom badge appearance with explicit foreground and background colors.
  case custom(foregroundColor: UIColor, backgroundColor: UIColor)
}

extension BadgeStyle {
  /// Foreground text color for the badge style.
  public var foregroundColor: UIColor {
    switch self {
    case .success: return LegacyColors.ksr_create_700.uiColor()
    case .neutral: return LegacyColors.ksr_support_500.uiColor()
    case .error: return LegacyColors.ksr_alert.uiColor()
    case let .custom(foregroundColor, _): return foregroundColor
    }
  }

  /// Background fill color for the badge style.
  public var backgroundColor: UIColor {
    switch self {
    case .success: return LegacyColors.ksr_create_100.uiColor()
    case .neutral: return LegacyColors.ksr_support_100.uiColor()
    case .error: return LegacyColors.ksr_alert.uiColor(opacity: 0.1)
    case let .custom(_, backgroundColor): return backgroundColor
    }
  }
}
