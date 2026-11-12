import Foundation

/// GraphQL mutation input for saving a tokenized payment source.
///
/// - Negative constraint: Do not pass raw card PAN or CVV numbers; pass tokenized `stripeToken` and `stripeCardId`.
public struct CreatePaymentSourceInput: GraphMutationInput, Encodable {
  let paymentType: PaymentType
  let reusable: Bool
  let stripeToken: String
  let stripeCardId: String

  /// Creates a save-payment-source mutation input.
  public init(paymentType: PaymentType, reusable: Bool, stripeToken: String, stripeCardId: String) {
    self.paymentType = paymentType
    self.reusable = reusable
    self.stripeToken = stripeToken
    self.stripeCardId = stripeCardId
  }
}
