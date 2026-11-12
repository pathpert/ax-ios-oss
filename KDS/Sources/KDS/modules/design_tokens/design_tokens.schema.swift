import Foundation

// MARK: - Rule 3 & Rule 4: Poka-Yoke & RFC 9457 Schemas for KDS Design Tokens

/// Field metadata descriptor for KDS design-token request contracts.
public struct AXDesignTokenFieldDescriptor: Codable, Equatable, Sendable {
  /// Request field name.
  public let field: String
  /// Business meaning of the design token field.
  public let meaning: String
  /// Accepted value format or discrete domain.
  public let format: String
  /// Explicit negative constraints listing disallowed inputs.
  public let negativeConstraints: [String]

  /// Creates an `AXDesignTokenFieldDescriptor`.
  public static func describe(
    field: String,
    meaning: String,
    format: String,
    negativeConstraints: [String]
  ) -> AXDesignTokenFieldDescriptor {
    AXDesignTokenFieldDescriptor(
      field: field,
      meaning: meaning,
      format: format,
      negativeConstraints: negativeConstraints
    )
  }
}

/// Invalid parameter item returned inside KDS RFC 9457 error responses.
public struct AXDesignTokenInvalidParam: Codable, Equatable, Sendable {
  /// Parameter name that failed validation.
  public let name: String
  /// Constraint violation message.
  public let reason: String

  /// Creates an invalid parameter entry.
  public init(name: String, reason: String) {
    self.name = name
    self.reason = reason
  }
}

/// Rate-limit HTTP headers for design-token resolution endpoints.
public struct AXDesignTokenRateLimitHeaders: Codable, Equatable, Sendable {
  /// Request quota ceiling per window.
  public let limit: Int
  /// Remaining requests in the current window.
  public let remaining: Int
  /// Optional retry delay in seconds when rate-limited.
  public let retryAfterSeconds: Int?

  /// Creates rate-limit header metadata.
  public init(limit: Int, remaining: Int, retryAfterSeconds: Int? = nil) {
    self.limit = limit
    self.remaining = remaining
    self.retryAfterSeconds = retryAfterSeconds
  }

  /// HTTP header map containing `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and optional `Retry-After`.
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

/// RFC 9457 Problem Details error payload for KDS design-token validation failures.
///
/// - Negative constraint: Do not fall back to raw hex/pixel guesses; use `suggestedAction` to select a valid token.
public struct AXDesignTokenProblemDetails: Error, Codable, Equatable, Sendable {
  /// URI reference identifying the problem category.
  public let type: String
  /// Short summary title of the error.
  public let title: String
  /// HTTP status code (e.g. `400`).
  public let status: Int
  /// Specific validation error description.
  public let detail: String
  /// Actionable instruction guiding callers to a valid token.
  public let suggestedAction: String
  /// Whether retrying unchanged input could succeed.
  public let isRetriable: Bool
  /// Per-parameter constraint violation details.
  public let invalidParams: [AXDesignTokenInvalidParam]
  /// Optional rate-limit backoff headers.
  public let rateLimitHeaders: AXDesignTokenRateLimitHeaders?

  enum CodingKeys: String, CodingKey {
    case type, title, status, detail
    case suggestedAction = "suggested_action"
    case isRetriable = "is_retriable"
    case invalidParams = "invalid_params"
    case rateLimitHeaders = "rate_limit_headers"
  }

