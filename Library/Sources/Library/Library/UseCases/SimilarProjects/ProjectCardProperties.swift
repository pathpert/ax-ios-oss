import Foundation
import Kingfisher
import KsApi

/// Represents a project that can be displayed in a project card.
public struct ProjectCardProperties {
  /// The identifier for the project.
  public let projectID: Int
  /// Image source rendered for the project card thumbnail.
  public let image: Kingfisher.Source
  /// Display title of the project.
  public let name: String

  /// Whether the project has launched.
  public let isLaunched: Bool
  /// Whether the current user has saved/starred the project.
  public let isStarred: Bool
  /// Whether the prelaunch page feature is activated for the project.
  public let isPrelaunchActivated: Bool
  /// Whether the project is currently accepting post-campaign late pledges.
  public let isInPostCampaignPledgingPhase: Bool
  /// Whether post-campaign late pledging is enabled for the project.
  public let isPostCampaignPledgingEnabled: Bool

  /// Launch timestamp of the campaign, if launched.
  public let launchedAt: Date?
  /// Funding deadline timestamp of the campaign, if applicable.
  public let deadlineAt: Date?
  /// Percentage of the funding goal currently reached.
  public let percentFunded: Int

  /// Current funding lifecycle state of the project.
  public let state: Project.State
  /// Target funding goal amount and currency, if available.
  public let goal: Money?
  /// Total amount pledged so far, if available.
  public let pledged: Money?
  /// Canonical web URL string of the project page.
  public let url: String

  let projectAnalytics: any ProjectAnalyticsProperties
  let projectPamphletMainCell: any HasProjectPamphletMainCellProperties

  /// Creates a `ProjectCardProperties` value from parsed project card fields.
  public init(
    projectID: Int,
    image: Kingfisher.Source,
    name: String,
    isLaunched: Bool,
    isStarred: Bool,
    isPrelaunchActivated: Bool,
    isInPostCampaignPledgingPhase: Bool,
    isPostCampaignPledgingEnabled: Bool,
    launchedAt: Date?,
    deadlineAt: Date?,
    percentFunded: Int,
    state: Project.State,
    goal: Money?,
    pledged: Money?,
    url: String,
    projectAnalytics: any ProjectAnalyticsProperties,
    projectPamphletMainCell: any HasProjectPamphletMainCellProperties
  ) {
    self.projectID = projectID
    self.image = image
    self.name = name
    self.isLaunched = isLaunched
    self.isStarred = isStarred
    self.isPrelaunchActivated = isPrelaunchActivated
    self.isInPostCampaignPledgingPhase = isInPostCampaignPledgingPhase
    self.isPostCampaignPledgingEnabled = isPostCampaignPledgingEnabled
    self.launchedAt = launchedAt
    self.deadlineAt = deadlineAt
    self.percentFunded = percentFunded
    self.state = state
    self.goal = goal
    self.pledged = pledged
    self.url = url
    self.projectAnalytics = projectAnalytics
    self.projectPamphletMainCell = projectPamphletMainCell
  }

  /// Whether the card should display prelaunch messaging prior to launch.
  public var shouldDisplayPrelaunch: Bool {
    self.isPrelaunchActivated && !self.isLaunched
  }

  /// Boxed navigation parameter referencing this project and initial card data.
  public var projectPageParam: ProjectPageParam {
    ProjectPageParamBox(
      param: Param.id(self.projectID),
      initialProject: self
    )
  }
}
