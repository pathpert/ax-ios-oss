import Foundation

/// GraphQL response envelope returned by the `updateBacking` mutation.
public struct UpdateBackingEnvelope: Decodable {
  /// Mutation payload containing the updated checkout state.
  public var updateBacking: UpdateBacking

  /// Inner payload wrapper around the updated `Checkout`.
  public struct UpdateBacking: Decodable {
    /// Updated checkout status and payment verification details.
    public var checkout: Checkout
  }
}
