import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Post-Campaign Pledge & Checkout Validation

/// Poka-Yoke request schema for validating a post-campaign pledge checkout prior to completion.
///
/// - Negative constraint: Pass a Base64 `"Checkout-<id>"` ID and a Stripe PaymentIntent secret matching `"pi_<id>_secret_<token>"` (never `"seti_..."` SetupIntent secrets).
public struct ValidateCheckoutRequestSchema: Codable, Equatable, Sendable {
  /// Base64 GraphQL Global ID of the Checkout session (`"Checkout-<id>"`).
  public let checkoutId: String
  /// Base64 GraphQL ID (`"PaymentSource-<id>"` / `"CreditCard-<id>"`) or Stripe ID (`"pm_..."` / `"src_..."`).
  public let paymentSourceId: String
  /// Stripe PaymentIntent client secret (`"pi_<id>_secret_<token>"`).
  public let paymentIntentClientSecret: String

  /// Field-level descriptors and negative constraints for `ValidateCheckoutRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "checkoutId": .describe(
      field: "checkoutId",
      meaning: "Base64-encoded GraphQL Global ID of the Checkout session to validate.",
      format: "Base64 string decoding to 'Checkout-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer checkout IDs.",
        "Do not use for batch checkout validation."
      ]
    ),
    "paymentSourceId": .describe(
      field: "paymentSourceId",
      meaning: "Base64-encoded GraphQL ID or Stripe identifier of the selected payment source.",
      format: "Base64 'PaymentSource-<id>', 'CreditCard-<id>', or Stripe 'pm_...' / 'src_...' ID",
      negativeConstraints: [
        "Do not pass raw credit card numbers (PAN) or CVV codes.",
        "Do not pass empty strings."
      ]
    ),
    "paymentIntentClientSecret": .describe(
      field: "paymentIntentClientSecret",
      meaning: "Stripe PaymentIntent client secret returned by CreatePaymentIntent.",
      format: "Stripe secret matching 'pi_<id>_secret_<token>'",
      negativeConstraints: [
        "Do not pass SetupIntent secrets ('seti_...') or Stripe publishable keys ('pk_...')."
      ]
    )
  ]

  /// Creates a `ValidateCheckoutRequestSchema` payload.
  public init(checkoutId: String, paymentSourceId: String, paymentIntentClientSecret: String) {
    self.checkoutId = checkoutId
    self.paymentSourceId = paymentSourceId
    self.paymentIntentClientSecret = paymentIntentClientSecret
  }

  /// Validates GraphID encoding, payment source identifier format, and Stripe PaymentIntent secret format.
  public func validate() -> Result<ValidateCheckoutRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !CreateCheckoutRequestSchema.isValidGraphID(self.checkoutId, expectedPrefix: "Checkout-") {
      violations.append(AXInvalidParam(name: "checkoutId", reason: "Must be Base64 'Checkout-<id>'."))
    }

    let trimmedSource = self.paymentSourceId.trimmingCharacters(in: .whitespacesAndNewlines)
    let validSource = CreateCheckoutRequestSchema.isValidGraphID(trimmedSource, expectedPrefix: "PaymentSource-")
      || CreateCheckoutRequestSchema.isValidGraphID(trimmedSource, expectedPrefix: "CreditCard-")
      || trimmedSource.hasPrefix("pm_")
      || trimmedSource.hasPrefix("src_")
    if !validSource {
      violations.append(AXInvalidParam(
        name: "paymentSourceId",
        reason: "Must be Base64 'PaymentSource-<id>' / 'CreditCard-<id>' or Stripe 'pm_...' / 'src_...'."
      ))
    }

    if !self.paymentIntentClientSecret.hasPrefix("pi_") || !self.paymentIntentClientSecret.contains("_secret_") {
      violations.append(AXInvalidParam(
        name: "paymentIntentClientSecret",
        reason: "Must match Stripe PaymentIntent secret format 'pi_<id>_secret_<token>'."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "ValidateCheckout request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a Base64 'Checkout-<id>', a valid paymentSourceId, and a Stripe 'pi_<id>_secret_<token>'.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(self)
  }
}

/// Idempotent validation status contract returned by post-campaign checkout validation.
public struct ValidatedCheckoutStatusContract: Codable, Equatable, Sendable {
  /// Validated checkout GraphQL ID.
  public let checkoutId: String
  /// `true` when checkout passes all backend payment/shipping checks.
  public let isValid: Bool
  /// Server-supplied validation messages or warnings.
  public let validationMessages: [String]
  /// `true` when returned from the idempotency cache.
  public let idempotencyReplayed: Bool

  /// Creates a `ValidatedCheckoutStatusContract`.
  public init(
    checkoutId: String,
    isValid: Bool,
    validationMessages: [String],
    idempotencyReplayed: Bool = false
  ) {
    self.checkoutId = checkoutId
    self.isValid = isValid
    self.validationMessages = validationMessages
    self.idempotencyReplayed = idempotencyReplayed
  }
}

