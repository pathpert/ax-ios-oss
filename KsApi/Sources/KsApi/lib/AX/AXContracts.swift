import Foundation

// MARK: - Shared Agent Experience (AX) Contracts (Rules 3, 4 & 5)

/// Runtime schema field descriptor enforcing business meaning, format, and explicit negative constraints.
public struct AXFieldDescriptor: Codable, Equatable, Sendable {
  /// Property identifier described by this descriptor.
  public let fieldName: String
  /// Semantic business definition of the field.
  public let meaning: String
  /// Canonical wire or domain representation expected from callers.
  public let expectedFormat: String
  /// Explicit negative constraints forbidding invalid formats, bounds, or unsafe usages.
  public let negativeConstraints: [String]
  /// Whether this field or primitive has been deprecated in favor of `replacementPrimitive`.
  public let deprecated: Bool
  /// Preferred replacement API or field identifier when `deprecated == true`.
  public let replacementPrimitive: String?

  /// Constructs an `AXFieldDescriptor` entry for a schema's `fieldDescriptors` map.
  public static func describe(
    field fieldName: String,
    meaning: String,
    format expectedFormat: String,
    negativeConstraints: [String],
    deprecated: Bool = false,
    replacementPrimitive: String? = nil
  ) -> AXFieldDescriptor {
    AXFieldDescriptor(
      fieldName: fieldName,
      meaning: meaning,
      expectedFormat: expectedFormat,
      negativeConstraints: negativeConstraints,
      deprecated: deprecated,
      replacementPrimitive: replacementPrimitive
    )
  }
}

/// Describes a specific parameter constraint violation within an `AXProblemDetails` response.
public struct AXInvalidParam: Codable, Equatable, Sendable {
  /// Name of the request field that violated validation.
  public let name: String
  /// Human- and agent-readable explanation of the validation failure.
  public let reason: String

  /// Creates an invalid parameter entry.
  public init(name: String, reason: String) {
    self.name = name
    self.reason = reason
  }
}

/// RFC 9457 Problem Details standard shared across `KsApi`, `Library`, and feature modules.
public struct AXProblemDetails: Error, Codable, Equatable, Sendable {
  /// Stable problem-type URI identifying the error category.
  public let type: String
  /// Short, human-readable summary of the error condition.
  public let title: String
  /// HTTP status code associated with this error.
  public let status: Int
  /// Detailed explanation specific to this error occurrence.
  public let detail: String
  /// Imperative remediation step advising callers how to recover before retrying.
  public let suggestedAction: String
  /// Whether retrying the request (possibly with backoff or an idempotency key) may succeed.
  public let isRetriable: Bool
  /// Per-field validation failures when `status == 400`.
  public let invalidParams: [AXInvalidParam]
  /// Optional server rate-limit telemetry parsed from HTTP headers.
  public let rateLimitHeaders: AXRateLimitHeaders?

  enum CodingKeys: String, CodingKey {
    case type, title, status, detail
    case suggestedAction = "suggested_action"
    case isRetriable = "is_retriable"
    case invalidParams = "invalid_params"
    case rateLimitHeaders = "rate_limit_headers"
  }

