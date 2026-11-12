import Foundation

/// GraphQL mutation deleting a stored payment card from the user's account and returning remaining cards.
///
/// Negative Constraint: Irreversible destructive operation on saved payment source IDs.
public struct PaymentSourceDeleteMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `PaymentSourceDeleteInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    let desc = """
    mutation paymentSourceDelete($input: PaymentSourceDeleteInput!) {
      paymentSourceDelete(input: $input) {
        clientMutationId
        user {
          storedCards {
            nodes {
              expirationDate
              id
              lastFour
              type
            }
          }
        }
      }
    }
    """

    return desc
  }
}
