import Prelude

extension ProjectStatsEnvelope.VideoStats {
  /// Functional optics namespace for `ProjectStatsEnvelope.VideoStats`.
  public enum lens {
    /// Lens focusing on `externalCompletions` count.
    public static let externalCompletions = Lens<ProjectStatsEnvelope.VideoStats, Int>(
      view: { $0.externalCompletions },
      set: { ProjectStatsEnvelope.VideoStats(
        externalCompletions: $0, externalStarts: $1.externalStarts,
        internalCompletions: $1.internalCompletions, internalStarts: $1.internalStarts
      ) }
    )

    /// Lens focusing on `externalStarts` count.
    public static let externalStarts = Lens<ProjectStatsEnvelope.VideoStats, Int>(
      view: { $0.externalStarts },
      set: { ProjectStatsEnvelope.VideoStats(
        externalCompletions: $1.externalCompletions, externalStarts: $0,
        internalCompletions: $1.internalCompletions, internalStarts: $1.internalStarts
      ) }
    )

    /// Lens focusing on `internalCompletions` count.
    public static let internalCompletions = Lens<ProjectStatsEnvelope.VideoStats, Int>(
      view: { $0.internalCompletions },
      set: { ProjectStatsEnvelope.VideoStats(
        externalCompletions: $1.externalCompletions,
        externalStarts: $1.externalStarts, internalCompletions: $0, internalStarts: $1.internalStarts
      ) }
    )

    /// Lens focusing on `internalStarts` count.
    public static let internalStarts = Lens<ProjectStatsEnvelope.VideoStats, Int>(
      view: { $0.internalStarts },
      set: { ProjectStatsEnvelope.VideoStats(
        externalCompletions: $1.externalCompletions,
        externalStarts: $1.externalStarts, internalCompletions: $1.internalCompletions, internalStarts: $0
      ) }
    )
  }
}
