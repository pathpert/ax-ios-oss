import Foundation
import GraphAPI

/// @deprecated Legacy content-flagging input primitive.
/// Prefer `CreateFlaggingRequestSchema` and `EngagementController.handleCreateFlagging(payload:headers:)`
/// in `KsApi/modules/engagement`.
public struct CreateFlaggingInput: GraphMutationInput {
  let contentId: String
  let kind: GraphAPI.NonDeprecatedFlaggingKind
  let details: String?
  let clientMutationId: String?

  private enum CodingKeys: String, CodingKey {
    case contentId
    case kind
    case details
    case clientMutationId
  }

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

  /// Encodes fields cleanly for typed `GraphMutationInput` / `AXGraphMutationBody` serialization.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.contentId, forKey: .contentId)
    try container.encode(self.kind.rawValue, forKey: .kind)
    try container.encodeIfPresent(self.details, forKey: .details)
    try container.encodeIfPresent(self.clientMutationId, forKey: .clientMutationId)
  }
}
