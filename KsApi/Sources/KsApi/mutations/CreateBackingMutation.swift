import Foundation

/// GraphQL mutation creating a project backing and returning checkout SCA requirements.
///
/// Negative Constraint: Prefer `BackingController` / `CreateBackingMutation` generated Apollo operations for new checkout flows.
public struct CreateBackingMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CreateBackingInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation createBacking($input: CreateBackingInput!) {
      createBacking(input: $input) {
        clientMutationId
        checkout {
          state
          id
          backing {
            requiresAction
            clientSecret
          }
        }
      }
    }
    """
  }
}
