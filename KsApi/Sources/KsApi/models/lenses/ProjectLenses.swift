import Foundation
import Prelude

extension ExtendedProjectProperties {
  /// Functional lenses for `ExtendedProjectProperties`.
  public enum lens {
    /// Lens focusing on the project's frequently asked questions array.
    public static let faqs = Lens<ExtendedProjectProperties, [ProjectFAQ]>(
      view: { $0.faqs },
      set: { ExtendedProjectProperties(
        environmentalCommitments: $1.environmentalCommitments,
        faqs: $0,
        aiDisclosure: $1.aiDisclosure,
        risks: $1.risks,
        story: $1.story,
        minimumPledgeAmount: $1.minimumPledgeAmount,
        projectNotice: $1.projectNotice
      ) }
    )
  }
}

extension Project {
  /// Functional lenses focusing on `Project` properties and nested sub-envelopes.
  ///
  /// - Negative constraint: Do not pass raw `Project(...)` copies inline across callsites; compose or apply these lenses instead.
  public enum lens {
    /// Lens focusing on supported payment card networks.
    public static let availableCardTypes = Lens<Project, [String]?>(
      view: { $0.availableCardTypes },
      set: { $1.updating(availableCardTypes: $0) }
    )

    /// Lens focusing on the short campaign blurb.
    public static let blurb = Lens<Project, String>(
      view: { $0.blurb },
      set: { $1.updating(blurb: $0) }
    )

    /// Lens focusing on whether Kickstarter selected the campaign as a Staff Pick.
    public static let staffPick = Lens<Project, Bool>(
      view: { $0.staffPick },
      set: { $1.updating(staffPick: $0) }
    )

    /// Lens focusing on the optional `Project.Category`.
    public static let category = Lens<Project, Project.Category?>(
      view: { $0.category },
      set: { $1.updating(category: $0) }
    )

    /// Lens focusing on the project category's display name (preserving category ID).
    public static let categoryName = Lens<Project, String>(
      view: { $0.category?.name ?? "" },
      set: { newName, project in
        let updatedCategory: Project.Category? = project.category.map { category in
          Project.Category(id: category.id, name: newName)
        }
        return project.updating(category: updatedCategory)
      }
    )

    /// Lens focusing on the creator's `Country`.
    public static let country = Lens<Project, Country>(
      view: { $0.country },
      set: { $1.updating(country: $0) }
    )

    /// Lens focusing on the project's creator `User`.
    public static let creator = Lens<Project, User>(
      view: { $0.creator },
      set: { $1.updating(creator: $0) }
    )

    /// Lens focusing on campaign milestone timestamps (`Project.Dates`).
    public static let dates = Lens<Project, Project.Dates>(
      view: { $0.dates },
      set: { $1.updating(dates: $0) }
    )

    /// Lens focusing on whether the project displays a prelaunch state.
    public static let displayPrelaunch = Lens<Project, Bool?>(
      view: { $0.displayPrelaunch },
      set: { $1.updating(displayPrelaunch: $0) }
    )

    /// Lens focusing on story/FAQ/risk extended properties fetched via GraphQL.
    public static let extendedProjectProperties = Lens<Project, ExtendedProjectProperties?>(
      view: { $0.extendedProjectProperties },
      set: { $1.updating(extendedProjectProperties: $0) }
    )

    /// Lens focusing on the numeric Kickstarter project ID.
    public static let id = Lens<Project, Int>(
      view: { $0.id },
      set: { $1.updating(id: $0) }
    )

    /// Lens focusing on the campaign's latest BackerKit/pledge wave metadata.
    public static let lastWave = Lens<Project, LastWave?>(
      view: { $0.lastWave },
      set: { $1.updating(lastWave: $0) }
    )

    /// Lens focusing on the project's geographical `Location`.
    public static let location = Lens<Project, Location?>(
      view: { $0.location },
      set: { $1.updating(location: $0) }
    )

    /// Safely unwraps the location, updates it and writes it back in the project.
    public static let locationDisplayableName = Lens<Project, String>(
      view: { $0.location?.displayableName ?? "" },
      set: { newDisplayableName, project in
        let updatedLocation = project.location.map { Location.lens.displayableName.set(newDisplayableName, $0) }
        return project.updating(location: updatedLocation)
      }
    )

    /// Lens focusing on creator/collaborator permissions and unread counts (`Project.MemberData`).
    public static let memberData = Lens<Project, Project.MemberData>(
      view: { $0.memberData },
      set: { $1.updating(memberData: $0) }
    )

    /// Lens focusing on the project title.
    public static let name = Lens<Project, String>(
      view: { $0.name },
      set: { $1.updating(name: $0) }
    )

    /// Lens focusing on attached Pledge Manager metadata.
    public static let pledgeManager = Lens<Project, PledgeManager?>(
      view: { $0.pledgeManager },
      set: { $1.updating(pledgeManager: $0) }
    )

    /// Lens focusing on viewer-specific backing/star state (`Project.Personalization`).
    public static let personalization = Lens<Project, Project.Personalization>(
      view: { $0.personalization },
      set: { $1.updating(personalization: $0) }
    )

