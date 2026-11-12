import Foundation
import GraphAPI

/// GraphQL order state and integer-cent total associated with a late pledge or checkout session.
public struct Order: Equatable, Decodable {
  /// Current checkout completion state.
  public let checkoutState: CheckoutState
  /// ISO 4217 currency code for `total`.
  public let currency: String
  /// Order total in integer minor currency units (cents), when available.
  public let total: Int?

  /// Creates an `Order`.
  public init(
    checkoutState: CheckoutState,
    currency: String,
    total: Int?
  ) {
    self.checkoutState = checkoutState
    self.currency = currency
    self.total = total
  }
}

/// Server checkout workflow state for an `Order`.
public enum CheckoutState: String, Decodable {
  case complete
  case inProgress = "in_progress"
  case notStarted = "not_started"
}

extension Order {
  /// Initializes an `Order` from a GraphQL `OrderFragment`, returning `nil` if `checkoutState` is unrecognized.
  public init?(withGraphQLFragment fragment: GraphAPI.OrderFragment) {
    guard let checkoutState = CheckoutState(rawValue: fragment.checkoutState.rawValue) else {
      return nil
    }

    self.checkoutState = checkoutState
    self.currency = fragment.currency.rawValue
    self.total = fragment.total
  }
}
