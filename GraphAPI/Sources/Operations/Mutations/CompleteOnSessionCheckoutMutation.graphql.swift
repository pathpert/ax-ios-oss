// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CompleteOnSessionCheckoutMutation`.
public class CompleteOnSessionCheckoutMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CompleteOnSessionCheckout"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CompleteOnSessionCheckout($input: CompleteOnSessionCheckoutInput!) { completeOnSessionCheckout(input: $input) { __typename checkout { __typename ...CheckoutFragment } } }"#,
      fragments: [CheckoutFragment.self]
    ))

  /// GraphQL variable or field `input`.
  public var input: CompleteOnSessionCheckoutInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CompleteOnSessionCheckoutInput) {
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
      .field("completeOnSessionCheckout", CompleteOnSessionCheckout?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Complete a checkout originating from an session payment
    public var completeOnSessionCheckout: CompleteOnSessionCheckout? { __data["completeOnSessionCheckout"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      completeOnSessionCheckout: CompleteOnSessionCheckout? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "completeOnSessionCheckout": completeOnSessionCheckout._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CompleteOnSessionCheckoutMutation.Data.self)
        ]
      ))
    }

    /// CompleteOnSessionCheckout
    ///
    /// Parent Type: `CompleteOnSessionCheckoutPayload`
    public struct CompleteOnSessionCheckout: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CompleteOnSessionCheckoutPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("checkout", Checkout?.self),
      ] }

      /// GraphQL variable or field `checkout`.
      public var checkout: Checkout? { __data["checkout"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        checkout: Checkout? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CompleteOnSessionCheckoutPayload.typename,
            "checkout": checkout._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CompleteOnSessionCheckoutMutation.Data.CompleteOnSessionCheckout.self)
          ]
        ))
      }

      /// CompleteOnSessionCheckout.Checkout
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
          .fragment(CheckoutFragment.self),
        ] }

        /// The backing that the checkout is modifying.
        public var backing: Backing { __data["backing"] }
        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// The current state of the checkout
        public var state: GraphQLEnum<GraphAPI.CheckoutState> { __data["state"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `checkoutFragment`.
          public var checkoutFragment: CheckoutFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          backing: Backing,
          id: GraphAPI.ID,
          state: GraphQLEnum<GraphAPI.CheckoutState>
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Checkout.typename,
              "backing": backing._fieldData,
              "id": id,
              "state": state,
            ],
            fulfilledFragments: [
              ObjectIdentifier(CompleteOnSessionCheckoutMutation.Data.CompleteOnSessionCheckout.Checkout.self),
              ObjectIdentifier(CheckoutFragment.self)
            ]
          ))
        }

        /// Type alias for `Backing` nested GraphQL selection set.
        public typealias Backing = CheckoutFragment.Backing
      }
    }
  }
}
