import Foundation

/// @deprecated Legacy watch/unwatch project input primitive using `[String: Any]` dictionary serialization.
/// Prefer `WatchProjectRequestSchema` and `EngagementController` in `KsApi/modules/engagement`.
/// - Negative Constraint: Do not use for new project watch callers; migrate to `WatchProjectRequestSchema`.
public struct WatchProjectInput: GraphMutationInput, Encodable {
  let clientMutationId: String?
  let id: String
  let trackingContext: String?

  /// Creates a legacy watch/unwatch project mutation input.
  ///
  /// - Negative constraint: Do not pass a URL slug for `id`; pass the GraphQL project ID.
  public init(clientMutationId: String? = nil, id: String, trackingContext: String? = nil) {
    self.clientMutationId = clientMutationId
    self.id = id
    self.trackingContext = trackingContext
  }
}
