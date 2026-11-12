import Foundation
import GraphAPI

/// @deprecated Legacy content-flagging input primitive using `[String: Any]` dictionary serialization.
/// Prefer `CreateFlaggingRequestSchema` and `EngagementController.handleCreateFlagging(payload:headers:)`
/// in `KsApi/modules/engagement`.
public struct CreateFlaggingInput: GraphMutationInput {
  let contentId: String
  let kind: GraphAPI.NonDeprecatedFlaggingKind
  let details: String?
  let clientMutationId: String?

  /// Creates a legacy content-flagging mutation input.
  public init(
    contentId: String,
    kind: GraphAPI.NonDeprecatedFlaggingKind,
    details: String?,
    clientMutationId: String?
  ) {
    self.contentId = contentId
    self.kind = kind
    self.details = details
    self.clientMutationId = clientMutationId
  }

  /// Serializes fields into an untyped GraphQL variable dictionary.
  ///
  /// Negative Constraint: Deprecated; migrate to `CreateFlaggingRequestSchema`.
  public func toInputDictionary() -> [String: Any] {
    return [
      "contentId": self.contentId,
      "kind": self.kind,
      "details": self.details,
      "clientMutationId": self.clientMutationId
    ]
  }
}