  /// Creates an `AXDesignTokenProblemDetails` error instance.
  public init(
    type: String,
    title: String,
    status: Int,
    detail: String,
    suggestedAction: String,
    isRetriable: Bool,
    invalidParams: [AXDesignTokenInvalidParam] = [],
    rateLimitHeaders: AXDesignTokenRateLimitHeaders? = nil
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

/// Validated request schema for resolving a KDS 4pt-grid spacing token.
public struct ResolveSpacingTokenRequestSchema: Codable, Equatable, Sendable {
  /// Discrete KDS spacing index.
  public let unitIndex: Int

  /// Supported discrete KDS spacing unit indices mapped to point values.
  public static let supportedUnits: [Int: Double] = [
    1: Double(Spacing.unit_01),
    2: Double(Spacing.unit_02),
    3: Double(Spacing.unit_03),
    4: Double(Spacing.unit_04),
    5: Double(Spacing.unit_05),
    6: Double(Spacing.unit_06),
    7: Double(Spacing.unit_07),
    8: Double(Spacing.unit_08),
    9: Double(Spacing.unit_09),
    10: Double(Spacing.unit_10),
    11: Double(Spacing.unit_11),
    12: Double(Spacing.unit_12),
    14: Double(Spacing.unit_14),
    16: Double(Spacing.unit_16),
    20: Double(Spacing.unit_20)
  ]

  /// Field-level descriptors and negative constraints for spacing resolution.
  public static let fieldDescriptors: [String: AXDesignTokenFieldDescriptor] = [
    "unitIndex": .describe(
      field: "unitIndex",
      meaning: "Kickstarter Design System (KDS) spacing scale index (4pt base grid).",
      format: "Discrete integer in {1..12, 14, 16, 20}",
      negativeConstraints: [
        "Do not pass arbitrary pixel/point floats outside the KDS 4pt grid.",
        "Do not pass unsupported indices such as 0, 13, 15, 17, 18, 19, or negative integers."
      ]
    )
  ]

  /// Creates a spacing token request.
  public init(unitIndex: Int) {
    self.unitIndex = unitIndex
  }

  /// Validates `unitIndex` against `supportedUnits`, returning `(unitIndex, points)` or an RFC 9457 error.
  public func validate() -> Result<(Int, Double), AXDesignTokenProblemDetails> {
    guard let points = Self.supportedUnits[self.unitIndex] else {
      let validList = Self.supportedUnits.keys.sorted().map(String.init).joined(separator: ", ")
      return .failure(AXDesignTokenProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-design-token",
        title: "Invalid Design Token",
        status: 400,
        detail: "Spacing unitIndex '\(self.unitIndex)' is not a valid KDS Spacing token.",
        suggestedAction: "Use one of the KDS discrete spacing indices: \(validList).",
        isRetriable: false,
        invalidParams: [AXDesignTokenInvalidParam(name: "unitIndex", reason: "Must be one of: \(validList).")]
      ))
    }
    return .success((self.unitIndex, points))
  }
}

/// Validated request schema for resolving a semantic color token path and integer opacity.
public struct ResolveSemanticColorRequestSchema: Codable, Equatable, Sendable {
  /// Slash-delimited KDS semantic color path (e.g., `"text/primary"`).
  public let tokenName: String
  /// Integer opacity percentage (`1...100`).
  public let opacityPercent: Int

  /// Field-level descriptors and negative constraints for semantic color resolution.
  public static let fieldDescriptors: [String: AXDesignTokenFieldDescriptor] = [
    "tokenName": .describe(
      field: "tokenName",
      meaning: "Canonical KDS semantic color path (e.g. text/primary, text/secondary, scrim).",
      format: "Lowercase slash-delimited semantic token string",
      negativeConstraints: [
        "Do not pass hardcoded hex strings (#RRGGBB) or raw RGB tuples.",
        "Do not use LegacyColor tokens for new UI components."
      ]
    ),
    "opacityPercent": .describe(
      field: "opacityPercent",
      meaning: "Integer opacity percentage from 1 to 100.",
      format: "Integer in 1...100",
      negativeConstraints: [
        "Do not pass floating-point alpha values; pass integer percentage 1...100.",
        "Do not pass 0 (fully invisible) or values > 100."
      ]
    )
  ]

  /// Creates a semantic color resolution request.
  public init(tokenName: String, opacityPercent: Int = 100) {
    self.tokenName = tokenName
    self.opacityPercent = opacityPercent
  }
}

/// Output contract describing a resolved KDS spacing token.
public struct SpacingTokenContract: Codable, Equatable, Sendable {
  /// Canonical KDS spacing identifier string.
  public let tokenIdentifier: String
  /// Validated discrete spacing index.
  public let unitIndex: Int
  /// Resolved spacing magnitude in iOS points.
  public let points: Double
}

/// Output contract describing a resolved semantic color token and opacity.
public struct SemanticColorTokenContract: Codable, Equatable, Sendable {
  /// Validated semantic color path.
  public let tokenName: String
  /// Validated integer opacity percentage (`1...100`).
  public let opacityPercent: Int
}

