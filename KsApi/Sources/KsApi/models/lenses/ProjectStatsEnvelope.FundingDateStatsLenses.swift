import Foundation
import Prelude

extension ProjectStatsEnvelope.FundingDateStats {
  /// Functional optics namespace for `ProjectStatsEnvelope.FundingDateStats`.
  public enum lens {
    /// Lens focusing on daily `backersCount`.
    public static let backersCount = Lens<ProjectStatsEnvelope.FundingDateStats, Int>(
      view: { $0.backersCount },
      set: { .init(
        backersCount: $0, cumulativePledged: $1.cumulativePledged,
        cumulativeBackersCount: $1.cumulativeBackersCount, date: $1.date, pledged: $1.pledged
      ) }
    )

    /// Lens focusing on `cumulativePledged`.
    public static let cumulativePledged = Lens<ProjectStatsEnvelope.FundingDateStats, Int>(
      view: { $0.cumulativePledged },
      set: { .init(
        backersCount: $1.backersCount, cumulativePledged: $0,
        cumulativeBackersCount: $1.cumulativeBackersCount, date: $1.date, pledged: $1.pledged
      ) }
    )

    /// Lens focusing on `cumulativeBackersCount`.
    public static let cumulativeBackersCount = Lens<ProjectStatsEnvelope.FundingDateStats, Int>(
      view: { $0.cumulativeBackersCount },
      set: { .init(
        backersCount: $1.backersCount, cumulativePledged: $1.cumulativePledged,
        cumulativeBackersCount: $0, date: $1.date, pledged: $1.pledged
      ) }
    )

    /// Lens focusing on UTC `date` timestamp.
    public static let date = Lens<ProjectStatsEnvelope.FundingDateStats, TimeInterval>(
      view: { $0.date },
      set: { .init(
        backersCount: $1.backersCount, cumulativePledged: $1.cumulativePledged,
        cumulativeBackersCount: $1.cumulativeBackersCount, date: $0, pledged: $1.pledged
      ) }
    )

    /// Lens focusing on daily `pledged` total.
    public static let pledged = Lens<ProjectStatsEnvelope.FundingDateStats, Int>(
      view: { $0.pledged },
      set: { .init(
        backersCount: $1.backersCount, cumulativePledged: $1.cumulativePledged,
        cumulativeBackersCount: $1.cumulativeBackersCount, date: $1.date, pledged: $0
      ) }
    )
  }
}
