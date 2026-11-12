/// GraphQL mutation input for saving a payment source backed by a Stripe SetupIntent client secret.
///
/// - Negative constraint: Do not pass an unconfirmed SetupIntent secret or card token.
public struct CreatePaymentSourceSetupIntentInput: GraphMutationInput, Encodable {
  let intentClientSecret: String
  let reuseable: Bool

  private enum CodingKeys: String, CodingKey {
    case intentClientSecret
    case reuseable = "reusable"
  }

  /// Creates a SetupIntent payment source mutation input.
  public init(intentClientSecret: String, reuseable: Bool) {
    self.intentClientSecret = intentClientSecret
    self.reuseable = reuseable
  }
}
