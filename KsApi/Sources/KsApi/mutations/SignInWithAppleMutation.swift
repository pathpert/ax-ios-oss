import Foundation

/// GraphQL mutation exchanging a Sign in with Apple authorization payload for a Kickstarter API access token.
///
/// Negative Constraint: Legacy direct GraphQL string mutation; prefer `AuthController.handleSignInWithApple`.
public struct SignInWithAppleMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `SignInWithAppleInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation signInWithApple($input: SignInWithAppleInput!) {
      signInWithApple(input: $input) {
        apiAccessToken
        user {
          uid
        }
      }
    }
    """
  }
}
