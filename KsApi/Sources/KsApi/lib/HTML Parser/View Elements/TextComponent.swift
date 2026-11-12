import Foundation

/// Inline styled text span parsed from HTML rich-text blocks.
///
/// Negative Constraint: Do not render directly without applying `styles` and resolving optional `link` URLs.
public struct TextComponent {
  /// Plain UTF-8 text content of this span.
  public let text: String
  /// Optional hyperlink target URL string when `.link` style is present.
  public let link: String?
  /// Formatting styles applied to this span.
  public let styles: [TextStyleType]

  // Direct body childs for text allows only TextBlockTypes
  enum TextBlockType: String, CaseIterable {
    case paragraph = "p"
    case header1 = "h1"
    case header2 = "h2"
    case header3 = "h3"
    case header4 = "h4"
    case header5 = "h5"
    case header6 = "h6"
    case unorderedList = "ul"
    case orderedList = "ol"
  }

  /// Supported HTML tag styles mapped to rich-text attributes.
  public enum TextStyleType: String {
    case bold = "strong"
    case emphasis = "em"
    case bulletStart = "li"
    case bulletEnd = "</li>"
    case link = "a"
    case header1 = "h1"
    case header2 = "h2"
    case header3 = "h3"
    case header4 = "h4"
    case header5 = "h5"
    case header6 = "h6"
  }
}
