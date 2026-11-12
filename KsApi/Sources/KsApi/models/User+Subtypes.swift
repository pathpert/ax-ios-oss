import Foundation

extension User {
  /// Profile image URL renditions for a `User`.
  public struct Avatar {
    /// Large profile image URL (`nil` on compact endpoints).
    public var large: String?
    /// Medium profile image URL string.
    public var medium: String
    /// Small avatar thumbnail URL string.
    public var small: String
  }

  /// Editorial email newsletter subscription opt-in toggles.
  public struct NewsletterSubscriptions {
    /// Arts & Culture newsletter opt-in.
    public var arts: Bool?
    /// Games newsletter ("Kickstarter Games") opt-in.
    public var games: Bool?
    /// Weekly "Happening" digest opt-in.
    public var happening: Bool?
    /// Design & Tech ("Invent") newsletter opt-in.
    public var invent: Bool?
    /// Special announcements and Kickstarter promos opt-in.
    public var promo: Bool?
    /// "Projects We Love" weekly roundup opt-in.
    public var weekly: Bool?
    /// Film & Video newsletter opt-in.
    public var films: Bool?
    /// Publishing newsletter opt-in.
    public var publishing: Bool?
    /// Alumni community newsletter opt-in.
    public var alumni: Bool?
    /// Music newsletter opt-in.
    public var music: Bool?

    /// Returns a `NewsletterSubscriptions` instance with all newsletters set uniformly to `on`.
    public static func all(on: Bool) -> NewsletterSubscriptions {
      return NewsletterSubscriptions(
        arts: on,
        games: on,
        happening: on,
        invent: on,
        promo: on,
        weekly: on,
        films: on,
        publishing: on,
        alumni: on,
        music: on
      )
    }
  }

  /// Email and mobile push notification opt-in preferences.
  public struct Notifications {
    /// Email notification when someone backs the creator's project.
    public var backings: Bool?
    /// Email notification on replies to the user's comments.
    public var commentReplies: Bool?
    /// Email notification when someone comments on the creator's project.
    public var comments: Bool?
    /// Daily creator activity digest email toggle.
    public var creatorDigest: Bool?
    /// Creator education & tips email toggle.
    public var creatorTips: Bool?
    /// Email notification when someone follows the user.
    public var follower: Bool?
    /// Email notification on friend backing/launch activity.
    public var friendActivity: Bool?
    /// Email notification for direct messages.
    public var messages: Bool?
    /// Push notification when someone backs the creator's project.
    public var mobileBackings: Bool?
    /// Push notification for new project comments.
    public var mobileComments: Bool?
    /// Push notification for new followers.
    public var mobileFollower: Bool?
    /// Push notification for friend activity.
    public var mobileFriendActivity: Bool?
    /// Push notification for marketing and product announcements.
    public var mobileMarketingUpdate: Bool?
    /// Push notification for direct messages.
    public var mobileMessages: Bool?
    /// Push notification when a user's comment/update receives a like.
    public var mobilePostLikes: Bool?
    /// Push notification when a backed project posts an update.
    public var mobileUpdates: Bool?
    /// Email notification for likes on updates/comments.
    public var postLikes: Bool?
    /// Email notification when a backed project posts an update.
    public var updates: Bool?
  }

  /// Aggregate user engagement and inbox counters.
  /// Negative Constraint: Counters are `nil` on public profiles; only populated for the authenticated viewer.
  public struct Stats {
    /// Number of projects backed by the user.
    public var backedProjectsCount: Int?
    /// Number of projects created by the user.
    public var createdProjectsCount: Int?
    /// Number of draft projects owned by the user.
    public var draftProjectsCount: Int?
    /// Number of projects where the user is a creator or collaborator.
    public var memberProjectsCount: Int?
    /// Number of saved/starred projects.
    public var starredProjectsCount: Int?
    /// Number of pending backer surveys awaiting completion.
    public var unansweredSurveysCount: Int?
    /// Count of unread inbox threads.
    public var unreadMessagesCount: Int?
  }
}

extension User.Avatar: Codable {
  enum CodingKeys: String, CodingKey {
    case large
    case medium
    case small
  }
}

extension User.Avatar: EncodableType {
  /// Serializes avatar image URLs to a legacy dictionary payload for v1 API encoding.
  public func encode() -> [String: Any] {
    var ret: [String: Any] = [
      "medium": self.medium,
      "small": self.small
    ]
    ret["large"] = self.large
    return ret
  }
}

extension User.NewsletterSubscriptions: Codable {
  enum CodingKeys: String, CodingKey {
    case arts = "arts_culture_newsletter"
    case games = "games_newsletter"
    case happening = "happening_newsletter"
    case invent = "invent_newsletter"
    case promo = "promo_newsletter"
    case weekly = "weekly_newsletter"
    case films = "film_newsletter"
    case publishing = "publishing_newsletter"
    case alumni = "alumni_newsletter"
    case music = "music_newsletter"
  }
}

