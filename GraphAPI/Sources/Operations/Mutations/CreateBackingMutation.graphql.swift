// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateBackingMutation`.
public class CreateBackingMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CreateBacking"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateBacking($input: CreateBackingInput!) { createBacking(input: $input) { __typename checkout { __typename ...CheckoutFragment } } }"#,
      fragments: [CheckoutFragment.self]
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateBackingInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateBackingInput) {
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
      .field("createBacking", CreateBacking?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a backing and checkout and process payment.
    public var createBacking: CreateBacking? { __data["createBacking"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createBacking: CreateBacking? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createBacking": createBacking._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateBackingMutation.Data.self)
        ]
      ))
    }

    /// CreateBacking
    ///
    /// Parent Type: `CreateBackingPayload`
    public struct CreateBacking: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateBackingPayload }
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
            "__typename": GraphAPI.Objects.CreateBackingPayload.typename,
            "checkout": checkout._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateBackingMutation.Data.CreateBacking.self)
          ]
        ))
      }

      /// CreateBacking.Checkout
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
              ObjectIdentifier(CreateBackingMutation.Data.CreateBacking.Checkout.self),
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
