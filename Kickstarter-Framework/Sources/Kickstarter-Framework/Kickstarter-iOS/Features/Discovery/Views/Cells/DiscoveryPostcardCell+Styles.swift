import AlamofireImage
import KDS
import KsApi
import Library
import Prelude
import UIKit

/// `DiscoveryPostcardCell` extensions declared in `DiscoveryPostcardCell+Styles.swift`.
extension DiscoveryPostcardCell {
  internal override func bindStyles() {
    super.bindStyles()

    self.backgroundGradientView.startPoint = .zero
    self.backgroundGradientView.endPoint = CGPoint(x: 0, y: 1)
    let gradient: [(UIColor?, Float)] = [
      (UIColor.init(white: 0.0, alpha: 0.5), 0),
      (UIColor.init(white: 0.0, alpha: 0.0), 1)
    ]
    self.backgroundGradientView.setGradient(gradient)

    _ = self
      |> baseTableViewCellStyle()
      // Future: the top should adjust to grid(4) when there is metadata present.
      |> DiscoveryPostcardCell.lens.contentView.layoutMargins %~~ { _, cell in
        cell.traitCollection.isRegularRegular
          ? .init(topBottom: Styles.grid(4), leftRight: Styles.grid(30))
          : .init(topBottom: Styles.grid(3), leftRight: Styles.grid(2))
      }
      |> DiscoveryPostcardCell.lens.accessibilityHint %~ { _ in
        Strings.dashboard_tout_accessibility_hint_opens_project()
      }

    _ = [self.backersTitleLabel, self.deadlineTitleLabel]
      ||> postcardStatsTitleStyle

    _ = [self.backersSubtitleLabel, self.deadlineSubtitleLabel, self.fundingSubtitleLabel]
      ||> postcardStatsSubtitleStyle

    _ = [
      self.backersTitleLabel, self.backersSubtitleLabel, self.deadlineTitleLabel,
      self.deadlineSubtitleLabel
    ]
      ||> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()

    _ = self.backersSubtitleLabel
      |> UILabel.lens.text %~ { _ in Strings.discovery_baseball_card_stats_backers() }

    _ = self.fundingTitleLabel
      |> postcardStatsTitleStyle
      |> UILabel.lens.textColor .~ LegacyColors.ksr_create_700.uiColor()

    _ = self.fundingSubtitleLabel
      |> UILabel.lens.text %~ { _ in Strings.discovery_baseball_card_stats_funded() }
      |> UILabel.lens.textColor .~ LegacyColors.ksr_create_700.uiColor()

    _ = self.cardView
      |> cardStyle()

    _ = self.fundingProgressContainerView
      |> UIView.lens.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()

    _ = self.fundingProgressBarView
      |> UIView.lens.backgroundColor .~ LegacyColors.ksr_create_700.uiColor()

    _ = self.metadataIconImageView
      |> UIImageView.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()

    _ = self.metadataLabel
      |> postcardMetadataLabelStyle

    _ = self.metadataStackView
      |> postcardMetadataStackViewStyle

    _ = self.metadataView
      |> cardStyle()
      |> \.layoutMargins .~ .init(all: Styles.grid(1))

    _ = self.projectImageView
      |> ignoresInvertColorsImageViewStyle

    _ = self.projectStatsSocialLocationStackView
      |> UIStackView.lens.spacing .~ Styles.grid(3)
      |> UIStackView.lens.layoutMargins .~ .init(topBottom: Styles.grid(4), leftRight: Styles.grid(3))
      |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true

    _ = self.projectNameAndBlurbLabel
      |> UILabel.lens.numberOfLines .~ 3
      |> UILabel.lens.lineBreakMode .~ .byTruncatingTail
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.projectStateSubtitleLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.font .~ .ksr_body(size: 13)
      |> UILabel.lens.numberOfLines .~ 1
      |> UILabel.lens.lineBreakMode .~ .byTruncatingTail

    _ = self.projectStateTitleLabel
      |> UILabel.lens.font .~ .ksr_headline(size: 14)

    _ = self.projectStateStackView
      |> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = self.projectStatsStackView
      |> UIStackView.lens.spacing .~ Styles.grid(4)

    styleDiscoverySaveButton(self.saveButton)

    _ = self.socialAvatarImageView
      |> UIImageView.lens.layer.shouldRasterize .~ true

    _ = self.socialAvatarImageView
      |> ignoresInvertColorsImageViewStyle

    _ = self.socialLabel
      |> UILabel.lens.numberOfLines .~ 2
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.font .~ .ksr_headline(size: 13.0)

    _ = self.socialStackView
      |> UIStackView.lens.alignment .~ .center
      |> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = self.locationStackView
      |> locationStackViewStyle

    _ = self.locationLabel
      |> locationLabelStyle

    _ = self.locationImageView
      |> locationImageViewStyle
  }
}

// MARK: - Styles

private let locationStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.alignment .~ .center
    |> \.distribution .~ .fill
    |> \.spacing .~ Styles.grid(1)
}

private let locationLabelStyle: LabelStyle = { label in
  label
    |> \.font .~ .ksr_footnote()
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.numberOfLines .~ 1
}

private let locationImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> UIImageView.lens.image .~ Library.image(named: "location-icon")
    |> \.tintColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.contentMode .~ .scaleAspectFit
}

