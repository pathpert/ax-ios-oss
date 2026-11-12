import Foundation
import KsApi

// MARK: - Rule 3: Poka-Yoke Schemas for Server-Driven UI RichText Normalization

/// Input schema representing a single RichText node for Poka-Yoke normalization validation.
public struct RichTextNodeInputSchema: Codable, Equatable, Sendable {
  /// Discriminator for the RichText block type (`"text"`, `"photo"`, or `"listItem"`).
  public let nodeType: String
  /// Plain text content for text or list-item nodes.
  public let text: String?
  /// Optional hyperlink URL string attached to the node.
  public let linkURL: String?
  /// Style modifier identifiers (e.g., `"STRONG"`, `"EMPHASIS"`, `"HEADING_1"`).
  public let styles: [String]
  /// HTTPS image URL string when `nodeType` is `"photo"`.
  public let photoURL: String?
  /// Accessibility alt text for a photo node.
  public let photoAltText: String?
  /// Inline child nodes (maximum nesting depth of 1).
  public let children: [RichTextNodeInputSchema]

  /// AX metadata descriptors for validating RichText node fields.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "nodeType": .describe(
      field: "nodeType",
      meaning: "Block-level RichText node discriminator.",
      format: "Enum string: text | photo | listItem",
      negativeConstraints: [
        "Do not pass unknown or raw HTML tags (e.g. <div>, <script>).",
        "Do not nest children more than 1 level deep."
      ]
    ),
    "styles": .describe(
      field: "styles",
      meaning: "Typography style modifiers for text nodes.",
      format: "Array of: STRONG | EMPHASIS | HEADING_1 | HEADING_2 | HEADING_3 | HEADING_4",
      negativeConstraints: [
        "Do not pass unknown style strings (legacy RichTextElement.Text.Style triggers assertionFailure on unknown values!)."
      ]
    ),
    "photoURL": .describe(
      field: "photoURL",
      meaning: "HTTPS URL of a RichText photo block.",
      format: "https:// URL string",
      negativeConstraints: [
        "Do not pass empty or non-HTTPS URLs on photo nodes."
      ]
    )
  ]

  /// Initializes a `RichTextNodeInputSchema` node.
  public init(
    nodeType: String,
    text: String? = nil,
    linkURL: String? = nil,
    styles: [String] = [],
    photoURL: String? = nil,
    photoAltText: String? = nil,
    children: [RichTextNodeInputSchema] = []
  ) {
    self.nodeType = nodeType
    self.text = text
    self.linkURL = linkURL
    self.styles = styles
    self.photoURL = photoURL
    self.photoAltText = photoAltText
    self.children = children
  }
}

/// Request schema for validating and normalizing a list of RichText block inputs.
public struct NormalizeRichTextRequestSchema: Codable, Equatable, Sendable {
  /// The RichText input nodes to validate and normalize.
  public let nodes: [RichTextNodeInputSchema]

  private static let allowedNodeTypes: Set<String> = ["text", "photo", "listItem"]
  private static let allowedStyles: Set<String> = [
    "STRONG", "EMPHASIS", "HEADING_1", "HEADING_2", "HEADING_3", "HEADING_4"
  ]

  /// Creates a normalization request for the provided RichText nodes.
  public init(nodes: [RichTextNodeInputSchema]) {
    self.nodes = nodes
  }

  /// Validates the input schema and returns normalized `RichTextElement` values or an `AXProblemDetails` error.
  public func validate() -> Result<[RichTextElement], AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.nodes.isEmpty {
      violations.append(AXInvalidParam(name: "nodes", reason: "Must contain at least 1 RichText node."))
    }

    var converted: [RichTextElement] = []
    for (idx, node) in self.nodes.enumerated() {
      switch Self.convertNode(node, path: "nodes[\(idx)]", depth: 0) {
      case let .success(element):
        converted.append(element)
      case let .failure(nodeErr):
        violations.append(contentsOf: nodeErr.violations)
      }
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid RichText Block Schema",
        status: 400,
        detail: "RichText block normalization request failed Poka-Yoke boundary validation.",
        suggestedAction: "Ensure all nodeType values are in {text, photo, listItem}, styles are valid RichTextElement.Text.Style values, and photo nodes have https:// URLs.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(converted)
  }

