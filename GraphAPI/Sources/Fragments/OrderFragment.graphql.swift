// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `OrderFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct OrderFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment OrderFragment on Order { __typename id checkoutState currency total }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Order }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", GraphAPI.ID.self),
    .field("checkoutState", GraphQLEnum<GraphAPI.CheckoutStateEnum>.self),
    .field("currency", GraphQLEnum<GraphAPI.CurrencyCode>.self),
    .field("total", Int?.self),
  ] }

  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The state of checkout (taking into account order and cart status)
  public var checkoutState: GraphQLEnum<GraphAPI.CheckoutStateEnum> { __data["checkoutState"] }
  /// The currency of the order
  public var currency: GraphQLEnum<GraphAPI.CurrencyCode> { __data["currency"] }
  /// The total cost for the order including taxes and shipping
  public var total: Int? { __data["total"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    id: GraphAPI.ID,
    checkoutState: GraphQLEnum<GraphAPI.CheckoutStateEnum>,
    currency: GraphQLEnum<GraphAPI.CurrencyCode>,
    total: Int? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Order.typename,
        "id": id,
        "checkoutState": checkoutState,
        "currency": currency,
        "total": total,
      ],
      fulfilledFragments: [
        ObjectIdentifier(OrderFragment.self)
      ]
    ))
  }
}
