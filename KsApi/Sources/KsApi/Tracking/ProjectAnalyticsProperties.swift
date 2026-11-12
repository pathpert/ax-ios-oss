import Foundation
import GraphAPI

/// Marker protocol exposing a `ProjectAnalyticsProperties` view for analytics serialization.
public protocol HasProjectAnalyticsProperties {
  /// Strongly-typed analytics projection of the project.
  var projectAnalyticsProperties: ProjectAnalyticsProperties { get }
}

/// Shared analytics projection unifying `Project` (REST/hybrid) and `GraphAPI.ProjectAnalyticsFragment`.
///
/// - Negative constraint: Do not pass raw mutable domain models directly to Segment adapters; project through this protocol.
public protocol ProjectAnalyticsProperties {
  /// Analytics category leaf name.
  var categoryAnalyticsName: String? { get }
  /// Analytics parent category name (`nil` for top-level categories).
  var categoryParentAnalyticsName: String? { get }
  /// Parent category identifier string (`nil` for top-level categories).
  var categoryParentId: String? { get }
  /// Two-letter ISO country code where the project is registered.
  var countryCode: String { get }
  /// String-encoded numeric creator identifier.
  var creatorId: String? { get }
  /// `true` when the creator has launched two or more projects.
  var creatorIsRepeatCreator: Bool? { get }
  /// Campaign deadline timestamp in Unix epoch seconds.
  var datesDeadline: TimeInterval? { get }
  /// Campaign launch timestamp in Unix epoch seconds.
  var datesLaunchedAt: TimeInterval? { get }
  /// Computes campaign duration in whole days using the supplied `calendar`.
  func datesDuration(using calendar: Calendar) -> Int?
  /// Computes non-negative remaining campaign hours from `date` using `calendar`.
  func datesHoursRemaining(from date: Foundation.Date, using calendar: Foundation.Calendar) -> Int?
  /// Numeric Kickstarter project identifier.
  var id: Int { get }
  /// `true` if add-on rewards exist on this project.
  var hasAddOns: Bool { get }
  /// `true` if the project has a campaign video.
  var hasVideo: Bool { get }
  /// Localized/display project title.
  var name: String { get }
  /// `true` when the project is actively accepting post-campaign late pledges.
  var isInPostCampaignPledgingPhase: Bool { get }
  /// Whether the viewer is watching/saving the project (`nil` when unauthenticated).
  var personalizationIsStarred: Bool? { get }
  /// Whether the viewer has backed the project (`nil` when unauthenticated).
  var personalizationIsBacking: Bool? { get }
  /// `true` when late pledging is enabled after campaign completion.
  var postCampaignPledgingEnabled: Bool { get }
  /// `true` when prelaunch follower activation is enabled (`nil` if omitted).
  var prelaunchActivated: Bool? { get }
  /// Count of selectable paid reward tiers (excluding `.noReward`).
  var rewardsCount: Int { get }
  /// Raw backend campaign state string (e.g., `"live"`, `"successful"`).
  var stateValue: String { get }
  /// Total number of backers.
  var statsBackerCount: Int { get }
  /// Total public comment count (`nil` if omitted).
  var statsCommentsCount: Int? { get }
  /// Three-letter ISO project currency code.
  var statsCurrency: String { get }
  /// Whole percentage funded (`0...`).
  var statsPercentFunded: Int { get }
  /// Total amount pledged in project currency integer units.
  var statsPledged: Int { get }
  /// Total amount pledged converted to USD (`nil` if rate unavailable).
  var statsTotalAmountPledgedUsdCurrency: Float? { get }
  /// Project funding goal converted to USD (`nil` if rate unavailable).
  var statsGoalUsdCurrency: Float? { get }
  /// Total project update post count (`nil` if omitted).
  var statsUpdatesCount: Int? { get }
  /// Campaign discovery tag names (`nil` if unset).
  var tags: [String]? { get }
}

extension Project: HasProjectAnalyticsProperties {
  /// Returns `self` viewed as `ProjectAnalyticsProperties`.
  public var projectAnalyticsProperties: any ProjectAnalyticsProperties { self }
}

extension Project: ProjectAnalyticsProperties {
  /// Category analytics name from `self.category`.
  public var categoryAnalyticsName: String? { self.category?.analyticsName }
  /// Parent category analytics name from `self.category`.
  public var categoryParentAnalyticsName: String? { self.category?.parentAnalyticsName }
  /// Stringified parent category ID from `self.category`.
  public var categoryParentId: String? { self.category?.parentId.flatMap(String.init) }
  /// Country code from `self.country`.
  public var countryCode: String { self.country.countryCode }
  /// Stringified creator ID from `self.creator`.
  public var creatorId: String? { String(self.creator.id) }
  /// Whether the creator has multiple launched projects.
  public var creatorIsRepeatCreator: Bool? { self.creator.isRepeatCreator }
  /// Campaign deadline timestamp in epoch seconds.
  public var datesDeadline: TimeInterval? { self.dates.deadline }
  /// Campaign launch timestamp in epoch seconds.
  public var datesLaunchedAt: TimeInterval? { self.dates.launchedAt }
  /// Campaign duration in days using `calendar`.
  public func datesDuration(using calendar: Calendar) -> Int? { self.dates.duration(using: calendar) }
  /// Remaining hours until campaign deadline from `date`.
  public func datesHoursRemaining(from date: Foundation.Date, using calendar: Foundation.Calendar) -> Int? {
    self.dates.hoursRemaining(from: date, using: calendar)
  }
  /// `true` when `self.video` is non-nil.
  public var hasVideo: Bool { self.video != nil }
  /// Viewer's starred/saved state.
  public var personalizationIsStarred: Bool? { self.personalization.isStarred }
  /// Viewer's backing state.
  public var personalizationIsBacking: Bool? { self.personalization.isBacking }
  /// Count of rewards excluding `Reward.noReward`.
  public var rewardsCount: Int { self.rewards.filter { $0 != .noReward }.count }
  /// Raw project state string.
  public var stateValue: String { self.state.rawValue }
  /// Backer count from `self.stats`.
  public var statsBackerCount: Int { self.stats.backersCount }
  /// Comment count from `self.stats`.
  public var statsCommentsCount: Int? { self.stats.commentsCount }
  /// Native project currency code from `self.stats`.
  public var statsCurrency: String { self.stats.projectCurrency }
  /// Percent funded from `self.stats`.
  public var statsPercentFunded: Int { self.stats.percentFunded }
  /// Pledged amount from `self.stats`.
  public var statsPledged: Int { self.stats.pledged }
  /// USD-converted total pledged amount from `self.stats`.
  public var statsTotalAmountPledgedUsdCurrency: Float? { self.stats.totalAmountPledgedUsdCurrency }
  /// USD-converted funding goal from `self.stats`.
  public var statsGoalUsdCurrency: Float? { self.stats.goalUsdCurrency }
  /// Project update count from `self.stats`.
  public var statsUpdatesCount: Int? { self.stats.updatesCount }
}
