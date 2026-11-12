import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Payments & Payment Sources

/// Poka-Yoke request schema for creating a Stripe PaymentIntent for a Kickstarter checkout.
///
/// - Negative constraint: Pass Base64 GraphIDs for `projectId`/`backingId`/`checkoutId` and integer minor-unit `amountInCents` (`100...100_000_000`).
public struct CreatePaymentIntentRequestSchema: Codable, Equatable, Sendable {
  /// Base64 GraphQL Global ID of the Project (`"Project-<id>"`).
  public let projectId: String
  /// Base64 GraphQL Global ID of the Backing (`"Backing-<id>"`).
  public let backingId: String
  /// Base64 GraphQL Global ID of the Checkout (`"Checkout-<id>"`).
  public let checkoutId: String
  /// Payment intent amount in minor currency units (`100...100_000_000` cents).
  public let amountInCents: Int
  /// Optional digital marketing attribution flag.
  public let digitalMarketingAttributed: Bool?

  /// Field-level descriptors and negative constraints for `CreatePaymentIntentRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "projectId": .describe(
      field: "projectId",
      meaning: "Base64-encoded GraphQL Global ID of the Project.",
      format: "Base64 string decoding to 'Project-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer project IDs.",
        "Do not use for batch payment intents."
      ]
    ),
    "backingId": .describe(
      field: "backingId",
      meaning: "Base64-encoded GraphQL Global ID of the Backing.",
      format: "Base64 string decoding to 'Backing-<numeric_id>'",
      negativeConstraints: ["Do not pass raw integer backing IDs."]
    ),
    "checkoutId": .describe(
      field: "checkoutId",
      meaning: "Base64-encoded GraphQL Global ID of the Checkout session.",
      format: "Base64 string decoding to 'Checkout-<numeric_id>'",
      negativeConstraints: ["Do not pass raw integer checkout IDs."]
    ),
    "amountInCents": .describe(
      field: "amountInCents",
      meaning: "Payment intent amount in integer cents.",
      format: "Positive integer >= 100 and <= 100_000_000",
      negativeConstraints: [
        "Do not pass floating-point dollar strings (e.g. 'amountDollars: \"12.50\"'); pass integer cents (1250).",
        "Do not pass zero or negative integers."
      ]
    )
  ]

  /// Creates a `CreatePaymentIntentRequestSchema` payload.
  public init(
    projectId: String,
    backingId: String,
    checkoutId: String,
    amountInCents: Int,
    digitalMarketingAttributed: Bool? = nil
  ) {
    self.projectId = projectId
    self.backingId = backingId
    self.checkoutId = checkoutId
    self.amountInCents = amountInCents
    self.digitalMarketingAttributed = digitalMarketingAttributed
  }

  /// Validates GraphID prefixes and integer-cent boundaries.
  public func validate() -> Result<ValidatedPaymentIntentContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !CreateCheckoutRequestSchema.isValidGraphID(self.projectId, expectedPrefix: "Project-") {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be Base64 'Project-<id>'."))
    }
    if !CreateCheckoutRequestSchema.isValidGraphID(self.backingId, expectedPrefix: "Backing-") {
      violations.append(AXInvalidParam(name: "backingId", reason: "Must be Base64 'Backing-<id>'."))
    }
    if !CreateCheckoutRequestSchema.isValidGraphID(self.checkoutId, expectedPrefix: "Checkout-") {
      violations.append(AXInvalidParam(name: "checkoutId", reason: "Must be Base64 'Checkout-<id>'."))
    }
    if self.amountInCents < 100 || self.amountInCents > 100_000_000 {
      violations.append(AXInvalidParam(
        name: "amountInCents",
        reason: "Must be integer cents between 100 and 100000000. Do not pass floating-point dollar strings."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "CreatePaymentIntent request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Encode projectId, backingId, and checkoutId as Base64 GraphIDs and pass amountInCents >= 100.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedPaymentIntentContract(
      projectId: self.projectId,
      backingId: self.backingId,
      checkoutId: self.checkoutId,
      amountInCents: self.amountInCents,
      legacyAmountDollars: String(format: "%d.%02d", self.amountInCents / 100, self.amountInCents % 100),
      digitalMarketingAttributed: self.digitalMarketingAttributed
    ))
  }
}

