import Foundation

/// GraphQL mutation updating an existing project backing (reward, amount, or payment source).
///
/// Negative Constraint: Do not use for creating a brand-new pledge; use `CreateBackingMutation`.
public struct UpdateBackingMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `UpdateBackingInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation updateBacking($input: UpdateBackingInput!) {
      updateBacking(input: $input) {
        checkout {
          id
          state
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
