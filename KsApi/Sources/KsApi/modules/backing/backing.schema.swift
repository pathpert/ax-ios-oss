import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Backing Creation

/// Poka-Yoke request schema for creating a new backing pledge with boundary validation.
///
/// - Negative constraint: Do not pass raw numeric IDs or floating-point currency amounts.
public struct CreateBackingRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL Global ID of the Project (`"Project-<numeric_id>"`).
  public let projectId: String
  /// Total pledge amount in integer minor currency units (cents).
  public let amountInCents: Int
  /// Array of 1...20 Base64-encoded Reward Global IDs.
  public let rewardIds: [String]
  /// Optional Base64-encoded Location Global ID for shipping destination.
  public let locationId: String?
  /// Saved Stripe/GraphQL payment source identifier (required if `setupIntentClientSecret` is `nil`).
  public let paymentSourceId: String?
  /// Confirmed Stripe SetupIntent client secret (`seti_..._secret_...`).
  public let setupIntentClientSecret: String?
  /// `true` when submitting a Pledge-Over-Time incremental backing.
  public let incremental: Bool
  /// Optional referral attribution tag.
  public let refParam: String?

  /// Field-level descriptors and negative constraints for `CreateBackingRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "projectId": .describe(
      field: "projectId",
      meaning: "Base64-encoded GraphQL Global ID of the Project to back.",
      format: "Base64 string decoding to 'Project-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw numeric project IDs or slugs.",
        "Do not use for batch backing across multiple projects."
      ]
    ),
    "amountInCents": .describe(
      field: "amountInCents",
      meaning: "Total backing pledge amount in minor currency units (integer cents).",
      format: "Positive integer >= 100 and <= 100_000_000",
      negativeConstraints: [
        "Do not pass floating-point currency strings (e.g. '25.50'); pass integer cents (2550).",
        "Do not pass zero or negative integers."
      ]
    ),
    "rewardIds": .describe(
      field: "rewardIds",
      meaning: "Array of Base64-encoded GraphQL Global IDs for selected Rewards.",
      format: "Array of 1..20 Base64 strings decoding to 'Reward-<numeric_id>'",
      negativeConstraints: [
        "Do not pass an empty array.",
        "Do not pass more than 20 rewards in a single backing."
      ]
    ),
    "paymentSourceId": .describe(
      field: "paymentSourceId",
      meaning: "Optional Base64-encoded GraphID or Stripe payment source identifier.",
      format: "Non-empty payment source ID when setupIntentClientSecret is nil",
      negativeConstraints: [
        "Do not omit both paymentSourceId and setupIntentClientSecret.",
        "Do not pass raw credit card PANs or CVVs."
      ]
    ),
    "setupIntentClientSecret": .describe(
      field: "setupIntentClientSecret",
      meaning: "Optional Stripe SetupIntent client secret from PaymentSheet.",
      format: "Stripe secret matching 'seti_<id>_secret_<token>' when present",
      negativeConstraints: [
        "Do not pass publishable keys or raw tokens without the 'seti_' prefix."
      ]
    )
  ]

  /// Creates an unvalidated create-backing request payload.
  public init(
    projectId: String,
    amountInCents: Int,
    rewardIds: [String],
    locationId: String? = nil,
    paymentSourceId: String? = nil,
    setupIntentClientSecret: String? = nil,
    incremental: Bool = false,
    refParam: String? = nil
  ) {
    self.projectId = projectId
    self.amountInCents = amountInCents
    self.rewardIds = rewardIds
    self.locationId = locationId
    self.paymentSourceId = paymentSourceId
    self.setupIntentClientSecret = setupIntentClientSecret
    self.incremental = incremental
    self.refParam = refParam
  }

  /// Validates GraphIDs, integer-cent bounds, and payment credentials, returning `AXProblemDetails` on error.
  public func validate() -> Result<ValidatedCreateBackingContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !CreateCheckoutRequestSchema.isValidGraphID(self.projectId, expectedPrefix: "Project-") {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be Base64 'Project-<id>'."))
    }
    if self.amountInCents < 100 || self.amountInCents > 100_000_000 {
      violations.append(AXInvalidParam(name: "amountInCents", reason: "Must be integer cents between 100 and 100000000."))
    }
    if self.rewardIds.isEmpty || self.rewardIds.count > 20 ||
      self.rewardIds.contains(where: { !CreateCheckoutRequestSchema.isValidGraphID($0, expectedPrefix: "Reward-") }) {
      violations.append(AXInvalidParam(name: "rewardIds", reason: "Must contain 1..20 Base64 'Reward-<id>' values."))
    }
    if let loc = self.locationId, !CreateCheckoutRequestSchema.isValidGraphID(loc, expectedPrefix: "Location-") {
      violations.append(AXInvalidParam(name: "locationId", reason: "Must be Base64 'Location-<id>' when present."))
    }

    let hasPaymentSource = !(self.paymentSourceId?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    let hasSetupSecret = !(self.setupIntentClientSecret?.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty ?? true)
    if !hasPaymentSource && !hasSetupSecret {
      violations.append(AXInvalidParam(
        name: "paymentSourceId",
        reason: "Either paymentSourceId or setupIntentClientSecret must be provided."
      ))
    }
    if let secret = self.setupIntentClientSecret, !secret.hasPrefix("seti_") || !secret.contains("_secret_") {
      violations.append(AXInvalidParam(
        name: "setupIntentClientSecret",
        reason: "Must match Stripe SetupIntent secret format 'seti_<id>_secret_<token>'."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "CreateBacking request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide amountInCents >= 100, valid Base64 GraphIDs ('Project-<id>', 'Reward-<id>'), and either a valid paymentSourceId or 'seti_..._secret_...' token.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedCreateBackingContract(
      projectId: self.projectId,
      amountInCents: self.amountInCents,
      legacyFormattedAmount: String(format: "%d.%02d", self.amountInCents / 100, self.amountInCents % 100),
      rewardIds: self.rewardIds,
      locationId: self.locationId,
      paymentSourceId: self.paymentSourceId,
      setupIntentClientSecret: self.setupIntentClientSecret,
      incremental: self.incremental,
      refParam: self.refParam
    ))
  }
}

/// Validated backing creation contract safe for adapter execution.
public struct ValidatedCreateBackingContract: Equatable, Sendable {
  /// Validated Base64 Project Global ID.
  public let projectId: String
  /// Validated integer-cent pledge amount.
  public let amountInCents: Int
  /// Decimal string formatted for legacy GraphQL adapter bridging (`"25.50"`).
  public let legacyFormattedAmount: String
  /// Validated Base64 Reward Global IDs.
  public let rewardIds: [String]
  /// Validated optional Base64 Location Global ID.
  public let locationId: String?
  /// Validated saved payment source ID.
  public let paymentSourceId: String?
  /// Validated Stripe SetupIntent client secret.
  public let setupIntentClientSecret: String?
  /// Whether incremental payments are requested.
  public let incremental: Bool
  /// Optional referral parameter.
  public let refParam: String?
}
