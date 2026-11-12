import KsApi

/// Referral attribution metadata paired with an optional triggering deep-link URL.
/// - Negative Constraint: Use `RefInfo` only for analytics and attribution tracking, not routing decisions.
public struct RefInfo: Equatable, Hashable {
  /// Parsed referral tag identifying the UI surface or campaign source.
  public let refTag: RefTag?
  /// Raw deep-link URL string that originated this referral context, if any.
  public let deeplinkUrl: String?

  /// Initializes referral metadata from an optional `RefTag` and deep-link URL.
  public init(_ refTag: RefTag?, deeplinkUrl: String? = nil) {
    self.refTag = refTag
    self.deeplinkUrl = deeplinkUrl
  }
}

/// Strongly-typed referral source tags persisted across discovery, project pages, and checkout events.
public enum RefTag {
  case activity
  case activitySample
  case category
  case categoryFeatured
  case categoryWithSort(DiscoveryParams.Sort)
  case city
  case dashboardActivity
  case discovery
  case discoveryWithSort(DiscoveryParams.Sort)
  case emailBackerFailedTransaction
  case messageThread
  case onboarding
  case profile
  case profileBacked
  case profileSaved
  case projectPage
  case push
  case recommended
  case recommendedWithSort(DiscoveryParams.Sort)
  case recsWithSort(DiscoveryParams.Sort)
  case search
  case searchFeatured
  case searchPopular
  case searchPopularFeatured
  case similarProjects
  case social
  case socialWithSort(DiscoveryParams.Sort)
  case starredWithSort(DiscoveryParams.Sort)
  case thanks
  case unrecognized(String)
  case update
  case videoFeed
  case videoFeedShareCopyLink
  case videoFeedShareInstagramStories
  case videoFeedShareX
  case videoFeedShareFacebookFeed
  case videoFeedShareFacebookStories
  case videoFeedShareWhatsApp
  case videoFeedShareMessages
  case videoFeedShareEmail
  case videoFeedShareMore

  /// Creates a `RefTag` from a wire code string, falling back to `.unrecognized(code)` when unknown.
  /// - parameter code: Serialized ref tag string.
  /// - returns: Parsed `RefTag` case.
  public init(code: String) {
    switch code {
    case "activity": self = .activity
    case "category": self = .category
    case "category_featured": self = .categoryFeatured
    case "discovery_activity_sample": self = .activitySample
    case "category_ending_soon": self = .categoryWithSort(.endingSoon)
    case "category_home": self = .categoryWithSort(.magic)
    case "category_newest": self = .categoryWithSort(.newest)
    case "category_popular": self = .categoryWithSort(.popular)
    case "city": self = .city
    case "dashboard_activity": self = .dashboardActivity
    case "discovery": self = .discovery
    case "discovery_ending_soon": self = .discoveryWithSort(.endingSoon)
    case "discovery_home": self = .discoveryWithSort(.magic)
    case "discovery_newest": self = .discoveryWithSort(.newest)
    case "discovery_popular": self = .discoveryWithSort(.popular)
    case "ksr_email_backer_failed_transaction": self = .emailBackerFailedTransaction
    case "ios_experiment_onboarding_1": self = .onboarding
    case "message_thread": self = .messageThread
    case "profile": self = .profile
    case "profile_backed": self = .profileBacked
    case "profile_saved": self = .profileSaved
    case "project_page": self = .projectPage
    case "push": self = .push
    case "recommended": self = .recommended
    case "recommended_ending_soon": self = .recommendedWithSort(.endingSoon)
    case "recommended_home": self = .recommendedWithSort(.magic)
    case "recommended_newest": self = .recommendedWithSort(.newest)
    case "recommended_popular": self = .recommendedWithSort(.popular)
    case "recs_ending_soon": self = .recsWithSort(.endingSoon)
    case "recs_home": self = .recsWithSort(.magic)
    case "recs_newest": self = .recsWithSort(.newest)
    case "recs_popular": self = .recsWithSort(.popular)
    case "search": self = .search
    case "search_featured": self = .searchFeatured
    case "search_popular": self = .searchPopular
    case "search_popular_featured": self = .searchPopularFeatured
    case "similar_projects": self = .similarProjects
    case "social": self = .social
    case "social_ending_soon": self = .socialWithSort(.endingSoon)
    case "social_home": self = .socialWithSort(.magic)
    case "social_newest": self = .socialWithSort(.newest)
    case "social_popular": self = .socialWithSort(.popular)
    case "starred_ending_soon": self = .starredWithSort(.endingSoon)
    case "starred_home": self = .starredWithSort(.magic)
    case "starred_newest": self = .starredWithSort(.newest)
    case "starred_popular": self = .starredWithSort(.popular)
    case "thanks": self = .thanks
    case "update": self = .update
    case "video_feed": self = .videoFeed
    case "ios_project_share_copy_link": self = .videoFeedShareCopyLink
    case "ios_project_share_instagram_stories": self = .videoFeedShareInstagramStories
    case "ios_project_share_x": self = .videoFeedShareX
    case "ios_project_share_facebook_feed": self = .videoFeedShareFacebookFeed
    case "ios_project_share_facebook_stories": self = .videoFeedShareFacebookStories
    case "ios_project_share_whatsapp": self = .videoFeedShareWhatsApp
    case "ios_project_share_messages": self = .videoFeedShareMessages
    case "ios_project_share_email": self = .videoFeedShareEmail
    case "ios_project_share_more": self = .videoFeedShareMore
    default: self = .unrecognized(code)
    }
  }

