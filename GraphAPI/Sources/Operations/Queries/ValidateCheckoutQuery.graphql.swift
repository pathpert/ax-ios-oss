// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `ValidateCheckoutQuery`.
public class ValidateCheckoutQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "ValidateCheckout"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ValidateCheckout($checkoutId: ID!, $paymentSourceId: String!, $paymentIntentClientSecret: String!) { checkout(id: $checkoutId) { __typename isValidForOnSessionCheckout( stripePaymentMethodId: $paymentSourceId paymentIntentClientSecret: $paymentIntentClientSecret ) { __typename valid messages } } }"#
    ))

  /// GraphQL variable or field `checkoutId`.
  public var checkoutId: ID
  /// GraphQL variable or field `paymentSourceId`.
  public var paymentSourceId: String
  /// GraphQL variable or field `paymentIntentClientSecret`.
  public var paymentIntentClientSecret: String

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    checkoutId: ID,
    paymentSourceId: String,
    paymentIntentClientSecret: String
  ) {
    self.checkoutId = checkoutId
    self.paymentSourceId = paymentSourceId
    self.paymentIntentClientSecret = paymentIntentClientSecret
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "checkoutId": checkoutId,
    "paymentSourceId": paymentSourceId,
    "paymentIntentClientSecret": paymentIntentClientSecret
  ] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Query }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("checkout", Checkout?.self, arguments: ["id": .variable("checkoutId")]),
    ] }

    /// Fetches a checkout given its id.
    public var checkout: Checkout? { __data["checkout"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      checkout: Checkout? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "checkout": checkout._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ValidateCheckoutQuery.Data.self)
        ]
      ))
    }

    /// Checkout
    ///
    /// Parent Type: `Checkout`
    public struct Checkout: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Checkout }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("isValidForOnSessionCheckout", IsValidForOnSessionCheckout.self, arguments: [
          "stripePaymentMethodId": .variable("paymentSourceId"),
          "paymentIntentClientSecret": .variable("paymentIntentClientSecret")
        ]),
      ] }

      /// Checks whether the checkout is valid prior to charging the user's card.
      public var isValidForOnSessionCheckout: IsValidForOnSessionCheckout { __data["isValidForOnSessionCheckout"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        isValidForOnSessionCheckout: IsValidForOnSessionCheckout
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Checkout.typename,
            "isValidForOnSessionCheckout": isValidForOnSessionCheckout._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ValidateCheckoutQuery.Data.Checkout.self)
          ]
        ))
      }

      /// Checkout.IsValidForOnSessionCheckout
      ///
      /// Parent Type: `Validation`
      public struct IsValidForOnSessionCheckout: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Validation }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("valid", Bool.self),
          .field("messages", [String].self),
        ] }

        /// Whether a value is valid.
        public var valid: Bool { __data["valid"] }
        /// Error messages associated with the value
        public var messages: [String] { __data["messages"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          valid: Bool,
          messages: [String]
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Validation.typename,
              "valid": valid,
              "messages": messages,
            ],
            fulfilledFragments: [
              ObjectIdentifier(ValidateCheckoutQuery.Data.Checkout.IsValidForOnSessionCheckout.self)
            ]
          ))
        }
      }
    }
  }
}
