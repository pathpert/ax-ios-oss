import Foundation

extension KSRAnalytics {
  /// Provides additional location context describing where an analytics event occurred.
  public enum LocationContext {
    case accountMenu
    case curated
    case creatorDetailsMenu
    case discoverAdvanced
    case discoverOverlay
    case globalNav
    case recommendations
    case searchResults
    case videoFeed

    var trackingString: String {
      switch self {
      case .accountMenu: return "account_menu"
      case .curated: return "curated"
      case .creatorDetailsMenu: return "creator_details_menu"
      case .discoverAdvanced: return "discover_advanced"
      case .discoverOverlay: return "discover_overlay"
      case .globalNav: return "global_nav"
      case .recommendations: return "recommendations"
      case .searchResults: return "search_results"
      case .videoFeed: return "video_feed"
      }
    }
  }

  /// Determines the surface from which a project update was presented.
  public enum UpdateContext {
    case activity
    case activitySample
    case creatorActivity
    case deepLink
    case draftPreview
    case updates

    fileprivate var trackingString: String {
      switch self {
      case .activity: return "activity"
      case .activitySample: return "activity_sample"
      case .creatorActivity: return "creator_activity"
      case .deepLink: return "deep_link"
      case .draftPreview: return "draft_preview"
      case .updates: return "updates"
      }
    }
  }

  /// Identifies a root tab bar destination for navigation analytics.
  public enum TabBarItemLabel: String {
    case discovery
    case activity
    case search
    case dashboard
    case profile

    var trackingString: String {
      return self.rawValue
    }
  }

  /// Immutable checkout telemetry payload attached to pledge funnel analytics events.
  public struct CheckoutPropertiesData: Equatable {
    let addOnsCountTotal: Int?
    let addOnsCountUnique: Int?
    let addOnsMinimumUsd: Double
    let bonusAmountInUsd: Decimal?
    let checkoutId: String?
    let estimatedDelivery: TimeInterval?
    let paymentType: String?
    let revenueInUsd: Decimal
    let rewardId: String
    let rewardMinimumUsd: Decimal
    let rewardTitle: String?
    let shippingEnabled: Bool
    let shippingAmountUsd: Double?
    let userHasStoredApplePayCard: Bool
  }

  /// Aggregate card-count telemetry payload for Pledged Projects Overview analytics events.
  public struct PledgedProjectOverviewProperties {
    let addressLocksSoonCount: Int
    let surveyAvailableCount: Int
    let pledgeManagementCount: Int
    let paymentFailedCount: Int
    let cardAuthRequiredCount: Int
    let fundedProjectCount: Int
    let liveProjectCount: Int
    let unsuccessfulPledgeCount: Int
    let page: Int?

    var alertCardCount: Int {
      return self.addressLocksSoonCount +
        self.surveyAvailableCount +
        self.pledgeManagementCount +
        self.paymentFailedCount +
        self.cardAuthRequiredCount
    }

    // Calculate the total number of cards that have been fetched.
    // This ensures the total count is consistent with other counts.
    var total: Int {
      return self.alertCardCount +
        self.fundedProjectCount +
        self.liveProjectCount +
        self.unsuccessfulPledgeCount
    }

    /// Creates a `PledgedProjectOverviewProperties` snapshot from card tier counts.
    public init(
      addressLocksSoonCount: Int,
      surveyAvailableCount: Int,
      pledgeManagementCount: Int,
      paymentFailedCount: Int,
      cardAuthRequiredCount: Int,
      fundedProjectCount: Int,
      liveProjectCount: Int,
      unsuccessfulPledgeCount: Int,
      page: Int?
    ) {
      self.addressLocksSoonCount = addressLocksSoonCount
      self.surveyAvailableCount = surveyAvailableCount
      self.pledgeManagementCount = pledgeManagementCount
      self.paymentFailedCount = paymentFailedCount
      self.cardAuthRequiredCount = cardAuthRequiredCount
      self.fundedProjectCount = fundedProjectCount
      self.liveProjectCount = liveProjectCount
      self.unsuccessfulPledgeCount = unsuccessfulPledgeCount
      self.page = page
    }
  }
}

