import Foundation

extension KSRAnalytics {
  /// Indicates which button or interactive control the user clicked or tapped for `CTA Clicked` events.
  public enum CTAContext {
    case addOnsContinue
    case authenticateCardInitiate
    case blockUser
    case confirmInitiate
    case confirmSubmit
    case creatorDashboard
    case creatorDetails
    case discover
    case discoverFilter
    case discoverSort
    case edit
    case finalizePledgeInitiate
    case fixPledgeInitiate
    case forgotPassword
    case logInInitiate
    case logInOrSignUp
    case logInSubmit
    case messageCreatorInitiate
    case nativeManagePledge
    case pledgeConfirm
    case pledgeInitiate
    case pledgeSubmit
    case project
    case projectSelect
    case projectUpdateCreateDraft
    case rewardContinue
    case search
    case signUpInitiate
    case signUpSubmit
    case surveyResponseInitiate
    case toggleRewardReceived
    case videoFeedPlay
    case videoFeedPause
    case videoFeedSave
    case videoFeedShare
    case videoFeedShareDestinationClicked
    case videoFeedProgressBar
    case watchProject
    /// Closes the onboarding modal flow.
    case onboardingClose
    /// Advances to the next onboarding step.
    case onboardingNext
    /// Opts into notifications during onboarding.
    case onboardingGetNotified
    /// Prompts for App Tracking Transparency during onboarding.
    case onboardingAllowTracking
    /// Opens login or signup from onboarding.
    case onboardingSignUpLogIn
    /// User allowed the iOS system permissions prompt during onboarding.
    case onboardingSystemPermissionsAllowed
    /// User denied the iOS system permissions prompt during onboarding.
    case onboardingSystemPermissionsDenied

    var trackingString: String {
      switch self {
      case .authenticateCardInitiate: return "authenticate_card_initiate"
      case .addOnsContinue: return "add_ons_continue"
      case .blockUser: return "block_user"
      case .confirmInitiate: return "confirm_initiate"
      case .confirmSubmit: return "confirm_submit"
      case .creatorDashboard: return "creator_dashboard"
      case .creatorDetails: return "creator_details"
      case .discover: return "discover"
      case .discoverFilter: return "discover_filter"
      case .discoverSort: return "discover_sort"
      case .edit: return "edit"
      case .finalizePledgeInitiate: return "finalize_pledge_initiate"
      case .fixPledgeInitiate: return "fix_pledge_initiate"
      case .forgotPassword: return "forgot_password"
      case .messageCreatorInitiate: return "message_creator_initiate"
      case .nativeManagePledge: return "native_manage_pledge"
      case .onboardingClose: return "close"
      case .onboardingNext: return "next"
      case .onboardingGetNotified: return "get_notified"
      case .onboardingAllowTracking: return "allow_tracking"
      case .onboardingSignUpLogIn: return "signup_login"
      case .onboardingSystemPermissionsAllowed: return "allow"
      case .onboardingSystemPermissionsDenied: return "deny"
      case .pledgeInitiate: return "pledge_initiate"
      case .pledgeConfirm: return "pledge_confirm"
      case .pledgeSubmit: return "pledge_submit"
      case .project: return "project"
      case .projectSelect: return "creator_project_select"
      case .projectUpdateCreateDraft: return "creator_project_update_create_draft"
      case .logInInitiate: return "log_in_initiate"
      case .logInOrSignUp: return "log_in_or_sign_up"
      case .logInSubmit: return "log_in_submit"
      case .rewardContinue: return "reward_continue"
      case .search: return "search"
      case .signUpInitiate: return "sign_up_initiate"
      case .signUpSubmit: return "sign_up_submit"
      case .surveyResponseInitiate: return "survey_response_initiate"
      case .toggleRewardReceived: return "toggle_reward_received"
      case .videoFeedPlay: return "video_feed_play"
      case .videoFeedPause: return "video_feed_pause"
      case .videoFeedSave: return "video_feed_save"
      case .videoFeedShare: return "video_feed_share"
      case .videoFeedShareDestinationClicked: return "share_platform_clicked"
      case .videoFeedProgressBar: return "video_feed_progress_bar"
      case .watchProject: return "watch_project"
      }
    }
  }

  /// Identifies an action selected from the Manage Pledge overflow menu.
  public enum ManagePledgeMenuCTAType {
    case editPledgeOverTimePledge
    case cancelPledge
    case changePaymentMethod
    case chooseAnotherReward
    case contactCreator
    case viewRewards

    var trackingString: String {
      switch self {
      case .editPledgeOverTimePledge: return "edit_pledge_over_time_pledge"
      case .cancelPledge: return "cancel_pledge"
      case .changePaymentMethod: return "change_payment_method"
      case .chooseAnotherReward: return "choose_another_reward"
      case .contactCreator: return "contact_creator"
      case .viewRewards: return "view_rewards"
      }
    }
  }

  /// Identifies the origin stage within the checkout flow.
  public enum CheckoutPageContext {
    case paymentsPage
    case projectPage
    case rewardSelection

    fileprivate var trackingString: String {
      switch self {
      case .paymentsPage: return "Payments Page"
      case .projectPage: return "Project Page"
      case .rewardSelection: return "Reward Selection"
      }
    }
  }
}