  /// A string representation of the ref tag that can be used in analytics tracking, cookies, etc...
  public var stringTag: String {
    switch self {
    case .activity:
      return "activity"
    case .activitySample:
      return "discovery_activity_sample"
    case .category:
      return "category"
    case .categoryFeatured:
      return "category_featured"
    case let .categoryWithSort(sort):
      return "category" + sortRefTagSuffix(sort)
    case .city:
      return "city"
    case .dashboardActivity:
      return "dashboard_activity"
    case .discovery:
      return "discovery"
    case let .discoveryWithSort(sort):
      return "discovery" + sortRefTagSuffix(sort)
    case .emailBackerFailedTransaction:
      return "ksr_email_backer_failed_transaction"
    case .messageThread:
      return "message_thread"
    case .onboarding:
      return "ios_experiment_onboarding_1"
    case .profile:
      return "profile"
    case .profileBacked:
      return "profile_backed"
    case .profileSaved:
      return "profile_saved"
    case .projectPage:
      return "project_page"
    case .push:
      return "push"
    case .recommended:
      return "recommended"
    case let .recommendedWithSort(sort):
      return "recommended" + sortRefTagSuffix(sort)
    case let .recsWithSort(sort):
      return "recs" + sortRefTagSuffix(sort)
    case .search:
      return "search"
    case .searchFeatured:
      return "search_featured"
    case .searchPopular:
      return "search_popular"
    case .searchPopularFeatured:
      return "search_popular_featured"
    case .similarProjects:
      return "similar_projects"
    case .social:
      return "social"
    case let .socialWithSort(sort):
      return "social" + sortRefTagSuffix(sort)
    case let .starredWithSort(sort):
      return "starred" + sortRefTagSuffix(sort)
    case .thanks:
      return "thanks"
    case let .unrecognized(code):
      return code
    case .update:
      return "update"
    case .videoFeed:
      return "video_feed"
    case .videoFeedShareCopyLink:
      return "ios_project_share_copy_link"
    case .videoFeedShareInstagramStories:
      return "ios_project_share_instagram_stories"
    case .videoFeedShareX:
      return "ios_project_share_x"
    case .videoFeedShareFacebookFeed:
      return "ios_project_share_facebook_feed"
    case .videoFeedShareFacebookStories:
      return "ios_project_share_facebook_stories"
    case .videoFeedShareWhatsApp:
      return "ios_project_share_whatsapp"
    case .videoFeedShareMessages:
      return "ios_project_share_messages"
    case .videoFeedShareEmail:
      return "ios_project_share_email"
    case .videoFeedShareMore:
      return "ios_project_share_more"
    }
  }
}

extension RefTag: Equatable {}
extension RefTag: CustomStringConvertible {
  /// Serialized analytics string representation of the referral tag.
  public var description: String {
    return self.stringTag
  }
}

extension RefTag: Hashable {
  /// Hashes the canonical `stringTag` representation.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.stringTag)
  }
}

private func sortRefTagSuffix(_ sort: DiscoveryParams.Sort) -> String {
  switch sort {
  case .endingSoon:
    return "_ending_soon"
  case .magic:
    return "_home"
  case .newest:
    return "_newest"
  case .popular:
    return "_popular"
  case .most_backed:
    return "_most_backed"
  case .most_funded:
    return "_most_funded"
  }
}

extension RefTag {
  /// Infers the appropriate `RefTag` from a `DiscoveryParams` query filter and sort combination.
  public static func fromParams(_ params: DiscoveryParams) -> RefTag {
    if params.category != nil {
      return .categoryWithSort(params.sort ?? .magic)
    } else if params.recommended == .some(true) {
      return .recsWithSort(params.sort ?? .magic)
    } else if params.staffPicks == .some(true) {
      return .recommendedWithSort(params.sort ?? .magic)
    } else if params.social == .some(true) {
      return .socialWithSort(params.sort ?? .magic)
    } else if params.starred == .some(true) {
      return .starredWithSort(params.sort ?? .magic)
    }

    return RefTag.discoveryWithSort(params.sort ?? .magic)
  }
}
