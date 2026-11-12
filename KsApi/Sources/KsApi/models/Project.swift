import Foundation
import Prelude
import ReactiveSwift

/// Canonical Kickstarter crowdfunding campaign domain model.
///
/// Format: Populated via REST `Decodable` or GraphQL adapters; money figures live in `stats`
/// and dates are stored as Unix epoch `TimeInterval` values inside `dates`.
/// Negative Constraint: Do not construct mock `Project` literals manually in feature code;
/// use `Project.template` lenses in tests, and never persist raw untyped dictionaries.
public struct Project {
  /// Card brand strings accepted by Stripe for this campaign (e.g., `["VISA", "MASTERCARD"]`).
  /// Negative Constraint: Do not infer card eligibility from `country` alone; check this array.
  public var availableCardTypes: [String]?
  /// Creator-written short summary displayed on project cards and campaign headers.
  /// Format: Plain text string; do not inject raw HTML here.
  public var blurb: String
  /// Primary category and optional parent category classification (`nil` on sparse GraphQL projections).
  public var category: Category?
  /// Country configuration (currency code, symbol, trailing code rule) where the project launched.
  public var country: Country
  /// Public user profile of the project creator.
  /// Negative Constraint: Do not treat `creator` as the currently authenticated viewer.
  public var creator: User
  /// Rich campaign details (story elements, FAQs, environmental commitments, risks) fetched separately.
  /// Negative Constraint: Will be `nil` on discovery/list payloads; only populated by project detail queries.
  public var extendedProjectProperties: ExtendedProjectProperties?
  /// Creator/collaborator permissions and unread creator counters for authenticated team members.
  public var memberData: MemberData
  /// Key campaign lifecycle timestamps (`launchedAt`, `deadline`, `stateChangedAt`, `featuredAt`).
  public var dates: Dates
  /// Indicates whether pre-launch UI should be shown instead of live funding stats.
  /// Negative Constraint: Do not assume `true` implies the project has never launched; check `state`.
  public var displayPrelaunch: Bool?
  /// Whether the project has an active moderation/compliance flag.
  public var flagging: Bool?
  /// Server-assigned numeric project identifier.
  /// Format: Positive integer ID. Do not use as a web URL path slug; use `slug` for web links.
  public var id: Int
  /// Latest Pledge Manager wave metadata when post-campaign survey/shipping collection is active.
  public var lastWave: LastWave?
  /// Geographic city/state/country where the creator is based.
  public var location: Location?
  /// Human-readable campaign title.
  /// Negative Constraint: Do not parse identifiers out of `name`; titles are mutable and non-unique.
  public var name: String
  /// Pledge Manager configuration (survey readiness and whether late backers are accepted).
  public var pledgeManager: PledgeManager?
  /// Localized explanation copy describing Pledge Over Time installment collection charges.
  public var pledgeOverTimeCollectionPlanChargeExplanation: String?
  /// Localized summary of how many installment payments will be charged.
  public var pledgeOverTimeCollectionPlanChargedAsNPayments: String?
  /// Short marketing pitch shown next to Pledge Over Time payment options.
  public var pledgeOverTimeCollectionPlanShortPitch: String?
  /// Minimum pledge threshold copy required to unlock Pledge Over Time installments.
  public var pledgeOverTimeMinimumExplanation: String?
  /// Viewer-specific state (user's `backing`, `friends` who backed, `isBacking`, `isStarred`).
  public var personalization: Personalization
  /// Project cover image URLs at multiple resolutions (`full`, `med`, `small`, `1024x768`).
  public var photo: Photo
  /// `true` while the campaign is actively accepting late pledges after funding closed.
  public var isInPostCampaignPledgingPhase: Bool
  /// `true` if late-pledge support is enabled on this campaign.
  /// Negative Constraint: Does not mean late pledging is currently open; also check `isInPostCampaignPledgingPhase`.
  public var postCampaignPledgingEnabled: Bool
  /// `true` when the creator has activated the prelaunch coming-soon page.
  public var prelaunchActivated: Bool?
  /// URL for redeeming digital/post-campaign rewards. May be empty string when unavailable.
  public var redemptionPageUrl: String
  /// Reward tiers and add-ons offered by this campaign.
  /// Negative Constraint: Check `rewardData.rewards` via `rewards`; list endpoints may return an empty array.
  public var rewardData: RewardData
  /// `true` if Meta Conversions API attribution events should be emitted for checkout actions.
  public var sendMetaCapiEvents: Bool
  /// URL-friendly canonical slug (e.g., `"creator/project-title"`).
  /// Negative Constraint: Do not pass `slug` where numeric integer `id` is required by REST endpoints.
  public var slug: String
  /// `true` when curated by Kickstarter editorial staff ("Project We Love").
  public var staffPick: Bool
  /// Current lifecycle state (`live`, `successful`, `failed`, `canceled`, `purged`, `started`, `submitted`, `suspended`).
  public var state: State
  /// Financial funding progress, goal, backer count, and FX conversion rates.
  public var stats: Stats
  /// Editorial/discovery tags attached to the campaign (`nil` when omitted by endpoint).
  public var tags: [String]?
  /// Web URLs (`web.project`, `web.updates`) for browser handoff and deep links.
  public var urls: UrlsEnvelope
  /// Optional campaign pitch video stream URLs (`high` MP4 and `hls` playlist).
  public var video: Video?
  /// Number of prelaunch followers watching this project. Populated only by watch/detail queries.
  public var watchesCount: Int?
  /// `true` when installment ("Pledge Over Time") payments are enabled for eligible pledges.
  public var isPledgeOverTimeAllowed: Bool?