  /// Creates an RFC 9457 problem details payload with explicit recovery guidance.
  public init(
    type: String,
    title: String,
    status: Int,
    detail: String,
    suggestedAction: String,
    isRetriable: Bool,
    invalidParams: [AXInvalidParam] = [],
    rateLimitHeaders: AXRateLimitHeaders? = nil
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

/// Machine-tempo backoff contract emitted on responses and 429 Problem Details.
public struct AXRateLimitHeaders: Codable, Equatable, Sendable {
  /// Maximum requests allowed in the current rate-limit window (`X-RateLimit-Limit`).
  public let limit: Int
  /// Remaining requests allowed in the current window (`X-RateLimit-Remaining`).
  public let remaining: Int
  /// Optional seconds callers must wait before retrying (`Retry-After`).
  public let retryAfterSeconds: Int?

  /// Serializes rate-limit metadata into canonical HTTP response header fields.
  public var httpHeaders: [String: String] {
    var headers = ["X-RateLimit-Limit": "\(self.limit)", "X-RateLimit-Remaining": "\(self.remaining)"]
    if let retryAfterSeconds = self.retryAfterSeconds {
      headers["Retry-After"] = "\(retryAfterSeconds)"
    }
    return headers
  }

  /// Creates a rate-limit header contract.
  public init(limit: Int, remaining: Int, retryAfterSeconds: Int? = nil) {
    self.limit = limit
    self.remaining = remaining
    self.retryAfterSeconds = retryAfterSeconds
  }

  /// Parses `X-RateLimit-Limit`, `X-RateLimit-Remaining`, and `Retry-After` from an `HTTPURLResponse`.
  public static func parse(from response: HTTPURLResponse) -> AXRateLimitHeaders? {
    let headers = response.allHeaderFields
    func intHeader(_ targetKey: String) -> Int? {
      for (key, value) in headers {
        if let k = key as? String, k.caseInsensitiveCompare(targetKey) == .orderedSame {
          if let str = value as? String, let parsed = Int(str) { return parsed }
          if let num = value as? NSNumber { return num.intValue }
        }
      }
      return nil
    }
    guard let limit = intHeader("X-RateLimit-Limit"),
          let remaining = intHeader("X-RateLimit-Remaining") else {
      return nil
    }
    return AXRateLimitHeaders(
      limit: limit,
      remaining: remaining,
      retryAfterSeconds: intHeader("Retry-After")
    )
  }
}

/// Validated UUID v4 idempotency contract required for mutating REST/GraphQL requests.
public struct IdempotencyKey: Codable, Equatable, Hashable, Sendable {
  /// Normalized lowercase UUID v4 string sent in the `Idempotency-Key` HTTP header.
  public let rawValue: String

  /// Schema descriptor detailing valid UUID format and replay constraints.
  public static let schema = AXFieldDescriptor.describe(
    field: "Idempotency-Key",
    meaning: "Unique client-generated key ensuring at-most-once execution for mutating API requests.",
    format: "UUID v4 string (case-insensitive, 36 characters, e.g. '550e8400-e29b-41d4-a716-446655440000')",
    negativeConstraints: [
      "Do not omit on POST, PUT, or DELETE requests.",
      "Do not reuse the same Idempotency-Key across different mutation payloads."
    ]
  )

  /// Generates a fresh lowercase UUID v4 `IdempotencyKey` for a new mutating request.
  public static func generate() -> IdempotencyKey {
    IdempotencyKey(rawValue: UUID().uuidString.lowercased())
  }

  private init(rawValue: String) {
    self.rawValue = rawValue
  }

  /// Validates a caller-supplied `Idempotency-Key` header string, returning an `AXProblemDetails` on failure.
  ///
  /// - Negative constraint: Do not pass empty strings or reuse keys across distinct mutation payloads.
  public static func validate(_ rawHeader: String?) -> Result<IdempotencyKey, AXProblemDetails> {
    guard let raw = rawHeader?.trimmingCharacters(in: .whitespacesAndNewlines), !raw.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/missing-idempotency-key",
        title: "Missing Idempotency-Key Header",
        status: 400,
        detail: "Mutating operations require a valid 'Idempotency-Key' header.",
        suggestedAction: "Generate a fresh UUID v4 string and pass it in the 'Idempotency-Key' header before retrying.",
        isRetriable: true,
        invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Header is missing or empty.")]
      ))
    }
    guard UUID(uuidString: raw) != nil else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-idempotency-key",
        title: "Invalid Idempotency-Key Format",
        status: 400,
        detail: "The provided Idempotency-Key '\(raw)' is not a valid UUID.",
        suggestedAction: "Replace 'Idempotency-Key' with a standard 36-character UUID string (e.g. UUID().uuidString).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Expected UUID format: \(Self.schema.expectedFormat)")]
      ))
    }
    return .success(IdempotencyKey(rawValue: raw.lowercased()))
  }
}

