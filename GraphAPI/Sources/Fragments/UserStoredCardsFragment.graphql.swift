// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `UserStoredCardsFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct UserStoredCardsFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment UserStoredCardsFragment on UserCreditCardTypeConnection { __typename nodes { __typename expirationDate id lastFour type stripeCardId } totalCount }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UserCreditCardTypeConnection }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("nodes", [Node?]?.self),
    .field("totalCount", Int.self),
  ] }

  /// A list of nodes.
  public var nodes: [Node?]? { __data["nodes"] }
  /// Total number of matching records in the connection.
  public var totalCount: Int { __data["totalCount"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    nodes: [Node?]? = nil,
    totalCount: Int
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.UserCreditCardTypeConnection.typename,
        "nodes": nodes._fieldData,
        "totalCount": totalCount,
      ],
      fulfilledFragments: [
        ObjectIdentifier(UserStoredCardsFragment.self)
      ]
    ))
  }

  /// Node
  ///
  /// Parent Type: `CreditCard`
  public struct Node: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreditCard }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("expirationDate", GraphAPI.Date.self),
      .field("id", String.self),
      .field("lastFour", String.self),
      .field("type", GraphQLEnum<GraphAPI.CreditCardTypes>.self),
      .field("stripeCardId", String.self),
    ] }

    /// When the credit card expires.
    public var expirationDate: GraphAPI.Date { __data["expirationDate"] }
    /// The card ID
    public var id: String { __data["id"] }
    /// The last four digits of the credit card number.
    public var lastFour: String { __data["lastFour"] }
    /// The card type.
    public var type: GraphQLEnum<GraphAPI.CreditCardTypes> { __data["type"] }
    /// Stripe card id
    public var stripeCardId: String { __data["stripeCardId"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      expirationDate: GraphAPI.Date,
      id: String,
      lastFour: String,
      type: GraphQLEnum<GraphAPI.CreditCardTypes>,
      stripeCardId: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.CreditCard.typename,
          "expirationDate": expirationDate,
          "id": id,
          "lastFour": lastFour,
          "type": type,
          "stripeCardId": stripeCardId,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UserStoredCardsFragment.Node.self)
        ]
      ))
    }
  }
}
