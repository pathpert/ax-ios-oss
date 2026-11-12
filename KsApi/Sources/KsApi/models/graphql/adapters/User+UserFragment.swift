import Foundation
import GraphAPI

extension User {
  /**
   Returns a minimal `User` from a `GraphAPI.PublicUserFragment`.
   This only includes fields which are publicly visible.
   */

  static func publicUser(from userFragment: GraphAPI.PublicUserFragment) -> User? {
    guard let id = decompose(id: userFragment.id) else { return nil }

    return User(
      avatar: Avatar(
        large: userFragment.imageUrl,
        medium: userFragment.imageUrl,
        small: userFragment.imageUrl
      ),
      erroredBackingsCount: nil,
      facebookConnected: nil,
      id: id,
      isAdmin: nil,
      isEmailVerified: nil,
      isFriend: userFragment.isFollowing,
      isBlocked: userFragment.isBlocked ?? false,
      location: self.location(locationFragment: userFragment.location?.fragments.locationFragment),
      name: userFragment.name,
      needsFreshFacebookToken: nil,
      needsPassword: nil,
      newsletters: NewsletterSubscriptions(),
      notifications: Notifications(),
      optedOutOfRecommendations: nil,
      showPublicProfile: nil,
      social: nil,
      stats: Stats(
        backedProjectsCount: userFragment.backingsCount,
        createdProjectsCount: userFragment.createdProjects?.totalCount,
        draftProjectsCount: nil,
        memberProjectsCount: nil,
        starredProjectsCount: nil,
        unansweredSurveysCount: nil,
        unreadMessagesCount: nil
      ),
      unseenActivityCount: nil
    )
  }

  /**
   Returns a minimal `User` from a `GraphAPI.UserFragment`
   */
  static func user(from userFragment: GraphAPI.UserFragment) -> User? {
    guard let id = decompose(id: userFragment.id) else { return nil }

    let erroredBackingsCount = erroredBackingsCount(userFragment: userFragment)

    /// Not accurate, but GQL doesn't currently return an unseen activity count as a top-level property on the `UserFragment`
    var unseenUserActivityCount = 0

    if let hasUnseenActivity = userFragment.hasUnseenActivity,
       hasUnseenActivity {
      unseenUserActivityCount = 1
    }

    return User(
      avatar: Avatar(
        large: userFragment.imageUrl,
        medium: userFragment.imageUrl,
        small: userFragment.imageUrl
      ),
      erroredBackingsCount: erroredBackingsCount == 0 ? nil : erroredBackingsCount,
      facebookConnected: self.isFacebookConnected(userFragment: userFragment),
      id: id,
      isAdmin: self.isAdmin(userFragment: userFragment),
      isEmailVerified: self.isEmailVerified(userFragment: userFragment),
      isFriend: userFragment.isFollowing,
      isBlocked: userFragment.isBlocked ?? false,
      location: self.location(locationFragment: userFragment.location?.fragments.locationFragment),
      name: userFragment.name,
      needsFreshFacebookToken: userFragment.needsFreshFacebookToken,
      needsPassword: self.needsPassword(userFragment: userFragment),
      newsletters: self.newsletterSubscriptions(userFragment: userFragment),
      notifications: self.notifications(userFragment: userFragment),
      optedOutOfRecommendations: userFragment.optedOutOfRecommendations,
      showPublicProfile: userFragment.showPublicProfile,
      social: userFragment.isSocializing,
      stats: self.userStats(from: userFragment),
      unseenActivityCount: unseenUserActivityCount
    )
  }

