import Foundation

/// GraphQL mutation requesting a verification email be resent to the viewer's primary address.
///
/// Negative Constraint: Rate-limited server-side; do not trigger automatically in tight loops.
public struct UserSendEmailVerificationMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with an `EmptyInput` payload.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation userSendEmailVerification($input: UserSendEmailVerificationInput!) {
      userSendEmailVerification(input: $input) {
        clientMutationId
      }
    }
    """
  }
}
