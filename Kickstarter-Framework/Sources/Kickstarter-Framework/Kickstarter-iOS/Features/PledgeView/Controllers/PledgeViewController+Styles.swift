import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Layout and spacing constants used across `PledgeViewController`.
enum PledgeViewLayout {
  enum Style {
    static let cornerRadius: CGFloat = Styles.grid(2)
    static let modalHeightMultiplier: CGFloat = 0.65
  }

  enum Margin {
    static let topBottom: CGFloat = Styles.grid(3)
    static let leftRight: CGFloat = CheckoutConstants.PledgeView.Inset.leftRight
  }
}

/// Delegate notified when `PledgeViewController` completes a pledge update.
protocol PledgeViewControllerDelegate: AnyObject {
  /// Called after an existing pledge is updated successfully with a confirmation message.
  func pledgeViewControllerDidUpdatePledge(
    _ viewController: PledgeViewController,
    message: String
  )
}

// MARK: - Styles

extension PledgeViewController {
  /// Applies typography, surface colors, and rounded corners across pledge sections.
  override func bindStyles() {
    super.bindStyles()

    self.view.backgroundColor = LegacyColors.ksr_support_100.uiColor()

    applyPledgeTitleLabelStyle(self.titleLabel)
    applyPledgeSectionTitleLabelStyle(self.collectionPlanSectionLabel)
    applyPledgeSectionTitleLabelStyle(self.paymentSectionLabel)
    applyPledgeRootScrollViewStyle(self.rootScrollView)
    applyPledgeRootStackViewStyle(self.rootStackView)
    applyPledgeRootInsetStackViewStyle(self.rootInsetStackView)
    applyPledgeRootInsetStackViewStyle(self.estimatedShippingStackView)

    roundedStyle(self.paymentMethodsViewController.view, cornerRadius: PledgeViewLayout.Style.cornerRadius)
    roundedStyle(self.paymentPlansView, cornerRadius: PledgeViewLayout.Style.cornerRadius)
    applyPledgeRoundedViewStyle(self.pledgeDisclaimerView, cornerRadius: PledgeViewLayout.Style.cornerRadius)
  }
}

/// Clips and rounds corners of a pledge section container view.
func applyPledgeRoundedViewStyle(_ view: UIView, cornerRadius: CGFloat) {
  view.clipsToBounds = true
  view.layer.masksToBounds = true
  view.layer.cornerRadius = cornerRadius
}

/// Configures scroll indicators and vertical bounce on the pledge root scroll view.
func applyPledgeRootScrollViewStyle(_ scrollView: UIScrollView) {
  scrollView.showsVerticalScrollIndicator = false
  scrollView.alwaysBounceVertical = true
}

/// Configures vertical spacing and margins on the top-level pledge stack view.
func applyPledgeRootStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = NSLayoutConstraint.Axis.vertical
  stackView.spacing = Styles.grid(2)
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = UIEdgeInsets(
    topBottom: PledgeViewLayout.Margin.topBottom,
    leftRight: 0
  )
}

/// Configures vertical spacing and inset horizontal margins for pledge form sections.
func applyPledgeRootInsetStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = NSLayoutConstraint.Axis.vertical
  stackView.spacing = Styles.grid(3)
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = UIEdgeInsets(
    topBottom: PledgeViewLayout.Margin.topBottom,
    leftRight: PledgeViewLayout.Margin.leftRight
  )
}

/// Styles the main checkout title label.
func applyPledgeTitleLabelStyle(_ label: UILabel) {
  label.numberOfLines = 1
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_title2().bolded
}

/// Styles section header labels (for example Collection plan and Payment).
func applyPledgeSectionTitleLabelStyle(_ label: UILabel) {
  label.numberOfLines = 1
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_headline().bolded
}

/// Styles an individual titled section container stack view.
func applyPledgeSectionStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.grid(2)
}

