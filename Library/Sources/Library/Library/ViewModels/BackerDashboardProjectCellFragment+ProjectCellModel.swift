import Foundation
import GraphAPI
import KsApi

extension GraphAPI.BackerDashboardProjectCellFragment: BackerDashboardProjectCellViewModel.ProjectCellModel {
  /// Whether the project has prelaunch activation enabled (`Optional.some(projectPrelaunchActivated)`).
  public var prelaunchActivated: Bool? {
    return Optional.some(self.projectPrelaunchActivated)
  }

  /// Normalized domain `Project.State` parsed from the GraphQL enum raw value, defaulting to `.live`.
  public var state: KsApi.Project.State {
    return Project.State(rawValue: self.projectState.rawValue.lowercased()) ?? Project.State.live
  }

  /// Remote cover photo URL string, if present.
  public var imageURL: String? {
    self.image?.url
  }

  /// Ratio of pledged amount to funding goal (`0.0` when goal is zero or missing).
  public var fundingProgress: Float {
    let pledged = self.pledged.fragments.moneyFragment.amount.flatMap(Float.init) ?? 0

    let goal = self.goal?.fragments.moneyFragment.amount.flatMap(Float.init).flatMap(Int.init) ?? 0

    return goal == 0 ? 0.0 : Float(pledged) / Float(goal)
  }

  /// Floored integer percentage funded (`0...100+`).
  public var percentFunded: Int {
    return Int(floor(self.fundingProgress * 100.0))
  }

  /// Whether prelaunch badge copy should be shown (`!isLaunched`).
  public var displayPrelaunch: Bool? {
    return !self.isLaunched
  }

  /// Project launch UNIX timestamp in seconds, if launched.
  public var launchedAt: TimeInterval? {
    return self.projectLaunchedAt.flatMap(TimeInterval.init)
  }

  /// Campaign deadline UNIX timestamp in seconds, if set.
  public var deadline: TimeInterval? {
    return self.deadlineAt.flatMap(TimeInterval.init)
  }

  /// Whether the current user has starred/watched this project.
  public var isStarred: Bool? {
    return self.isWatched
  }
}
