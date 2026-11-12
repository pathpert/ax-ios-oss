import Prelude

extension Project.Video {
  /// Functional optics namespace for `Project.Video`.
  public enum lens {
    /// Lens focusing on video `id`.
    public static let id = Lens<Project.Video, Int>(
      view: { $0.id },
      set: { .init(id: $0, high: $1.high, hls: $1.hls) }
    )

    /// Lens focusing on high-quality MP4 URL string.
    public static let high = Lens<Project.Video, String>(
      view: { $0.high },
      set: { .init(id: $1.id, high: $0, hls: $1.hls) }
    )

    /// Lens focusing on optional HLS playlist URL string.
    public static let hls = Lens<Project.Video, String?>(
      view: { $0.hls },
      set: { .init(id: $1.id, high: $1.high, hls: $0) }
    )
  }
}
