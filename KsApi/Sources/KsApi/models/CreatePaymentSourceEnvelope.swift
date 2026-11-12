import Foundation

/// GraphQL response envelope returned after attaching a saved payment source to the user's account.
public struct CreatePaymentSourceEnvelope: Decodable {
  /// Nested `createPaymentSource` result.
  public var createPaymentSource: CreatePaymentSource

  /// Outcome and newly stored credit card metadata.
  public struct CreatePaymentSource: Decodable {
    /// `true` when the payment source was persisted successfully.
    public var isSuccessful: Bool
    /// Saved credit card returned by the GraphQL mutation.
    public var paymentSource: UserCreditCards.CreditCard
  }
}
