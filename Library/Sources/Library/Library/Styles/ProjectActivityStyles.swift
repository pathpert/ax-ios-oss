import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Circular bullet separator style in project activity feed items.
public let projectActivityBulletSeparatorViewStyle: (UIView) -> UIView = { view in
  view
    |> roundedStyle(cornerRadius: 2.0)
    |> UIView.lens.backgroundColor .~ LegacyColors.ksr_support_400.uiColor()
}

/// Horizontal hairline divider style in project activity feed items.
public let projectActivityDividerViewStyle = UIView.lens.backgroundColor .~ LegacyColors.ksr_support_300
  .uiColor()

/// Button style for project activity card footers.
public let projectActivityFooterButton =
  UIButton.lens.titleColor(for: .normal) .~ LegacyColors.ksr_create_700.uiColor()
    <> UIButton.lens.titleLabel.font .~ UIFont.ksr_footnote(size: 12).bolded
    <> UIButton.lens.titleColor(for: .highlighted) .~ LegacyColors.ksr_support_100.uiColor()

/// Stack view layout style for project activity footers.
public let projectActivityFooterStackViewStyle =
  UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(3), leftRight: Styles.grid(2))
    <> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
    <> UIStackView.lens.spacing .~ Styles.grid(2)

/// Stack view layout style for project activity headers.
public let projectActivityHeaderStackViewStyle =
  UIStackView.lens.layoutMargins .~ .init(all: Styles.grid(2))
    <> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
    <> UIStackView.lens.spacing .~ Styles.grid(1)

/// Horizontal margin applied to project activity cells in regular-regular size classes.
public let projectActivityRegularRegularLeftRight = Styles.grid(30)

/// Layout margins applied to project activity cells in regular-regular size classes.
public let projectActivityRegularRegularLayoutMargins: UIEdgeInsets =
  .init(topBottom: Styles.grid(4), leftRight: projectActivityRegularRegularLeftRight)

// Use `.ksr_body` for font.
/// Centered multi-line label style for project activity state-change headlines.
public let projectActivityStateChangeLabelStyle = UILabel.lens.numberOfLines .~ 0
  <> UILabel.lens.textAlignment .~ .center

// Use `.ksr_title3(size: 14)` for font.
/// Two-line title label style for project activity cards.
public let projectActivityTitleLabelStyle = UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
  <> UILabel.lens.numberOfLines .~ 2
