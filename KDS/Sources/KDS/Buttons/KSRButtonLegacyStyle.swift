import UIKit

/// Defines legacy button styles using the `KSRButtonStyleConfiguration` protocol.
///
/// These styles are used as fallback or for buttons that do not have equivalents in the new design system.
public enum KSRButtonLegacyStyle: KSRButtonStyleConfiguration, CaseIterable {
  case blue
  case grey

  /// Default background color for the legacy button style.
  public var backgroundColor: UIColor {
    switch self {
    case .blue: LegacyColors.Buttons.blue.uiColor()
    case .grey: LegacyColors.ksr_support_300.uiColor()
    }
  }

  /// Background color displayed when the button is highlighted/pressed.
  public var highlightedBackgroundColor: UIColor {
    switch self {
    case .blue: LegacyColors.Buttons.blue.uiColor().mixDarker(0.36)
    case .grey: LegacyColors.ksr_support_300.uiColor().mixDarker(0.36)
    }
  }

  /// Background color displayed when the button is disabled.
  public var disabledBackgroundColor: UIColor {
    switch self {
    case .blue: LegacyColors.Buttons.blue.uiColor().mixLighter(0.36)
    case .grey: LegacyColors.ksr_support_300.uiColor().mixLighter(0.12)
    }
  }

  /// Default text color for the button title.
  public var titleColor: UIColor {
    switch self {
    case .blue: LegacyColors.ksr_white.uiColor()
    case .grey: LegacyColors.ksr_support_700.uiColor()
    }
  }

  /// Text color when highlighted.
  public var highlightedTitleColor: UIColor {
    switch self {
    case .blue: LegacyColors.ksr_white.uiColor()
    case .grey: LegacyColors.ksr_support_700.uiColor()
    }
  }

  /// Text color when disabled.
  public var disabledTitleColor: UIColor {
    switch self {
    case .blue: LegacyColors.ksr_white.uiColor()
    case .grey: LegacyColors.ksr_support_400.uiColor()
    }
  }

  /// Font applied to the button title label.
  public var font: UIFont {
    .ksr_ButtonLabel()
  }

  /// Border width (zero for legacy filled styles).
  public var borderWidth: CGFloat {
    0.0
  }

  /// Border color (`.clear` for legacy filled styles).
  public var borderColor: UIColor {
    .clear
  }

  /// Highlighted border color.
  public var highlightedBorderColor: UIColor {
    self.borderColor
  }

  /// Disabled border color.
  public var disabledBorderColor: UIColor {
    self.borderColor
  }

  /// Corner radius applied to the button container.
  public var cornerRadius: CGFloat {
    Dimension.CornerRadius.small
  }

  /// Base `UIButton.Configuration` used by the button.
  public var buttonConfiguration: UIButton.Configuration {
    .filled()
  }

  /// Tint color for the button's loading spinner.
  public var loadingIndicatorColor: UIColor {
    self.highlightedBackgroundColor
  }
}
