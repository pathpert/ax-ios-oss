import KDS
import SwiftUI
import UIKit

/// Use as the default environment style so block views adapt to light/dark automatically.
public struct AutomaticRichTextStyle: RichTextStyle, Sendable {
  /// Creates a default `AutomaticRichTextStyle` instance.
  public init() {}

  // MARK: RichTextStyle

  /// Default body copy font.
  public var bodyFont: Font {
    InterFont.bodyLG.swiftUIFont(size: nil)
  }

  /// Adaptive foreground color for body copy.
  public var bodyColor: AdaptiveColor {
    Colors.Text.primary
  }

  /// Font for H1 headings.
  public var heading1Font: Font {
    InterFont.heading2XL.swiftUIFont(size: nil)
  }

  /// Font for H2 headings.
  public var heading2Font: Font {
    InterFont.headingXL.swiftUIFont(size: nil)
  }

  /// Font for H3 headings.
  public var heading3Font: Font {
    InterFont.headingLG.swiftUIFont(size: nil)
  }

  /// Font for H4 headings.
  public var heading4Font: Font {
    InterFont.headingMD.swiftUIFont(size: nil)
  }

  /// Adaptive foreground color for headings.
  public var headingColor: AdaptiveColor {
    Colors.Text.primary
  }

  /// Adaptive color applied to hyperlinks.
  public var linkColor: AdaptiveColor {
    Colors.Text.Accent.Blue.bolder
  }

  /// Whether hyperlinks render with an underline.
  public var linkUnderlined: Bool {
    true
  }

  /// Adaptive container background color.
  public var backgroundColor: AdaptiveColor {
    Colors.Background.Surface.primary
  }

  /// Vertical spacing between consecutive rich text blocks.
  public var blockSpacing: CGFloat {
    Spacing.unit_04
  }

  /// Leading indentation applied to list items.
  public var listIndentation: CGFloat {
    Spacing.unit_06
  }

  /// Horizontal padding surrounding rich text content.
  public var contentHorizontalPadding: CGFloat {
    Spacing.unit_04
  }

  /// Italicized font used for media captions.
  public var mediaCaptionFont: Font {
    InterFont.caption1.swiftUIFont(size: nil)
      .italic()
  }

  /// Adaptive foreground color for media captions.
  public var mediaCaptionColor: AdaptiveColor {
    Colors.Text.secondary
  }

  /// Horizontal text alignment for media captions.
  public var mediaCaptionAlignment: TextAlignment {
    .center
  }

  /// Corner radius applied to embedded media frames.
  public var mediaCornerRadius: CGFloat {
    Dimension.CornerRadius.medium
  }

  /// Placeholder surface color shown while media loads.
  public var mediaPlaceholderColor: AdaptiveColor {
    Colors.Background.Surface.secondary
  }
}
