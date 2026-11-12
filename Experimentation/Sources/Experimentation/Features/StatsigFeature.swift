import Foundation

/// Registry of boolean feature gates evaluated through Statsig.
/// Format: Raw values match snake_case gate keys configured in the Statsig console.
/// Negative Constraint: Do not hardcode raw feature gate key strings outside `StatsigFeature`.
public enum StatsigFeature: String, CaseIterable {
  case projectStoryRichText = "project_story_rich_text"
  case videoFeed = "video_feed"
}

extension StatsigFeature: CustomStringConvertible {
  /// Human-readable display label for the Statsig feature gate (for debug tools and diagnostics).
  public var description: String {
    switch self {
    case .projectStoryRichText: "Project Story Rich Text"
    case .videoFeed: "Video Feed"
    }
  }
}
