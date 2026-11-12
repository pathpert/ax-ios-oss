import Foundation

/// @deprecated Legacy cancel-backing input primitive.
/// Prefer `CancelBackingRequestSchema` and `CheckoutController.handleCancelBacking(payload:headers:)`
/// in `KsApi/modules/checkout` which enforces Base64 GraphID validation, Idempotency-Key safety,
/// and RFC 9457 Problem Details errors.
/// - Negative Constraint: Do not use for new cancellation flows; migrate callers to `CancelBackingRequestSchema`.
public struct CancelBackingInput: GraphMutationInput {
  let backingId: String
  let cancellationReason: String?

  /// Initializes a legacy `CancelBackingInput` for `CancelBackingMutation`.
  /// - parameter backingId: Base64 GraphQL ID of the backing.
  /// - parameter cancellationReason: Optional user-provided cancellation note.
  public init(backingId: String, cancellationReason: String? = nil) {
    self.backingId = backingId
    self.cancellationReason = cancellationReason
  }
}

extension CancelBackingInput: Encodable {
  enum CodingKeys: String, CodingKey {
    case backingId = "id"
    case cancellationReason = "note"
  }
}
