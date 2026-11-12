import Foundation
import GraphAPI

extension GraphAPI.ProjectAnalyticsFragment: ProjectAnalyticsProperties {
  /// Prelaunch activation status mapped from `isPrelaunchActivated`.
  public var prelaunchActivated: Bool? {
    self.isPrelaunchActivated
  }

  /// Category analytics name from GraphQL fragment.
  public var categoryAnalyticsName: String? {
    self.category?.analyticsName
  }

  /// Parent category analytics name from GraphQL fragment.
  public var categoryParentAnalyticsName: String? {
    self.category?.parentCategory?.analyticsName
  }

  /// Parent category identifier from GraphQL fragment.
  public var categoryParentId: String? {
    self.category?.parentCategory?.id
  }

  /// Two-letter ISO country code from GraphQL fragment.
  public var countryCode: String {
    self.country.code.rawValue
  }

  /// Creator node ID from GraphQL fragment.
  public var creatorId: String? {
    self.creator?.id
  }

  /// `true` when the creator has created at least two projects.
  public var creatorIsRepeatCreator: Bool? {
    (self.creator?.createdProjects?.totalCount ?? 0) >= 2
  }

  /// Campaign deadline timestamp in epoch seconds.
  public var datesDeadline: TimeInterval? {
    self.deadlineAt.flatMap(TimeInterval.init)
  }

  /// Campaign launch timestamp in epoch seconds.
  public var datesLaunchedAt: TimeInterval? {
    self.launchedAt.flatMap(TimeInterval.init)
  }

  /// Whole days elapsed between campaign launch and deadline.
  public func datesDuration(using calendar: Calendar = .current) -> Int? {
    guard let deadlineDateValue = self.datesDeadline,
          let launchedAtDateValue = self.datesLaunchedAt else {
      return nil
    }

    let deadlineDate = Date(timeIntervalSince1970: deadlineDateValue)
    let launchedAtDate = Date(timeIntervalSince1970: launchedAtDateValue)

    return calendar.dateComponents([.day], from: launchedAtDate, to: deadlineDate).day
  }

  /// Non-negative remaining campaign hours relative to `date`.
  public func datesHoursRemaining(
    from date: Foundation.Date = Date(),
    using calendar: Foundation.Calendar = .current
  ) -> Int? {
    guard let deadlineDateValue = self.datesDeadline else {
      return nil
    }

    let deadlineDate = Date(timeIntervalSince1970: deadlineDateValue)

    guard let hoursRemaining = calendar.dateComponents([.hour], from: date, to: deadlineDate).hour else {
      return nil
    }

    return max(0, hoursRemaining)
  }

  /// Numeric Kickstarter project ID (`pid`).
  public var id: Int {
    self.pid
  }

  /// `true` when the project exposes one or more add-on rewards.
  public var hasAddOns: Bool {
    (self.addOns?.totalCount ?? 0) > 0
  }

  /// `true` when a campaign video is attached.
  public var hasVideo: Bool {
    self.video != nil
  }

  /// Whether the viewer watches/stars the project (`isWatched`).
  public var personalizationIsStarred: Bool? {
    self.isWatched
  }

  /// `true` when the viewer has an active backing record on this fragment.
  public var personalizationIsBacking: Bool? {
    self.backing != nil
  }

  /// Total reward count reported by the GraphQL connection.
  public var rewardsCount: Int {
    self.rewards?.totalCount ?? 0
  }

  /// Raw GraphQL project state string.
  public var stateValue: String {
    self.state.rawValue
  }

  /// Total backer count on the campaign.
  public var statsBackerCount: Int {
    self.backersCount
  }

  /// Total public comment count on the campaign.
  public var statsCommentsCount: Int? {
    self.commentsCount
  }

  /// Native project currency ISO code.
  public var statsCurrency: String {
    self.currency.rawValue
  }

  /// Whole percentage funded.
  public var statsPercentFunded: Int {
    self.percentFunded
  }

  /// Truncated integer pledged amount in native project currency.
  public var statsPledged: Int {
    Int(self.pledged.amount ?? "") ?? 0
  }

  /// Total pledged converted to USD via `usdExchangeRate`.
  public var statsTotalAmountPledgedUsdCurrency: Float? {
    let amount = self.pledged.amount.flatMap(Float.init)
    return amount.flatMap { amount in self.usdExchangeRate.map { amount * Float($0) } }
  }

  /// Funding goal converted to USD via `usdExchangeRate`.
  public var statsGoalUsdCurrency: Float? {
    let amount = self.goal?.amount.flatMap(Float.init)
    return amount.flatMap { amount in self.usdExchangeRate.map { amount * Float($0) } }
  }

  /// Total project update post count.
  public var statsUpdatesCount: Int? {
    self.posts.totalCount
  }

  /// Discovery tag display names attached to the project.
  public var tags: [String]? {
    self.projectTags.compactMap { $0?.name }
  }
}

