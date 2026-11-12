import Foundation

// MARK: - Rule 3: Poka-Yoke Domain Primitives & Boundary Schemas (Checkout)
// Shared AX contracts (`AXFieldDescriptor`, `AXProblemDetails`, `AXInvalidParam`,
// `AXRateLimitHeaders`, `IdempotencyKey`) now live in `KsApi/Sources/KsApi/lib/AX/AXContracts.swift`.

/// Poka-Yoke request schema for initializing a new Kickstarter checkout session.
///
/// - Negative constraint: Pass Base64 GraphIDs for `projectId`/`rewardIds`/`locationId` and integer minor-unit `amountInCents` (`100...100_000_000`).
public struct CreateCheckoutRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL Global ID of the target Project (`"Project-<id>"`).
  public let projectId: String
  /// Total pledge amount in integer minor currency units (cents).
  public let amountInCents: Int
  /// Array of `1...20` Base64-encoded Reward Global IDs (`"Reward-<id>"`).
  public let rewardIds: [String]
  /// Optional Base64-encoded Location Global ID (`"Location-<id>"`) for shipping.
  public let locationId: String?
  /// Optional referral attribution tag.
  public let refParam: String?

  /// Field-level descriptors and negative constraints for `CreateCheckoutRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "projectId": .describe(
      field: "projectId",
      meaning: "Base64-encoded GraphQL Global ID of the target Kickstarter Project.",
      format: "Base64 string decoding to 'Project-<numeric_id>'",
      negativeConstraints: ["Do not pass raw integer project IDs or slugs.", "Do not pass multiple project IDs."]
    ),
    "amountInCents": .describe(
      field: "amountInCents",
      meaning: "Total pledge amount in minor currency units (integer cents).",
      format: "Positive integer >= 100 and <= 100_000_000",
      negativeConstraints: ["Do not pass floating-point currency; use integer cents.", "Do not pass zero or negative values."]
    ),
    "rewardIds": .describe(
      field: "rewardIds",
      meaning: "List of Base64-encoded GraphQL Global IDs for selected Rewards.",
      format: "Array of 1 to 20 Base64 strings decoding to 'Reward-<numeric_id>'",
      negativeConstraints: ["Do not pass an empty array.", "Do not use for batch operations (> 20 rewards)."]
    ),
    "locationId": .describe(
      field: "locationId",
      meaning: "Optional Base64-encoded GraphQL ID of the shipping destination location.",
      format: "Base64 string decoding to 'Location-<numeric_id>' or nil",
      negativeConstraints: ["Do not pass ISO country names or postal codes; pass the GraphQL Location ID."]
    )
  ]

  /// Creates a `CreateCheckoutRequestSchema` payload.
  public init(
    projectId: String,
    amountInCents: Int,
    rewardIds: [String],
    locationId: String? = nil,
    refParam: String? = nil
  ) {
    self.projectId = projectId
    self.amountInCents = amountInCents
    self.rewardIds = rewardIds
    self.locationId = locationId
    self.refParam = refParam
  }

  /// Validates GraphID encoding, reward count (`1...20`), and integer-cent amount boundaries.
  public func validate() -> Result<ValidatedCreateCheckoutContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    if !Self.isValidGraphID(self.projectId, expectedPrefix: "Project-") {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be Base64 'Project-<id>'. Do not pass raw integer IDs."))
    }
    if self.amountInCents < 100 || self.amountInCents > 100_000_000 {
      violations.append(AXInvalidParam(name: "amountInCents", reason: "Must be integer cents between 100 and 100000000."))
    }
    if self.rewardIds.isEmpty || self.rewardIds.count > 20 ||
      self.rewardIds.contains(where: { !Self.isValidGraphID($0, expectedPrefix: "Reward-") }) {
      violations.append(AXInvalidParam(name: "rewardIds", reason: "Must contain 1..20 Base64 'Reward-<id>' values."))
    }
    if let loc = self.locationId, !Self.isValidGraphID(loc, expectedPrefix: "Location-") {
      violations.append(AXInvalidParam(name: "locationId", reason: "Must be Base64 'Location-<id>' when present."))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Checkout request failed Poka-Yoke boundary schema validation (\(violations.count) violation(s)).",
        suggestedAction: "Inspect 'invalid_params', convert currency to integer cents >= 100, and encode GraphIDs as Base64 'Project-<id>' / 'Reward-<id>' before re-submitting.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedCreateCheckoutContract(
      projectId: self.projectId,
      amountInCents: self.amountInCents,
      legacyFormattedAmount: String(format: "%d.%02d", self.amountInCents / 100, self.amountInCents % 100),
      rewardIds: self.rewardIds,
      locationId: self.locationId,
      refParam: self.refParam
    ))
  }

  internal static func isValidGraphID(_ value: String, expectedPrefix: String) -> Bool {
    guard let data = Data(base64Encoded: value),
          let decoded = String(data: data, encoding: .utf8),
          decoded.hasPrefix(expectedPrefix) else { return false }
    let suffix = decoded.dropFirst(expectedPrefix.count)
    return !suffix.isEmpty && suffix.allSatisfy(\.isNumber)
  }
}

