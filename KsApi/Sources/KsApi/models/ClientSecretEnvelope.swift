import Foundation
import GraphAPI
import ReactiveSwift

/// GraphQL response envelope carrying a Stripe SetupIntent client secret.
public struct ClientSecretEnvelope: Decodable {
  /// Stripe SetupIntent client secret returned by `createSetupIntent`.
  public let clientSecret: String
}

// MARK: - GraphQL Adapters

extension ClientSecretEnvelope {
  static func envelopeProducer(from data: GraphAPI.CreateSetupIntentMutation.Data)
    -> SignalProducer<ClientSecretEnvelope, ErrorEnvelope> {
    guard let envelope = ClientSecretEnvelope.clientSecretEnvelope(from: data) else {
      return SignalProducer(error: .couldNotParseJSON)
    }
    return SignalProducer(value: envelope)
  }
}
