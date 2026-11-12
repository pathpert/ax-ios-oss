import Foundation

/// Tokenized Apple Pay payment instrument payload forwarded during Apple Pay checkout mutations.
///
/// Negative Constraint: Never persist or log `token`; forward once inside checkout requests.
public struct ApplePayParams: Encodable, Equatable {
  let paymentInstrumentName: String
  let paymentNetwork: String
  let transactionIdentifier: String
  let token: String

  /// Creates an `ApplePayParams` payload from PassKit/Stripe token metadata.
  public init(
    paymentInstrumentName: String,
    paymentNetwork: String,
    transactionIdentifier: String,
    token: String
  ) {
    self.paymentInstrumentName = paymentInstrumentName
    self.paymentNetwork = paymentNetwork
    self.transactionIdentifier = transactionIdentifier
    self.token = token
  }
}
