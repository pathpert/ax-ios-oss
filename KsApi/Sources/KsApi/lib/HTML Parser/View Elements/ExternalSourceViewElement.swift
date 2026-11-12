import Foundation

/// Represents iFrame HTML, loaded inside an embedded webview for external media providers.
///
/// Negative Constraint: Do not pass arbitrary untrusted raw HTML; only use parsed embed URLs from `HTMLParser`.
public struct ExternalSourceViewElement: HTMLViewElement {
  /// Embedded iframe source URL string.
  public let embeddedURLString: String
  /// Optional fixed pixel/point height declared by the embed markup.
  public let embeddedURLContentHeight: Int?
}
