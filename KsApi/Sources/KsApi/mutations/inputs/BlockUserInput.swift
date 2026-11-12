import Foundation

/// @deprecated Legacy block-user input primitive.
/// Prefer `BlockUserRequestSchema` and `CommentsController.handleBlockUser(payload:headers:)`
/// in `KsApi/modules/comments`.
/// - Negative Constraint: Do not use for new block-user callers; migrate to `BlockUserRequestSchema`.
public struct BlockUserInput: GraphMutationInput, Encodable {
  let blockUserId: String

  /// Initializes a legacy block-user mutation input for the target user GraphID.
  /// - Negative Constraint: Prefer `BlockUserRequestSchema` in `KsApi/modules/comments`.
  public init(blockUserId: String) {
    self.blockUserId = blockUserId
  }
}
