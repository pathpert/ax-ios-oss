import Foundation
import GraphAPI

/// @deprecated Legacy payment-intent input primitive using string `amountDollars`.
/// Prefer `CreatePaymentIntentRequestSchema` and `PaymentsController.handleCreatePaymentIntent(payload:headers:)`
/// in `KsApi/modules/payments`.
/// - Negative Constraint: Do not use decimal dollar strings for new callers; use integer cents via `CreatePaymentIntentRequestSchema`.
public struct CreatePaymentIntentInput: GraphMutationInput, Encodable {
  let projectId: String
  let backingId: String
  let amountDollars: String
  let checkoutId: String
  let digitalMarketingAttributed: Bool?
  let paymentIntentContext: GraphAPI.StripeIntentContextTypes?

  /// Initializes a legacy `CreatePaymentIntentInput` for post-campaign checkout.
  /// - parameter projectId: Base64 GraphQL project ID.
  /// - parameter backingId: Base64 GraphQL backing ID.
  /// - parameter amountDollars: Decimal dollar string amount.
  /// - parameter checkoutId: GraphQL checkout ID from `CreateCheckout`.
  /// - parameter digitalMarketingAttributed: Optional digital marketing attribution flag.
  public init(
    projectId: String,
    backingId: String,
    amountDollars: String,
    checkoutId: String,
    digitalMarketingAttributed: Bool?
  ) {
    self.projectId = projectId
    self.backingId = backingId
    self.amountDollars = amountDollars
    self.checkoutId = checkoutId
    self.digitalMarketingAttributed = digitalMarketingAttributed
    self.paymentIntentContext = .postCampaignCheckout
  }
}
