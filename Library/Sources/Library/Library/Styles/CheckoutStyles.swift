import KDS
import Prelude
import UIKit

// MARK: - Types

/// Semantic button visual styles available in checkout and project CTA flows.
public enum ButtonStyleType: Equatable {
  /// High-emphasis black filled button style.
  case black
  /// Legacy blue button style.
  case blue
  /// Primary Kickstarter green CTA button style.
  case green
  /// Secondary grey button style.
  case grey
  /// Unstyled button variant (no background/tint configuration applied).
  case none
  /// Destructive red action button style.
  case red

  private var ksrButtonStyle: (any KSRButtonStyleConfiguration)? {
    switch self {
    case .black: return KSRButtonStyle.filled
    case .blue: return KSRButtonLegacyStyle.blue
    case .green: return KSRButtonStyle.green
    case .grey: return KSRButtonLegacyStyle.grey
    case .none: return nil
    case .red: return KSRButtonStyle.filledDestructive
    }
  }

  /// Functional style closure applying this button style to a `UIButton`.
  public var style: ButtonStyle {
    let buttonStyle = self.ksrButtonStyle

    return { button in
      if let buttonStyle {
        button.applyStyleConfiguration(buttonStyle)
      }
      return button
    }
  }
}

// MARK: - Constants

/// Shared layout constants used across pledge and checkout views.
public enum CheckoutConstants {
  /// Credit card cell sizing constants.
  public enum CreditCardView {
    /// Fixed height for saved credit card cells.
    public static let height: CGFloat = 143
  }

  /// Pledge screen spacing constants.
  public enum PledgeView {
    /// Horizontal edge insets for pledge containers.
    public enum Inset {
      /// Standard left and right margin inside pledge views.
      public static let leftRight: CGFloat = Styles.grid(4)
    }
  }

  /// Reward card sizing constants.
  public enum RewardCard {
    /// Layout metrics for horizontal reward carousel cards.
    public enum Layout {
      /// Fixed reward card width.
      public static let width: CGFloat = 294
    }
  }

  /// Payment source card sizing constants.
  public enum PaymentSource {
    /// Stored card cell width.
    public enum Card {
      /// Fixed width for saved payment method card.
      public static let width: CGFloat = 240
    }

    /// Card brand icon dimensions.
    public enum ImageView {
      /// Card icon width.
      public static let width: CGFloat = 64
      /// Card icon height.
      public static let height: CGFloat = 40
    }

    /// Action button dimensions on payment source views.
    public enum Button {
      /// Standard CTA width inside payment source tiles.
      public static let width: CGFloat = 217
    }
  }
}

// MARK: - Attributes

/// Returns default attributed-string attributes for currency amounts in checkout.
public func checkoutCurrencyDefaultAttributes() -> String.Attributes {
  return [
    .font: UIFont.ksr_title1(),
    .foregroundColor: LegacyColors.ksr_support_400.uiColor()
  ]
}

/// Returns attributes for superscripted currency symbols in checkout amounts.
public func checkoutCurrencySuperscriptAttributes() -> String.Attributes {
  return [
    .font: UIFont.ksr_body(),
    .baselineOffset: UIFont.ksr_body().baselineOffsetToSuperscript(of: UIFont.ksr_title1())
  ]
}

// MARK: - Styles

/// Shared sheet offset constants for checkout modal presentation.
public enum Layout {
  /// Vertical presentation offsets for bottom sheets.
  public enum Sheet {
    /// Standard bottom-sheet vertical offset on regular displays.
    public static let offset: CGFloat = 222
    /// Compact vertical offset when height is constrained.
    public static let offsetCompact: CGFloat = 44
  }
}

/// Applies the secondary surface grey background color for checkout screens.
public let checkoutBackgroundStyle: ViewStyle = { (view: UIView) in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
}

/// Applies the subtle grey background color to checkout labels.
public let checkoutLabelStyle: LabelStyle = { label in
  label
    |> \.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
}

/// Applies a 6pt corner radius to checkout containers.
public let checkoutRoundedCornersStyle: ViewStyle = { (view: UIView) in
  view
    |> \.layer.cornerRadius .~ 6
}

/// Configures a vertical stack view with compact checkout item spacing.
public let checkoutStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> verticalStackViewStyle
    |> \.spacing .~ (Styles.grid(1) + Styles.gridHalf(1))
}

/// Applies Kickstarter green tinting to checkout switches.
public let checkoutSwitchControlStyle: SwitchControlStyle = { switchControl in
  switchControl
    |> \.onTintColor .~ LegacyColors.ksr_create_700.uiColor()
    |> \.tintColor .~ LegacyColors.ksr_support_300.uiColor()
}

