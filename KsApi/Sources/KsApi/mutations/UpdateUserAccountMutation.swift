import Foundation

/// GraphQL mutation updating account security or email settings on the viewer's account.
///
/// Negative Constraint: Do not use for public profile bio/name edits; use `UpdateUserProfileMutation`.
public struct UpdateUserAccountMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed account update input (`ChangeEmailInput`, `ChangePasswordInput`, etc.).
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation updateUserAccount($input: UpdateUserAccountInput!) {
      updateUserAccount(input: $input) {
        clientMutationId
      }
    }
    """
  }
}
