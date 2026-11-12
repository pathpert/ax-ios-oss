import Foundation
import KDS
import KsApi
import Library
import Prelude
import UIKit

/// Height and width constants for facepile avatar image views on discovery project cards.
enum FacepileAvatarSize {
  static let height: CGFloat = 26.0
  static let width: CGFloat = 26.0
}

// MARK: - Styles

let discoveryCardAvatarImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.translatesAutoresizingMaskIntoConstraints .~ false
    |> \.layer.borderColor .~ LegacyColors.ksr_white.uiColor().cgColor
    |> \.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    |> \.layer.borderWidth .~ 2
    |> \.clipsToBounds .~ true
    |> ignoresInvertColorsImageViewStyle
    |> roundedStyle(cornerRadius: FacepileAvatarSize.width / 2)
}

let discoveryCardContentViewStyle: ViewStyle = { view in
  view
    |> \.preservesSuperviewLayoutMargins .~ false
    |> \.backgroundColor .~ LegacyColors.ksr_support_100.uiColor()
}

let discoveryCardContainerViewStyle: ViewStyle = { view in
  view
    |> roundedStyle(cornerRadius: Styles.grid(2))
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

let discoveryCardStatusContainerViewStyle: ViewStyle = { view in
  view
    |> \.layoutMargins .~ .init(topBottom: Styles.gridHalf(2), leftRight: Styles.gridHalf(3))
}

let discoveryCardGoalMetIconImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.image .~ Library.image(named: "icon--star")
    |> \.tintColor .~ LegacyColors.ksr_create_700.uiColor()
    |> \.contentMode .~ .center
}

let discoveryCardProjectImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.clipsToBounds .~ true
    |> \.backgroundColor .~ LegacyColors.ksr_support_300.uiColor()
    |> \.contentMode .~ .scaleAspectFill
    |> ignoresInvertColorsImageViewStyle
}

let discoveryCardProjectNameLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 2
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.font .~ UIFont.ksr_headline().bolded
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

let discoveryCardProjectBlurbLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 2
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.font .~ UIFont.ksr_subhead()
    |> \.textColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

let discoveryCardProjectStatusLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.backgroundColor .~ .clear
}

let discoveryCardFacepileDescriptionLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 2
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ UIFont.ksr_footnote().bolded
}

let discoveryCardProjectStatusIconImageStyle: ImageViewStyle = { imageView in
  imageView
    |> \.tintColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.contentMode .~ .center
}

let discoveryCardInfoStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ .horizontal
    |> \.spacing .~ Styles.grid(1)
    |> \.alignment .~ .fill
    |> \.distribution .~ .fill
}

let discoveryCardPercentFundedLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.textColor .~ LegacyColors.ksr_create_700.uiColor()
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

let discoveryCardBackersCountIconImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.image .~ Library.image(named: "icon--humans")
    |> \.tintColor .~ LegacyColors.ksr_support_400.uiColor()
    |> \.contentMode .~ .center
}

let discoveryCardBackersCountLabelStyle: LabelStyle = { label in
  label
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
}

let discoveryCardProjectInfoStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.distribution .~ .fill
    |> \.spacing .~ Styles.grid(2)
}

let discoveryCardFacepileStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.alignment .~ .center
    |> \.distribution .~ .fill
    |> \.spacing .~ Styles.grid(1)
}

let discoveryCardProjectDetailsStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> verticalStackViewStyle
    |> \.spacing .~ Styles.grid(2)
    |> \.alignment .~ .fill
    |> \.layoutMargins .~ .init(all: Styles.grid(3))
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.insetsLayoutMarginsFromSafeArea .~ false
}

let discoveryCardYoureABackerViewStyle: ViewStyle = { view in
  view
    |> roundedStyle(cornerRadius: Styles.grid(1))
    |> \.backgroundColor .~ LegacyColors.ksr_trust_500.uiColor()
    |> \.layoutMargins .~ .init(topBottom: Styles.grid(1), leftRight: Styles.gridHalf(3))
}

let discoveryCardYoureABackerLabelStyle: LabelStyle = { label in
  label
    |> \.font .~ UIFont.ksr_footnote().bolded
    |> \.textColor .~ LegacyColors.ksr_white.uiColor()
    |> \.numberOfLines .~ 1
    |> \.lineBreakMode .~ .byTruncatingTail
    |> \.text %~ { _ in Strings.Youre_a_backer_no_punctuation() }
}

