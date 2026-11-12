import Foundation

// MARK: - Rule 3 & Rule 4: Poka-Yoke & RFC 9457 Schemas for Experimentation & Feature Gates

/// Schema metadata descriptor for feature gate and experiment contract fields.
public struct AXExperimentFieldDescriptor: Codable, Equatable, Sendable {
  /// Property name documented by this descriptor.
  public let field: String
  /// Business meaning of the field.
  public let meaning: String
  /// Expected string/numeric format or enum domain.
  public let format: String
  /// Explicit negative constraints detailing forbidden inputs.
  public let negativeConstraints: [String]

  /// Constructs an `AXExperimentFieldDescriptor`.
  public static func describe(
    field: String,
    meaning: String,
    format: String,
    negativeConstraints: [String]
  ) -> AXExperimentFieldDescriptor {
    AXExperimentFieldDescriptor(
      field: field,
      meaning: meaning,
      format: format,
      negativeConstraints: negativeConstraints
    )
  }
}

/// Invalid parameter item included in RFC 9457 validation errors for experimentation.
public struct AXExperimentInvalidParam: Codable, Equatable, Sendable {
  /// Failing request parameter name.
  public let name: String
  /// Human- and agent-readable explanation of the violated constraint.
  public let reason: String

  /// Creates an invalid parameter diagnostic entry.
  public init(name: String, reason: String) {
    self.name = name
    self.reason = reason
  }
}

/// Rate-limit HTTP header values emitted for experiment/feature-gate requests.
public struct AXExperimentRateLimitHeaders: Codable, Equatable, Sendable {
  /// Maximum requests allowed in the current window.
  public let limit: Int
  /// Remaining requests in the current window.
  public let remaining: Int
  /// Seconds until retry is safe when throttled (`nil` if not throttled).
  public let retryAfterSeconds: Int?

  /// Creates machine-readable rate-limit header metadata.
  public init(limit: Int, remaining: Int, retryAfterSeconds: Int? = nil) {
    self.limit = limit
    self.remaining = remaining
    self.retryAfterSeconds = retryAfterSeconds
  }

  /// Dictionary of canonical `X-RateLimit-*` and `Retry-After` headers.
  public var httpHeaders: [String: String] {
    var headers = [
      "X-RateLimit-Limit": "\(self.limit)",
      "X-RateLimit-Remaining": "\(self.remaining)"
    ]
    if let retry = self.retryAfterSeconds {
      headers["Retry-After"] = "\(retry)"
    }
    return headers
  }
}

/// RFC 9457 Problem Details error payload returned by experimentation controllers.
///
/// - Negative constraint: Do not discard `suggestedAction` or treat errors as silent `false` gate values.
public struct AXExperimentProblemDetails: Error, Codable, Equatable, Sendable {
  /// URI reference identifying the problem type.
  public let type: String
  /// Short, human-readable summary of the problem type.
  public let title: String
  /// HTTP status code associated with this error.
  public let status: Int
  /// Detailed explanation of why the request failed.
  public let detail: String
  /// Actionable remediation guidance for callers and agents.
  public let suggestedAction: String
  /// Indicates whether retrying the exact request later may succeed.
  public let isRetriable: Bool
  /// List of parameter-level validation failures.
  public let invalidParams: [AXExperimentInvalidParam]
  /// Optional rate-limit backoff headers when throttled.
  public let rateLimitHeaders: AXExperimentRateLimitHeaders?

  enum CodingKeys: String, CodingKey {
    case type, title, status, detail
    case suggestedAction = "suggested_action"
    case isRetriable = "is_retriable"
    case invalidParams = "invalid_params"
    case rateLimitHeaders = "rate_limit_headers"
  }

  /// Creates an RFC 9457 Problem Details error value.
  public init(
    type: String,
    title: String,
    status: Int,
    detail: String,
    suggestedAction: String,
    isRetriable: Bool,
    invalidParams: [AXExperimentInvalidParam] = [],
    rateLimitHeaders: AXExperimentRateLimitHeaders? = nil
  ) {
    self.type = type
    self.title = title
    self.status = status
    self.detail = detail
    self.suggestedAction = suggestedAction
    self.isRetriable = isRetriable
    self.invalidParams = invalidParams
    self.rateLimitHeaders = rateLimitHeaders
  }
}

/// Validated request schema for evaluating a registered Statsig feature gate.
public struct EvaluateFeatureGateRequestSchema: Codable, Equatable, Sendable {
  /// Canonical `StatsigFeature` raw key string.
  public let gateKey: String

  /// Field-level metadata and negative constraints for `EvaluateFeatureGateRequestSchema`.
  public static let fieldDescriptors: [String: AXExperimentFieldDescriptor] = [
    "gateKey": .describe(
      field: "gateKey",
      meaning: "Canonical StatsigFeature raw identifier to evaluate.",
      format: "Enum string: project_story_rich_text | video_feed",
      negativeConstraints: [
        "Do not pass arbitrary unvalidated feature flag strings.",
        "Do not treat uninitialized nil gate states as false silently."
      ]
    )
  ]

