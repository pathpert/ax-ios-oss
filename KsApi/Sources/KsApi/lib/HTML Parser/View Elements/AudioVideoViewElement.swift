import CoreMedia
import Prelude

/// Parsed HTML audio/video media element rendered inside project story/update blocks.
///
/// Negative Constraint: Do not use for inline still images; see `ImageViewElement`.
public struct AudioVideoViewElement: HTMLViewElement {
  /// Remote media stream or file URL string.
  public let sourceURLString: String
  /// Optional poster thumbnail URL string displayed prior to playback.
  public let thumbnailURLString: String?
  /// Current playback offset preserved across cell reuse.
  public var seekPosition: CMTime
}

extension AudioVideoViewElement {
  /// Functional optics namespace for `AudioVideoViewElement`.
  public enum lens {
    /// Lens focusing on `AudioVideoViewElement.seekPosition`.
    public static let seekPosition = Lens<AudioVideoViewElement, CMTime>(
      view: { $0.seekPosition },
      set: { AudioVideoViewElement(
        sourceURLString: $1.sourceURLString,
        thumbnailURLString: $1.thumbnailURLString,
        seekPosition: $0
      )
      }
    )
  }
}
