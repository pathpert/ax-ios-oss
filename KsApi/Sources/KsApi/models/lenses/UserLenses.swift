import Prelude

extension User {
  /// Functional lenses focusing on top-level `User` model fields.
  ///
  /// - Negative constraint: Do not mutate `User` instances in place; compose or apply these lenses to derive updated immutable copies.
  public enum lens {
    /// Lens focusing on the user's avatar image URLs (`User.Avatar`).
    public static let avatar = Lens<User, User.Avatar>(
      view: { $0.avatar },
      set: { $1.updating(avatar: $0) }
    )

    /// Lens focusing on the count of errored backings awaiting payment resolution.
    public static let erroredBackingsCount = Lens<User, Int?>(
      view: { $0.erroredBackingsCount },
      set: { $1.updating(erroredBackingsCount: $0) }
    )

    /// Lens focusing on whether the account is linked to Facebook.
    public static let facebookConnected = Lens<User, Bool?>(
      view: { $0.facebookConnected },
      set: { $1.updating(facebookConnected: $0) }
    )

    /// Lens focusing on the immutable numeric Kickstarter user ID.
    public static let id = Lens<User, Int>(
      view: { $0.id },
      set: { $1.updating(id: $0) }
    )

    /// Lens focusing on whether the user holds Kickstarter staff/admin privileges.
    public static let isAdmin = Lens<User, Bool?>(
      view: { $0.isAdmin },
      set: { $1.updating(isAdmin: $0) }
    )

    /// Lens focusing on email address verification status.
    public static let isEmailVerified = Lens<User, Bool?>(
      view: { $0.isEmailVerified },
      set: { $1.updating(isEmailVerified: $0) }
    )

    /// Lens focusing on whether the logged-in viewer follows/is friends with this user.
    public static let isFriend = Lens<User, Bool?>(
      view: { $0.isFriend },
      set: { $1.updating(isFriend: $0) }
    )

    /// Lens focusing on whether this user is blocked by the viewer.
    public static let isBlocked = Lens<User, Bool>(
      view: { $0.isBlocked },
      set: { $1.updating(isBlocked: $0) }
    )

    /// Lens focusing on the user's optional primary `Location`.
    public static let location = Lens<User, Location?>(
      view: { $0.location },
      set: { $1.updating(location: $0) }
    )

    /// Lens focusing on the user's display name.
    public static let name = Lens<User, String>(
      view: { $0.name },
      set: { $1.updating(name: $0) }
    )

    /// Lens focusing on whether the user's linked Facebook OAuth token needs reauthorization.
    public static let needsFreshFacebookToken = Lens<User, Bool?>(
      view: { $0.needsFreshFacebookToken },
      set: { $1.updating(needsFreshFacebookToken: $0) }
    )

    /// Lens focusing on the user's newsletter subscription preferences.
    public static let newsletters = Lens<User, User.NewsletterSubscriptions>(
      view: { $0.newsletters },
      set: { $1.updating(newsletters: $0) }
    )

    /// Lens focusing on the user's email and push notification preferences.
    public static let notifications = Lens<User, User.Notifications>(
      view: { $0.notifications },
      set: { $1.updating(notifications: $0) }
    )

    /// Lens focusing on whether the user opted out of personalized recommendations.
    public static let optedOutOfRecommendations = Lens<User, Bool?>(
      view: { $0.optedOutOfRecommendations },
      set: { $1.updating(optedOutOfRecommendations: $0) }
    )

    /// Lens focusing on whether the user's Kickstarter profile is publicly visible.
    public static let showPublicProfile = Lens<User, Bool?>(
      view: { $0.showPublicProfile },
      set: { $1.updating(showPublicProfile: $0) }
    )

    /// Lens focusing on social sharing opt-in preference.
    public static let social = Lens<User, Bool?>(
      view: { $0.social },
      set: { $1.updating(social: $0) }
    )

    /// Lens focusing on aggregate account activity counters (`User.Stats`).
    public static let stats = Lens<User, User.Stats>(
      view: { $0.stats },
      set: { $1.updating(stats: $0) }
    )

    /// Lens focusing on the user's unseen activity badge count.
    public static let unseenActivityCount = Lens<User, Int?>(
      view: { $0.unseenActivityCount },
      set: { $1.updating(unseenActivityCount: $0) }
    )
  }
}

private extension User {
  func updating(
    avatar: User.Avatar? = nil,
    erroredBackingsCount: Int?? = nil,
    facebookConnected: Bool?? = nil,
    id: Int? = nil,
    isAdmin: Bool?? = nil,
    isEmailVerified: Bool?? = nil,
    isFriend: Bool?? = nil,
    isBlocked: Bool? = nil,
    location: Location?? = nil,
    name: String? = nil,
    needsFreshFacebookToken: Bool?? = nil,
    newsletters: User.NewsletterSubscriptions? = nil,
    notifications: User.Notifications? = nil,
    optedOutOfRecommendations: Bool?? = nil,
    showPublicProfile: Bool?? = nil,
    social: Bool?? = nil,
    stats: User.Stats? = nil,
    unseenActivityCount: Int?? = nil
  ) -> User {
    User(
      avatar: avatar ?? self.avatar,
      erroredBackingsCount: erroredBackingsCount ?? self.erroredBackingsCount,
      facebookConnected: facebookConnected ?? self.facebookConnected,
      id: id ?? self.id,
      isAdmin: isAdmin ?? self.isAdmin,
      isEmailVerified: isEmailVerified ?? self.isEmailVerified,
      isFriend: isFriend ?? self.isFriend,
      isBlocked: isBlocked ?? self.isBlocked,
      location: location ?? self.location,
      name: name ?? self.name,
      needsFreshFacebookToken: needsFreshFacebookToken ?? self.needsFreshFacebookToken,
      needsPassword: self.needsPassword,
      newsletters: newsletters ?? self.newsletters,
      notifications: notifications ?? self.notifications,
      optedOutOfRecommendations: optedOutOfRecommendations ?? self.optedOutOfRecommendations,
      showPublicProfile: showPublicProfile ?? self.showPublicProfile,
      social: social ?? self.social,
      stats: stats ?? self.stats,
      unseenActivityCount: unseenActivityCount ?? self.unseenActivityCount
    )
  }
}