    /// Lens focusing on project cover imagery URLs (`Project.Photo`).
    public static let photo = Lens<Project, Project.Photo>(
      view: { $0.photo },
      set: { $1.updating(photo: $0) }
    )

    /// Lens focusing on whether post-campaign late pledging is currently active.
    public static let isInPostCampaignPledgingPhase = Lens<Project, Bool>(
      view: { $0.isInPostCampaignPledgingPhase },
      set: { $1.updating(isInPostCampaignPledgingPhase: $0) }
    )

    /// Lens focusing on localized Pledge-Over-Time installment charge explanation copy.
    public static let pledgeOverTimeCollectionPlanChargeExplanation = Lens<Project, String?>(
      view: { $0.pledgeOverTimeCollectionPlanChargeExplanation },
      set: { $1.updating(pledgeOverTimeCollectionPlanChargeExplanation: $0) }
    )

    /// Lens focusing on localized Pledge-Over-Time installment count copy.
    public static let pledgeOverTimeCollectionPlanChargedAsNPayments = Lens<Project, String?>(
      view: { $0.pledgeOverTimeCollectionPlanChargedAsNPayments },
      set: { $1.updating(pledgeOverTimeCollectionPlanChargedAsNPayments: $0) }
    )

    /// Lens focusing on the Pledge-Over-Time short pitch label.
    public static let pledgeOverTimeCollectionPlanShortPitch = Lens<Project, String?>(
      view: { $0.pledgeOverTimeCollectionPlanShortPitch },
      set: { $1.updating(pledgeOverTimeCollectionPlanShortPitch: $0) }
    )

    /// Lens focusing on the Pledge-Over-Time minimum threshold explanation string.
    public static let pledgeOverTimeMinimumExplanation = Lens<Project, String?>(
      view: { $0.pledgeOverTimeMinimumExplanation },
      set: { $1.updating(pledgeOverTimeMinimumExplanation: $0) }
    )

    /// Lens focusing on whether post-campaign late pledging is enabled for this project.
    public static let postCampaignPledgingEnabled = Lens<Project, Bool>(
      view: { $0.postCampaignPledgingEnabled },
      set: { $1.updating(postCampaignPledgingEnabled: $0) }
    )

    /// Lens focusing on whether prelaunch follow activation is enabled.
    public static let prelaunchActivated = Lens<Project, Bool?>(
      view: { $0.prelaunchActivated },
      set: { $1.updating(prelaunchActivated: $0) }
    )

    /// Lens focusing on the web redemption URL for rewards/pledge management.
    public static let redemptionPageUrl = Lens<Project, String>(
      view: { $0.redemptionPageUrl },
      set: { $1.updating(redemptionPageUrl: $0) }
    )

    /// Lens focusing on reward tiers and add-ons (`RewardData`).
    public static let rewardData = Lens<Project, RewardData>(
      view: { $0.rewardData },
      set: { $1.updating(rewardData: $0) }
    )

    /// Lens focusing on whether Meta Conversions API events should be emitted.
    public static let sendMetaCapiEvents = Lens<Project, Bool>(
      view: { $0.sendMetaCapiEvents },
      set: { $1.updating(sendMetaCapiEvents: $0) }
    )

    /// Lens focusing on the URL path slug of the project.
    public static let slug = Lens<Project, String>(
      view: { $0.slug },
      set: { $1.updating(slug: $0) }
    )

    /// Lens focusing on the lifecycle state (`Project.State`).
    public static let state = Lens<Project, Project.State>(
      view: { $0.state },
      set: { $1.updating(state: $0) }
    )

    /// Lens focusing on campaign funding statistics (`Project.Stats`).
    public static let stats = Lens<Project, Project.Stats>(
      view: { $0.stats },
      set: { $1.updating(stats: $0) }
    )

    /// Lens focusing on discovery tag names.
    public static let tags = Lens<Project, [String]?>(
      view: { $0.tags },
      set: { $1.updating(tags: $0) }
    )

    /// Lens focusing on web/API URLs (`Project.UrlsEnvelope`).
    public static let urls = Lens<Project, Project.UrlsEnvelope>(
      view: { $0.urls },
      set: { $1.updating(urls: $0) }
    )

    /// Lens focusing on the optional campaign video asset (`Project.Video`).
    public static let video = Lens<Project, Project.Video?>(
      view: { $0.video },
      set: { $1.updating(video: $0) }
    )

    /// Lens focusing on total project watcher/follower count.
    public static let watchesCount = Lens<Project, Int?>(
      view: { $0.watchesCount },
      set: { $1.updating(watchesCount: $0) }
    )

    /// Lens focusing on whether Pledge-Over-Time installments are permitted.
    public static let isPledgeOverTimeAllowed = Lens<Project, Bool?>(
      view: { $0.isPledgeOverTimeAllowed },
      set: { $1.updating(isPledgeOverTimeAllowed: $0) }
    )
  }
}
