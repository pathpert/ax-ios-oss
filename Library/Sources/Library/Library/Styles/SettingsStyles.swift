import KDS
import KsApi
import Prelude
import Prelude_UIKit
import UIKit

/// Clears default button title text on full-row settings disclosure buttons.
public let settingsSectionButtonStyle =
  UIButton.lens.title(for: .normal) .~ nil

/// Tints settings chevron disclosure arrows with muted secondary ink.
public let settingsArrowViewStyle = UIImageView.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()

/// Primary multi-line row label style for top-level settings items.
public let settingsSectionLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ .ksr_subhead()
    |> \.numberOfLines .~ 2
}

/// Body text label style for primary settings row titles.
public let settingsTitleLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ .ksr_body()
}

/// Single-line trailing detail label style for settings rows.
public let settingsDetailLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.font .~ .ksr_body()
    |> \.numberOfLines .~ 1
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.lineBreakMode .~ .byTruncatingTail
}

/// Multi-line explanatory caption label style inside settings cells.
public let settingsDescriptionLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.font .~ .ksr_body(size: 13)
    |> \.numberOfLines .~ 0
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.lineBreakMode .~ .byWordWrapping
}

/// Footnote typography style shared by settings table section headers and footers.
public let settingsHeaderFooterLabelBaseStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.font .~ .ksr_footnote()
    |> \.numberOfLines .~ 0
}

/// Color styling for grouped settings section header and footer labels.
public let settingsHeaderFooterLabelStyle: LabelStyle = { (label: UILabel) in
  label
    |> \.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
}

/// Base text color for editable fields on settings forms.
public let settingsFormFieldStyle =
  UITextField.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()

/// Right-aligned AutoFill-enabled email field style for account settings.
public let settingsEmailFieldAutoFillStyle = emailFieldAutoFillStyle
  <> settingsFormFieldStyle
  <> UITextField.lens.textAlignment .~ .right

/// Right-aligned secure password field style for account settings.
public let settingsPasswordFormFieldStyle = passwordFieldStyle
  <> settingsFormFieldStyle
  <> UITextField.lens.textAlignment .~ .right

/// Password field style with `.password` AutoFill content type for settings forms.
public let settingsPasswordFormFieldAutoFillStyle = passwordFieldAutoFillStyle
  <> settingsPasswordFormFieldStyle

/// Password field style with `.newPassword` AutoFill content type for password updates.
public let settingsNewPasswordFormFieldAutoFillStyle = newPasswordFieldAutoFillStyle
  <> settingsPasswordFormFieldStyle

/// Decorative settings list separator style hidden from accessibility.
public let settingsSeparatorStyle = UIView.lens.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
  <> UIView.lens.accessibilityElementsHidden .~ true

/// Icon-only notification bell toggle button style in notification settings.
public let settingsNotificationIconButtonStyle =
  UIButton.lens.title(for: .normal) .~ nil
    <> UIButton.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()

/// Switch style tinted with Kickstarter green for settings toggles.
public let settingsSwitchStyle = UISwitch.lens.onTintColor .~ LegacyColors.ksr_create_700.uiColor()
  <> UISwitch.lens.tintColor .~ LegacyColors.ksr_support_100.uiColor()

/// Bordered circular/rounded toggle button style for notification channel controls.
public let notificationButtonStyle = UIButton.lens.layer.cornerRadius .~ 9
  <> UIButton.lens.accessibilityHint %~ { _ in Strings.Double_tap_to_toggle_setting() }
  <> UIButton.lens.accessibilityTraits .~ UIAccessibilityTraits.none
  <> UIButton.lens.layer.borderColor .~ LegacyColors.ksr_support_100.uiColor().cgColor
  <> UIButton.lens.layer.borderWidth .~ 1.0
  <> UIButton.lens.backgroundColor(for: .normal) .~ LegacyColors.ksr_white.uiColor()
  <> UIButton.lens.backgroundColor(for: .highlighted) .~ LegacyColors.ksr_support_100.uiColor()
  <> UIButton.lens.backgroundColor(for: .selected) .~ LegacyColors.ksr_support_100.uiColor()
  <> UIButton.lens.title(for: .normal) .~ nil
  <> UIButton.lens.clipsToBounds .~ true

/// View controller background style for grouped settings screens.
public let settingsViewControllerStyle: (UIViewController) -> UIViewController = { tvc in
  tvc
    |> baseControllerStyle()
    |> UIViewController.lens.view.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
}

/// Borderless grouped settings table view style.
public let settingsTableViewStyle = UITableView.lens.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
  <> UITableView.lens.separatorStyle .~ .none

/// Single-line full-bleed separator style for settings tables.
public let settingsTableViewSeparatorStyle = UITableView.lens.separatorStyle .~ .singleLine
  <> \.separatorColor .~ LegacyColors.ksr_support_300.uiColor()
  <> \.separatorInset .~ .zero

/// Builds an `NSAttributedString` placeholder colored with secondary settings ink.
public func settingsAttributedPlaceholder(_ string: String) -> NSAttributedString {
  return NSAttributedString(
    string: string,
    attributes: [NSAttributedString.Key.foregroundColor: LegacyColors.ksr_support_400.uiColor()]
  )
}

/// Applies uniform grid margins to generic settings cell containers.
public func settingsContentViewStyle(_ view: UIView) -> UIView {
  return view
    |> \.layoutMargins .~ .init(all: Styles.grid(2))
    |> \.preservesSuperviewLayoutMargins .~ false
}

/// Applies footer container padding in grouped settings sections.
public func settingsFooterContentViewStyle(_ view: UIView) -> UIView {
  return view
    |> settingsContentViewStyle
    |> \.layoutMargins .~ .init(
      top: Styles.grid(1),
      left: Styles.grid(2),
      bottom: Styles.grid(0),
      right: Styles.grid(2)
    )
}

/// Applies generous top header spacing for grouped settings sections.
public func settingsHeaderContentViewStyle(_ view: UIView) -> UIView {
  return view
    |> settingsContentViewStyle
    |> \.layoutMargins .~ .init(
      top: Styles.grid(5),
      left: Styles.grid(2),
      bottom: Styles.grid(2),
      right: Styles.grid(2)
    )
}

/// Applies white cell background and body typography to settings labels.
public func settingsLabelStyle(_ label: UILabel) -> UILabel {
  return label
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> \.font %~ { _ in .ksr_body() }
}

/// Adapts a settings row stack view between horizontal and vertical layout for accessibility sizes.
public func settingsStackViewStyle(_ stackView: UIStackView) -> UIStackView {
  return stackView
    |> \.axis %~~ { _, stackView in
      stackView.traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .vertical : .horizontal
    }
    |> \.alignment %~~ { _, stackView in
      stackView.traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .leading : .fill
    }
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.spacing .~ 8
}

/// Non-selectable grouped table style for informational settings pages.
public func settingsGroupedTableViewStyle(_ tableView: UITableView) -> UITableView {
  return tableView
    |> \.allowsSelection .~ false
    |> \.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
    |> \.separatorInset .~ .zero
}

/// Styles editable settings text fields with accessibility-aware text alignment.
public func settingsTextFieldStyle(_ textField: UITextField) -> UITextField {
  return textField
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> \.font %~ { _ in .ksr_body() }
    |> \.textAlignment %~~ { _, stackView in
      stackView.traitCollection.preferredContentSizeCategory.isAccessibilityCategory ? .left : .right
    }
}
