import KDS
import Library
import UIKit

/// Enumeration representing `PledgePaymentPlanOptionConstants` cases.
enum PledgePaymentPlanOptionConstants {
  static let contentInsets = NSDirectionalEdgeInsets(top: 1.0, leading: 0, bottom: 1.0, trailing: 0)
  static let defaultPaddingSpacing = Styles.grid(2)
  static let optionDescriptorStackViewSpacing = Styles.grid(1)
  static let selectionIndicatorImageWidth = Styles.grid(4)
}

func applyOptionDescriptorStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = PledgePaymentPlanOptionConstants.optionDescriptorStackViewSpacing
  stackView.alignment = .leading
}

func applyPlotSelectedStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = PledgePaymentPlanOptionConstants.optionDescriptorStackViewSpacing
  stackView.alignment = .leading
}

func applyPaymentIncrementsStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = PledgePaymentPlanOptionConstants.defaultPaddingSpacing
  stackView.alignment = .leading
}

func applyOptionTitleLabelStyle(_ label: UILabel) {
  label.accessibilityTraits = UIAccessibilityTraits.header
  label.adjustsFontForContentSizeCategory = true
  label.numberOfLines = 0
  label.font = UIFont.ksr_subhead().bolded
}

func applyOptionSubtitleLabelStyle(_ label: UILabel) {
  label.accessibilityTraits = UIAccessibilityTraits.header
  label.adjustsFontForContentSizeCategory = true
  label.numberOfLines = 0
  label.font = UIFont.ksr_caption1()
  label.textColor = LegacyColors.ksr_support_400.uiColor()
}

func applySelectionIndicatorImageViewStyle(_ imageView: UIImageView) {
  imageView.contentMode = .center
}

func applyOptionTermsOfUseStyle(_ button: UIButton) {
  button.configuration = {
    var config = UIButton.Configuration.borderless()
    config.contentInsets = PledgePaymentPlanOptionConstants.contentInsets
    config.baseForegroundColor = LegacyColors.ksr_create_700.uiColor()
    return config
  }()

  button.contentHorizontalAlignment = .leading
}

func applyOptionTextColorByState(_ label: UILabel, isEnabled: Bool) {
  label.textColor = isEnabled ? LegacyColors.ksr_black.uiColor() : LegacyColors.ksr_support_300.uiColor()
}
