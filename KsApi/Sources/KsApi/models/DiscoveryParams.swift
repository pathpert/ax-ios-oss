
import Prelude

/// @deprecated Legacy 22-field discovery parameter struct with unbounded pagination.
/// Prefer `DiscoveryQueryRequestSchema` and `DiscoveryController` in `KsApi/modules/discovery`.
/// - Negative Constraint: Do not add new discovery filter fields here; use `DiscoveryQueryRequestSchema`.
public struct DiscoveryParams {
  /// Filter by projects backed (`true`) or not backed (`false`) by the current user.
  public var backed: Bool?
  /// Restrict results to a specific root category or subcategory.
  public var category: Category?
  /// `true` to filter projects where the current user is a collaborator.
  public var collaborated: Bool?
  /// `true` to filter projects created by the current user.
  public var created: Bool?
  /// `true` to require projects to have a campaign video.
  public var hasVideo: Bool?
  /// `true` to include the Project of the Day highlight.
  public var includePOTD: Bool?
  /// 1-based pagination page index (`nil` omits pagination).
  public var page: Int?
  /// Maximum number of projects returned per page (`nil` uses server default).
  public var perPage: Int?
  /// Free-text search term mapped to query parameter `"term"`.
  public var query: String?
  /// `true` to filter personalized recommended projects.
  public var recommended: Bool?
  /// Server-supplied random seed preserving consistent shuffle order across pages.
  public var seed: Int?
  /// Filter projects similar to the referenced `Project`.
  public var similarTo: Project?
  /// `true` to prioritize projects backed by friends.
  public var social: Bool?
  /// Result ordering strategy (e.g., `.magic`, `.popular`, `.newest`).
  public var sort: Sort?
  /// `true` to restrict results to "Projects We Love" staff picks.
  public var staffPicks: Bool?
  /// Filter by projects saved/watched (`true`) or not saved (`false`) by the viewer.
  public var starred: Bool?
  /// Lifecycle state filter (e.g., `.live`, `.successful`, `.upcoming`).
  public var state: State?
  /// Funding percentage bucket filter (GraphQL search only).
  public var percentRaised: PercentRaisedBucket?
  /// Geographic city/country filter (GraphQL search only).
  public var location: Location?
  /// Total amount raised bucket filter in USD (GraphQL search only).
  public var amountRaised: AmountRaisedBucket?
  /// Funding goal bucket filter in USD (GraphQL search only).
  public var goal: GoalBucket?

  /// Lifecycle state filter values supported across Discovery and GraphQL Search.
  public enum State: String, Decodable {
    /// Include projects across all lifecycle states.
    case all
    /// Actively funding live campaigns.
    case live
    /// Successfully funded campaigns.
    case successful
    /// Campaigns accepting post-campaign late pledges (GraphQL search only).
    case late_pledge
    /// Prelaunch upcoming campaigns (GraphQL search only).
    case upcoming
  }

  /// Result sorting modes for project discovery and search queries.
  public enum Sort: String, Decodable {
    /// Projects nearest to campaign deadline.
    case endingSoon = "end_date"
    /// Personalized Kickstarter "Magic" relevance sort.
    case magic
    /// Most recently launched projects.
    case newest
    /// Currently trending/popular projects.
    case popular = "popularity"
    /// Highest total funds raised (GraphQL search only).
    case most_funded
    /// Highest backer count (GraphQL search only).
    case most_backed

    /// Event-tracking analytics identifier corresponding to this sort mode.
    public var trackingString: String {
      switch self {
      case .endingSoon: return "ending_soon"
      case .magic: return "magic"
      case .newest: return "newest"
      case .popular: return "popular"
      case .most_funded: return "most_funded"
      case .most_backed: return "most_backed"
      }
    }
  }

  /// Funded percentage filter buckets (GraphQL search only).
  public enum PercentRaisedBucket: Int, CaseIterable {
    /// 0 to 75%
    case bucket_0
    /// 75% - 100%
    case bucket_1
    /// 100% or more
    case bucket_2
  }

  /// Total amount pledged filter buckets in USD (GraphQL search only).
  public enum AmountRaisedBucket: Int, CaseIterable {
    /// Range from 0 to 1,000 USD
    case bucket_0

    /// Range from 1,000 to 10,000 USD
    case bucket_1

    /// Range from 10,000 to 100,000 USD
    case bucket_2

    /// Range from 100,000 to 1,000,000 USD
    case bucket_3

    /// Range from 1,000,000 to Infinity USD
    case bucket_4
  }

  /// Campaign funding goal filter buckets in USD (GraphQL search only).
  public enum GoalBucket: Int, CaseIterable {
    /// Range from 0 to 1,000 USD
    case bucket_0

    /// Range from 1,000 to 10,000 USD
    case bucket_1

    /// Range from 10,000 to 100,000 USD
    case bucket_2

    /// Range from 100,000 to 1,000,000 USD
    case bucket_3

    /// Range from 1,000,000 to Infinity USD
    case bucket_4
  }

  /// Empty baseline discovery filter set with all optional criteria unset.
  public static let defaults = DiscoveryParams(
    backed: nil, category: nil, collaborated: nil,
    created: nil, hasVideo: nil, includePOTD: nil,
    page: nil, perPage: nil, query: nil, recommended: nil,
    seed: nil, similarTo: nil, social: nil, sort: nil,
    staffPicks: nil, starred: nil, state: nil
  )

  /// Default parameters for personalized unbacked recommendations with Project of the Day.
  public static let recommendedDefaults = DiscoveryParams.defaults
    |> DiscoveryParams.lens.includePOTD .~ true
    |> DiscoveryParams.lens.backed .~ false
    |> DiscoveryParams.lens.recommended .~ true

  /// Flattens configured filters into v1 REST query-string dictionary entries.
  public var queryParams: [String: String] {
    var params: [String: String] = [:]
    params["backed"] = self.backed == true ? "1" : self.backed == false ? "-1" : nil
    params["category_id"] = self.category?.intID?.description
    params["collaborated"] = self.collaborated?.description
    params["created"] = self.created?.description
    params["has_video"] = self.hasVideo?.description
    params["page"] = self.page?.description
    params["per_page"] = self.perPage?.description
    params["recommended"] = self.recommended?.description
    params["seed"] = self.seed?.description
    params["similar_to"] = self.similarTo?.id.description
    params["social"] = self.social == true ? "1" : self.social == false ? "-1" : nil
    params["sort"] = self.sort?.rawValue
    params["staff_picks"] = self.staffPicks?.description
    params["starred"] = self.starred == true ? "1" : self.starred == false ? "-1" : nil
    params["state"] = self.state?.rawValue
    params["term"] = self.query

    return params
  }
}

extension DiscoveryParams: Equatable {}
/// Compares two `DiscoveryParams` values by their canonical `queryParams` map.
public func == (a: DiscoveryParams, b: DiscoveryParams) -> Bool {
  return a.queryParams == b.queryParams
}

extension DiscoveryParams: Hashable {
  /// Hashes the canonical description of discovery query parameters.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.description)
  }
}

extension DiscoveryParams: CustomStringConvertible, CustomDebugStringConvertible {
  /// String representation of encoded query parameters.
  public var description: String {
    return self.queryParams.description
  }

  /// Debug string representation of encoded query parameters.
  public var debugDescription: String {
    return self.queryParams.debugDescription
  }
}
