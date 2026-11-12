import Foundation
import GraphAPI

extension Project {
  static var htmlParser = {
    HTMLParser()
  }()

  /**
   Returns a minimal `Project` from a `ProjectFragment`
   */
  static func project(
    from projectFragment: GraphAPI.ProjectFragment,
    flagging: Bool? = nil,
    rewards: [Reward] = [],
    addOns: [Reward]? = nil,
    backing: Backing? = nil,
    extendedProjectProperties: ExtendedProjectProperties?,
    video: Project.Video?
  ) -> Project? {
    guard
      let country = Country.country(
        from: projectFragment.country.fragments.countryFragment,
        minPledge: projectFragment.minPledge,
        maxPledge: projectFragment.maxPledge,
        currency: projectFragment.currency.value
      ),
      let categoryFragment = projectFragment.category?.fragments.categoryFragment,
      let dates = projectDates(from: projectFragment.fragments.projectDatesFragment),
      let memberData = projectMemberData(from: projectFragment),
      let photo = projectPhoto(from: projectFragment),
      let state = projectState(from: projectFragment.state.value),
      let userFragment = projectFragment.creator?.fragments.publicUserFragment,
      let creator = User.publicUser(from: userFragment)
    else { return nil }

    let category = Project.Category.category(from: categoryFragment)

    var location: Location?
    if let locationFragment = projectFragment.location?.fragments.locationFragment {
      location = Location.location(from: locationFragment)
    }

    let urls = Project.UrlsEnvelope(
      web: UrlsEnvelope.WebEnvelope(project: projectFragment.url, updates: projectFragment.url + "/posts")
    )

    let availableCardTypes = projectFragment.availableCardTypes.compactMap { $0.rawValue }
    let displayPrelaunch = !projectFragment.isLaunched
    let discoverTags: [String] = projectFragment.tags.compactMap { $0?.name }

    /**
     NOTE: Project friends fetched by
     `fetchProjectFriends(param: Param) -> SignalProducer<[User], ErrorEnvelope>`
     */

    /**
     NOTE: `Project.generatedSlug`currently returns an internal server error for user that isn't logged in. Seeing as we need the project object even if the user isn't logged in, we can still use `Project.slug` and parse the string below to get the same result until the `Project.generatedSlug` is fixed.
     */
    let generatedSlug = projectFragment.slug
      .components(separatedBy: "/")
      .filter { $0 != "" }
      .last

    let lastWave = projectFragment.lastWave.flatMap { LastWave(fromFragment: $0.fragments.lastWaveFragment) }
    let pledgeManager = projectFragment.pledgeManager
      .flatMap { PledgeManager(fromFragment: $0.fragments.pledgeManagerFragment) }
    let plotFragment = projectFragment.fragments.pledgeOverTimeFragment
    let stats = projectStats(from: projectFragment.fragments.projectStatsFragment)

    return Project(
      availableCardTypes: availableCardTypes,
      blurb: projectFragment.description,
      category: category,
      country: country,
      creator: creator,
      extendedProjectProperties: extendedProjectProperties,
      memberData: memberData,
      dates: dates,
      displayPrelaunch: displayPrelaunch,
      flagging: flagging,
      id: projectFragment.pid,
      lastWave: lastWave,
      location: location,
      name: projectFragment.name,
      pledgeManager: pledgeManager,
      pledgeOverTimeCollectionPlanChargeExplanation: plotFragment
        .pledgeOverTimeCollectionPlanChargeExplanation ?? "",
      pledgeOverTimeCollectionPlanChargedAsNPayments: plotFragment
        .pledgeOverTimeCollectionPlanChargedAsNPayments ?? "",
      pledgeOverTimeCollectionPlanShortPitch: plotFragment.pledgeOverTimeCollectionPlanShortPitch ?? "",
      pledgeOverTimeMinimumExplanation: plotFragment.pledgeOverTimeMinimumExplanation ?? "",
      personalization: projectPersonalization(
        isStarred: projectFragment.isWatched,
        backing: backing,
        friends: []
      ),
      photo: photo,
      isInPostCampaignPledgingPhase: projectFragment.isInPostCampaignPledgingPhase,
      postCampaignPledgingEnabled: projectFragment.postCampaignPledgingEnabled,
      prelaunchActivated: projectFragment.prelaunchActivated,
      redemptionPageUrl: projectFragment.redemptionPageUrl,
      rewardData: RewardData(addOns: addOns, rewards: rewards),
      sendMetaCapiEvents: projectFragment.sendMetaCapiEvents,
      slug: generatedSlug ?? projectFragment.slug,
      staffPick: projectFragment.isProjectWeLove,
      state: state,
      stats: stats,
      tags: discoverTags,
      urls: urls,
      video: video,
      watchesCount: projectFragment.watchesCount,
      isPledgeOverTimeAllowed: plotFragment.isPledgeOverTimeAllowed
    )
  }
}

