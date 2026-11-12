import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Base vertical `UIStackView` style with leading alignment and 16pt spacing.
public let verticalComponentStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> verticalStackViewStyle
    |> \.alignment .~ .leading
    |> \.spacing .~ 8
    |> \.distribution .~ .fill
    |> UIStackView.lens.spacing .~ Styles.grid(2)
}

// MARK: - Alert StackView

/// Horizontal `UIStackView` style with padded margins and rounded corners for alert banners.
public let alertStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> \.axis .~ NSLayoutConstraint.Axis.horizontal
    |> \.distribution .~ .fill
    |> \.layoutMargins .~ UIEdgeInsets.init(topBottom: 8, leftRight: 12)
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.spacing .~ 12
    |> \.tintColor .~ .white
    |> \.layer.cornerRadius .~ 6
}

// MARK: - Icons

/// Aspect-fit icon `UIImageView` style disabling autoresizing mask translation.
public let adaptiveIconImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.contentMode .~ .scaleAspectFit
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
}

// MARK: - Switch Control

/// Adaptive toggle switch tint style using legacy KDS green (`ksr_create_700`).
public let adaptiveSwitchControlStyle: SwitchControlStyle = { switchControl in
  switchControl
    |> \.onTintColor .~ LegacyColors.ksr_create_700.uiColor()
    |> \.tintColor .~ LegacyColors.ksr_support_100.uiColor()
}

// MARK: - Drop Down

/// Drop-down filter button style with trailing chevron icon and medium label font.
public let adaptiveDropDownButtonStyle: ButtonStyle = { (button: UIButton) in
  button
    |> UIButton.lens.contentEdgeInsets .~ UIEdgeInsets(
      top: Styles.gridHalf(3), left: Styles.grid(2), bottom: Styles.gridHalf(3), right: Styles.grid(5)
    )
    |> UIButton.lens.titleLabel.font .~ UIFont.ksr_body().bolded
    |> UIButton.lens.titleColor(for: .normal) .~ LegacyColors.ksr_create_500.uiColor()
    |> UIButton.lens.titleColor(for: .highlighted) .~ LegacyColors.ksr_create_500.uiColor()
    |> UIButton.lens.image(for: .normal) .~ image(named: "icon-dropdown-small")
    |> UIButton.lens.semanticContentAttribute .~ .forceRightToLeft
    |> UIButton.lens.imageEdgeInsets .~ UIEdgeInsets(top: 0, left: Styles.grid(6), bottom: 0, right: 0)
    |> UIButton.lens.layer.shadowColor .~ LegacyColors.ksr_black.uiColor().cgColor
}

// MARK: - Form

/// Adaptive text-field form style with dynamic body font and adaptive primary ink color.
public let adaptiveFormFieldStyle: TextFieldStyle = { (textField: UITextField) in
  textField
    |> formTextInputStyle
    |> \.backgroundColor .~ .clear
    |> \.font .~ .ksr_body()
    |> \.textColor .~ LegacyColors.ksr_black.uiColor()
}

// MARK: - Text Field

/// Adaptive email form field style configuring `.emailAddress` keyboard type.
public let adaptiveEmailFieldStyle = adaptiveFormFieldStyle
  <> UITextField.lens.keyboardType .~ .emailAddress

/// Builds a muted-placeholder attributed string styled with `ksr_support_400`.
public func adaptiveAttributedPlaceholder(_ string: String) -> NSAttributedString {
  return NSAttributedString(
    string: string,
    attributes: [NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_400.uiColor()]
  )
}

private let adaptiveEmailTextFieldPlaceholderStyle: TextFieldStyle = { (textField: UITextField) in
  textField
    |> \.returnKeyType .~ UIReturnKeyType.next
    |> \.attributedPlaceholder %~ { _ in
      adaptiveAttributedPlaceholder(Strings.login_placeholder_email())
    }
}

// MARK: - Activity Indicator

/// Adaptive spinner style hiding when stopped and using `ksr_support_700`.
public func adaptiveActivityIndicatorStyle(indicator: UIActivityIndicatorView) -> UIActivityIndicatorView {
  return indicator
    |> UIActivityIndicatorView.lens.hidesWhenStopped .~ true
    |> UIActivityIndicatorView.lens.style .~ .medium
    |> UIActivityIndicatorView.lens.color .~ LegacyColors.ksr_support_700.uiColor()
}

// MARK: - Links

/// Tappable attributed link `UITextView` style with non-scrolling body sizing.
public let adaptiveTappableLinksViewStyle: TextViewStyle = { (textView: UITextView) -> UITextView in
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
