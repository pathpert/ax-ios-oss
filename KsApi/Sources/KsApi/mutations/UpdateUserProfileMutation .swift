import Foundation

/// GraphQL mutation updating public creator/backer profile fields (such as chosen currency).
///
/// Negative Constraint: Do not use for password or email changes; use `UpdateUserAccountMutation`.
public struct UpdateUserProfileMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed profile update input (`ChangeCurrencyInput`).
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation updateUserProfile($input: UpdateUserProfileInput!) {
      updateUserProfile(input: $input) {
        clientMutationId
      }
    }
    """
  }
}
