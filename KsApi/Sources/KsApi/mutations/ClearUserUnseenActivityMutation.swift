/// GraphQL mutation clearing the signed-in user's unseen activity badge counter.
///
/// Negative Constraint: Requires an authenticated user session; do not invoke while logged out.
public struct ClearUserUnseenActivityMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `ClearUserUnseenActivityInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation clearUserUnseenActivity($input: ClearUserUnseenActivityInput!) {
      clearUserUnseenActivity(input: $input) {
        clientMutationId
        activityIndicatorCount
      }
    }
    """
  }
}