/// Validated checkout payload emitted by `CreateCheckoutRequestSchema.validate()`.
public struct ValidatedCreateCheckoutContract: Equatable, Sendable {
  /// Validated Base64 `"Project-<id>"` GraphQL identifier.
  public let projectId: String
  /// Pledge amount in integer cents.
  public let amountInCents: Int
  /// Legacy decimal currency string formatted from `amountInCents` for GraphQL input bridging.
  public let legacyFormattedAmount: String
  /// Validated Base64 `"Reward-<id>"` identifiers.
  public let rewardIds: [String]
  /// Optional validated Base64 `"Location-<id>"` identifier.
  public let locationId: String?
  /// Optional referral attribution tag.
  public let refParam: String?
}

/// Poka-Yoke request schema for canceling an active backing pledge.
///
/// - Negative constraint: Pass a Base64 `"Backing-<id>"` GraphQL ID, not a raw integer backing ID.
public struct CancelBackingRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL Global ID of the Backing to cancel.
  public let backingId: String

  /// Field-level descriptors and negative constraints for `CancelBackingRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "backingId": .describe(
      field: "backingId",
      meaning: "Base64-encoded GraphQL Global ID of the Backing to cancel.",
      format: "Base64 string decoding to 'Backing-<numeric_id>'",
      negativeConstraints: ["Do not pass raw integer backing IDs.", "Do not use for batch cancellation."]
    )
  ]

  /// Creates a `CancelBackingRequestSchema` payload.
  public init(backingId: String) { self.backingId = backingId }

  /// Validates that `backingId` decodes to `"Backing-<numeric_id>"`.
  public func validate() -> Result<String, AXProblemDetails> {
    guard CreateCheckoutRequestSchema.isValidGraphID(self.backingId, expectedPrefix: "Backing-") else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "The backingId '\(self.backingId)' is not a valid Base64 'Backing-<id>' GraphID.",
        suggestedAction: "Base64-encode 'Backing-<numeric_id>' (for example, 'QmFja2luZy0x') and retry.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "backingId", reason: "Must be Base64 'Backing-<id>'.")]
      ))
    }
    return .success(self.backingId)
  }
}

/// Idempotent contract emitted when a checkout session is created.
public struct CheckoutSessionContract: Codable, Equatable, Sendable {
  /// Server-assigned GraphQL checkout session ID.
  public let checkoutId: String
  /// Created GraphQL backing identifier.
  public let backingId: String
  /// Hosted payment authorization URL returned by the backend.
  public let paymentUrl: String
  /// Authorized checkout amount in integer cents.
  public let amountInCents: Int
  /// `true` when returned from idempotent replay protection.
  public let idempotencyReplayed: Bool

  /// Creates a `CheckoutSessionContract`.
  public init(checkoutId: String, backingId: String, paymentUrl: String, amountInCents: Int, idempotencyReplayed: Bool = false) {
    self.checkoutId = checkoutId
    self.backingId = backingId
    self.paymentUrl = paymentUrl
    self.amountInCents = amountInCents
    self.idempotencyReplayed = idempotencyReplayed
  }
}
