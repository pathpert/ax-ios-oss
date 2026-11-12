import Foundation

/// GraphQL mutation saving a tokenized Stripe payment method onto the signed-in user's account.
///
/// Negative Constraint: Never submit raw card numbers; pass Stripe tokens/PaymentMethod IDs only.
public struct CreatePaymentSourceMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CreatePaymentSourceInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation createPaymentSource($input: CreatePaymentSourceInput!) {
    createPaymentSource(input: $input) {
      clientMutationId
      errorMessage
      isSuccessful
      paymentSource {
          expirationDate
          id
          lastFour
          type
        }
      }
    }
    """
  }
}
