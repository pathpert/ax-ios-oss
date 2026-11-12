import Prelude

/// Parsed HTML `<img>` element rendered inside project story/update blocks.
///
/// Negative Constraint: Do not use for embedded video/audio streams; see `AudioVideoViewElement`.
public struct ImageViewElement: HTMLViewElement {
  /// Remote image asset URL string.
  public let src: String
  /// Optional tap-through destination link wrapping the image.
  public let href: String?
  /// Optional caption displayed beneath the image.
  public let caption: String?
}
