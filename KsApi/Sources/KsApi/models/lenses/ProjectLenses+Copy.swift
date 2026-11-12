import Foundation
import Prelude

extension Project {
  /// Convenience accessor for the optional project location's short name.
  public var locationName: String? {
    self.location?.name
  }

  /// Convenience accessor for the optional project location's displayable name.
  public var locationDisplayableName: String? {
    self.location?.displayableName
  }

  internal func updating(
    availableCardTypes: [String]?? = nil,
    blurb: String? = nil,
    category: Project.Category?? = nil,
    country: Country? = nil,
    creator: User? = nil,
    extendedProjectProperties: ExtendedProjectProperties?? = nil,
    memberData: Project.MemberData? = nil,
    dates: Project.Dates? = nil,
    displayPrelaunch: Bool?? = nil,
    flagging: Bool? = nil,
    id: Int? = nil,
    lastWave: LastWave?? = nil,
    location: Location?? = nil,
    name: String? = nil,
    pledgeManager: PledgeManager?? = nil,
    pledgeOverTimeCollectionPlanChargeExplanation: String?? = nil,
    pledgeOverTimeCollectionPlanChargedAsNPayments: String?? = nil,
    pledgeOverTimeCollectionPlanShortPitch: String?? = nil,
    pledgeOverTimeMinimumExplanation: String?? = nil,
    personalization: Project.Personalization? = nil,
    photo: Project.Photo? = nil,
    isInPostCampaignPledgingPhase: Bool? = nil,
    postCampaignPledgingEnabled: Bool? = nil,
    prelaunchActivated: Bool?? = nil,
    redemptionPageUrl: String? = nil,
    rewardData: RewardData? = nil,
    sendMetaCapiEvents: Bool? = nil,
    slug: String? = nil,
    staffPick: Bool? = nil,
    state: Project.State? = nil,
    stats: Project.Stats? = nil,
    tags: [String]?? = nil,
    urls: Project.UrlsEnvelope? = nil,
    video: Project.Video?? = nil,
    watchesCount: Int?? = nil,
    isPledgeOverTimeAllowed: Bool?? = nil
  ) -> Project {
    Project(
      availableCardTypes: availableCardTypes ?? self.availableCardTypes,
      blurb: blurb ?? self.blurb,
      category: category ?? self.category,
      country: country ?? self.country,
      creator: creator ?? self.creator,
      extendedProjectProperties: extendedProjectProperties ?? self.extendedProjectProperties,
      memberData: memberData ?? self.memberData,
      dates: dates ?? self.dates,
      displayPrelaunch: displayPrelaunch ?? self.displayPrelaunch,
      flagging: flagging ?? self.flagging,
      id: id ?? self.id,
      lastWave: lastWave ?? self.lastWave,
      location: location ?? self.location,
      name: name ?? self.name,
      pledgeManager: pledgeManager ?? self.pledgeManager,
      pledgeOverTimeCollectionPlanChargeExplanation:
        pledgeOverTimeCollectionPlanChargeExplanation ?? self.pledgeOverTimeCollectionPlanChargeExplanation,
      pledgeOverTimeCollectionPlanChargedAsNPayments:
        pledgeOverTimeCollectionPlanChargedAsNPayments ?? self.pledgeOverTimeCollectionPlanChargedAsNPayments,
      pledgeOverTimeCollectionPlanShortPitch:
        pledgeOverTimeCollectionPlanShortPitch ?? self.pledgeOverTimeCollectionPlanShortPitch,
      pledgeOverTimeMinimumExplanation:
        pledgeOverTimeMinimumExplanation ?? self.pledgeOverTimeMinimumExplanation,
      personalization: personalization ?? self.personalization,
      photo: photo ?? self.photo,
      isInPostCampaignPledgingPhase: isInPostCampaignPledgingPhase ?? self.isInPostCampaignPledgingPhase,
      postCampaignPledgingEnabled: postCampaignPledgingEnabled ?? self.postCampaignPledgingEnabled,
      prelaunchActivated: prelaunchActivated ?? self.prelaunchActivated,
      redemptionPageUrl: redemptionPageUrl ?? self.redemptionPageUrl,
      rewardData: rewardData ?? self.rewardData,
      sendMetaCapiEvents: sendMetaCapiEvents ?? self.sendMetaCapiEvents,
      slug: slug ?? self.slug,
      staffPick: staffPick ?? self.staffPick,
      state: state ?? self.state,
      stats: stats ?? self.stats,
      tags: tags ?? self.tags,
      urls: urls ?? self.urls,
      video: video ?? self.video,
      watchesCount: watchesCount ?? self.watchesCount,
      isPledgeOverTimeAllowed: isPledgeOverTimeAllowed ?? self.isPledgeOverTimeAllowed
    )
  }
}

extension Project.UrlsEnvelope {
  /// Functional lenses for `Project.UrlsEnvelope`.
  public enum lens {
    /// Lens focusing on the nested web URLs container.
    public static let web = Lens<Project.UrlsEnvelope, Project.UrlsEnvelope.WebEnvelope>(
      view: { $0.web },
      set: { part, _ in .init(web: part) }
    )
  }
}

extension Project.UrlsEnvelope.WebEnvelope {
  /// Functional lenses for `Project.UrlsEnvelope.WebEnvelope`.
  public enum lens {
    /// Lens focusing on the canonical web project URL string.
    public static let project = Lens<Project.UrlsEnvelope.WebEnvelope, String>(
      view: { $0.project },
      set: { .init(project: $0, updates: $1.updates) }
    )

    /// Lens focusing on the project updates feed URL string.
    public static let updates = Lens<Project.UrlsEnvelope.WebEnvelope, String?>(
      view: { $0.updates },
      set: { .init(project: $1.project, updates: $0) }
    )
  }
}

