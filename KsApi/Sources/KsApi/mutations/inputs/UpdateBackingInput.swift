import Foundation

/// @deprecated Legacy update-backing input primitive.
/// Prefer `UpdateBackingRequestSchema` and `BackingController.handleUpdateBacking(payload:headers:)`
/// in `KsApi/modules/backing` which enforces integer-cent Poka-Yoke validation, Idempotency-Key safety,
/// and RFC 9457 Problem Details errors.
/// - Negative Constraint: Do not use for new backing update flows; migrate callers to `UpdateBackingRequestSchema`.
public struct UpdateBackingInput: GraphMutationInput, Encodable {
  let amount: String?
  let applePay: ApplePayParams?
  let id: String
  let incremental: Bool
  let locationId: String?
  let paymentSourceId: String?
  let rewardIds: [String]?
  let setupIntentClientSecret: String?

  /// Initializes a legacy `UpdateBackingInput` payload.
  /// - parameter amount: Optional updated pledge amount string.
  /// - parameter applePay: Optional Apple Pay token payload.
  /// - parameter id: Base64 GraphQL backing ID.
  /// - parameter locationId: Optional shipping rule location ID.
  /// - parameter incremental: Whether incremental Pledge Over Time is enabled.
  /// - parameter paymentSourceId: Optional saved payment source ID.
  /// - parameter rewardIds: Optional updated GraphQL reward IDs.
  /// - parameter setupIntentClientSecret: Optional Stripe SetupIntent client secret.
  public init(
    amount: String?,
    applePay: ApplePayParams?,
    id: String,
    incremental: Bool,
    locationId: String?,
    paymentSourceId: String?,
    rewardIds: [String]?,
    setupIntentClientSecret: String?
  ) {
    self.amount = amount
    self.applePay = applePay
    self.id = id
    self.incremental = incremental
    self.locationId = locationId
    self.paymentSourceId = paymentSourceId
    self.rewardIds = rewardIds
    self.setupIntentClientSecret = setupIntentClientSecret
  }
}