/// Validated PaymentIntent contract emitted by `CreatePaymentIntentRequestSchema.validate()`.
public struct ValidatedPaymentIntentContract: Equatable, Sendable {
  /// Validated Base64 `"Project-<id>"` GraphQL identifier.
  public let projectId: String
  /// Validated Base64 `"Backing-<id>"` GraphQL identifier.
  public let backingId: String
  /// Validated Base64 `"Checkout-<id>"` GraphQL identifier.
  public let checkoutId: String
  /// Payment amount in integer cents.
  public let amountInCents: Int
  /// Legacy decimal dollar string formatted for GraphQL mutation compatibility.
  public let legacyAmountDollars: String
  /// Optional digital marketing attribution flag.
  public let digitalMarketingAttributed: Bool?
}

/// Poka-Yoke request schema for deleting a saved user payment method.
///
/// - Negative constraint: Pass a Base64 `"PaymentSource-<id>"` or `"CreditCard-<id>"` GraphID, never raw PAN digits or last-4 strings.
public struct DeletePaymentSourceRequestSchema: Codable, Equatable, Sendable {
  /// Base64 GraphQL Global ID of the saved payment source to delete.
  public let paymentSourceId: String

  /// Field-level descriptors and negative constraints for `DeletePaymentSourceRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "paymentSourceId": .describe(
      field: "paymentSourceId",
      meaning: "Base64-encoded GraphQL ID of the stored PaymentSource to delete.",
      format: "Base64 string decoding to 'PaymentSource-<numeric_id>' or 'CreditCard-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw card numbers or last-4 digits.",
        "Do not use for batch deletion."
      ]
    )
  ]

  /// Creates a `DeletePaymentSourceRequestSchema` payload.
  public init(paymentSourceId: String) {
    self.paymentSourceId = paymentSourceId
  }

  /// Validates that `paymentSourceId` decodes to `"PaymentSource-<id>"` or `"CreditCard-<id>"`.
  public func validate() -> Result<String, AXProblemDetails> {
    let isValidPaymentSource = CreateCheckoutRequestSchema.isValidGraphID(
      self.paymentSourceId,
      expectedPrefix: "PaymentSource-"
    ) || CreateCheckoutRequestSchema.isValidGraphID(
      self.paymentSourceId,
      expectedPrefix: "CreditCard-"
    )

    guard isValidPaymentSource else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "paymentSourceId '\(self.paymentSourceId)' is not a valid Base64 PaymentSource/CreditCard GraphID.",
        suggestedAction: "Encode 'PaymentSource-<numeric_id>' or 'CreditCard-<numeric_id>' as Base64 and retry.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(
          name: "paymentSourceId",
          reason: "Must be Base64 'PaymentSource-<id>' or 'CreditCard-<id>'."
        )]
      ))
    }
    return .success(self.paymentSourceId)
  }
}

/// Idempotent contract returned when a Stripe PaymentIntent is created.
public struct PaymentIntentContract: Codable, Equatable, Sendable {
  /// Stripe PaymentIntent client secret used to confirm payment on-session.
  public let clientSecret: String
  /// Authorized PaymentIntent amount in integer cents.
  public let amountInCents: Int
  /// `true` when returned from the idempotency cache.
  public let idempotencyReplayed: Bool

  /// Creates a `PaymentIntentContract`.
  public init(clientSecret: String, amountInCents: Int, idempotencyReplayed: Bool = false) {
    self.clientSecret = clientSecret
    self.amountInCents = amountInCents
    self.idempotencyReplayed = idempotencyReplayed
  }
}

/// Idempotent contract returned after deleting a saved payment source.
public struct DeletedPaymentSourceContract: Codable, Equatable, Sendable {
  /// Identifier of the deleted payment source.
  public let deletedPaymentSourceId: String
  /// Number of remaining stored cards on the account.
  public let remainingStoredCardsCount: Int
  /// `true` when returned from the idempotency cache.
  public let idempotencyReplayed: Bool

  /// Creates a `DeletedPaymentSourceContract`.
  public init(
    deletedPaymentSourceId: String,
    remainingStoredCardsCount: Int,
    idempotencyReplayed: Bool = false
  ) {
    self.deletedPaymentSourceId = deletedPaymentSourceId
    self.remainingStoredCardsCount = remainingStoredCardsCount
    self.idempotencyReplayed = idempotencyReplayed
  }
}

