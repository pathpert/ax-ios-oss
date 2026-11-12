import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Layout constants shared across comment table cells.
public enum CommentCellStyles {
  /// Spacing constants for nested comment cell content.
  public enum Content {
    /// Number of legacy grid units used for threaded reply indentation.
    public static let leftIndentWidth: Int = 5
  }
}

/// Root stack view style applied to indented comment reply cells.
public let commentCellIndentedRootStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ .vertical
    |> \.layoutMargins .~ .init(
      top: Styles.grid(1),
      left: Styles.grid(CommentCellStyles.Content.leftIndentWidth),
      bottom: Styles.grid(3),
      right: Styles.grid(1)
    )
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.spacing .~ Styles.grid(3)
}

/// Root stack view style applied to top-level comment cells.
public let commentCellRootStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ .vertical
    |> \.layoutMargins .~ .init(topBottom: Styles.grid(3), leftRight: Styles.grid(1))
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.insetsLayoutMarginsFromSafeArea .~ false
    |> \.spacing .~ Styles.grid(3)
}

/// Interactive read-only body text view style for comment content with link detection.
public let commentBodyTextViewStyle: TextViewStyle = { textView in
  let t = textView
    |> UITextView.lens.isScrollEnabled .~ false
    |> UITextView.lens.textContainerInset .~ UIEdgeInsets.zero
    |> UITextView.lens.textContainer.lineFragmentPadding .~ 0
    |> UITextView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.textAlignment .~ .left

  let b = t
    |> \.font .~ UIFont.ksr_callout()
    |> \.adjustsFontForContentSizeCategory .~ true
    |> \.isEditable .~ false
    |> \.isSelectable .~ true
    |> \.isUserInteractionEnabled .~ true
    |> \.dataDetectorTypes .~ .link

  return b
}

/// Uppercase celebratory badge style for Superbacker comment authors.
public let superbackerAuthorBadgeStyle: PaddingLabelStyle = { label in
  label
    |> \.text .~ Strings.Superbacker().uppercased()
    |> \.font .~ UIFont.ksr_headline(size: 10)
    |> \.textColor .~ LegacyColors.ksr_celebrate_500.uiColor()
    |> \.backgroundColor .~ .clear
    |> \.insets .~ .zero
    |> \.adjustsFontForContentSizeCategory .~ true
}

/// Pill badge style identifying comments authored by the signed-in user.
public let youAuthorBadgeStyle: PaddingLabelStyle = { label in
  label
    |> \.text .~ Strings.update_comments_you()
    |> \.font .~ UIFont.ksr_footnote()
    |> \.textColor .~ LegacyColors.ksr_trust_700.uiColor()
    |> \.backgroundColor .~ LegacyColors.ksr_trust_100.uiColor()
    |> roundedStyle(cornerRadius: Styles.grid(1))
    |> \.adjustsFontForContentSizeCategory .~ true
    |> \.insets .~ UIEdgeInsets(all: Styles.grid(1))
}

/// Base author role badge label style for creator and collaborator indicators.
public let authorBadgeLabelStyle: PaddingLabelStyle = { label in
  label
    |> \.numberOfLines .~ 1
    |> \.textColor .~ LegacyColors.ksr_create_500.uiColor()
    |> \.textAlignment .~ .left
    |> \.font .~ UIFont.ksr_callout().bolded
    |> \.adjustsFontForContentSizeCategory .~ true
}

/// Resets padded badge label text and background state when reusing cells.
public let resetTextStyle: PaddingLabelStyle = { label in
  label
    |> \.text .~ nil
    |> \.backgroundColor .~ .clear
    |> \.insets .~ UIEdgeInsets(all: Styles.grid(1))
}

/// Bordered container style for the inline "view replies" button row.
public let viewRepliesStackViewStyle: StackViewStyle = { stackView in
  stackView
    |> \.axis .~ .horizontal
    |> \.alignment .~ .center
    |> \.layoutMargins .~ .init(all: Styles.grid(3))
    |> \.isLayoutMarginsRelativeArrangement .~ true
    |> \.spacing .~ Styles.grid(1)
    |> \.layer.borderWidth .~ 1
    |> \.layer.borderColor .~ LegacyColors.ksr_support_200.uiColor().cgColor
    |> roundedStyle(cornerRadius: 2.0)
}
