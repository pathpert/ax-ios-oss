import Foundation

/// GraphQL response envelope returned by `createBacking`.
public struct CreateBackingEnvelope: Decodable {
  /// Nested `createBacking` payload containing checkout state.
  public var createBacking: CreateBacking

  /// Inner payload wrapping the created `Checkout`.
  public struct CreateBacking: Decodable {
    /// Checkout state and SCA confirmation details for the newly created backing.
    public var checkout: Checkout
  }
}
