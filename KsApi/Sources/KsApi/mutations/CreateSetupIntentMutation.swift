import Foundation

/// GraphQL mutation creating a Stripe SetupIntent for saving a card outside immediate checkout.
///
/// Negative Constraint: Do not use for charging an immediate pledge amount; use `CreatePaymentIntentMutation`.
public struct CreateSetupIntentMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CreateSetupIntentInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    let desc = """
    mutation CreateSetupIntent($input: CreateSetupIntentInput!) {
      createSetupIntent(input: $input) {
        clientSecret
      }
    }
    """

    return desc
  }
}