  private static func newsletterSubscriptions(
    userFragment: GraphAPI
      .UserFragment
  ) -> NewsletterSubscriptions {
    let newslettersSubscriptions = NewsletterSubscriptions(
      arts: userFragment.newsletterSubscriptions?
        .artsCultureNewsletter,
      games: userFragment.newsletterSubscriptions?
        .gamesNewsletter,
      happening: userFragment.newsletterSubscriptions?
        .happeningNewsletter,
      invent: userFragment.newsletterSubscriptions?
        .inventNewsletter,
      promo: userFragment.newsletterSubscriptions?
        .promoNewsletter,
      weekly: userFragment.newsletterSubscriptions?
        .weeklyNewsletter,
      films: userFragment.newsletterSubscriptions?
        .filmNewsletter,
      publishing: userFragment.newsletterSubscriptions?
        .publishingNewsletter,
      alumni: userFragment.newsletterSubscriptions?
        .alumniNewsletter,
      music: userFragment.newsletterSubscriptions?
        .musicNewsletter
    )

    return newslettersSubscriptions
  }

  private static func notifications(
    userFragment: GraphAPI
      .UserFragment
  ) -> Notifications {
    guard let userNotifications = userFragment.notifications else {
      return Notifications()
    }

    var backingsNotification: Bool?
    var commentRepliesNotification: Bool?
    var commentsNotification: Bool?
    var creatorDigestNotification: Bool?
    var creatorTipsNotification: Bool?
    var followerNotification: Bool?
    var friendActivityNotification: Bool?
    var messagesNotification: Bool?
    var postLikesNotification: Bool?
    var updatesNotification: Bool?
    var mobileBackingsNotification: Bool?
    var mobileCommentsNotification: Bool?
    var mobileFollowerNotification: Bool?
    var mobileFriendActivityNotification: Bool?
    var mobileMarketingUpdateNotification: Bool?
    var mobileMessagesNotification: Bool?
    var mobilePostLikesNotification: Bool?
    var mobileUpdatesNotification: Bool?

    for notification in userNotifications {
      switch (notification.topic, notification.mobile, notification.email) {
      case let (.backings, mobileEnabled, emailEnabled):
        backingsNotification = emailEnabled
        mobileBackingsNotification = mobileEnabled
      case let (.commentReplies, _, emailEnabled):
        commentRepliesNotification = emailEnabled
      case let (.comments, mobileEnabled, emailEnabled):
        commentsNotification = emailEnabled
        mobileCommentsNotification = mobileEnabled
      case let (.creatorDigest, _, emailEnabled):
        creatorDigestNotification = emailEnabled
      case let (.creatorEdu, _, emailEnabled):
        creatorTipsNotification = emailEnabled
      case let (.follower, mobileEnabled, emailEnabled):
        followerNotification = emailEnabled
        mobileFollowerNotification = mobileEnabled
      case let (.friendActivity, mobileEnabled, emailEnabled):
        friendActivityNotification = emailEnabled
        mobileFriendActivityNotification = mobileEnabled
      case let (.messages, mobileEnabled, emailEnabled):
        messagesNotification = emailEnabled
        mobileMessagesNotification = mobileEnabled
      /** FIXME: No longer supported by GQL Schema.
       case let (.postLikes, mobileEnabled, emailEnabled):
         postLikesNotification = emailEnabled
         mobilePostLikesNotification = mobileEnabled
       */
      case let (.updates, mobileEnabled, emailEnabled):
        updatesNotification = emailEnabled
        mobileUpdatesNotification = mobileEnabled
      case let (.marketingUpdate, mobileEnabled, _):
        mobileMarketingUpdateNotification = mobileEnabled
      default:
        continue
      }
    }

    let notifications = Notifications(
      backings: backingsNotification,
      commentReplies: commentRepliesNotification,
      comments: commentsNotification,
      creatorDigest: creatorDigestNotification,
      creatorTips: creatorTipsNotification,
      follower: followerNotification,
      friendActivity: friendActivityNotification,
      messages: messagesNotification,
      mobileBackings: mobileBackingsNotification,
      mobileComments: mobileCommentsNotification,
      mobileFollower: mobileFollowerNotification,
      mobileFriendActivity: mobileFriendActivityNotification,
      mobileMarketingUpdate: mobileMarketingUpdateNotification,
      mobileMessages: mobileMessagesNotification,
      mobilePostLikes: mobilePostLikesNotification,
      mobileUpdates: nil,
      postLikes: nil,
      updates: updatesNotification
    )

    return notifications
  }
}
