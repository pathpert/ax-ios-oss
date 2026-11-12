import Foundation

/// Legacy GraphQL mutation canceling an active pledge backing (`CancelBackingInput`).
///
/// Negative Constraint: Irreversible pledge cancellation; confirm user intent before invoking.
final class CancelBackingMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `CancelBackingInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation cancelBacking($input: CancelBackingInput!) {
      cancelBacking(input: $input) {
        clientMutationId
      }
    }
    """
  }
}
