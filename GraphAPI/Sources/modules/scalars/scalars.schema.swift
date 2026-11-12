import Foundation

// MARK: - Rule 3 & Rule 4: Poka-Yoke & RFC 9457 Schemas for GraphAPI Custom Scalars

/// Machine-readable field metadata describing format and negative constraints for a GraphQL custom scalar.
public struct AXGraphScalarFieldDescriptor: Codable, Equatable, Sendable {
  /// Scalar field name (for example `"iso8601DateTime"`).
  public let field: String
  /// Semantic description of what the field represents.
  public let meaning: String
  /// Required string wire format.
  public let format: String
  /// Explicit misuse prohibitions ("Do not ...").
  public let negativeConstraints: [String]

  /// Constructs an `AXGraphScalarFieldDescriptor` entry for schema introspection.
  public static func describe(
    field: String,
    meaning: String,
    format: String,
    negativeConstraints: [String]
  ) -> AXGraphScalarFieldDescriptor {
    AXGraphScalarFieldDescriptor(
      field: field,
      meaning: meaning,
      format: format,
      negativeConstraints: negativeConstraints
    )
  }
}

/// Field-level validation violation reported inside `AXGraphScalarProblemDetails`.
public struct AXGraphScalarInvalidParam: Codable, Equatable, Sendable {
  /// Name of the failing scalar field.
  public let name: String
  /// Actionable validation failure reason.
  public let reason: String

  /// Creates an invalid parameter entry.
  public init(name: String, reason: String) {
    self.name = name
    self.reason = reason
  }
}

/// RFC 9457 Problem Details error returned when GraphQL scalar validation or rate limiting fails.
public struct AXGraphScalarProblemDetails: Error, Codable, Equatable, Sendable {
  /// URI reference identifying the problem type.
  public let type: String
  /// Short human-readable summary of the problem.
  public let title: String
  /// HTTP status code (for example `400` or `429`).
  public let status: Int
  /// Detailed explanation of the failure.
  public let detail: String
  /// Concrete recovery instruction for agents/callers.
  public let suggestedAction: String
  /// Whether retrying the operation later may succeed.
  public let isRetriable: Bool
  /// Per-field validation failures causing this error.
  public let invalidParams: [AXGraphScalarInvalidParam]

  enum CodingKeys: String, CodingKey {
    case type, title, status, detail
    case suggestedAction = "suggested_action"
    case isRetriable = "is_retriable"
    case invalidParams = "invalid_params"
  }
}

/// Poka-Yoke request schema validating GraphAPI custom scalars (`ISO8601DateTime`, `Email`, `JSON`).
/// Negative Constraint: Do not forward unvalidated scalar strings directly to GraphQL mutations.
public struct ValidateGraphScalarsRequestSchema: Codable, Equatable, Sendable {
  /// ISO 8601 timestamp string with explicit timezone designator.
  public let iso8601DateTime: ISO8601DateTime
  /// RFC 5322 email address string.
  public let email: Email
  /// Serialized JSON object string (`{...}`).
  public let jsonObjectString: JSON

  private static let isoRegex =
    #"^\d{4}-\d{2}-\d{2}T\d{2}:\d{2}:\d{2}(?:\.\d+)?(?:Z|[+-]\d{2}:\d{2})$"#
  private static let emailRegex =
    #"^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$"#

  /// Field-level semantic descriptions and negative constraints indexed by property name.
  public static let fieldDescriptors: [String: AXGraphScalarFieldDescriptor] = [
    "iso8601DateTime": .describe(
      field: "iso8601DateTime",
      meaning: "GraphQL ISO8601DateTime custom scalar with timezone offset.",
      format: "ISO 8601 timestamp (YYYY-MM-DDTHH:mm:ssZ)",
      negativeConstraints: [
        "Do not pass unformatted human date strings or Unix epoch numbers.",
        "Do not omit the timezone designator (Z or +/-HH:mm)."
      ]
    ),
    "email": .describe(
      field: "email",
      meaning: "GraphQL Email custom scalar.",
      format: "RFC 5322 email string",
      negativeConstraints: [
        "Do not pass display names or angle brackets (<user@example.com>)."
      ]
    ),
    "jsonObjectString": .describe(
      field: "jsonObjectString",
      meaning: "GraphQL JSON custom scalar serialized as a valid JSON object.",
      format: "Serialized JSON object string ({...})",
      negativeConstraints: [
        "Do not pass malformed JSON or top-level primitives/arrays when a JSON object is expected."
      ]
    )
  ]

  /// Creates a scalar validation request schema.
  public init(iso8601DateTime: ISO8601DateTime, email: Email, jsonObjectString: JSON) {
    self.iso8601DateTime = iso8601DateTime
    self.email = email
    self.jsonObjectString = jsonObjectString
  }

  /// Validates all three custom scalars against format constraints and returns a normalized contract or `AXGraphScalarProblemDetails`.
  public func validate() -> Result<ValidatedGraphScalarsContract, AXGraphScalarProblemDetails> {
    var violations: [AXGraphScalarInvalidParam] = []

    if self.iso8601DateTime.range(of: Self.isoRegex, options: .regularExpression) == nil {
      violations.append(AXGraphScalarInvalidParam(
        name: "iso8601DateTime",
        reason: "Must be a valid ISO 8601 timestamp with timezone (e.g. 2026-11-11T07:00:00Z)."
      ))
    }

    let trimmedEmail = self.email.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    if trimmedEmail.range(of: Self.emailRegex, options: .regularExpression) == nil {
      violations.append(AXGraphScalarInvalidParam(
        name: "email",
        reason: "Must be a valid email address."
      ))
    }

    var jsonKeyCount = 0
    if
      let data = self.jsonObjectString.data(using: .utf8),
      let parsed = try? JSONSerialization.jsonObject(with: data) as? [String: Any] {
      jsonKeyCount = parsed.count
    } else {
      violations.append(AXGraphScalarInvalidParam(
        name: "jsonObjectString",
        reason: "Must be a valid serialized JSON object ({...})."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXGraphScalarProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-graphql-scalar",
        title: "Invalid GraphQL Custom Scalar",
        status: 400,
        detail: "GraphAPI custom scalar payload failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide a valid ISO 8601 timestamp, RFC 5322 email, and serialized JSON object.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedGraphScalarsContract(
      iso8601DateTime: self.iso8601DateTime,
      normalizedEmail: trimmedEmail,
      jsonKeyCount: jsonKeyCount
    ))
  }
}

/// Validated and normalized custom scalar output contract.
public struct ValidatedGraphScalarsContract: Codable, Equatable, Sendable {
  /// Validated ISO 8601 timestamp string.
  public let iso8601DateTime: String
  /// Trimmed and lowercased email address.
  public let normalizedEmail: String
  /// Top-level JSON object key count verified during parsing.
  public let jsonKeyCount: Int
}

