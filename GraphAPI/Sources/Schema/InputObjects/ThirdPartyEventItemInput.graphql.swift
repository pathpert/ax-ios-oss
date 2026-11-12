// @generated
// This file was automatically generated and should not be edited.

import ApolloAPI

/// Line-item payload sent within third-party attribution and conversion tracking events.
/// - Negative Constraint: Do not use outside `TriggerThirdPartyEventInput` payloads.
public struct ThirdPartyEventItemInput: InputObject {
  /// Raw GraphQL input dictionary backing this input object.
  public private(set) var __data: InputDict

  /// Initializes the input wrapper from a pre-built GraphQL dictionary.
  /// - Negative Constraint: Prefer the typed initializer instead of passing untyped keys manually.
  public init(_ data: InputDict) {
    __data = data
  }

  /// Creates an event line-item payload with item identifier, price, and quantity.
  public init(
    itemId: String,
    itemName: String,
    price: GraphQLNullable<Double> = nil
  ) {
    __data = InputDict([
      "itemId": itemId,
      "itemName": itemName,
      "price": price
    ])
  }

  /// The ID of the item.
  public var itemId: String {
    get { __data["itemId"] }
    set { __data["itemId"] = newValue }
  }

  /// The name of the item.
  public var itemName: String {
    get { __data["itemName"] }
    set { __data["itemName"] = newValue }
  }

  /// The monetary price of the item, in units of the specified currency parameter.
  public var price: GraphQLNullable<Double> {
    get { __data["price"] }
    set { __data["price"] = newValue }
  }
}
