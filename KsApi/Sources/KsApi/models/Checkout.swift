import Foundation

// This model is used in multiple queries, if modified update UpdateBacking and CreateBacking mutations.
/// GraphQL checkout session state returned after creating or updating a backing.
public struct Checkout: Decodable {
  /// Encoded GraphQL identifier of the checkout session.
  public var id: String
  /// Current payment authorization/verification state.
  public var state: State
  /// Associated backing payment metadata, including SCA client secret when required.
  public var backing: Backing

  /// Checkout processing state machine reported by the backend.
  public enum State: String, Decodable, CaseIterable {
    /// Payment authorization is in progress.
    case authorizing = "AUTHORIZING"
    /// Additional verification (such as 3DS) is in progress.
    case verifying = "VERIFYING"
    /// Checkout completed successfully.
    case successful = "SUCCESSFUL"
    /// Checkout failed.
    case failed = "FAILED"
  }

  /// Payment confirmation details attached to a `Checkout`.
  public struct Backing: Decodable {
    /// Stripe PaymentIntent client secret used when `requiresAction == true`.
    public let clientSecret: String?
    /// `true` when 3DS/SCA user action is required before checkout completes.
    public let requiresAction: Bool
  }
}
