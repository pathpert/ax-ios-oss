// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `DeletePaymentSourceMutation`.
public class DeletePaymentSourceMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "DeletePaymentSource"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation DeletePaymentSource($input: PaymentSourceDeleteInput!) { paymentSourceDelete(input: $input) { __typename user { __typename storedCards { __typename ...UserStoredCardsFragment } } } }"#,
      fragments: [UserStoredCardsFragment.self]
    ))

  /// GraphQL variable or field `input`.
  public var input: PaymentSourceDeleteInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: PaymentSourceDeleteInput) {
    self.input = input
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["input": input] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Mutation }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("paymentSourceDelete", PaymentSourceDelete?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Delete a user's payment source
    public var paymentSourceDelete: PaymentSourceDelete? { __data["paymentSourceDelete"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      paymentSourceDelete: PaymentSourceDelete? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "paymentSourceDelete": paymentSourceDelete._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(DeletePaymentSourceMutation.Data.self)
        ]
      ))
    }

    /// PaymentSourceDelete
    ///
    /// Parent Type: `PaymentSourceDeletePayload`
    public struct PaymentSourceDelete: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PaymentSourceDeletePayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("user", User?.self),
      ] }

      /// GraphQL variable or field `user`.
      public var user: User? { __data["user"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        user: User? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.PaymentSourceDeletePayload.typename,
            "user": user._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(DeletePaymentSourceMutation.Data.PaymentSourceDelete.self)
          ]
        ))
      }

      /// PaymentSourceDelete.User
      ///
      /// Parent Type: `User`
      public struct User: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("storedCards", StoredCards?.self),
        ] }

        /// Stored Cards
        public var storedCards: StoredCards? { __data["storedCards"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          storedCards: StoredCards? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.User.typename,
              "storedCards": storedCards._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(DeletePaymentSourceMutation.Data.PaymentSourceDelete.User.self)
            ]
          ))
        }

        /// PaymentSourceDelete.User.StoredCards
        ///
        /// Parent Type: `UserCreditCardTypeConnection`
        public struct StoredCards: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UserCreditCardTypeConnection }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .fragment(UserStoredCardsFragment.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }
          /// GraphQL variable or field `totalCount`.
          public var totalCount: Int { __data["totalCount"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `userStoredCardsFragment`.
            public var userStoredCardsFragment: UserStoredCardsFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
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
                ObjectIdentifier(DeletePaymentSourceMutation.Data.PaymentSourceDelete.User.StoredCards.self),
                ObjectIdentifier(UserStoredCardsFragment.self)
              ]
            ))
          }

          /// Type alias for `Node` nested GraphQL selection set.
          public typealias Node = UserStoredCardsFragment.Node
        }
      }
    }
  }
}
