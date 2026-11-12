import Foundation

/// GraphQL mutation unwatching (unsaving) a project for the signed-in viewer.
///
/// Negative Constraint: Requires an authenticated session; do not use on logged-out viewers.
public struct UnwatchProjectMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `UnwatchProjectInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    let desc = """
    mutation unwatchProject($input: UnwatchProjectInput!) {
      watchProject: unwatchProject(input: $input) {
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
