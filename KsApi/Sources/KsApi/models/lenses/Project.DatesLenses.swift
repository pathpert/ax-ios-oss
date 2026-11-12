import Foundation
import Prelude

extension Project.Dates {
  /// Functional optics namespace for `Project.Dates`.
  public enum lens {
    /// Lens focusing on optional campaign `deadline` timestamp.
    public static let deadline = Lens<Project.Dates, TimeInterval?>(
      view: { $0.deadline },
      set: { Project.Dates(
        deadline: $0, featuredAt: $1.featuredAt, launchedAt: $1.launchedAt,
        stateChangedAt: $1.stateChangedAt
      ) }
    )

    /// Lens focusing on optional `featuredAt` timestamp.
    public static let featuredAt = Lens<Project.Dates, TimeInterval?>(
      view: { $0.featuredAt },
      set: { Project.Dates(
        deadline: $1.deadline, featuredAt: $0, launchedAt: $1.launchedAt,
        stateChangedAt: $1.stateChangedAt
      ) }
    )

    /// Lens focusing on optional `launchedAt` timestamp.
    public static let launchedAt = Lens<Project.Dates, TimeInterval?>(
      view: { $0.launchedAt },
      set: { Project.Dates(
        deadline: $1.deadline, featuredAt: $1.featuredAt, launchedAt: $0,
        stateChangedAt: $1.stateChangedAt
      ) }
    )

    /// Lens focusing on `stateChangedAt` timestamp.
    public static let stateChangedAt = Lens<Project.Dates, TimeInterval>(
      view: { $0.stateChangedAt },
      set: { Project.Dates(
        deadline: $1.deadline, featuredAt: $1.featuredAt, launchedAt: $1.launchedAt,
        stateChangedAt: $0
      ) }
    )
  }
}
