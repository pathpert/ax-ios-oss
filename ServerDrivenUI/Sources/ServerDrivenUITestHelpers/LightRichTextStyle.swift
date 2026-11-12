import KDS
import ServerDrivenUI
import SwiftUI

/// Fixed light theme for rich text with explicit light-mode colors from KDS.
/// Use for screenshot tests and snapshots so colors are deterministic (no runtime trait resolution).
public struct LightRichTextStyle: RichTextStyle, Sendable {
  private let parent = AutomaticRichTextStyle()
  /// Creates a deterministic light-mode rich text style for tests and snapshots.
  public init() {}

  // MARK: - RichTextStyle

  /// Font used for standard body paragraphs.
  public var bodyFont: Font { self.parent.bodyFont }
  /// Fixed light-mode foreground color for body text.
  public var bodyColor: AdaptiveColor { self.parent.bodyColor.resolvedForLightMode() }
  /// Font used for level-1 headings.
  public var heading1Font: Font { self.parent.heading1Font }
  /// Font used for level-2 headings.
  public var heading2Font: Font { self.parent.heading2Font }
  /// Font used for level-3 headings.
  public var heading3Font: Font { self.parent.heading3Font }
  /// Font used for level-4 headings.
  public var heading4Font: Font { self.parent.heading4Font }
  /// Fixed light-mode foreground color for heading text.
  public var headingColor: AdaptiveColor { self.parent.headingColor.resolvedForLightMode() }
  /// Fixed light-mode foreground color for inline links.
  public var linkColor: AdaptiveColor { self.parent.linkColor.resolvedForLightMode() }
  /// Whether inline links render with an underline.
  public var linkUnderlined: Bool { self.parent.linkUnderlined }
  /// Fixed light-mode background color behind rich text content.
  public var backgroundColor: AdaptiveColor { self.parent.backgroundColor.resolvedForLightMode() }
  /// Vertical spacing between adjacent rich text blocks.
  public var blockSpacing: CGFloat { self.parent.blockSpacing }
  /// Leading indentation applied to list items.
  public var listIndentation: CGFloat { self.parent.listIndentation }
  /// Horizontal padding applied to the rich text container.
  public var contentHorizontalPadding: CGFloat { self.parent.contentHorizontalPadding }
  /// Corner radius applied to media thumbnails and embeds.
  public var mediaCornerRadius: CGFloat { self.parent.mediaCornerRadius }
  /// Font used for captions below media blocks.
  public var mediaCaptionFont: Font { self.parent.mediaCaptionFont }
  /// Fixed light-mode foreground color for media captions.
  public var mediaCaptionColor: AdaptiveColor { self.parent.mediaCaptionColor.resolvedForLightMode() }
  /// Text alignment used for media captions.
  public var mediaCaptionAlignment: TextAlignment { self.parent.mediaCaptionAlignment }
  /// Fixed light-mode placeholder fill color while media loads.
  public var mediaPlaceholderColor: AdaptiveColor { self.parent.mediaPlaceholderColor.resolvedForLightMode() }
}
