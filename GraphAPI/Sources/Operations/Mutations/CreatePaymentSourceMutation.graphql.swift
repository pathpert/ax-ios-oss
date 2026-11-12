// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreatePaymentSourceMutation`.
public class CreatePaymentSourceMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CreatePaymentSource"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreatePaymentSource($input: CreatePaymentSourceInput!) { createPaymentSource(input: $input) { __typename clientMutationId isSuccessful paymentSource { __typename ...PaymentSourceFragment } } }"#,
      fragments: [PaymentSourceFragment.self]
    ))

  /// GraphQL variable or field `input`.
  public var input: CreatePaymentSourceInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreatePaymentSourceInput) {
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
      .field("createPaymentSource", CreatePaymentSource?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a payment source
    public var createPaymentSource: CreatePaymentSource? { __data["createPaymentSource"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createPaymentSource: CreatePaymentSource? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createPaymentSource": createPaymentSource._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreatePaymentSourceMutation.Data.self)
        ]
      ))
    }

    /// CreatePaymentSource
    ///
    /// Parent Type: `CreatePaymentSourcePayload`
    public struct CreatePaymentSource: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreatePaymentSourcePayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientMutationId", String?.self),
        .field("isSuccessful", Bool.self),
        .field("paymentSource", PaymentSource?.self),
      ] }

      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }
      /// GraphQL variable or field `isSuccessful`.
      public var isSuccessful: Bool { __data["isSuccessful"] }
      /// GraphQL variable or field `paymentSource`.
      public var paymentSource: PaymentSource? { __data["paymentSource"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientMutationId: String? = nil,
        isSuccessful: Bool,
        paymentSource: PaymentSource? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreatePaymentSourcePayload.typename,
            "clientMutationId": clientMutationId,
            "isSuccessful": isSuccessful,
            "paymentSource": paymentSource._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreatePaymentSourceMutation.Data.CreatePaymentSource.self)
          ]
        ))
      }

      /// CreatePaymentSource.PaymentSource
      ///
      /// Parent Type: `CreditCard`
      public struct PaymentSource: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreditCard }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(PaymentSourceFragment.self),
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

        /// GraphQL variable or field `asBankAccount`.
        public var asBankAccount: AsBankAccount? { _asInlineFragment() }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `paymentSourceFragment`.
          public var paymentSourceFragment: PaymentSourceFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
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
              ObjectIdentifier(CreatePaymentSourceMutation.Data.CreatePaymentSource.PaymentSource.self),
              ObjectIdentifier(PaymentSourceFragment.self),
              ObjectIdentifier(PaymentSourceFragment.AsCreditCard.self)
            ]
          ))
        }

        /// CreatePaymentSource.PaymentSource.AsBankAccount
        ///
        /// Parent Type: `BankAccount`
        public struct AsBankAccount: GraphAPI.InlineFragment, ApolloAPI.CompositeInlineFragment {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// Type alias for `RootEntityType` nested GraphQL selection set.
          public typealias RootEntityType = CreatePaymentSourceMutation.Data.CreatePaymentSource.PaymentSource
          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.BankAccount }
          /// Static GraphQL metadata `__mergedSources`.
          public static var __mergedSources: [any ApolloAPI.SelectionSet.Type] { [
            CreatePaymentSourceMutation.Data.CreatePaymentSource.PaymentSource.self,
            PaymentSourceFragment.AsCreditCard.self,
            PaymentSourceFragment.AsBankAccount.self
          ] }

          /// When the credit card expires.
          public var expirationDate: GraphAPI.Date { __data["expirationDate"] }
          /// Unique GraphQL node identifier.
          public var id: String { __data["id"] }
          /// The last four digits of the account number.
          public var lastFour: String { __data["lastFour"] }
          /// The card's payment type.
          public var paymentType: GraphQLEnum<GraphAPI.CreditCardPaymentType> { __data["paymentType"] }
          /// The card type.
          public var type: GraphQLEnum<GraphAPI.CreditCardTypes> { __data["type"] }
          /// Stripe card id
          public var stripeCardId: String { __data["stripeCardId"] }
          /// The bank name if available.
          public var bankName: String? { __data["bankName"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `paymentSourceFragment`.
            public var paymentSourceFragment: PaymentSourceFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            expirationDate: GraphAPI.Date,
            id: String,
            lastFour: String,
            paymentType: GraphQLEnum<GraphAPI.CreditCardPaymentType>,
            type: GraphQLEnum<GraphAPI.CreditCardTypes>,
            stripeCardId: String,
            bankName: String? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.BankAccount.typename,
                "expirationDate": expirationDate,
                "id": id,
                "lastFour": lastFour,
                "paymentType": paymentType,
                "type": type,
                "stripeCardId": stripeCardId,
                "bankName": bankName,
              ],
              fulfilledFragments: [
                ObjectIdentifier(CreatePaymentSourceMutation.Data.CreatePaymentSource.PaymentSource.self),
                ObjectIdentifier(CreatePaymentSourceMutation.Data.CreatePaymentSource.PaymentSource.AsBankAccount.self),
                ObjectIdentifier(PaymentSourceFragment.self),
                ObjectIdentifier(PaymentSourceFragment.AsCreditCard.self),
                ObjectIdentifier(PaymentSourceFragment.AsBankAccount.self)
              ]
            ))
          }
        }
      }
    }
  }
}
