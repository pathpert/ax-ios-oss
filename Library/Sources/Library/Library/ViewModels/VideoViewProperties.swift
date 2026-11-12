import Foundation
import KsApi

/// Protocol providing playback video streams and poster image URL for project video views.
public protocol HasVideoViewProperties {
  /// Video stream URLs paired with full-resolution poster artwork URL.
  var videoViewProperties: VideoViewProperties { get }
}

/// Composite configuration contract required by project video player view models.
public typealias VideoViewConfiguration =
  HasProjectAnalyticsProperties & HasProjectWebURL & HasVideoViewProperties

/// Minimal immutable view properties required to play a project's campaign video.
/// - Negative Constraint: Pass only sanitized HTTPS stream URLs; do not construct local file paths here.
public struct VideoViewProperties {
  /// Tuple of optional HLS playlist URL string and required MP4 high-quality URL string.
  public let video: (hls: String?, high: String)?
  /// Full-resolution poster image URL string displayed before playback starts.
  public let photoFull: String

  /// Initializes video playback properties from optional video streams and poster image URL.
  public init(video: (hls: String?, high: String)?, photoFull: String) {
    self.video = video
    self.photoFull = photoFull
  }
}

extension Project: HasVideoViewProperties {
  /// Projects this campaign's video streams and full-bleed photo into `VideoViewProperties`.
  public var videoViewProperties: VideoViewProperties {
    VideoViewProperties(
      video: self.video.map { ($0.hls, $0.high) },
      photoFull: self.photo.full
    )
  }
}
