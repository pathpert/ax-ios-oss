
import Foundation

/// Timeline activity feed event returned by `/v1/activities`.
///
/// Format: `createdAt` is Unix epoch seconds; `category` classifies which optional nested objects (`comment`, `project`, `update`, `user`) are populated.
/// Negative Constraint: Unknown server activity categories decode to `.unknown` instead of failing; always handle `.unknown` gracefully.
public struct Activity {
  /// Categorized event type determining how the feed item should render.
  public let category: Activity.Category
  /// Associated comment payload for comment activity categories; otherwise `nil`.
  public let comment: ActivityComment?
  /// Event timestamp in Unix epoch seconds.
  public let createdAt: TimeInterval
  /// Server-assigned numeric activity identifier.
  public let id: Int
  /// Backing amount/reward change details flattened from the activity JSON root.
  public let memberData: MemberData
  /// Related `Project` summary, if applicable to this activity category.
  public let project: Project?
  /// Carrier shipment tracking number (present on `.shipped` events).
  public let trackingNumber: String?
  /// Carrier tracking URL string (present on `.shipped` events).
  public let trackingUrl: String?
  /// Creator `Update` post (present on `.update` events).
  public let update: Update?
  /// Actor `User` associated with the activity (e.g., followed friend or backer).
  public let user: User?

  /// Known activity feed event categories.
  public enum Category: String {
    /// Viewer or followed friend backed a project.
    case backing
    /// A backing or campaign was canceled.
    case cancellation
    /// Comment posted on a project update.
    case commentPost = "comment-post"
    /// Comment posted on a project campaign page.
    case commentProject = "comment-project"
    /// Backed project failed to reach its funding goal.
    case failure
    /// Social follow event.
    case follow
    /// Project reached a funding milestone.
    case funding
    /// Followed creator launched a new project.
    case launch
    /// Creator marked reward shipment as shipped.
    case shipped
    /// Backed project succeeded in reaching its funding goal.
    case success
    /// Project was suspended by Trust & Safety.
    case suspension
    /// Creator published a new project update.
    case update
    /// Viewer watched/saved a project.
    case watch
    /// Forward-compatibility fallback for unrecognized activity categories.
    case unknown
  }

  /// Backing amount and reward tier transition details embedded in backing-related activities.
  public struct MemberData {
    /// Pledge amount in whole currency units (or `nil` when not a backing event).
    public let amount: Int?
    /// Embedded `Backing` record when included in the activity payload.
    public let backing: Backing?
    /// Previous pledge amount prior to an adjustment.
    public let oldAmount: Int?
    /// Previous reward identifier prior to a reward tier change.
    public let oldRewardId: Int?
    /// Updated pledge amount after an adjustment.
    public let newAmount: Int?
    /// Updated reward identifier after a reward tier change.
    public let newRewardId: Int?
    /// Associated reward identifier.
    public let rewardId: Int?
  }
}

extension Activity: Equatable {}

/// Compares two `Activity` items by their unique numeric `id`.
public func == (lhs: Activity, rhs: Activity) -> Bool {
  return lhs.id == rhs.id
}

extension Activity: Decodable {
  enum CodingKeys: String, CodingKey {
    case category
    case comment
    case createdAt = "created_at"
    case id
    case project
    case trackingNumber = "tracking_number"
    case trackingUrl = "tracking_url"
    case update
    case user
  }

  /// Decodes an `Activity` feed item from the API payload.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.category = try values.decode(Activity.Category.self, forKey: .category)
    self.comment = try values.decodeIfPresent(ActivityComment.self, forKey: .comment)
    self.createdAt = try values.decode(TimeInterval.self, forKey: .createdAt)
    self.id = try values.decode(Int.self, forKey: .id)
    self.memberData = try Activity.MemberData(from: decoder)
    self.project = try values.decodeIfPresent(Project.self, forKey: .project)
    self.trackingNumber = try values.decodeIfPresent(String.self, forKey: .trackingNumber)
    self.trackingUrl = try values.decodeIfPresent(String.self, forKey: .trackingUrl)
    self.update = try values.decodeIfPresent(Update.self, forKey: .update)
    self.user = try values.decodeIfPresent(User.self, forKey: .user)
  }
}

extension Activity.Category: Decodable {
  /// Decodes an `Activity.Category` string, falling back to `.unknown` for unrecognized server values.
  public init(from decoder: Decoder) throws {
    self = try Activity.Category(rawValue: decoder.singleValueContainer().decode(String.self)) ?? .unknown
  }
}

extension Activity.MemberData: Decodable {
  enum CodingKeys: String, CodingKey {
    case amount
    case backing
    case oldAmount = "old_amount"
    case oldRewardId = "old_reward_id"
    case newAmount = "new_amount"
    case newRewardId = "new_reward_id"
    case rewardId = "reward_id"
  }
}
