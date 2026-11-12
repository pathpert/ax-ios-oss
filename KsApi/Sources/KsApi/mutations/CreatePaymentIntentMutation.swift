import Foundation

/// GraphQL mutation creating a Stripe PaymentIntent client secret for pledge checkout.
///
/// Negative Constraint: Do not log or persist the returned `clientSecret`.
public struct CreatePaymentIntentMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CreatePaymentIntentInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation createPaymentIntent($input: CreatePaymentIntentInput!) {
      createPaymentIntent(input: $input) {
        clientSecret
        clientMutationId
      }
    }
    """
  }
}