  /// Creates an unvalidated feature-gate evaluation request.
  public init(gateKey: String) {
    self.gateKey = gateKey
  }

  /// Validates the raw `gateKey` against `StatsigFeature` cases, returning an RFC 9457 error on mismatch.
  public func validate() -> Result<StatsigFeature, AXExperimentProblemDetails> {
    let trimmed = self.gateKey.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let feature = StatsigFeature(rawValue: trimmed) else {
      let allowed = StatsigFeature.allCases.map(\.rawValue).joined(separator: ", ")
      return .failure(AXExperimentProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Feature gate key '\(self.gateKey)' is not a registered StatsigFeature.",
        suggestedAction: "Pass one of the registered StatsigFeature raw values: \(allowed).",
        isRetriable: false,
        invalidParams: [AXExperimentInvalidParam(name: "gateKey", reason: "Must be one of: \(allowed).")]
      ))
    }
    return .success(feature)
  }
}

/// Validated request schema for reloading the Statsig experiment user identity.
public struct ReloadExperimentUserRequestSchema: Codable, Equatable, Sendable {
  /// Authenticated Kickstarter numeric user ID (`nil` when logged out).
  public let ksrUserId: Int?
  /// Segment anonymous device identifier (`nil` only when `ksrUserId` is supplied).
  public let segmentAnonymousId: String?

  /// Field-level metadata and negative constraints for `ReloadExperimentUserRequestSchema`.
  public static let fieldDescriptors: [String: AXExperimentFieldDescriptor] = [
    "ksrUserId": .describe(
      field: "ksrUserId",
      meaning: "Authenticated Kickstarter user ID for experiment bucketing.",
      format: "Positive integer > 0 or nil",
      negativeConstraints: [
        "Do not pass 0 or negative user IDs.",
        "Do not omit both ksrUserId and segmentAnonymousId simultaneously."
      ]
    ),
    "segmentAnonymousId": .describe(
      field: "segmentAnonymousId",
      meaning: "Non-empty Segment anonymous device identifier for logged-out bucketing.",
      format: "Non-empty UUID/token string (4-128 chars)",
      negativeConstraints: [
        "Do not pass empty or whitespace-only anonymous IDs."
      ]
    )
  ]

  /// Creates an experiment user reload request.
  public init(ksrUserId: Int?, segmentAnonymousId: String?) {
    self.ksrUserId = ksrUserId
    self.segmentAnonymousId = segmentAnonymousId
  }

  /// Validates user/anonymous IDs and constructs a canonical `StatsigClientUser` contract.
  public func validate() -> Result<StatsigClientUser, AXExperimentProblemDetails> {
    var violations: [AXExperimentInvalidParam] = []

    if let userId = self.ksrUserId, userId <= 0 {
      violations.append(AXExperimentInvalidParam(name: "ksrUserId", reason: "Must be > 0 when provided."))
    }

    let trimmedAnon = self.segmentAnonymousId?.trimmingCharacters(in: .whitespacesAndNewlines)
    if let anon = trimmedAnon, anon.count < 4 || anon.count > 128 {
      violations.append(AXExperimentInvalidParam(
        name: "segmentAnonymousId",
        reason: "Must be between 4 and 128 characters when provided."
      ))
    }

    if self.ksrUserId == nil && (trimmedAnon == nil || trimmedAnon?.isEmpty == true) {
      violations.append(AXExperimentInvalidParam(
        name: "ksrUserId",
        reason: "At least one of ksrUserId or segmentAnonymousId must be provided for deterministic bucketing."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXExperimentProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Experiment user reload request failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide a positive ksrUserId (> 0) or a non-empty segmentAnonymousId (4-128 chars).",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(StatsigClientUser(ksrUserId: self.ksrUserId, segmentAnonymousId: trimmedAnon))
  }
}

/// Output contract describing an evaluated Statsig feature gate result.
public struct FeatureGateEvaluationContract: Codable, Equatable, Sendable {
  /// Evaluated canonical feature gate key.
  public let gateKey: String
  /// Human-readable gate description.
  public let description: String
  /// Effective boolean gate evaluation result.
  public let isEnabled: Bool
}

/// Output contract returned after reloading or replaying an experiment user context.
public struct ExperimentUserReloadContract: Codable, Equatable, Sendable {
  /// Reloaded Kickstarter user ID (`nil` if anonymous).
  public let ksrUserId: Int?
  /// Reloaded Segment anonymous identifier (`nil` if omitted).
  public let segmentAnonymousId: String?
  /// Indicates whether the reload operation completed.
  public let reloaded: Bool
  /// Indicates whether the response was replayed from an idempotency cache entry.
  public let idempotencyReplayed: Bool
}

