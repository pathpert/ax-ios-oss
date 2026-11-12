// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `MoneyFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct MoneyFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment MoneyFragment on Money { __typename amount currency symbol }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("amount", String?.self),
    .field("currency", GraphQLEnum<GraphAPI.CurrencyCode>?.self),
    .field("symbol", String?.self),
  ] }

  /// Floating-point numeric value of monetary amount represented as a string
  public var amount: String? { __data["amount"] }
  /// Currency of the monetary amount
  public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
  /// Symbol of the currency in which the monetary amount appears
  public var symbol: String? { __data["symbol"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    amount: String? = nil,
    currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
    symbol: String? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Money.typename,
        "amount": amount,
        "currency": currency,
        "symbol": symbol,
      ],
      fulfilledFragments: [
        ObjectIdentifier(MoneyFragment.self)
      ]
    ))
  }
}
