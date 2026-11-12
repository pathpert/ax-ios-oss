import KDS
import Library
import UIKit

extension RewardCardView {
  /// Applies stack, label, pill, and image styling to `RewardCardView` subviews.
  public override func bindStyles() {
    super.bindStyles()

    let stackViews = [
      self.detailsStackView,
      self.priceStackView,
      self.descriptionStackView,
      self.includedItemsStackView,
      self.estimatedShippingStackView,
      self.estimatedDeliveryStackView,
      self.rewardLocationStackView
    ]

    stackViews.forEach(applySectionStackViewStyle)
    applyRootStackViewStyle(self.rootStackView)
    applyDetailsStackViewStyle(self.detailsStackView)
    applyPriceStackViewStyle(self.priceStackView)

    let sectionPairs: [(UIStackView, UILabel, UILabel?, (UILabel) -> Void)] = [
      (self.includedItemsStackView, self.includedItemsTitleLabel, nil, applyIncludedItemsTitleLabelStyle),
      (
        self.estimatedDeliveryStackView,
        self.estimatedDeliveryTitleLabel,
        self.estimatedDeliveryDateLabel,
        applyEstimatedDeliveryTitleLabelStyle
      ),
      (
        self.estimatedShippingStackView,
        self.estimatedShippingTitleLabel,
        self.estimatedShippingLabel,
        applyEstimatedShippingTitleLabelStyle
      ),
      (
        self.rewardLocationStackView,
        self.rewardLocationTitleLabel,
        self.rewardLocationPickupLabel,
        applyRewardLocationTitleLabelStyle
      )
    ]

    sectionPairs.forEach { stack, titleLabel, bodyLabel, applyTitleStyle in
      applyIncludedItemsStackViewStyle(stack)
      applyTitleStyle(titleLabel)
      if let bodyLabel { applyRewardSectionBodyStyle(bodyLabel) }
      stack.subviews.dropFirst().compactMap { $0 as? UILabel }.forEach(applyRewardSectionBodyStyle)
    }

    applyRewardSectionBodyStyle(self.descriptionLabel)
    applyBaseRewardLabelStyle(self.rewardTitleLabel)
    applyRewardTitleLabelStyle(self.rewardTitleLabel)
    applyBaseRewardLabelStyle(self.minimumPriceLabel)
    applyMinimumPriceLabelStyle(self.minimumPriceLabel)
    applyBaseRewardLabelStyle(self.minimumPriceConversionLabel)
    applyMinimumPriceConversionLabelStyle(self.minimumPriceConversionLabel)
    applyPillsViewStyle(self.pillsView)
    applyRewardImageViewStyle(self.rewardImageView)
  }

  func load(items: [String]) {
    self.includedItemsStackView.subviews.forEach { $0.removeFromSuperview() }

    let includedItemViews = items.map { item -> UIView in
      let label = UILabel()
      applyRewardSectionBodyStyle(label)
      label.text = item
      return label
    }

    let separatedItemViews = includedItemViews.dropLast().flatMap { view -> [UIView] in
      let separator = UIView()
      _ = separatorStyle(separator)
      separator.heightAnchor.constraint(equalToConstant: 1).isActive = true
      return [view, separator]
    }

    let allItemViews = [self.includedItemsTitleLabel]
      + separatedItemViews
      + [includedItemViews.last].compact()

    self.includedItemsStackView.addArrangedSubviews(allItemViews)
  }
}

// MARK: - UICollectionViewDelegate

extension RewardCardView: UICollectionViewDelegate {
  /// Updates pill label maximum layout width prior to display so multi-line pills wrap cleanly.
  public func collectionView(
    _ collectionView: UICollectionView,
    willDisplay cell: UICollectionViewCell,
    forItemAt _: IndexPath
  ) {
    guard let pillCell = cell as? PillCell else { return }
    pillCell.label.preferredMaxLayoutWidth = collectionView.bounds.width
  }
}

// MARK: - Styles

private func applyRewardSectionBodyStyle(_ label: UILabel) {
  applyBaseRewardLabelStyle(label)
  applySectionBodyLabelStyle(label)
}

private func applyBaseRewardLabelStyle(_ label: UILabel) {
  label.numberOfLines = 0
  label.textAlignment = .left
  label.lineBreakMode = .byWordWrapping
}

private func applySectionTitleLabelStyle(_ label: UILabel, text: String) {
  applyBaseRewardLabelStyle(label)
  label.font = .ksr_headline()
  label.text = text
  label.textColor = LegacyColors.ksr_support_400.uiColor()
}

private func applyIncludedItemsTitleLabelStyle(_ label: UILabel) {
  applySectionTitleLabelStyle(label, text: Strings.project_view_pledge_includes())
}

private func applyEstimatedDeliveryTitleLabelStyle(_ label: UILabel) {
  applySectionTitleLabelStyle(label, text: Strings.Estimated_delivery())
}

private func applyEstimatedShippingTitleLabelStyle(_ label: UILabel) {
  applySectionTitleLabelStyle(label, text: Strings.Estimated_Shipping())
}

private func applyRewardLocationTitleLabelStyle(_ label: UILabel) {
  applySectionTitleLabelStyle(label, text: Strings.Reward_location())
}

private func applyPillsViewStyle(_ view: PillsView) {
  view.backgroundColor = view.backgroundColor
}

private func applySectionStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.spacing = Styles.grid(1)
}

private func applyDetailsStackViewStyle(_ stackView: UIStackView) {
  stackView.spacing = Styles.grid(3)
  stackView.isLayoutMarginsRelativeArrangement = true
  stackView.layoutMargins = .init(all: Styles.grid(3))
}

private func applyPriceStackViewStyle(_ stackView: UIStackView) {
  stackView.spacing = Styles.gridHalf(1)
}

private func applySectionBodyLabelStyle(_ label: UILabel) {
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_body()
}

private func applyIncludedItemsStackViewStyle(_ stackView: UIStackView) {
  stackView.spacing = Styles.grid(2)
}

private func applyRewardTitleLabelStyle(_ label: UILabel) {
  label.textColor = LegacyColors.ksr_support_700.uiColor()
  label.font = UIFont.ksr_title2().bolded
}

private func applyMinimumPriceLabelStyle(_ label: UILabel) {
  label.textColor = LegacyColors.ksr_create_700.uiColor()
  label.font = UIFont.ksr_title3().bolded
}

private func applyMinimumPriceConversionLabelStyle(_ label: UILabel) {
  label.textColor = LegacyColors.ksr_create_700.uiColor()
  label.font = UIFont.ksr_caption1().bolded
}

private func applyRewardImageViewStyle(_ imageView: UIImageView) {
  imageView.contentMode = .scaleAspectFill
  imageView.clipsToBounds = true
}

private func applyRootStackViewStyle(_ stackView: UIStackView) {
  stackView.axis = .vertical
  stackView.backgroundColor = Colors.Background.Surface.primary.uiColor()
  stackView.rounded(with: Styles.grid(3))
}

