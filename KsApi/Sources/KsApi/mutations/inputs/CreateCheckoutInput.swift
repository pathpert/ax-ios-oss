import Foundation

/// @deprecated Legacy checkout input primitive.
/// Prefer `CreateCheckoutRequestSchema` and `CheckoutController.handleCreateCheckout(payload:headers:)`
/// in `KsApi/modules/checkout` which enforces integer-cent Poka-Yoke validation, Idempotency-Key safety,
/// and RFC 9457 Problem Details errors.
/// - Negative Constraint: Do not use for new checkout flows; migrate callers to `CreateCheckoutRequestSchema`.
public struct CreateCheckoutInput: GraphMutationInput, Encodable {
  let projectId: String
  let amount: String?
  let locationId: String?
  let rewardIds: [String]
  let refParam: String?

  /// Initializes a legacy `CreateCheckoutInput`.
  /// - parameter projectId: Base64 GraphQL project ID.
  /// - parameter amount: Optional pledge amount string.
  /// - parameter locationId: Optional shipping rule location ID.
  /// - parameter rewardIds: Base64 GraphQL reward IDs.
  /// - parameter refParam: Optional referral attribution tag.
  public init(
    projectId: String,
    amount: String?,
    locationId: String?,
    rewardIds: [String],
    refParam: String?
  ) {
    self.projectId = projectId
    self.amount = amount
    self.locationId = locationId
    self.rewardIds = rewardIds
    self.refParam = refParam
  }
}
