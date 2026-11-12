// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `PaymentSourceFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct PaymentSourceFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment PaymentSourceFragment on PaymentSource { __typename ... on CreditCard { expirationDate id lastFour paymentType type stripeCardId } ... on BankAccount { id lastFour bankName } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Unions.PaymentSource }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .inlineFragment(AsCreditCard.self),
    .inlineFragment(AsBankAccount.self),
  ] }

  /// Inline fragment projection as `AsCreditCard?`, or `nil` if `__typename` differs.
  public var asCreditCard: AsCreditCard? { _asInlineFragment() }
  /// Inline fragment projection as `AsBankAccount?`, or `nil` if `__typename` differs.
  public var asBankAccount: AsBankAccount? { _asInlineFragment() }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    __typename: String
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": __typename,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PaymentSourceFragment.self)
      ]
    ))
  }

  /// AsCreditCard
  ///
  /// Parent Type: `CreditCard`
  public struct AsCreditCard: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `PaymentSourceFragment`.
    public typealias RootEntityType = PaymentSourceFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreditCard }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("expirationDate", GraphAPI.Date.self),
      .field("id", String.self),
      .field("lastFour", String.self),
      .field("paymentType", GraphQLEnum<GraphAPI.CreditCardPaymentType>.self),
      .field("type", GraphQLEnum<GraphAPI.CreditCardTypes>.self),
      .field("stripeCardId", String.self),
    ] }

    /// When the credit card expires.
    public var expirationDate: GraphAPI.Date { __data["expirationDate"] }
    /// The card ID
    public var id: String { __data["id"] }
    /// The last four digits of the credit card number.
    public var lastFour: String { __data["lastFour"] }
    /// The card's payment type.
    public var paymentType: GraphQLEnum<GraphAPI.CreditCardPaymentType> { __data["paymentType"] }
    /// The card type.
    public var type: GraphQLEnum<GraphAPI.CreditCardTypes> { __data["type"] }
    /// Stripe card id
    public var stripeCardId: String { __data["stripeCardId"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      expirationDate: GraphAPI.Date,
      id: String,
      lastFour: String,
      paymentType: GraphQLEnum<GraphAPI.CreditCardPaymentType>,
      type: GraphQLEnum<GraphAPI.CreditCardTypes>,
      stripeCardId: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.CreditCard.typename,
          "expirationDate": expirationDate,
          "id": id,
          "lastFour": lastFour,
          "paymentType": paymentType,
          "type": type,
          "stripeCardId": stripeCardId,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PaymentSourceFragment.self),
          ObjectIdentifier(PaymentSourceFragment.AsCreditCard.self)
        ]
      ))
    }
  }

  /// AsBankAccount
  ///
  /// Parent Type: `BankAccount`
  public struct AsBankAccount: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `PaymentSourceFragment`.
    public typealias RootEntityType = PaymentSourceFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.BankAccount }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("id", String.self),
      .field("lastFour", String.self),
      .field("bankName", String?.self),
    ] }

    /// Relay global node identifier (`GraphAPI.ID`).
    public var id: String { __data["id"] }
    /// The last four digits of the account number.
    public var lastFour: String { __data["lastFour"] }
    /// The bank name if available.
    public var bankName: String? { __data["bankName"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      id: String,
      lastFour: String,
      bankName: String? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.BankAccount.typename,
          "id": id,
          "lastFour": lastFour,
          "bankName": bankName,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PaymentSourceFragment.self),
          ObjectIdentifier(PaymentSourceFragment.AsBankAccount.self)
        ]
      ))
    }
  }
}