  /// Returns `true` when the project defines at least one add-on reward.
  public var hasAddOns: Bool {
    return self.addOns?.isEmpty == false
  }

  /// Convenience accessor for `rewardData.addOns`.
  public var addOns: [Reward]? {
    return self.rewardData.addOns
  }

  /// Convenience accessor for `rewardData.rewards`.
  public var rewards: [Reward] {
    return self.rewardData.rewards
  }

  /// Returns `true` if the campaign ends within 48 hours of `today`, or if no deadline is set.
  /// - parameter today: Reference timestamp defaulting to `Date()`.
  public func endsIn48Hours(today: Date = Date()) -> Bool {
    guard let datesDeadlineValue = self.dates.deadline else {
      return true
    }

    let twoDays: TimeInterval = 60.0 * 60.0 * 48.0
    return datesDeadlineValue - today.timeIntervalSince1970 <= twoDays
  }

  /// Returns `true` when `dates.featuredAt` falls on the same calendar day as `today`.
  public func isFeaturedToday(today: Date = Date(), calendar: Calendar = .current) -> Bool {
    guard let featuredAt = self.dates.featuredAt else { return false }
    return self.isDateToday(date: featuredAt, today: today, calendar: calendar)
  }

  /// Returns `true` when post-campaign Pledge Manager checkout/management is currently accessible.
  public var pledgeManagementAvailable: Bool {
    let isBacking = self.personalizationIsBacking ?? false
    let lastWaveActive = self.lastWave?.active ?? false
    let pmAcceptsNewBackers = self.pledgeManager?.acceptsNewBackers ?? false

    return lastWaveActive && (pmAcceptsNewBackers || isBacking)
  }

  private func isDateToday(date: TimeInterval, today: Date, calendar: Calendar) -> Bool {
    let startOfToday = calendar.startOfDay(for: today)
    return abs(startOfToday.timeIntervalSince1970 - date) < 60.0 * 60.0 * 24.0
  }
}

extension Project: Equatable {}
/// Compares two projects by their canonical `id`.
public func == (lhs: Project, rhs: Project) -> Bool {
  return lhs.id == rhs.id
}

extension Project: CustomDebugStringConvertible {
  /// Concise debug summary containing the project `id` and `name`.
  public var debugDescription: String {
    return "Project(id: \(self.id), name: \"\(self.name)\")"
  }
}

extension Project: GraphIDBridging {
  /// GraphQL global node type name (`"Project"`) used when bridging base64 GraphIDs.
  public static var modelName: String {
    return "Project"
  }
}
