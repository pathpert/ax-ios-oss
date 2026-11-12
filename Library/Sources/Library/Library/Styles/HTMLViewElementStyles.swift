import KDS
import Prelude
import Prelude_UIKit
import UIKit

/// Base `UITextView` style for non-editable HTML rich text blocks supporting dynamic type and links.
public let textViewStyle: TextViewStyle = { textView in
  let updatedTextView = textView
    |> UITextView.lens.isScrollEnabled .~ false
    |> UITextView.lens.textContainerInset .~ UIEdgeInsets.zero
    |> UITextView.lens.textContainer.lineFragmentPadding .~ 0
    |> UITextView.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> \.textAlignment .~ .left

  let configurableSettingsTextView = updatedTextView
    |> \.adjustsFontForContentSizeCategory .~ true
    |> \.isEditable .~ false
    |> \.isSelectable .~ true
    |> \.isUserInteractionEnabled .~ true
    |> \.dataDetectorTypes .~ .link

  return configurableSettingsTextView
}

/// Style for inline HTML content images.
public let imageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.clipsToBounds .~ true
    |> \.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    |> \.contentMode .~ .scaleAspectFit
    |> ignoresInvertColorsImageViewStyle
}

/// Style for HTML video/media thumbnail image views.
public let thumbnailImageViewStyle: ImageViewStyle = { imageView in
  imageView
    |> \.clipsToBounds .~ true
    |> \.backgroundColor .~ LegacyColors.ksr_black.uiColor()
    |> \.contentMode .~ .scaleAspectFit
    |> ignoresInvertColorsImageViewStyle
}
