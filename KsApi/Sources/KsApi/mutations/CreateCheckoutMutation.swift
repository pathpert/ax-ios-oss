import Foundation

/// GraphQL mutation initiating a checkout session (`paymentUrl` + `backing.id`).
///
/// Negative Constraint: Do not use for modifying an existing pledge; use `UpdateBackingMutation`.
public struct CreateCheckoutMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CreateCheckoutInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation createBacking($input: CreateCheckoutInput!) {
      createBacking(input: $input) {
        clientMutationId
        checkout {
          id
          paymentUrl
        }
        backing {
          id
        }
      }
    }
    """
  }
}
