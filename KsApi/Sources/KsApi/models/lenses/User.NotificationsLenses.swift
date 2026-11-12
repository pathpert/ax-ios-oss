import Prelude

extension User.Notifications {
  /// Functional lenses for `User.Notifications`.
  public enum lens {
    private static func copy(
      _ notifications: User.Notifications,
      backings: Bool?? = nil,
      commentReplies: Bool?? = nil,
      comments: Bool?? = nil,
      creatorDigest: Bool?? = nil,
      creatorTips: Bool?? = nil,
      follower: Bool?? = nil,
      friendActivity: Bool?? = nil,
      messages: Bool?? = nil,
      mobileBackings: Bool?? = nil,
      mobileComments: Bool?? = nil,
      mobileFollower: Bool?? = nil,
      mobileFriendActivity: Bool?? = nil,
      mobileMessages: Bool?? = nil,
      mobilePostLikes: Bool?? = nil,
      mobileUpdates: Bool?? = nil,
      postLikes: Bool?? = nil,
      updates: Bool?? = nil
    ) -> User.Notifications {
      User.Notifications(
        backings: backings ?? notifications.backings,
        commentReplies: commentReplies ?? notifications.commentReplies,
        comments: comments ?? notifications.comments,
        creatorDigest: creatorDigest ?? notifications.creatorDigest,
        creatorTips: creatorTips ?? notifications.creatorTips,
        follower: follower ?? notifications.follower,
        friendActivity: friendActivity ?? notifications.friendActivity,
        messages: messages ?? notifications.messages,
        mobileBackings: mobileBackings ?? notifications.mobileBackings,
        mobileComments: mobileComments ?? notifications.mobileComments,
        mobileFollower: mobileFollower ?? notifications.mobileFollower,
        mobileFriendActivity: mobileFriendActivity ?? notifications.mobileFriendActivity,
        mobileMessages: mobileMessages ?? notifications.mobileMessages,
        mobilePostLikes: mobilePostLikes ?? notifications.mobilePostLikes,
        mobileUpdates: mobileUpdates ?? notifications.mobileUpdates,
        postLikes: postLikes ?? notifications.postLikes,
        updates: updates ?? notifications.updates
      )
    }

    /// Lens focusing on email notifications for creator backings.
    public static let backings = Lens<User.Notifications, Bool?>(
      view: { $0.backings },
      set: { copy($1, backings: .some($0)) }
    )

    /// Lens focusing on email notifications for comment replies.
    public static let commentReplies = Lens<User.Notifications, Bool?>(
      view: { $0.commentReplies },
      set: { copy($1, commentReplies: .some($0)) }
    )

    /// Lens focusing on email notifications for new project comments.
    public static let comments = Lens<User.Notifications, Bool?>(
      view: { $0.comments },
      set: { copy($1, comments: .some($0)) }
    )

    /// Lens focusing on daily/weekly creator digest email notifications.
    public static let creatorDigest = Lens<User.Notifications, Bool?>(
      view: { $0.creatorDigest },
      set: { copy($1, creatorDigest: .some($0)) }
    )

    /// Lens focusing on creator tips and guidance email preferences.
    public static let creatorTips = Lens<User.Notifications, Bool?>(
      view: { $0.creatorTips },
      set: { copy($1, creatorTips: .some($0)) }
    )

    /// Lens focusing on email notifications when someone follows the user.
    public static let follower = Lens<User.Notifications, Bool?>(
      view: { $0.follower },
      set: { copy($1, follower: .some($0)) }
    )

    /// Lens focusing on email notifications for friend backing/launching activity.
    public static let friendActivity = Lens<User.Notifications, Bool?>(
      view: { $0.friendActivity },
      set: { copy($1, friendActivity: .some($0)) }
    )

    /// Lens focusing on email notifications for direct backer/creator messages.
    public static let messages = Lens<User.Notifications, Bool?>(
      view: { $0.messages },
      set: { copy($1, messages: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for creator backings.
    public static let mobileBackings = Lens<User.Notifications, Bool?>(
      view: { $0.mobileBackings },
      set: { copy($1, mobileBackings: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for project comments.
    public static let mobileComments = Lens<User.Notifications, Bool?>(
      view: { $0.mobileComments },
      set: { copy($1, mobileComments: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for new followers.
    public static let mobileFollower = Lens<User.Notifications, Bool?>(
      view: { $0.mobileFollower },
      set: { copy($1, mobileFollower: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for friend activity.
    public static let mobileFriendActivity = Lens<User.Notifications, Bool?>(
      view: { $0.mobileFriendActivity },
      set: { copy($1, mobileFriendActivity: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for direct messages.
    public static let mobileMessages = Lens<User.Notifications, Bool?>(
      view: { $0.mobileMessages },
      set: { copy($1, mobileMessages: .some($0)) }
    )

    /// Lens focusing on mobile push notifications when updates receive likes.
    public static let mobilePostLikes = Lens<User.Notifications, Bool?>(
      view: { $0.mobilePostLikes },
      set: { copy($1, mobilePostLikes: .some($0)) }
    )

    /// Lens focusing on mobile push notifications for backed project updates.
    public static let mobileUpdates = Lens<User.Notifications, Bool?>(
      view: { $0.mobileUpdates },
      set: { copy($1, mobileUpdates: .some($0)) }
    )

    /// Lens focusing on email notifications when updates receive likes.
    public static let postLikes = Lens<User.Notifications, Bool?>(
      view: { $0.postLikes },
      set: { copy($1, postLikes: .some($0)) }
    )

    /// Lens focusing on email notifications for backed project updates.
    public static let updates = Lens<User.Notifications, Bool?>(
      view: { $0.updates },
      set: { copy($1, updates: .some($0)) }
    )
  }
}
