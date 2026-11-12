import Foundation
import Prelude

// MARK: - Rule 3: Poka-Yoke Schemas for Project Discovery & Pagination

/// Poka-Yoke request schema for bounded Kickstarter project discovery searches.
///
/// - Negative constraint: `page` is bounded to `1...500` and `perPage` to `1...50` to prevent context window bloat.
public struct DiscoveryQueryRequestSchema: Codable, Equatable, Sendable {
  /// Optional keyword search string (`1...120` non-whitespace characters when present).
  public let query: String?
  /// Optional project lifecycle filter (`all`, `live`, `successful`, `late_pledge`, `upcoming`).
  public let state: String?
  /// Optional sort order (`end_date`, `magic`, `newest`, `popularity`, `most_funded`, `most_backed`).
  public let sort: String?
  /// 1-indexed page number (`1...500`).
  public let page: Int
  /// Maximum projects per page (`1...50`).
  public let perPage: Int
  /// Optional filter restricting results to Staff Picks.
  public let staffPicks: Bool?

  /// Field-level descriptors and negative constraints for `DiscoveryQueryRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "query": .describe(
      field: "query",
      meaning: "Optional keyword search query for discovering projects.",
      format: "Trimmed UTF-8 search string between 1 and 120 characters or nil",
      negativeConstraints: [
        "Do not pass empty whitespace-only strings when query is non-nil.",
        "Do not pass SQL/GraphQL injection fragments or queries > 120 characters."
      ]
    ),
    "page": .describe(
      field: "page",
      meaning: "1-indexed page number for paginated discovery results.",
      format: "Positive integer between 1 and 500",
      negativeConstraints: ["Do not pass 0 or negative page numbers."]
    ),
    "perPage": .describe(
      field: "perPage",
      meaning: "Maximum number of projects returned per page (bounded to protect agent context window).",
      format: "Positive integer between 1 and 50",
      negativeConstraints: [
        "Do not pass values > 50 to prevent context window bloat.",
        "Do not pass 0 or negative integers."
      ]
    ),
    "state": .describe(
      field: "state",
      meaning: "Optional project lifecycle filter state.",
      format: "One of: all, live, successful, late_pledge, upcoming (or nil)",
      negativeConstraints: ["Do not pass arbitrary state strings outside the allowed enum."]
    ),
    "sort": .describe(
      field: "sort",
      meaning: "Optional sort order for discovery results.",
      format: "One of: end_date, magic, newest, popularity, most_funded, most_backed (or nil)",
      negativeConstraints: ["Do not pass arbitrary SQL ORDER BY expressions."]
    )
  ]

  /// Creates a `DiscoveryQueryRequestSchema` payload.
  public init(
    query: String? = nil,
    state: String? = nil,
    sort: String? = nil,
    page: Int = 1,
    perPage: Int = 15,
    staffPicks: Bool? = nil
  ) {
    self.query = query
    self.state = state
    self.sort = sort
    self.page = page
    self.perPage = perPage
    self.staffPicks = staffPicks
  }

  /// Validates pagination bounds, keyword length, and enum values, returning typed `DiscoveryParams`.
  public func validate() -> Result<DiscoveryParams, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if let rawQuery = self.query {
      let trimmed = rawQuery.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty || trimmed.count > 120 {
        violations.append(AXInvalidParam(
          name: "query",
          reason: "When present, query must be 1..120 non-whitespace characters."
        ))
      }
    }

    if self.page < 1 || self.page > 500 {
      violations.append(AXInvalidParam(name: "page", reason: "Must be between 1 and 500."))
    }

    if self.perPage < 1 || self.perPage > 50 {
      violations.append(AXInvalidParam(
        name: "perPage",
        reason: "Must be between 1 and 50 to prevent context window bloat."
      ))
    }

    var parsedState: DiscoveryParams.State?
    if let rawState = self.state {
      if let s = DiscoveryParams.State(rawValue: rawState) {
        parsedState = s
      } else {
        violations.append(AXInvalidParam(
          name: "state",
          reason: "Must be one of: all, live, successful, late_pledge, upcoming."
        ))
      }
    }

    var parsedSort: DiscoveryParams.Sort?
    if let rawSort = self.sort {
      if let s = DiscoveryParams.Sort(rawValue: rawSort) {
        parsedSort = s
      } else {
        violations.append(AXInvalidParam(
          name: "sort",
          reason: "Must be one of: end_date, magic, newest, popularity, most_funded, most_backed."
        ))
      }
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "DiscoveryQuery request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Ensure page is 1..500, perPage is 1..50, and state/sort use valid enum raw values.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    var params = DiscoveryParams.defaults
    params.query = self.query?.trimmingCharacters(in: .whitespacesAndNewlines)
    params.page = self.page
    params.perPage = self.perPage
    params.state = parsedState
    params.sort = parsedSort
    params.staffPicks = self.staffPicks
    return .success(params)
  }
}

/// Context-budget-friendly project summary returned inside `DiscoveryPageContract`.
public struct DiscoveryProjectSummaryContract: Codable, Equatable, Sendable {
  /// Unique numeric identifier of the discovered project.
  public let projectId: Int
  /// Project title.
  public let name: String
  /// Short project summary blurb.
  public let blurb: String
  /// Current campaign lifecycle state string.
  public let state: String
  /// Total pledged amount (rounded integer units).
  public let pledged: Int
  /// Funding target amount (integer units).
  public let goal: Int

  /// Creates a `DiscoveryProjectSummaryContract`.
  public init(projectId: Int, name: String, blurb: String, state: String, pledged: Int, goal: Int) {
    self.projectId = projectId
    self.name = name
    self.blurb = blurb
    self.state = state
    self.pledged = pledged
    self.goal = goal
  }
}

/// Paginated discovery contract emitted by `DiscoveryController`.
public struct DiscoveryPageContract: Codable, Equatable, Sendable {
  /// Bounded list of summarized discovery projects (`<= 50` items).
  public let projects: [DiscoveryProjectSummaryContract]
  /// Total matching projects reported by the backend.
  public let totalCount: Int
  /// Opaque URL for fetching the next discovery page.
  public let moreProjectsUrl: String

  /// Creates a `DiscoveryPageContract`.
  public init(projects: [DiscoveryProjectSummaryContract], totalCount: Int, moreProjectsUrl: String) {
    self.projects = projects
    self.totalCount = totalCount
    self.moreProjectsUrl = moreProjectsUrl
  }
}

