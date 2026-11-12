import Foundation

/// GraphQL response envelope returned after watching (`watchProject`) or unwatching (`unwatchProject`) a project.
///
/// Negative Constraint: Do not cache `isWatched` long-term without refreshing project state on subsequent loads.
public struct WatchProjectResponseEnvelope: Decodable {
  /// Nested mutation payload wrapper.
  public var watchProject: WatchProject

  /// Inner mutation result containing the updated project state.
  public struct WatchProject: Decodable {
    /// Updated project watch status and watcher count.
    public var project: Project

    /// Subset of `Project` fields returned by watch/unwatch GraphQL mutations.
    public struct Project: Decodable {
      /// GraphQL global node identifier of the project.
      public var id: String
      /// Whether the current viewer is now watching the project.
      public var isWatched: Bool
      /// Updated total watcher count.
      public var watchesCount: Int
    }
  }
}
