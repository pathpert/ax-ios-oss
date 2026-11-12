import AppTrackingTransparency
import Foundation

extension KSRAnalytics {
  /// Determines the screen from which an analytics event is emitted.
  public enum PageContext: String {
    case activities = "activity_feed" // ActivitiesViewController
    case addOnsSelection = "add_ons" // RewardAddOnSelectionViewController
    case changePayment = "change_payment" // PledgeViewController
    case checkout // PledgeViewController
    case creatorDashboard = "creator_dashboard" // DashboardViewController
    case discovery = "discover" // DiscoveryViewController
    case forgotPassword = "forgot_password" // ResetPasswordViewController
    case login = "log_in" // LoginViewController
    case loginTout = "log_in_sign_up" // LoginToutViewController
    case managePledgeScreen = "manage_pledge" // ManagePledgeViewController
    case messages // MessagesViewController
    case onboarding // OnboardingView
    case pledgeAddNewCard = "pledge_add_new_card"
    case pledgeScreen = "pledge" // PledgeViewController
    case project // ProjectPageViewController
    case projectAlerts = "project_alerts" // PPOView
    case profile // BackerDashboardProjectsViewController
    case rewards // RewardsViewController
    case search // SearchViewController
    case settingsAddNewCard = "settings_add_new_card"
    case signup = "sign_up" // SignupViewController
    case thanks // ThanksViewController
    case twoFactorAuth = "two_factor_auth" // TwoFactorViewController
    case updatePledge = "update_pledge" // PledgeViewController
    case videoFeed = "video_feed" // VideoFeedViewController
  }

  /// Determines the authentication type for login or signup events.
  public enum AuthType {
    case email
    case facebook

    var trackingString: String {
      switch self {
      case .email: return "Email"
      case .facebook: return "Facebook"
      }
    }
  }

  /// Determines the origin screen from which an external link was presented.
  public enum ExternalLinkContext {
    case projectCreator
    case projectUpdate
    case projectUpdates

    var trackingString: String {
      switch self {
      case .projectCreator:
        return "project_creator"
      case .projectUpdate:
        return "project_update"
      case .projectUpdates:
        return "project_updates"
      }
    }
  }

  /// Determines the screen from which the message dialog was presented.
  public enum MessageDialogContext: String, Equatable {
    case backerModal = "backer_modal"
    case creatorActivity = "creator_activity"
    case messages
    case projectMessages = "project_messages"
    case projectPage = "project_page"
  }

  /// Determines the screen from which the comments dialog was presented.
  public enum CommentDialogContext {
    case projectActivity
    case projectComments
    case updateComments

    var trackingString: String {
      switch self {
      case .projectActivity: return "project_activity"
      case .projectComments: return "project_comments"
      case .updateComments: return "update_comments"
      }
    }
  }

  /// Determines which touch gesture triggered an interaction event.
  public enum GestureType: String {
    case swipe
    case tap

    fileprivate var trackingString: String {
      switch self {
      case .swipe: return "swipe"
      case .tap: return "tap"
      }
    }
  }

  /// Determines the screen from which a newsletter subscription toggle was presented.
  public enum NewsletterContext {
    case facebookSignup
    case settings
    case signup
    case thanks

    var trackingString: String {
      switch self {
      case .facebookSignup: return "facebook_signup"
      case .settings: return "settings"
      case .signup: return "signup"
      case .thanks: return "thanks"
      }
    }
  }
}

