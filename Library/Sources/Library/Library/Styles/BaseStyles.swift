import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Legacy layout constants and grid spacing helpers (prefer `Spacing` tokens for new code).
public enum Styles {
  /// Minimum accessible tap target size (`44x44` pt).
  public static let minTouchSize: CGSize = CGSize(width: 44, height: 44)
  /// Horizontal inset applied to project page sections.
  public static let projectPageLeftRightInset: CGFloat = Styles.grid(3)
  /// Vertical inset applied to project page sections.
  public static let projectPageTopBottomInset: CGFloat = Styles.grid(4)

  /// Returns `count` multiples of the legacy 6pt layout grid unit.
  @available(
    *,
    deprecated,
    message: "Styles.grid is part of our old design system. If you're writing new code, use Spacing.unit_xx instead."
  )
  public static func grid(_ count: Int) -> CGFloat {
    return 6.0 * CGFloat(count)
  }

  /// Returns half of the legacy 6pt grid unit multiplied by `count`.
  @available(
    *,
    deprecated,
    message: "Styles.gridHalf is part of our old design system. If you're writing new code, use Spacing.unit_xx instead."
  )
  public static func gridHalf(_ count: Int) -> CGFloat {
    return self.grid(count) / 2.0
  }
}

/// Functional style closure transforming a `UIActivityIndicatorView`.
public typealias ActivityIndicatorStyle = (UIActivityIndicatorView) -> UIActivityIndicatorView
/// Functional style closure transforming a `UIBarButtonItem`.
public typealias BarButtonStyle = (UIBarButtonItem) -> UIBarButtonItem
/// Functional style closure transforming a `UIButton`.
public typealias ButtonStyle = (UIButton) -> UIButton
/// Functional style closure transforming a `UICollectionView`.
public typealias CollectionViewStyle = (UICollectionView) -> UICollectionView
/// Functional style closure transforming a `UIImageView`.
public typealias ImageViewStyle = (UIImageView) -> UIImageView
/// Functional style closure transforming a `UILabel`.
public typealias LabelStyle = (UILabel) -> UILabel
/// Functional style closure transforming a `CALayer`.
public typealias LayerStyle = (CALayer) -> CALayer
/// Functional style closure transforming an optional `UINavigationBar`.
public typealias NavigationBarStyle = (UINavigationBar?) -> UINavigationBar?
/// Functional style closure transforming a `UIPageControl`.
public typealias PageControlStyle = (UIPageControl) -> UIPageControl
/// Functional style closure transforming a `UIScrollView`.
public typealias ScrollStyle = (UIScrollView) -> UIScrollView
/// Functional style closure transforming a `UIStackView`.
public typealias StackViewStyle = (UIStackView) -> UIStackView
/// Functional style closure transforming a `UISwitch`.
public typealias SwitchControlStyle = (UISwitch) -> UISwitch
/// Functional style closure transforming a `UITableView`.
public typealias TableViewStyle = (UITableView) -> UITableView
/// Functional style closure transforming a `UITableViewCell`.
public typealias TableViewCellStyle = (UITableViewCell) -> UITableViewCell
/// Functional style closure transforming a `UITextField`.
public typealias TextFieldStyle = (UITextField) -> UITextField
/// Functional style closure transforming a `UITextView`.
public typealias TextViewStyle = (UITextView) -> UITextView
/// Functional style closure transforming a `UIToolbar`.
public typealias ToolbarStyle = (UIToolbar) -> UIToolbar
/// Functional style closure transforming a `UIView`.
public typealias ViewStyle = (UIView) -> UIView

/// Applies standard white background and opaque navigation bar styling to a view controller.
public func baseControllerStyle<VC: UIViewControllerProtocol>() -> ((VC) -> VC) {
  return VC.lens.view.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    <> (VC.lens.navigationController .. navBarLens) %~ { $0.map(baseNavigationBarStyle) }
}

/// Configures standard medium activity indicator appearance and auto-hiding behavior.
public func baseActivityIndicatorStyle(indicator: UIActivityIndicatorView) -> UIActivityIndicatorView {
  return indicator
    |> UIActivityIndicatorView.lens.hidesWhenStopped .~ true
    |> UIActivityIndicatorView.lens.style .~ .medium
    |> UIActivityIndicatorView.lens.color .~ LegacyColors.ksr_support_700.uiColor()
}

