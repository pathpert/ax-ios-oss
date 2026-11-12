import Prelude

extension Lens where Whole == User, Part == User.Avatar {
  /// Composed lens from `User` to large avatar URL.
  public var large: Lens<User, String?> {
    return User.lens.avatar .. User.Avatar.lens.large
  }

  /// Composed lens from `User` to medium avatar URL.
  public var medium: Lens<User, String> {
    return User.lens.avatar .. User.Avatar.lens.medium
  }

  /// Composed lens from `User` to small avatar URL.
  public var small: Lens<User, String> {
    return User.lens.avatar .. User.Avatar.lens.small
  }
}

extension Lens where Whole == User, Part == User.NewsletterSubscriptions {
  /// Composed lens from `User` to Arts newsletter subscription toggle.
  public var arts: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.arts
  }

  /// Composed lens from `User` to Games newsletter subscription toggle.
  public var games: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.games
  }

  /// Composed lens from `User` to Happening newsletter subscription toggle.
  public var happening: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.happening
  }

  /// Composed lens from `User` to Invent newsletter subscription toggle.
  public var invent: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.invent
  }

  /// Composed lens from `User` to Promotional newsletter subscription toggle.
  public var promo: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.promo
  }

  /// Composed lens from `User` to Projects We Love weekly newsletter toggle.
  public var weekly: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.weekly
  }

  /// Composed lens from `User` to Film newsletter subscription toggle.
  public var films: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.films
  }

  /// Composed lens from `User` to Publishing newsletter subscription toggle.
  public var publishing: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.publishing
  }

  /// Composed lens from `User` to Alumni newsletter subscription toggle.
  public var alumni: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.alumni
  }

  /// Composed lens from `User` to Music newsletter subscription toggle.
  public var music: Lens<User, Bool?> {
    return User.lens.newsletters .. User.NewsletterSubscriptions.lens.music
  }
}

extension Lens where Whole == User, Part == User.Notifications {
  /// Composed lens for email notifications on project backings.
  public var backings: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.backings
  }

  /// Composed lens for email notifications on comments.
  public var comments: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.comments
  }

  /// Composed lens for email notifications on new followers.
  public var follower: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.follower
  }

  /// Composed lens for email notifications on friend activity.
  public var friendActivity: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.friendActivity
  }

  /// Composed lens for email notifications on new inbox messages.
  public var messages: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.messages
  }

  /// Composed lens for email notifications on liked updates/posts.
  public var postLikes: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.postLikes
  }

  /// Composed lens for creator tip emails.
  public var creatorTips: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.creatorTips
  }

  /// Composed lens for creator daily/weekly digest emails.
  public var creatorDigest: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.creatorDigest
  }

  /// Composed lens for email notifications on backed project updates.
  public var updates: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.updates
  }

  /// Composed lens for mobile push notifications on new backings.
  public var mobileBackings: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileBackings
  }

  /// Composed lens for mobile push notifications on new comments.
  public var mobileComments: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileComments
  }

  /// Composed lens for mobile push notifications on new followers.
  public var mobileFollower: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileFollower
  }

  /// Composed lens for mobile push notifications on friend activity.
  public var mobileFriendActivity: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileFriendActivity
  }

  /// Composed lens for mobile push notifications on inbox messages.
  public var mobileMessages: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileMessages
  }

  /// Composed lens for mobile push notifications on post likes.
  public var mobilePostLikes: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobilePostLikes
  }

  /// Composed lens for mobile push notifications on project updates.
  public var mobileUpdates: Lens<User, Bool?> {
    return User.lens.notifications .. User.Notifications.lens.mobileUpdates
  }
}

extension Lens where Whole == User, Part == User.Stats {
  /// Composed lens from `User` to total backed projects count.
  public var backedProjectsCount: Lens<User, Int?> {
    return User.lens.stats .. User.Stats.lens.backedProjectsCount
  }

  /// Composed lens from `User` to created/launched projects count.
  public var createdProjectsCount: Lens<User, Int?> {
    return User.lens.stats .. User.Stats.lens.createdProjectsCount
  }

  /// Composed lens from `User` to draft projects count.
  public var draftProjectsCount: Lens<User, Int?> {
    return User.lens.stats .. User.Stats.lens.draftProjectsCount
  }

  /// Composed lens from `User` to collaborator/member projects count.
  public var memberProjectsCount: Lens<User, Int?> {
    return User.lens.stats .. User.Stats.lens.memberProjectsCount
  }

  /// Composed lens from `User` to saved/starred projects count.
  public var starredProjectsCount: Lens<User, Int?> {
    return User.lens.stats .. User.Stats.lens.starredProjectsCount
  }
}