/// Styles a `UIStepper` with custom Kickstarter increment/decrement icons.
public let checkoutStepperStyle: (UIStepper) -> UIStepper = { stepper in
  stepper
    |> \.stepValue .~ 1.0
    |> \.tintColor .~ UIColor.clear
    <> UIStepper.lens.decrementImage(for: .normal) .~ image(named: "stepper-decrement-normal")
    <> UIStepper.lens.decrementImage(for: .disabled) .~ image(named: "stepper-decrement-disabled")
    <> UIStepper.lens.decrementImage(for: .highlighted) .~ image(named: "stepper-decrement-highlighted")
    <> UIStepper.lens.incrementImage(for: .normal) .~ image(named: "stepper-increment-normal")
    <> UIStepper.lens.incrementImage(for: .disabled) .~ image(named: "stepper-increment-disabled")
    <> UIStepper.lens.incrementImage(for: .highlighted) .~ image(named: "stepper-increment-highlighted")
}

/// Styles multi-line section header labels in checkout flows.
public let checkoutTitleLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.accessibilityTraits .~ UIAccessibilityTraits.header
    |> \.adjustsFontForContentSizeCategory .~ true
    |> \.font .~ UIFont.ksr_headline(size: 15)
    |> \.numberOfLines .~ 0
}

/// Applies white card background color for checkout containers.
public let checkoutWhiteBackgroundStyle: ViewStyle = { (view: UIView) in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

/// Applies a 16pt corner radius to floating checkout card layers.
public let checkoutLayerCardRoundedStyle: LayerStyle = { layer in
  layer
    |> \.cornerRadius .~ 16.0
}

/// Styles read-only `UITextView` instances containing tappable policy links.
public let tappableLinksViewStyle: TextViewStyle = { (textView: UITextView) -> UITextView in
  _ = textView
    |> \.isScrollEnabled .~ false
    |> \.isEditable .~ false
    |> \.isUserInteractionEnabled .~ true
    |> \.adjustsFontForContentSizeCategory .~ true

  _ = textView
    |> \.textContainerInset .~ UIEdgeInsets.zero
    |> \.textContainer.lineFragmentPadding .~ 0
    |> \.linkTextAttributes .~ [
      .foregroundColor: LegacyColors.ksr_create_700.uiColor()
    ]

  return textView
}

/// Parses an HTML legal disclaimer string into an `NSAttributedString` styled for checkout.
public func checkoutAttributedLink(with string: String) -> NSAttributedString? {
  guard let attributedString = try? NSMutableAttributedString(
    data: Data(string.utf8),
    options: [
      .documentType: NSAttributedString.DocumentType.html,
      .characterEncoding: String.Encoding.utf8.rawValue
    ],
    documentAttributes: nil
  ) else { return nil }

  let attributes: String.Attributes = [
    .font: UIFont.ksr_caption1(),
    .foregroundColor: LegacyColors.ksr_support_400.uiColor(),
    .underlineStyle: 0
  ]

  let fullRange = (attributedString.string as NSString).range(of: attributedString.string)

  attributedString.addAttributes(attributes, range: fullRange)

  return attributedString
}

/// Configures vertical spacing between checkout card elements.
public let checkoutCardStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> verticalStackViewStyle
    |> \.spacing .~ Styles.grid(3)
}

/// Configures root stack view spacing and margins in checkout controllers.
public let checkoutRootStackViewStyle = { (stackView: UIStackView) in
  stackView
    |> \.axis .~ NSLayoutConstraint.Axis.vertical
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.layoutMargins .~ UIEdgeInsets(topBottom: Styles.grid(3), leftRight: Styles.grid(4))
    |> \.spacing .~ Styles.grid(4)
}

/// Configures spacing for nested checkout sub-stacks.
public let checkoutSubStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> \.spacing .~ Styles.grid(3)
}

/// Applies medium elevation shadow without rasterization for reward cards.
public let rewardCardShadowStyle: ViewStyle = { (view: UIView) in
  view
    |> dropShadowStyleMedium()
    |> \.layer.shouldRasterize .~ false
}

/// Configures payment card brand image views with aspect-fit content mode.
public let cardImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.contentMode .~ .scaleAspectFit
}

/// Styles rounded white pledge summary cards with standardized margins.
public let pledgeCardViewStyle: ViewStyle = { view in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> roundedStyle(cornerRadius: Styles.grid(1))
    |> \.layoutMargins .~ UIEdgeInsets(topBottom: Styles.grid(3), leftRight: Styles.grid(2))
}
