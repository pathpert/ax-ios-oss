import UIKit

/// Primary Kickstarter Design System button styles conforming to `KSRButtonStyleConfiguration`.
public enum KSRButtonStyle: KSRButtonStyleConfiguration, CaseIterable {
  case filled
  case green
  case filledInverted
  case filledDestructive
  case borderless
  case outlined
  case outlinedDestructive
  case borderlessDestructive
  case facebook

  /// Default background color for the button style.
  public var backgroundColor: UIColor {
    switch self {
    case .filled: Colors.Background.action.uiColor()
    case .green: Colors.Background.Action.primary.uiColor()
    case .filledInverted: Colors.Background.Surface.primary.uiColor()
    case .filledDestructive: Colors.Background.Danger.bold.uiColor()
    case .facebook:
      LegacyColors.Facebook.primary.uiColor()
    default: .clear
    }
  }

  /// Background color displayed when the button is highlighted/pressed.
  public var highlightedBackgroundColor: UIColor {
    switch self {
    case .filled: Colors.Background.Action.pressed.uiColor()
    case .green: Colors.Background.Action.Primary.pressed.uiColor()
    case .filledDestructive: Colors.Background.Danger.Bold.pressed.uiColor()
    case .borderlessDestructive, .outlinedDestructive: Colors.Background.Accent.Red.subtle.uiColor()
    case .facebook: LegacyColors.Facebook.pressed.uiColor()
    default: Colors.Background.Inverse.pressed.uiColor()
    }
  }

  /// Background color displayed when the button is disabled.
  public var disabledBackgroundColor: UIColor {
    switch self {
    case .filled: Colors.Background.Action.disabled.uiColor()
    case .green: Colors.Background.Action.Primary.disabled.uiColor()
    case .filledInverted: Colors.Background.Inverse.disabled.uiColor()
    case .filledDestructive: Colors.Background.Danger.disabled.uiColor()
    case .facebook: LegacyColors.Facebook.disabled.uiColor()
    default: .clear
    }
  }

  /// Default text color for the button title.
  public var titleColor: UIColor {
    switch self {
    case .filled, .green, .facebook, .filledDestructive: Colors.Text.Inverse.primary.uiColor()
    case .filledInverted, .borderless, .outlined: Colors.Text.primary.uiColor()
    case .outlinedDestructive, .borderlessDestructive: Colors.Text.Accent.red.uiColor()
    }
  }

  /// Text color displayed when the button is highlighted/pressed.
  public var highlightedTitleColor: UIColor {
    switch self {
    case .outlinedDestructive, .borderlessDestructive: Colors.Text.Accent.Red.bolder.uiColor()
    default: self.titleColor
    }
  }

  /// Text color displayed when the button is disabled.
  public var disabledTitleColor: UIColor {
    switch self {
    case .filled: Colors.Text.Inverse.disabled.uiColor()
    case .green: Colors.Text.Action.disabled.uiColor()
    case .filledInverted, .borderless, .outlined: Colors.Text.disabled.uiColor()
    case .filledDestructive: Colors.Text.Accent.Red.Inverse.disabled.uiColor()
    case .outlinedDestructive, .borderlessDestructive: Colors.Text.Accent.Red.disabled.uiColor()
    case .facebook: self.titleColor.mixLighter(0.35)
    }
  }

  /// Font applied to the button title label.
  public var font: UIFont {
    .ksr_ButtonLabel()
  }

  /// Stroke width applied to outlined button variants.
  public var borderWidth: CGFloat {
    switch self {
    case .outlined, .outlinedDestructive: 1.0
    default: 0.0
    }
  }

  /// Default border stroke color.
  public var borderColor: UIColor {
    switch self {
    case .outlined: Colors.Border.bold.uiColor()
    case .outlinedDestructive: Colors.Background.Danger.bold.uiColor()
    default: .clear
    }
  }

  /// Border stroke color when the button is highlighted.
  public var highlightedBorderColor: UIColor {
    switch self {
    case .outlinedDestructive: Colors.Border.Danger.bold.uiColor()
    default: self.borderColor
    }
  }

  /// Border stroke color when the button is disabled.
  public var disabledBorderColor: UIColor {
    switch self {
    case .outlined: Colors.Border.subtle.uiColor()
    case .outlinedDestructive: Colors.Border.Danger.subtle.uiColor()
    default: self.borderColor
    }
  }

  /// Corner radius applied to the button container.
  public var cornerRadius: CGFloat {
    Dimension.CornerRadius.small
  }

  /// Base `UIButton.Configuration` corresponding to this style variant.
  public var buttonConfiguration: UIButton.Configuration {
    switch self {
    case .filled, .green, .filledDestructive, .facebook: .filled()
    case .outlined, .outlinedDestructive: .bordered()
    case .filledInverted, .borderless, .borderlessDestructive: .borderless()
    }
  }

  /// Tint color for the button's embedded activity indicator.
  public var loadingIndicatorColor: UIColor {
    switch self {
    case .filledInverted, .borderless, .outlined: self.titleColor
    default: self.highlightedBackgroundColor
    }
  }
}
