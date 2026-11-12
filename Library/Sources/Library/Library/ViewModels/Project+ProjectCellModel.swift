import Foundation
import KsApi

extension Project: BackerDashboardProjectCellViewModel.ProjectCellModel {
  /// Normalized funding ratio (`pledged / goal`), `>= 0`.
  public var fundingProgress: Float {
    return self.stats.fundingProgress
  }

  /// Whole percentage funded reported by campaign statistics.
  public var percentFunded: Int {
    return self.stats.percentFunded
  }

  /// Full-size campaign cover image URL string.
  public var imageURL: String? {
    return self.photo.full
  }

  /// Campaign launch timestamp in Unix seconds.
  public var launchedAt: TimeInterval? {
    return self.dates.launchedAt
  }

  /// Campaign deadline timestamp in Unix seconds.
  public var deadline: TimeInterval? {
    return self.dates.deadline
  }

  /// Whether the signed-in user has saved/starred this project.
  public var isStarred: Bool? {
    self.personalization.isStarred
  }
}
