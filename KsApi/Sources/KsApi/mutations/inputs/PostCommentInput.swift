import Foundation

/// @deprecated Legacy comment input primitive.
/// Prefer `PostCommentRequestSchema` and `CommentsController.handlePostComment(payload:headers:)`
/// in `KsApi/modules/comments`.
/// - Negative Constraint: Do not use for new comment submission callers; migrate to `PostCommentRequestSchema`.
public struct PostCommentInput: GraphMutationInput, Encodable {
  let body: String

  /// This is base64 encoded ID of the Project-{projectId}}
  let commentableId: String

  /// If the comment is on the project level, this is nil. For replies, this is the ID of the comment.
  let parentId: String?

  /// Creates a legacy comment mutation input.
  ///
  /// - Negative constraint: Do not pass a raw integer project ID to `commentableId`; pass the base64-encoded GraphQL node ID.
  public init(body: String, commentableId: String, parentId: String? = nil) {
    self.body = body
    self.commentableId = commentableId
    self.parentId = parentId
  }
}
