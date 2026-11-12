import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Backing Mutation & Response Contracts

/// Poka-Yoke request schema for updating an existing backing pledge.
///
/// - Negative constraint: Do not omit all mutable fields; at least one update field must be provided.
public struct UpdateBackingRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL Global ID of the existing Backing (`"Backing-<numeric_id>"`).
  public let backingId: String
  /// Optional updated pledge amount in integer minor currency units (cents).
  public let amountInCents: Int?
  /// Optional updated list of 1...20 Base64-encoded Reward Global IDs.
  public let rewardIds: [String]?
  /// Optional updated Base64-encoded Location Global ID.
  public let locationId: String?
  /// Optional replacement payment source identifier.
  public let paymentSourceId: String?
  /// `true` when enabling or updating incremental payments.
  public let incremental: Bool

  /// Field-level descriptors and negative constraints for `UpdateBackingRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "backingId": .describe(
      field: "backingId",
      meaning: "Base64-encoded GraphQL Global ID of the existing Backing to update.",
      format: "Base64 string decoding to 'Backing-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer backing IDs.",
        "Do not use for creating new backings; use CreateBackingRequestSchema instead."
      ]
    ),
    "amountInCents": .describe(
      field: "amountInCents",
      meaning: "Optional updated pledge amount in integer cents.",
      format: "Positive integer >= 100 and <= 100_000_000 or nil",
      negativeConstraints: [
        "Do not pass floating-point currency; use integer cents.",
        "Do not pass values < 100."
      ]
    )
  ]

  /// Creates an unvalidated update-backing request payload.
  public init(
    backingId: String,
    amountInCents: Int? = nil,
    rewardIds: [String]? = nil,
    locationId: String? = nil,
    paymentSourceId: String? = nil,
    incremental: Bool = false
  ) {
    self.backingId = backingId
    self.amountInCents = amountInCents
    self.rewardIds = rewardIds
    self.locationId = locationId
    self.paymentSourceId = paymentSourceId
    self.incremental = incremental
  }

  /// Validates the backing ID and mutable update fields, returning `AXProblemDetails` on violation.
  public func validate() -> Result<ValidatedUpdateBackingContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !CreateCheckoutRequestSchema.isValidGraphID(self.backingId, expectedPrefix: "Backing-") {
      violations.append(AXInvalidParam(name: "backingId", reason: "Must be Base64 'Backing-<id>'."))
    }
    if let cents = self.amountInCents, cents < 100 || cents > 100_000_000 {
      violations.append(AXInvalidParam(name: "amountInCents", reason: "When present, must be integer cents between 100 and 100000000."))
    }
    if let rewards = self.rewardIds, rewards.isEmpty || rewards.count > 20 ||
      rewards.contains(where: { !CreateCheckoutRequestSchema.isValidGraphID($0, expectedPrefix: "Reward-") }) {
      violations.append(AXInvalidParam(name: "rewardIds", reason: "When present, must contain 1..20 Base64 'Reward-<id>' values."))
    }
    if self.amountInCents == nil && self.rewardIds == nil && self.locationId == nil && self.paymentSourceId == nil {
      violations.append(AXInvalidParam(
        name: "updateFields",
        reason: "At least one mutable field (amountInCents, rewardIds, locationId, or paymentSourceId) must be non-nil."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "UpdateBacking request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Ensure backingId is Base64 'Backing-<id>', amountInCents >= 100, and at least one mutable field is specified.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    let formattedAmount = self.amountInCents.map { String(format: "%d.%02d", $0 / 100, $0 % 100) }
    return .success(ValidatedUpdateBackingContract(
      backingId: self.backingId,
      amountInCents: self.amountInCents,
      legacyFormattedAmount: formattedAmount,
      rewardIds: self.rewardIds,
      locationId: self.locationId,
      paymentSourceId: self.paymentSourceId,
      incremental: self.incremental
    ))
  }
}

/// Validated backing update contract safe for adapter execution.
public struct ValidatedUpdateBackingContract: Equatable, Sendable {
  /// Validated Base64 Backing Global ID.
  public let backingId: String
  /// Validated optional updated pledge amount in integer cents.
  public let amountInCents: Int?
  /// Optional decimal string formatted for legacy GraphQL adapter bridging.
  public let legacyFormattedAmount: String?
  /// Validated optional Base64 Reward Global IDs.
  public let rewardIds: [String]?
  /// Validated optional Location Global ID.
  public let locationId: String?
  /// Validated optional payment source ID.
  public let paymentSourceId: String?
  /// Whether incremental payments are requested.
  public let incremental: Bool
}

/// Strongly-typed response contract returned by create/update backing controllers.
public struct BackingMutationContract: Codable, Equatable, Sendable {
  /// Identifier of the created or updated checkout record.
  public let checkoutId: String
  /// Current server checkout/backing state string.
  public let state: String
  /// `true` when 3DS/SCA user authentication is required using `clientSecret`.
  public let requiresAction: Bool
  /// Optional Stripe PaymentIntent/SetupIntent client secret when `requiresAction` is `true`.
  public let clientSecret: String?
  /// `true` when this response was replayed from an idempotency key cache.
  public let idempotencyReplayed: Bool

  /// Creates a backing mutation response contract.
  public init(
    checkoutId: String,
    state: String,
    requiresAction: Bool,
    clientSecret: String?,
    idempotencyReplayed: Bool = false
  ) {
    self.checkoutId = checkoutId
    self.state = state
    self.requiresAction = requiresAction
    self.clientSecret = clientSecret
    self.idempotencyReplayed = idempotencyReplayed
  }
}

