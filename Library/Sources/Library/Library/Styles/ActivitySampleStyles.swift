import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Style for the backing title label in the activity sample card.
public let activitySampleBackingTitleLabelStyle =
  UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
    <> UILabel.lens.numberOfLines .~ 2
    <> UILabel.lens.lineBreakMode .~ .byTruncatingTail

/// Table cell layout and background style for the activity sample card.
public let activitySampleCellStyle: (UITableViewCell) -> UITableViewCell = { cell in
  cell |> baseTableViewCellStyle()
    |> UITableViewCell.lens.backgroundColor .~ .clear
    |> UITableViewCell.lens.contentView.layoutMargins %~~ { _, view in
      view.traitCollection.isRegularRegular
        ? .init(top: Styles.grid(4), left: Styles.grid(30), bottom: Styles.grid(3), right: Styles.grid(30))
        : .init(top: Styles.grid(4), left: Styles.grid(2), bottom: Styles.grid(3), right: Styles.grid(2))
    }
}

/// Style for the friend-follow description label in the activity sample card.
public let activitySampleFriendFollowLabelStyle =
  UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
    <> UILabel.lens.numberOfLines .~ 2
    <> UILabel.lens.lineBreakMode .~ .byTruncatingTail
    <> UILabel.lens.font .~ .ksr_subhead()

/// Style for the project subtitle label in the activity sample card.
public let activitySampleProjectSubtitleLabelStyle =
  UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
    <> UILabel.lens.numberOfLines .~ 2
    <> UILabel.lens.lineBreakMode .~ .byTruncatingTail
    <> UILabel.lens.font .~ .ksr_subhead()

/// Style for the bold project title label in the activity sample card.
public let activitySampleProjectTitleLabelStyle =
  UILabel.lens.textColor .~ LegacyColors.ksr_support_700.uiColor()
    <> UILabel.lens.numberOfLines .~ 2
    <> UILabel.lens.lineBreakMode .~ .byTruncatingTail
    <> UILabel.lens.font .~ UIFont.ksr_subhead().bolded

/// Button style for the "See all activity" CTA in the activity sample card.
public let activitySampleSeeAllActivityButtonStyle: ButtonStyle = { button in
  button.applyStyleConfiguration(KSRButtonLegacyStyle.grey)
  button.setTitle(Strings.discovery_activity_sample_button_see_all_activity(), for: .normal)
  return button
}

/// Stack view spacing and margin style for the activity sample container.
public let activitySampleStackViewStyle =
  UIStackView.lens.spacing .~ Styles.grid(3)
    <> UIStackView.lens.layoutMargins .~ .init(all: Styles.grid(4))
    <> UIStackView.lens.isLayoutMarginsRelativeArrangement .~ true

/// Style for the "Since your last visit" section header label in the activity sample card.
public let activitySampleTitleLabelStyle =
  UILabel.lens.font .~ .ksr_footnote()
    <> UILabel.lens.textColor .~ LegacyColors.ksr_support_400.uiColor()
    <> UILabel.lens.numberOfLines .~ 1
    <> UILabel.lens.lineBreakMode .~ .byTruncatingTail
    <> UILabel.lens.text %~ { _ in Strings.discovery_activity_sample_title_Since_your_last_visit() }