private func projectPersonalization(
  isStarred: Bool,
  backing: Backing?,
  friends: [User]
) -> Project.Personalization {
  return Project.Personalization(
    backing: backing,
    friends: friends,
    isBacking: backing != nil,
    isStarred: isStarred
  )
}

/**
 Returns a minimal `Project.Dates` from a `ProjectDatesFragment`
 */
private func projectDates(from datesFragment: GraphAPI.ProjectDatesFragment) -> Project.Dates? {
  guard let stateChangedAt = TimeInterval(datesFragment.stateChangedAt) else { return nil }

  let startOfToday = Calendar.current.startOfDay(for: Date()).timeIntervalSince1970
  var featuredAtDate: TimeInterval?

  if let projectOfTheDay = datesFragment.isProjectOfTheDay {
    featuredAtDate = projectOfTheDay ? startOfToday : nil
  }

  return Project.Dates(
    deadline: datesFragment.deadlineAt.flatMap(TimeInterval.init),
    featuredAt: featuredAtDate,
    finalCollectionDate: finalCollectionDateTimeInterval(from: datesFragment.finalCollectionDate),
    launchedAt: datesFragment.launchedAt.flatMap(TimeInterval.init),
    stateChangedAt: stateChangedAt
  )
}

private func finalCollectionDateTimeInterval(
  from string: String?,
  dateFormatter: ISO8601DateFormatter = ISO8601DateFormatter()
) -> TimeInterval? {
  guard let string = string else { return nil }

  return dateFormatter.date(from: string)?.timeIntervalSince1970
}

/**
 Returns a minimal `Project.MemberData` from a `ProjectFragment`
 */
private func projectMemberData(from projectFragment: GraphAPI.ProjectFragment) -> Project.MemberData? {
  // TODO: Also used by `DashboardActionCellViewModel` and `MessagesViewModel` - but they are not using the GQL `fetchProject(param:)` call yet.
  return Project.MemberData(permissions: projectFragment.canComment ? [.comment] : [])
}

/**
 Returns a minimal `Project.Photo` from a `ProjectFragment`
 */
private func projectPhoto(from projectFragment: GraphAPI.ProjectFragment) -> Project.Photo? {
  guard let url = projectFragment.image?.url else { return nil }

  return Project.Photo(full: url, med: url, size1024x768: url, small: url)
}

private func projectState(from projectState: GraphAPI.ProjectState?) -> Project.State? {
  guard let projectState else { return nil }
  return Project.State(rawValue: projectState.rawValue.lowercased())
}

/**
 Returns a minimal `Project.Stats` from a `ProjectStatsFragment`
 */
private func projectStats(
  from statsFragment: GraphAPI.ProjectStatsFragment
) -> Project.Stats {
  let pledgedRawData = statsFragment.pledged.fragments.moneyFragment.amount.flatMap(Float.init)
  let pledgedRawValue = statsFragment.pledged.fragments.moneyFragment.amount.flatMap(Float.init) ?? 0
  let pledgedValue = pledgedRawData != nil ? Int(pledgedRawValue) : 0
  let fxRateValue = Float(statsFragment.fxRate)
  let convertedPledgedAmountValue = pledgedRawData != nil ? pledgedRawValue * fxRateValue : nil
  let staticUSDRateValue = Float(statsFragment.usdExchangeRate ?? 0)
  var usdExchangeRate: Float?

  if let usdExchangeRateRawValue = statsFragment.usdExchangeRate {
    usdExchangeRate = Float(usdExchangeRateRawValue)
  }

  return Project.Stats(
    backersCount: statsFragment.backersCount,
    commentsCount: statsFragment.commentsCount,
    convertedPledgedAmount: convertedPledgedAmountValue,
    projectCurrency: statsFragment.currency.rawValue,
    userCurrency: statsFragment.fxRateCurrency.rawValue,
    userCurrencyRate: fxRateValue,
    goal: statsFragment.goal?.fragments.moneyFragment.amount.flatMap(Float.init).flatMap(Int.init) ?? 0,
    pledged: pledgedValue,
    staticUsdRate: staticUSDRateValue,
    updatesCount: statsFragment.posts.totalCount,
    usdExchangeRate: usdExchangeRate
  )
}

/**
 Returns a video `Project.video` from `ProjectVideoFragment`
 */
internal extension Project.Video {
  static func projectVideo(from videoFragment: GraphAPI.ProjectVideoFragment?) -> Project.Video? {
    guard let video = videoFragment,
          let videoId = decompose(id: video.id),
          let high = video.videoSources?.high?.src else {
      return nil
    }

    return Project.Video(id: videoId, high: high, hls: video.videoSources?.hls?.src)
  }
}

extension Project.State {
  /// Creates a `Project.State` from a GraphQL `ProjectState` enum value.
  public init?(_ fragment: GraphAPI.ProjectState) {
    guard let state = projectState(from: fragment) else {
      return nil
    }
    self = state
  }
}