extension User.NewsletterSubscriptions: EncodableType {
  /// Serializes newsletter opt-in flags to a legacy dictionary payload using snake_case API keys.
  /// - Negative Constraint: Do not use for new Codable GraphQL mutations.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["arts_culture_newsletter"] = self.arts
    result["games_newsletter"] = self.games
    result["happening_newsletter"] = self.happening
    result["invent_newsletter"] = self.invent
    result["promo_newsletter"] = self.promo
    result["weekly_newsletter"] = self.weekly
    result["film_newsletter"] = self.films
    result["publishing_newsletter"] = self.publishing
    result["alumni_newsletter"] = self.alumni
    result["music_newsletter"] = self.music
    return result
  }
}

extension User.NewsletterSubscriptions: Equatable {}
/// Compares two `User.NewsletterSubscriptions` values across standard newsletter flags.
public func == (lhs: User.NewsletterSubscriptions, rhs: User.NewsletterSubscriptions) -> Bool {
  return lhs.arts == rhs.arts &&
    lhs.games == rhs.games &&
    lhs.happening == rhs.happening &&
    lhs.invent == rhs.invent &&
    lhs.promo == rhs.promo &&
    lhs.weekly == rhs.weekly &&
    lhs.films == rhs.films &&
    lhs.publishing == rhs.publishing &&
    lhs.alumni == rhs.alumni
}

extension User.Notifications: Codable {
  enum CodingKeys: String, CodingKey {
    case backings = "notify_of_backings"
    case commentReplies = "notify_of_comment_replies"
    case comments = "notify_of_comments"
    case creatorDigest = "notify_of_creator_digest"
    case creatorTips = "notify_of_creator_edu"
    case follower = "notify_of_follower"
    case friendActivity = "notify_of_friend_activity"
    case messages = "notify_of_messages"
    case mobileBackings = "notify_mobile_of_backings"
    case mobileComments = "notify_mobile_of_comments"
    case mobileFriendActivity = "notify_mobile_of_friend_activity"
    case mobileMarketingUpdate = "notify_mobile_of_marketing_update"
    case mobileMessages = "notify_mobile_of_messages"
    case mobileFollower = "notify_mobile_of_follower"
    case mobilePostLikes = "notify_mobile_of_post_likes"
    case mobileUpdates = "notify_mobile_of_updates"
    case postLikes = "notify_of_post_likes"
    case updates = "notify_of_updates"
  }
}

extension User.Notifications: EncodableType {
  /// Encodes user email and mobile push notification toggles into API form parameters.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["notify_of_backings"] = self.backings
    result["notify_of_comment_replies"] = self.commentReplies
    result["notify_of_comments"] = self.comments
    result["notify_of_creator_digest"] = self.creatorDigest
    result["notify_of_creator_edu"] = self.creatorTips
    result["notify_of_follower"] = self.follower
    result["notify_of_friend_activity"] = self.friendActivity
    result["notify_of_messages"] = self.messages
    result["notify_mobile_of_comments"] = self.mobileComments
    result["notify_mobile_of_follower"] = self.mobileFollower
    result["notify_mobile_of_friend_activity"] = self.mobileFriendActivity
    result["notify_mobile_of_marketing_update"] = self.mobileMarketingUpdate
    result["notify_mobile_of_messages"] = self.mobileMessages
    result["notify_mobile_of_post_likes"] = self.mobilePostLikes
    result["notify_mobile_of_updates"] = self.mobileUpdates
    result["notify_of_post_likes"] = self.postLikes
    result["notify_of_updates"] = self.updates
    result["notify_mobile_of_backings"] = self.mobileBackings
    return result
  }
}

extension User.Notifications: Equatable {}

extension User.Stats: Codable {
  enum CodingKeys: String, CodingKey {
    case backedProjectsCount = "backed_projects_count"
    case createdProjectsCount = "created_projects_count"
    case draftProjectsCount = "draft_projects_count"
    case memberProjectsCount = "member_projects_count"
    case starredProjectsCount = "starred_projects_count"
    case unansweredSurveysCount = "unanswered_surveys_count"
    case unreadMessagesCount = "unread_messages_count"
  }
}

extension User.Stats: EncodableType {
  /// Encodes user dashboard statistics counters for fixture/serialization use.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["backed_projects_count"] = self.backedProjectsCount
    result["created_projects_count"] = self.createdProjectsCount
    result["draft_projects_count"] = self.draftProjectsCount
    result["member_projects_count"] = self.memberProjectsCount
    result["starred_projects_count"] = self.starredProjectsCount
    result["unanswered_surveys_count"] = self.unansweredSurveysCount
    result["unread_messages_count"] = self.unreadMessagesCount
    return result
  }
}