/// Returns a view transformer that rounds corners, sets white background color, and applies a hairline border.
/// - parameter radius: The corner radius (defaults to `0`).
public func cardStyle<V: UIViewProtocol>(cornerRadius radius: CGFloat = 0) -> ((V) -> V) {
  return roundedStyle(cornerRadius: radius)
    <> V.lens.layer.borderColor .~ LegacyColors.ksr_support_300.uiColor().cgColor
    <> V.lens.layer.borderWidth .~ 1.0
    <> V.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

/// Applies card styling with darker border contrast suitable for dark-surface groupings.
public func darkCardStyle<V: UIViewProtocol>
(cornerRadius radius: CGFloat = Dimension.CornerRadius.small) -> ((V) -> V) {
  return cardStyle(cornerRadius: radius)
    <> V.lens.layer.borderColor .~ LegacyColors.ksr_support_400.uiColor().cgColor
}

/// Configures stack axis, alignment, and distribution adaptively for accessibility text sizes.
public func adaptableStackViewStyle(_ isAccessibilityCategory: Bool) -> (StackViewStyle) {
  return { (stackView: UIStackView) in
    let alignment: UIStackView.Alignment = (isAccessibilityCategory ? .leading : .center)
    let axis: NSLayoutConstraint.Axis = (isAccessibilityCategory ? .vertical : .horizontal)
    let distribution: UIStackView.Distribution = (isAccessibilityCategory ? .equalSpacing : .fill)
    let spacing: CGFloat = (isAccessibilityCategory ? Styles.grid(1) : 0)

    return stackView
      |> \.alignment .~ alignment
      |> \.axis .~ axis
      |> \.distribution .~ distribution
      |> \.spacing .~ spacing
  }
}

/// Applies light neutral grey background color to container views.
public let containerViewBackgroundStyle =
  UIView.lens.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()

/// Applies customizable drop shadow attributes to a view's layer.
public func dropShadowStyle<V: UIViewProtocol>(
  radius: CGFloat = 2.0,
  offset: CGSize = .init(width: 0, height: 1),
  shadowOpacity: Float = 0.17
) -> ((V) -> V) {
  return
    V.lens.layer.shadowColor .~ LegacyColors.ksr_black.uiColor().cgColor
      <> V.lens.layer.shadowOpacity .~ shadowOpacity
      <> V.lens.layer.shadowRadius .~ radius
      <> V.lens.layer.masksToBounds .~ false
      <> V.lens.layer.shouldRasterize .~ true
      <> V.lens.layer.shadowOffset .~ offset
}

/// Applies medium elevation shadow preset.
public func dropShadowStyleMedium<V: UIViewProtocol>() -> ((V) -> V) {
  return dropShadowStyle(radius: 5.0, offset: .init(width: 0, height: 2.0))
}

/// Applies large elevation shadow preset.
public func dropShadowStyleLarge<V: UIViewProtocol>() -> ((V) -> V) {
  return dropShadowStyle(radius: 6.0, offset: .init(width: 0, height: 3.0))
}

/// Applies responsive table cell margins for regular and compact size classes.
public let feedTableViewCellStyle: (UITableViewCell) -> UITableViewCell = { cell in
  cell
    |> baseTableViewCellStyle()
    |> UITableViewCell.lens.contentView.layoutMargins %~~ { _, cell in
      cell.traitCollection.isRegularRegular
        ? .init(topBottom: Styles.grid(2), leftRight: Styles.grid(30))
        : .init(topBottom: Styles.gridHalf(3), leftRight: Styles.grid(2))
    }
}

/// Disables autocapitalization, autocorrection, and spell checking on text fields.
public let formTextInputStyle: TextFieldStyle = { (textField: UITextField) in
  textField
    |> \.autocapitalizationType .~ UITextAutocapitalizationType.none
    |> \.autocorrectionType .~ UITextAutocorrectionType.no
    |> \.spellCheckingType .~ UITextSpellCheckingType.no
}

/// Applies standard body typography and accent tinting to borderless form fields.
public let formFieldStyle: TextFieldStyle = { (textField: UITextField) in
  textField
    |> formTextInputStyle
    |> \.backgroundColor .~ UIColor.clear
    |> \.borderStyle .~ UITextField.BorderStyle.none
    |> \.font .~ UIFont.ksr_body()
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.tintColor .~ LegacyColors.ksr_create_700.uiColor()
}

/// Opts an image view out of Smart Invert Colors.
public let ignoresInvertColorsImageViewStyle: ImageViewStyle = { (imageView: UIImageView) in
  imageView
    |> \.accessibilityIgnoresInvertColors .~ true
}

/// Styles decorative hairline separator views while hiding them from accessibility.
public let separatorStyle: ViewStyle = { (view: UIView) in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    |> \.accessibilityElementsHidden .~ true
}

/// Dark-variant decorative separator style hidden from accessibility elements.
public let separatorStyleDark: ViewStyle = { view in
  view
    |> \.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    |> \.accessibilityElementsHidden .~ true
}

/// Returns a view transformer that rounds corners to `r`.
/// - parameter r: The corner radius (defaults to `Dimension.CornerRadius.small`).
public func roundedStyle<V: UIViewProtocol>(cornerRadius r: CGFloat = Dimension.CornerRadius.small)
  -> ((V) -> V) {
  return V.lens.clipsToBounds .~ true
    <> V.lens.layer.masksToBounds .~ true
    <> V.lens.layer.cornerRadius .~ r
}

/// Applies Kickstarter green tinting to standard settings switches.
public let baseSwitchControlStyle: SwitchControlStyle = { switchControl in
  switchControl
    |> \.onTintColor .~ LegacyColors.ksr_create_700.uiColor()
    |> \.tintColor .~ LegacyColors.ksr_support_100.uiColor()
}

// MARK: - Private Helpers

// Just a lil helper lens for getting inside a nav controller's nav bar.
private let navBarLens: Lens<UINavigationController?, UINavigationBar?> = Lens(
  view: { $0?.navigationBar },
  set: { _, whole in whole }
)

private let baseNavigationBarStyle =
  UINavigationBar.lens.titleTextAttributes .~ [
    NSAttributedString.Key.foregroundColor: LegacyColors.ksr_black.uiColor()
  ]
  <> UINavigationBar.lens.isTranslucent .~ false
  <> UINavigationBar.lens.tintColor .~ LegacyColors.ksr_create_700.uiColor()
  <> UINavigationBar.lens.standardAppearance .~ navigationBarAppearance
  <> UINavigationBar.lens.scrollEdgeAppearance .~ navigationBarAppearance

private var navigationBarAppearance: UINavigationBarAppearance {
  let navBarAppearance = UINavigationBarAppearance()
  navBarAppearance.configureWithOpaqueBackground()
  navBarAppearance.backgroundColor = LegacyColors.ksr_white.uiColor()

  return navBarAppearance
}

/// Styles rounded white input accessory keyboard toolbars.
public let keyboardToolbarStyle: ToolbarStyle = { toolbar -> UIToolbar in
  toolbar
    |> roundedStyle(cornerRadius: 8)
    |> \.layer.backgroundColor .~ LegacyColors.ksr_white.uiColor().cgColor
    |> \.layer.maskedCorners .~ [.layerMaxXMinYCorner, .layerMinXMinYCorner]
}

/// Styles keyboard accessory Done buttons across iOS versions.
public let keyboardDoneButtonStyle: ButtonStyle = { button -> UIButton in
  if #available(iOS 26.0, *) {
    var config = UIButton.Configuration.borderless()
    config.baseForegroundColor = Colors.Background.Action.primary.uiColor()
    button.configuration = config
  } else {
    button.applyStyleConfiguration(KSRButtonStyle.green)
  }
  return button
}

/// Configures a vertical-axis stack view.
public let verticalStackViewStyle: StackViewStyle = { (stackView: UIStackView) in
  stackView
    |> \.axis .~ NSLayoutConstraint.Axis.vertical
}
