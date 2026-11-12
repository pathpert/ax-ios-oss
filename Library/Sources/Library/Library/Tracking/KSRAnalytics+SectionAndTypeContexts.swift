import KsApi

extension KSRAnalytics {
  /// Represents a tab or section within a structured screen or dashboard.
  public enum SectionContext {
    case backed
    case backerSurvey
    case comments
    case dashboard
    case onboardingWelcome
    case onboardingSaveProjects
    case onboardingEnableNotifications
    case onboardingAllowTracking
    case onboardingLoginSignup
    case onboardingNotificationsDialog
    case onboardingAppTrackingDialog
    case overview
    case updates
    case watched
    case tabSelected(TabContext)

    var trackingString: String {
      switch self {
      case .backed: return "backed"
      case .backerSurvey: return "backer_survey"
      case .comments: return "comments"
      case .dashboard: return "dashboard"
      case .onboardingWelcome: return "welcome"
      case .onboardingSaveProjects: return "save_projects"
      case .onboardingEnableNotifications: return "enable_notifications"
      case .onboardingAllowTracking: return "activity_tracking"
      case .onboardingLoginSignup: return "signup_login"
      case .onboardingNotificationsDialog: return "enable_notifications_prompt"
      case .onboardingAppTrackingDialog: return "activity_tracking_prompt"
      case .overview: return "overview"
      case .updates: return "updates"
      case .watched: return "watched"
      case let .tabSelected(tabContext): return tabContext.trackingString
      }
    }

    /// Identifies the selected project page detail tab.
    public enum TabContext {
      case overview
      case risks
      case campaign
      case useOfAI
      case faqs
      case environmentalCommitments

      var trackingString: String {
        switch self {
        case .overview: return "overview"
        case .risks: return "risks"
        case .campaign: return "campaign"
        case .useOfAI: return "use_of_ai"
        case .faqs: return "faq"
        case .environmentalCommitments: return "environment"
        }
      }
    }
  }

  /// Contextual details about an emitted event not captured by standard context properties.
  public enum TypeContext {
    case address
    case allProjects
    case amountGoal
    case amountPledged
    case apple
    case applePay
    case backed
    case categoryName
    case cancel
    case creditCard
    case confirm
    case discovery(DiscoverySortContext)
    case facebook
    case initiate
    case location
    case off
    case on
    case percentRaised
    case pledge(PledgeContext)
    case projectState
    case pwl
    case recommended
    case results
    case searchTerm
    case social
    case subcategoryName
    case subscriptionFalse
    case subscriptionTrue
    case tag
    case unwatch
    case watch
    case watched
    case videoFeedShareDestination(VideoFeedShareDestinationContext)

    /// Creates a `TypeContext` value derived from active `DiscoveryParams` filters.
    init(params: DiscoveryParams) {
      if let recommended = params.recommended, recommended {
        self = .recommended
      } else if let starred = params.starred, starred {
        self = .watched
      } else if let social = params.social, social {
        self = .social
      } else {
        self = .results
      }
    }

    /// Identifies a discovery sorting option selected by the user.
    public enum DiscoverySortContext {
      case endingSoon
      case magic
      case newest
      case popular

      var trackingString: String {
        switch self {
        case .endingSoon: return "ending_soon"
        case .magic: return "magic"
        case .newest: return "newest"
        case .popular: return "popular"
        }
      }
    }

    /// Distinguishes the pledge lifecycle mode for checkout analytics events.
    public enum PledgeContext {
      case fixErroredPledge
      case newPledge
      case managePledge

      var trackingString: String {
        switch self {
        case .fixErroredPledge: return "fix_errored_pledge"
        case .newPledge: return "new_pledge"
        case .managePledge: return "manage_pledge"
        }
      }
    }

    /// Maps each video feed share destination to its analytics tracking string.
    public enum VideoFeedShareDestinationContext {
      case copyLink
      case instagramStories
      case x
      case facebookFeed
      case facebookStories
      case whatsApp
      case messages
      case email
      case more

      var trackingString: String {
        switch self {
        case .copyLink: return "copy_link"
        case .instagramStories: return "instagram_stories"
        case .x: return "x"
        case .facebookFeed: return "facebook_feed"
        case .facebookStories: return "facebook_stories"
        case .whatsApp: return "whatsapp"
        case .messages: return "messages"
        case .email: return "email"
        case .more: return "more"
        }
      }
    }

    var trackingString: String {
      switch self {
      case .allProjects: return "all"
      case .amountGoal: return "amount_goal"
      case .amountPledged: return "amount_pledged"
      case .apple: return "apple"
      case .applePay: return "apple_pay"
      case .backed: return "backed"
      case .cancel: return "cancel"
      case .categoryName: return "category_name"
      case .confirm: return "confirm"
      case .creditCard: return "credit_card"
      case let .discovery(discoveryContext): return discoveryContext.trackingString
      case .facebook: return "facebook"
      case .initiate: return "initiate"
      case .location: return "location"
      case .off: return "off"
      case .on: return "on"
      case .percentRaised: return "percent_raised"
      case let .pledge(pledgeContext): return pledgeContext.trackingString
      case .projectState: return "project_state"
      case .pwl: return "pwl"
      case .recommended: return "recommended"
      case .results: return "results"
      case .searchTerm: return "search_term"
      case .social: return "social"
      case .subcategoryName: return "subcategory_name"
      case .subscriptionFalse: return "subscription_false"
      case .subscriptionTrue: return "subscription_true"
      case .tag: return "tag"
      case .unwatch: return "unwatch"
      case .watch: return "watch"
      case .watched: return "watched"
      case .address: return "address"
      case let .videoFeedShareDestination(videoFeedShareDestinationContext):
        return videoFeedShareDestinationContext.trackingString
      }
    }
  }
}

