import Foundation

/// @deprecated Legacy payment-source deletion input primitive.
/// Prefer `DeletePaymentSourceRequestSchema` and `PaymentsController.handleDeletePaymentSource(payload:headers:)`
/// in `KsApi/modules/payments`.
/// - Negative Constraint: Do not use for new card deletion callers; migrate to `DeletePaymentSourceRequestSchema`.
public struct PaymentSourceDeleteInput: GraphMutationInput, Encodable {
  let paymentSourceId: String

  /// Creates a legacy payment-source deletion input.
  ///
  /// - Negative constraint: Do not pass a Stripe `pm_` token directly if the GraphQL ID differs; pass the stored payment source GraphQL ID.
  public init(paymentSourceId: String) {
    self.paymentSourceId = paymentSourceId
  }
}
