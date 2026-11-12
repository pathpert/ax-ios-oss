import KDS
import KsApi
import Library
import Prelude
import UIKit

/// `ProjectPamphletMainCell` extensions declared in `ProjectPamphletMainCell+Styles.swift`.
extension ProjectPamphletMainCell {
  internal override func bindStyles() {
    super.bindStyles()

    // maintain vertical spacing in one place so that it's consistent in nested stackviews
    let verticalSpacing = Styles.grid(3)

    _ = self
      |> baseTableViewCellStyle()
      |> UITableViewCell.lens.clipsToBounds .~ true
      |> UITableViewCell.lens.accessibilityElements .~ self.subviews

    self.contentStackView.backgroundColor = LegacyColors.ksr_white.uiColor()

    let subtitleLabelStyling = UILabel.lens.font .~ .ksr_caption1(size: 13)
      <> UILabel.lens.numberOfLines .~ 1
      <> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = [self.backersSubtitleLabel, self.deadlineSubtitleLabel]
      ||> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      ||> subtitleLabelStyling

    _ = self.pledgeSubtitleLabel |> subtitleLabelStyling

    _ = [self.backersTitleLabel, self.deadlineTitleLabel, self.pledgedTitleLabel]
      ||> UILabel.lens.font .~ .ksr_headline(size: 13)
      ||> UILabel.lens.numberOfLines .~ 1
      ||> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.categoryStackView
      |> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = self.categoryIconImageView
      |> UIImageView.lens.contentMode .~ .scaleAspectFit
      |> UIImageView.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UIImageView.lens.image .~ Library.image(named: "category-icon")
      |> UIImageView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.categoryNameLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.font .~ .ksr_body(size: 12)
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    let isIpad = self.traitCollection.isRegularRegular == true
    let leftRightInsetValue: CGFloat = isIpad ? Styles.grid(16) : Styles.grid(4)

    _ = self.contentStackView
      |> UIStackView.lens.layoutMargins %~~ { _, _ in
        isIpad
          ? .init(topBottom: Styles.grid(6), leftRight: leftRightInsetValue)
          : .init(
            top: Styles.grid(4),
            left: leftRightInsetValue,
            bottom: Styles.grid(3),
            right: leftRightInsetValue
          )
      }
      |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true
      |> UIStackView.lens.spacing .~ verticalSpacing

    _ = (self.projectNameAndCreatorStackView, self.contentStackView)
      |> ksr_setCustomSpacing(Styles.grid(4))

    _ = self.blurbAndOverviewStackview
      |> \.spacing .~ verticalSpacing

    _ = self.blurbStackView
      |> UIStackView.lens.layoutMargins .~ UIEdgeInsets(
        top: 0,
        left: 0,
        bottom: verticalSpacing, // Double spacing below blurb.
        right: 0
      )
      |> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true

    _ = self.conversionLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.font .~ UIFont.ksr_caption2().italicized
      |> UILabel.lens.numberOfLines .~ 2

    _ = self.creatorImageView
      |> ignoresInvertColorsImageViewStyle

    _ = self.creatorImageView
      |> UIImageView.lens.clipsToBounds .~ true
      |> UIImageView.lens.contentMode .~ .scaleAspectFill

    _ = self.creatorLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
      |> UILabel.lens.font .~ .ksr_headline(size: 13)
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.creatorStackView
      |> UIStackView.lens.alignment .~ .center
      |> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = self.fundingProgressContainerView
      |> UIView.lens.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()

    _ = self.locationImageView
      |> UIImageView.lens.contentMode .~ .scaleAspectFit
      |> UIImageView.lens.tintColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UIImageView.lens.image .~ Library.image(named: "location-icon")
      |> UIImageView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.locationNameLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.font .~ .ksr_body(size: 12)
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.locationStackView
      |> UIStackView.lens.spacing .~ Styles.grid(1)

    _ = self.projectBlurbLabel
      |> UILabel.lens.font %~~ { _, _ in
        isIpad
          ? .ksr_body(size: 18)
          : .ksr_body(size: 15)
      }
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
      |> UILabel.lens.numberOfLines .~ 0
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.projectNameAndCreatorStackView
      |> UIStackView.lens.spacing .~ (verticalSpacing / 2)

    _ = self.projectNameLabel
      |> UILabel.lens.font %~~ { _, _ in
        isIpad
          ? .ksr_title3(size: 28)
          : .ksr_title3(size: 20)
      }
      |> UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
      |> UILabel.lens.numberOfLines .~ 0
      |> UILabel.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.progressBarAndStatsStackView
      |> UIStackView.lens.spacing .~ verticalSpacing

    _ = self.stateLabel
      |> UILabel.lens.font .~ .ksr_headline(size: 12)
      |> UILabel.lens.numberOfLines .~ 2

    _ = self.statsStackView
      |> UIStackView.lens.isAccessibilityElement .~ true
      |> UIStackView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()

    _ = self.backingContainerViewLeadingConstraint
      |> \.constant .~ leftRightInsetValue

    _ = self.backingContainerView
      |> roundedStyle(cornerRadius: 2)
      |> UIView.lens.backgroundColor .~ LegacyColors.ksr_create_700.uiColor()
      |> UIView.lens.layoutMargins .~ .init(topBottom: Styles.grid(1), leftRight: Styles.gridHalf(3))

    _ = self.backingLabel
      |> UILabel.lens.textColor .~ LegacyColors.ksr_white.uiColor()
      |> UILabel.lens.font .~ .ksr_headline(size: 12)
  }
}

