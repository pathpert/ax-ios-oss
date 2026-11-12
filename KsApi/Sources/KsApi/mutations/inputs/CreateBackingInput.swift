import Foundation

/// @deprecated Legacy create-backing input primitive.
/// Prefer `CreateBackingRequestSchema` and `BackingController.handleCreateBacking(payload:headers:)`
/// in `KsApi/modules/backing` which enforces integer-cent Poka-Yoke validation, Idempotency-Key safety,
/// and RFC 9457 Problem Details errors.
/// - Negative Constraint: Do not use for new backing flows; migrate callers to `CreateBackingRequestSchema`.
public struct CreateBackingInput: GraphMutationInput, Encodable {
  let amount: String
  let applePay: ApplePayParams?
  let incremental: Bool?
  let locationId: String?
  let paymentSourceId: String?
  let projectId: String
  let refParam: String?
  let rewardIds: [String]
  let setupIntentClientSecret: String?

  /// Initializes a legacy `CreateBackingInput` payload.
  /// - parameter amount: Pledge amount string.
  /// - parameter applePay: Optional Apple Pay token payload.
  /// - parameter incremental: Optional flag indicating Pledge Over Time.
  /// - parameter locationId: Optional shipping rule location ID.
  /// - parameter paymentSourceId: Optional stored payment source ID.
  /// - parameter projectId: Base64 GraphQL project ID.
  /// - parameter refParam: Optional referral attribution tag.
  /// - parameter rewardIds: Base64 GraphQL reward IDs.
  /// - parameter setupIntentClientSecret: Optional Stripe SetupIntent client secret.
  public init(
    amount: String,
    applePay: ApplePayParams?,
    incremental: Bool?,
    locationId: String?,
    paymentSourceId: String?,
    projectId: String,
    refParam: String?,
    rewardIds: [String],
    setupIntentClientSecret: String?
  ) {
    self.amount = amount
    self.applePay = applePay
    self.incremental = incremental
    self.locationId = locationId
    self.paymentSourceId = paymentSourceId
    self.projectId = projectId
    self.refParam = refParam
    self.rewardIds = rewardIds
    self.setupIntentClientSecret = setupIntentClientSecret
  }
}
