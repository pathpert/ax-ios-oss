import Foundation

/// GraphQL mutation posting a top-level comment or reply on a project or campaign update.
///
/// Negative Constraint: Do not pass unvalidated empty strings; ensure body text meets campaign comment guidelines.
public struct PostCommentMutation<T: GraphMutationInput>: GraphMutation {
  var input: T

  /// Creates the mutation with typed `PostCommentInput`.
  public init(input: T) {
    self.input = input
  }

  /// Raw GraphQL mutation document string.
  public var description: String {
    return """
    mutation ($input: PostCommentInput!) {
      createComment(input: $input) {
        comment {
          author {
            id
            imageUrl(width: 200)
            isBlocked
            isCreator
            name
          }
          authorBadges
          body
          createdAt
          deleted
          parentId
          id
          replies {
            totalCount
          }
        }
      }
    }
    """
  }
}
