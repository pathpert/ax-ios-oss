import Foundation
import GraphAPI

/// Represents a single block-level element in a RichText list. Used to make implementing
/// the different views in SwiftUI more easily and with a consistent interface.
/// @deprecated Direct unvalidated construction of `RichTextElement` (whose `Style(rawValue:)` calls `assertionFailure` on unknown styles).
/// Prefer `NormalizeRichTextRequestSchema` and `RichTextController` in `ServerDrivenUI/modules/rich_text`.
public indirect enum RichTextElement: Sendable, Equatable {
  case text(Text, HeaderLevel?)
  case listItemOpen
  case listItemClose
  case listItem(Text)
  case audio(Audio)
  case photo(Photo)
  case video(Video)
  case oembed(OEmbed)
  case unknown

  /// A styled or linked inline text run and its nested child elements.
  public struct Text: Sendable, Equatable {
    let text: String
    let link: URL?
    let styles: [Style]
    let children: [RichTextElement]

    internal init(text: String, link: URL? = nil, styles: [Style] = [], children: [RichTextElement] = []) {
      self.text = text
      self.link = link
      self.styles = styles
      self.children = children
    }

    /// Supported GraphQL inline and heading style tags for a rich text run.
    public enum Style: String, Sendable, Equatable {
      case strong = "STRONG"
      case emphasis = "EMPHASIS"
      case heading1 = "HEADING_1"
      case heading2 = "HEADING_2"
      case heading3 = "HEADING_3"
      case heading4 = "HEADING_4"

      /// Parses a raw GraphQL style string into a `Style`, returning `nil` if unknown.
      public init?(rawValue: String) {
        switch rawValue {
        case "STRONG":
          self = .strong
        case "EMPHASIS":
          self = .emphasis
        case "HEADING_1":
          self = .heading1
        case "HEADING_2":
          self = .heading2
        case "HEADING_3":
          self = .heading3
        case "HEADING_4":
          self = .heading4
        default:
          assertionFailure("unknown style type: \(rawValue)")
          return nil
        }
      }
    }
  }

  /// Heading hierarchy level applied to a rich text paragraph.
  public enum HeaderLevel: String, Sendable, Equatable {
    case one = "HEADING_1"
    case two = "HEADING_2"
    case three = "HEADING_3"
    case four = "HEADING_4"

    /// Create a HeaderLevel from an array of style strings from GraphQL, if
    /// one is present
    internal init?(styles: [String]?) {
      for style in styles ?? [] {
        if let level = HeaderLevel(rawValue: style) {
          self = level
          return
        }
      }
      return nil
    }
  }

  /// Embedded audio block payload.
  public struct Audio: Sendable, Equatable {
    let altText: String?
    let assetID: String?
    let caption: String?
    let url: String?
  }

  /// Embedded photo block payload.
  public struct Photo: Sendable, Equatable {
    let altText: String?
    let assetID: String?
    let caption: String?
    let url: String?

    /// The link this photo should navigate to when tapped. `RichTextPhoto` itself has no
    /// `link` field; the server represents a linkable image as a `RichText` node whose `link`
    /// wraps a `RichTextPhoto` child, so this is populated during normalization from the
    /// enclosing text's link rather than from the photo's own GraphQL fields.
    let link: URL?
  }

  /// Encoding format metadata for an embedded video asset.
  public struct VideoFormat: Sendable, Equatable {
    let encoding: String
    let height: String
    let width: String
    let profile: String
    let url: String
  }

  /// Embedded video block payload.
  public struct Video: Sendable, Equatable {
    let altText: String?
    let assetID: String?
    let caption: String?
    let url: String?
    let posterURL: String?
    let formats: [VideoFormat]
  }

  /// Embedded oEmbed third-party media payload.
  public struct OEmbed: Sendable, Equatable {
    let width: Int
    let height: Int
    let version: String
    let title: String
    let type: String

    let iframeUrl: String?
    let originalUrl: String?
  }
}
