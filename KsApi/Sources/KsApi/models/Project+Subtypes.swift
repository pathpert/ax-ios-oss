import Foundation

extension Project {
  /// Editorial category hierarchy node assigned to a project.
  public struct Category {
    /// Unlocalized English analytics identifier (e.g., `"Tabletop Games"`).
    /// Negative Constraint: Do not show `analyticsName` in user-facing UI; display `name` instead.
    public var analyticsName: String?
    /// Numeric Kickstarter category ID.
    public var id: Int
    /// Localized display name of the category or subcategory.
    public var name: String
    /// Unlocalized parent category name used exclusively for analytics events.
    public var parentAnalyticsName: String?
    /// Numeric ID of the root parent category (`nil` if this category is already top-level).
    public var parentId: Int?
    /// Localized display name of the parent category (`nil` if top-level).
    public var parentName: String?

    /// Top-level category identifier (`parentId` when present, otherwise `id`).
    public var rootId: Int {
      return self.parentId ?? self.id
    }
  }

  /// Envelope holding public web URLs associated with a project.
  public struct UrlsEnvelope {
    /// Web URLs container for browser and deep-link routing.
    public var web: WebEnvelope

    /// Canonical project & updates web URLs.
    public struct WebEnvelope {
      /// Canonical campaign landing page URL (Format: HTTPS URL string).
      public var project: String
      /// Optional URL to the project's updates feed.
      public var updates: String?
    }
  }

  /// Campaign pitch video asset URLs.
  public struct Video {
    /// Numeric video asset ID.
    public var id: Int
    /// High-resolution MP4 stream URL.
    public var high: String
    /// Adaptive HTTP Live Streaming (`.m3u8`) URL, preferred for AVPlayer when available.
    public var hls: String?
  }

  /// Finite campaign lifecycle states returned by the API.
  public enum State: String, CaseIterable, Decodable {
    /// Creator canceled funding before completion.
    case canceled
    /// Deadline passed without meeting funding goal.
    case failed
    /// Actively accepting pledges.
    case live
    /// Removed/purged by moderation or creator deletion.
    case purged
    /// Draft project started in creator dashboard, not yet submitted.
    case started
    /// Submitted for review prior to launch.
    case submitted
    /// Funding goal reached before deadline.
    case successful
    /// Suspended by Trust & Safety; do not allow pledging.
    case suspended
  }

  /// Creator/collaborator permissions and unread activity counters for team members.
  public struct MemberData {
    /// Unix epoch timestamp (`TimeInterval`) of the most recently published creator update.
    public var lastUpdatePublishedAt: TimeInterval?
    /// Granted creator/collaborator capabilities filtered to known cases.
    public var permissions: [Permission]
    /// Unread creator inbox thread count (`nil` for non-members).
    public var unreadMessagesCount: Int?
    /// Unseen creator activity count (`nil` for non-members).
    public var unseenActivityCount: Int?

    /// Granular collaborator permission scopes.
    public enum Permission: String {
      case editProject = "edit_project"
      case editFaq = "edit_faq"
      case post
      case comment
      case viewPledges = "view_pledges"
      case fulfillment
      case unknown
    }
  }

  /// Campaign lifecycle timestamps expressed as Unix epoch seconds (`TimeInterval`).
  /// Negative Constraint: Do not pass raw `TimeInterval` values directly to UI labels; use formatted date helpers.
  public struct Dates {
    /// Scheduled campaign funding end time in Unix epoch seconds (`nil` for drafts/prelaunch).
    public var deadline: TimeInterval?
    /// Timestamp when the project was featured on the home/discovery showcase.
    public var featuredAt: TimeInterval?
    /// Final collection cutoff date for Pledge Over Time / post-campaign collection.
    public var finalCollectionDate: TimeInterval?
    /// Timestamp when the project went live (`nil` if not yet launched).
    public var launchedAt: TimeInterval?
    /// Timestamp when the project last transitioned `state` (required Unix epoch seconds).
    public var stateChangedAt: TimeInterval

    /// Total campaign duration in whole calendar days between `launchedAt` and `deadline`.
    public func duration(using calendar: Calendar = .current) -> Int? {
      guard let deadlineDateValue = self.deadline,
            let launchedAtDateValue = self.launchedAt else {
        return nil
      }

      let deadlineDate = Date(timeIntervalSince1970: deadlineDateValue)
      let launchedAtDate = Date(timeIntervalSince1970: launchedAtDateValue)

      return calendar.dateComponents([.day], from: launchedAtDate, to: deadlineDate).day
    }

    /// Non-negative whole hours remaining until `deadline` relative to `date`.
    public func hoursRemaining(from date: Date = Date(), using calendar: Calendar = .current) -> Int? {
      guard let deadlineDateValue = self.deadline else {
        return nil
      }

      let deadlineDate = Date(timeIntervalSince1970: deadlineDateValue)

      guard let hoursRemaining = calendar.dateComponents([.hour], from: date, to: deadlineDate).hour else {
        return nil
      }

      return max(0, hoursRemaining)
    }
  }

  /// Viewer-specific relationship state relative to a project.
  public struct Personalization {
    /// The viewer's active or historical backing on this project (`nil` if not fetched or not backing).
    public var backing: Backing?
    /// Social connections who have also backed this project.
    public var friends: [User]?
    /// `true` when the viewer is currently backing this project (`nil` when unauthenticated).
    public var isBacking: Bool?
    /// `true` when the viewer bookmarked/saved this project (`nil` when unauthenticated).
    public var isStarred: Bool?
  }

  /// Image rendition URLs for the campaign hero photo.
  public struct Photo {
    /// Full-resolution hero image URL string.
    public var full: String
    /// Medium card thumbnail URL string.
    public var med: String
    /// 1024x768 (or 1024x576 fallback) wide preview image URL string.
    public var size1024x768: String?
    /// Small list thumbnail URL string.
    public var small: String
  }

  /// Reward tiers and add-ons offered on a project.
  public struct RewardData {
    /// Optional add-on rewards purchasable alongside a primary tier.
    public var addOns: [Reward]?
    /// Ordered array of primary reward tiers (empty on sparse list projections).
    public var rewards: [Reward]
  }
}

extension Project.UrlsEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case web
  }
}

extension Project.UrlsEnvelope.WebEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case project
    case updates
  }
}

extension Project.Dates: Decodable {
  enum CodingKeys: String, CodingKey {
    case deadline
    case featuredAt = "featured_at"
    case finalCollectionDate = "final_collection_date"
    case launchedAt = "launched_at"
    case stateChangedAt = "state_changed_at"
  }
}

extension Project.Personalization: Decodable {
  enum CodingKeys: String, CodingKey {
    case backing
    case friends
    case isBacking = "is_backing"
    case isStarred = "is_starred"
  }
}

extension Project.Category: Decodable {
  enum CodingKeys: String, CodingKey {
    case analyticsName = "analytics_name"
    case id
    case name
    case parentId = "parent_id"
    case parentName = "parent_name"
  }
}

extension Project.Video: Decodable {}

