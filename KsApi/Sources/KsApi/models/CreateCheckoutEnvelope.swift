import Foundation
import GraphAPI
import ReactiveSwift

/// GraphQL response envelope returned by `createCheckout`.
public struct CreateCheckoutEnvelope: Decodable {
  /// Checkout payload created for the pledge session.
  public var checkout: Checkout

  /// Nested checkout identifiers and payment confirmation URL.
  public struct Checkout: Decodable {
    /// Encoded GraphQL identifier of the checkout session.
    public var id: String
    /// URL for completing hosted or on-session checkout payment confirmation.
    public var paymentUrl: String
    /// Encoded GraphQL identifier of the backing associated with this checkout.
    public var backingId: String
  }
}

// MARK: - GraphQL Adapters

extension CreateCheckoutEnvelope {
  static func from(_ data: GraphAPI.CreateCheckoutMutation.Data) -> CreateCheckoutEnvelope? {
    guard let id = data.createCheckout?.checkout?.id,
          let paymentUrl = data.createCheckout?.checkout?.paymentUrl,
          let backingId = data.createCheckout?.checkout?.backing.id else {
      return nil
    }

    return CreateCheckoutEnvelope(checkout: Checkout(id: id, paymentUrl: paymentUrl, backingId: backingId))
  }

  static func producer(from data: GraphAPI.CreateCheckoutMutation.Data)
    -> SignalProducer<CreateCheckoutEnvelope, ErrorEnvelope> {
    guard let envelope = CreateCheckoutEnvelope.from(data) else {
      return SignalProducer(error: .couldNotParseJSON)
    }
    return SignalProducer(value: envelope)
  }
}
