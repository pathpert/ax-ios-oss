import Foundation

/// GraphQL mutation saving/watching a project for launch and reminder notifications.
///
/// Negative Constraint: Requires an authenticated session; use `UnwatchProjectMutation` to revert.
public struct WatchProjectMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `WatchProjectInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    let desc = """
    mutation watchProject($input: WatchProjectInput!) {
      watchProject(input: $input) {
        clientMutationId
        project {
          id
          isWatched
        }
      }
    }
    """

    return desc
  }
}