  private struct NodeValidationError: Error {
    let violations: [AXInvalidParam]
  }

  private static func convertNode(
    _ node: RichTextNodeInputSchema,
    path: String,
    depth: Int
  ) -> Result<RichTextElement, NodeValidationError> {
    var violations: [AXInvalidParam] = []

    if depth > 1 {
      violations.append(AXInvalidParam(
        name: "\(path).children",
        reason: "Nesting depth > 1 is forbidden by ServerDrivenUI normalization guarantees."
      ))
    }

    guard Self.allowedNodeTypes.contains(node.nodeType) else {
      return .failure(NodeValidationError(violations: [AXInvalidParam(
        name: "\(path).nodeType",
        reason: "Unsupported nodeType '\(node.nodeType)'. Allowed: text, photo, listItem."
      )]))
    }

    var parsedLink: URL?
    if let rawLink = node.linkURL {
      if let url = URL(string: rawLink), url.scheme == "https" || url.scheme == "http" {
        parsedLink = url
      } else {
        violations.append(AXInvalidParam(name: "\(path).linkURL", reason: "Must be a valid HTTP/HTTPS URL."))
      }
    }

    var parsedStyles: [RichTextElement.Text.Style] = []
    for style in node.styles {
      if Self.allowedStyles.contains(style), let typed = RichTextElement.Text.Style(rawValue: style) {
        parsedStyles.append(typed)
      } else {
        violations.append(AXInvalidParam(
          name: "\(path).styles",
          reason: "Unsupported style '\(style)'. Allowed: \(Self.allowedStyles.sorted().joined(separator: ", "))."
        ))
      }
    }

    var childElements: [RichTextElement] = []
    for (cIdx, child) in node.children.enumerated() {
      switch Self.convertNode(child, path: "\(path).children[\(cIdx)]", depth: depth + 1) {
      case let .success(el):
        childElements.append(el)
      case let .failure(err):
        violations.append(contentsOf: err.violations)
      }
    }

    if node.nodeType == "photo" {
      guard let rawPhotoURL = node.photoURL, rawPhotoURL.hasPrefix("https://"), URL(string: rawPhotoURL) != nil else {
        violations.append(AXInvalidParam(
          name: "\(path).photoURL",
          reason: "Photo node requires a valid https:// photoURL."
        ))
        return .failure(NodeValidationError(violations: violations))
      }
      guard violations.isEmpty else { return .failure(NodeValidationError(violations: violations)) }
      return .success(.photo(RichTextElement.Photo(
        altText: node.photoAltText,
        assetID: nil,
        caption: nil,
        url: rawPhotoURL,
        link: parsedLink
      )))
    }

    guard violations.isEmpty else { return .failure(NodeValidationError(violations: violations)) }

    let textPayload = RichTextElement.Text(
      text: node.text ?? "",
      link: parsedLink,
      styles: parsedStyles,
      children: childElements
    )

    if node.nodeType == "listItem" {
      return .success(.listItem(textPayload))
    }

    let headerLevel = RichTextElement.HeaderLevel(styles: node.styles)
    return .success(.text(textPayload, headerLevel))
  }
}

/// Normalized output representation of a validated RichText block.
public struct NormalizedRichTextBlockContract: Codable, Equatable, Sendable {
  /// Discriminator for the normalized block kind.
  public let blockKind: String
  /// Normalized plain text content, if applicable.
  public let text: String?
  /// Validated HTTPS photo URL, if applicable.
  public let photoURL: String?
  /// Validated HTTP/HTTPS link URL, if applicable.
  public let linkURL: String?
}

/// Summary contract returned after normalizing a sequence of RichText blocks.
public struct RichTextNormalizationContract: Codable, Equatable, Sendable {
  /// Number of raw input nodes supplied.
  public let inputNodeCount: Int
  /// Number of normalized blocks produced.
  public let normalizedBlockCount: Int
  /// Normalized block contracts in display order.
  public let blocks: [NormalizedRichTextBlockContract]
}
