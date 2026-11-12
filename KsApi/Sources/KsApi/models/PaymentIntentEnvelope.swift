import Foundation
import GraphAPI
import ReactiveSwift

/// GraphQL response envelope carrying a Stripe PaymentIntent client secret.
public struct PaymentIntentEnvelope: Decodable {
  /// Stripe PaymentIntent client secret returned by `createPaymentIntent`.
  public let clientSecret: String
}

// MARK: - GraphQL Adapters

extension PaymentIntentEnvelope {
  static func envelopeProducer(from data: GraphAPI.CreatePaymentIntentMutation.Data)
    -> SignalProducer<PaymentIntentEnvelope, ErrorEnvelope> {
    guard let envelope = PaymentIntentEnvelope.clientSecretEnvelope(from: data) else {
      return SignalProducer(error: .couldNotParseJSON)
    }
    return SignalProducer(value: envelope)
  }

  /**
   Returns a minimal `PaymentIntentEnvelope` from a `CreatePaymentIntentMutation.Data`
   */
  static func clientSecretEnvelope(
    from data: GraphAPI.CreatePaymentIntentMutation
      .Data
  ) -> PaymentIntentEnvelope? {
    guard let clientSecret = data.createPaymentIntent?.clientSecret
    else { return nil }

    return PaymentIntentEnvelope(clientSecret: clientSecret)
  }
}
