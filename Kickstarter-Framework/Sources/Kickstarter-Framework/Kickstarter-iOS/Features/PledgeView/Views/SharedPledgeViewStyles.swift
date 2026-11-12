import KDS
import Library
import UIKit

/// Shared UIKit styling helpers used across pledge summary and checkout rows.
public enum PledgeViewStyles {
  /// Configures dynamic-type bold section heading style with `.header` accessibility trait.
  public static func pledgeAmountHeadingStyle(_ label: UILabel) {
    label.accessibilityTraits = UIAccessibilityTraits.header
    label.adjustsFontForContentSizeCategory = true
    label.font = UIFont.ksr_headline(size: 16).bolded
    label.numberOfLines = 0
  }

  /// Configures right-aligned pledge amount value label style scaling down to 75% width if needed.
  public static func pledgeAmountValueStyle(_ label: UILabel) {
    label.adjustsFontForContentSizeCategory = true
    label.textAlignment = NSTextAlignment.right
    label.isAccessibilityElement = true
    label.minimumScaleFactor = 0.75
  }

  /// Configures horizontal margin background styling for pledge amount summary stacks.
  public static func pledgeAmountStackViewStyle(_ stackView: UIStackView) {
    stackView.backgroundColor = LegacyColors.ksr_white.uiColor()
    stackView.layoutMargins = UIEdgeInsets(leftRight: Styles.gridHalf(4))
  }

  /// Configures the root vertical pledge CTA stack with top/horizontal margins.
  public static func rootPledgeCTAStackViewStyle(_ stackView: UIStackView) {
    stackView.axis = NSLayoutConstraint.Axis.vertical
    stackView.isLayoutMarginsRelativeArrangement = true
    stackView.layoutMargins = UIEdgeInsets.init(
      top: Styles.grid(2),
      left: Styles.grid(3),
      bottom: Styles.grid(0),
      right: Styles.grid(3)
    )
    stackView.spacing = Styles.grid(1)
  }
}
