import KDS
import Library
import Prelude
import UIKit

extension RewardAddOnCardView {
  /// Applies styling to stack views, labels, stepper controls, and buttons of `RewardAddOnCardView`.
  public override func bindStyles() {
    super.bindStyles()

    _ = checkoutWhiteBackgroundStyle(self)
    applyAddButtonStyle(self.addButton)

    var stackViews = [
      self.detailsStackView,
      self.titleAmountStackView,
      self.includedItemsStackView,
      self.rewardLocationStackView
    ]
    stackViews.insert(self.estimatedShippingStackView, at: 3)
    stackViews.forEach(applySectionStackViewStyle)

    applyRootStackViewStyle(self.rootStackView)
    applyDetailsStackViewStyle(self.detailsStackView)
    applyTitleAmountStackViewStyle(self.titleAmountStackView)
    _ = separatorStyle(self.includedItemsSeparator)
    applyIncludedItemsStackViewStyle(self.includedItemsStackView)
    applyIncludedItemsTitleLabel(self.includedItemsTitleLabel)
    applyIncludedItemsLabel(self.includedItemsLabel)
    _ = separatorStyle(self.estimatedShippingSeparator)
    applyIncludedItemsStackViewStyle(self.estimatedShippingStackView)
    applyEstimatedShippingTitleLabel(self.estimatedShippingTitleLabel)
    applyEstimatedShippingLabel(self.estimatedShippingLabel)
    applyDescriptionLabelStyle(self.descriptionLabel)
    applyRewardTitleLabelStyle(self.rewardTitleLabel)
    applyAmountLabelStyle(self.amountLabel)
    applyAmountConvertedLabelStyle(self.amountConversionLabel)
    applyQuantityLabelContainerStyle(self.quantityLabelContainer)
    applyQuantityLabelStyle(self.quantityLabel)
    applyStepperStyle(self.stepper)
    applyStepperStackViewStyle(self.stepperStackView)

    self.rewardLocationStackView.addArrangedSubviews(
      self.rewardLocationTitleLabel,
      self.rewardLocationPickupLabel
    )

    applyIncludedItemsStackViewStyle(self.rewardLocationStackView)
    applyRewardLocationTitleLabelStyle(self.rewardLocationTitleLabel)
    applySectionBodyLabelStyle(self.rewardLocationPickupLabel)
    applyRewardImageViewStyle(self.rewardImageView)
  }
}

// MARK: - Styles

private func applyIncludedItemsTitleLabel(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.font = .ksr_callout().weighted(.semibold)
  label.text = Strings.project_view_pledge_includes()
  label.textColor = LegacyColors.ksr_support_400.uiColor()
}

private func applyEstimatedShippingTitleLabel(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.font = .ksr_callout().weighted(.semibold)
  label.text = Strings.Estimated_Shipping()
  label.textColor = LegacyColors.ksr_support_400.uiColor()
}

private func applyEstimatedShippingLabel(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.font = .ksr_callout()
}

private func applyIncludedItemsLabel(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.font = .ksr_callout()
}

private func applyBaseRewardLabelStyle(_ label: UILabel) {
  label.numberOfLines = 0
  label.textAlignment = .left
  label.lineBreakMode = .byWordWrapping
}

private func applyDetailsStackViewStyle(_ stackView: UIStackView) {
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = .init(all: Styles.grid(3))
  stackView.spacing = Styles.grid(3)
}

private func applyIncludedItemsStackViewStyle(_ stackView: UIStackView) {
  stackView.spacing = Styles.grid(2)
}

private func applyAmountLabelStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.textColor = LegacyColors.ksr_create_700.uiColor()
  label.font = UIFont.ksr_title3().bolded
}

private func applyAmountConvertedLabelStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.textColor = LegacyColors.ksr_support_400.uiColor()
  label.font = UIFont.ksr_footnote().weighted(.medium)
}

private func applyDescriptionLabelStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_body()
}

private func applyTitleAmountStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.gridHalf(1)
}

private func applyRewardTitleLabelStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_title3().bolded
}

private func applySectionStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.grid(1)
}

private func applySectionBodyLabelStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_body()
}

private func applyRootStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
}

private func applyRewardImageViewStyle(_ imageView: UIImageView) {
  imageView.contentMode = .scaleAspectFill
  imageView.clipsToBounds = true
}

private func applyQuantityLabelContainerStyle(_ view: UIView) {
  _ = checkoutRoundedCornersStyle(view)
  view.layoutMargins = .init(topBottom: Styles.grid(1), leftRight: Styles.grid(2))
  view.layer.borderColor = LegacyColors.ksr_support_300.uiColor().cgColor
  view.layer.borderWidth = 1
}

private func applyQuantityLabelStyle(_ label: UILabel) {
  label.font = UIFont.ksr_headline().monospaced
}

private func applyStepperStyle(_ stepper: UIStepper) {
  _ = checkoutStepperStyle(stepper)
  stepper.setDecrementImage(image(named: "stepper-decrement-normal-grey"), for: .normal)
  stepper.setIncrementImage(image(named: "stepper-increment-normal-grey"), for: .normal)
}

private func applyStepperStackViewStyle(_ stackView: UIStackView) {
  stackView.alignment = .center
}

private func applyAddButtonStyle(_ button: UIButton) {
  button.applyStyleConfiguration(KSRButtonStyle.filled)
  button.setTitle(Strings.Add(), for: .normal)
}

private func applyRewardLocationTitleLabelStyle(_ label: UILabel) {
  applySectionBodyLabelStyle(label)
  label.text = Strings.Reward_location()
  label.textColor = LegacyColors.ksr_support_400.uiColor()
  label.font = .ksr_headline()
}

