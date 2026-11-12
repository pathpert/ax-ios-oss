// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateCheckoutMutation`.
public class CreateCheckoutMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CreateCheckout"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateCheckout($input: CreateCheckoutInput!) { createCheckout(input: $input) { __typename clientMutationId checkout { __typename id paymentUrl backing { __typename id } } } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateCheckoutInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateCheckoutInput) {
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
      .field("createCheckout", CreateCheckout?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a backing and checkout without syncing to Rosie
    public var createCheckout: CreateCheckout? { __data["createCheckout"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createCheckout: CreateCheckout? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createCheckout": createCheckout._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateCheckoutMutation.Data.self)
        ]
      ))
    }

    /// CreateCheckout
    ///
    /// Parent Type: `CreateCheckoutPayload`
    public struct CreateCheckout: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateCheckoutPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientMutationId", String?.self),
        .field("checkout", Checkout?.self),
      ] }

      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }
      /// GraphQL variable or field `checkout`.
      public var checkout: Checkout? { __data["checkout"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientMutationId: String? = nil,
        checkout: Checkout? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreateCheckoutPayload.typename,
            "clientMutationId": clientMutationId,
            "checkout": checkout._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateCheckoutMutation.Data.CreateCheckout.self)
          ]
        ))
      }

      /// CreateCheckout.Checkout
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
          .field("id", GraphAPI.ID.self),
          .field("paymentUrl", String?.self),
          .field("backing", Backing.self),
        ] }

        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// GraphQL variable or field `paymentUrl`.
        public var paymentUrl: String? { __data["paymentUrl"] }
        /// The backing that the checkout is modifying.
        public var backing: Backing { __data["backing"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          id: GraphAPI.ID,
          paymentUrl: String? = nil,
          backing: Backing
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Checkout.typename,
              "id": id,
              "paymentUrl": paymentUrl,
              "backing": backing._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(CreateCheckoutMutation.Data.CreateCheckout.Checkout.self)
            ]
          ))
        }

        /// CreateCheckout.Checkout.Backing
        ///
        /// Parent Type: `Backing`
        public struct Backing: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("id", GraphAPI.ID.self),
          ] }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Backing.typename,
                "id": id,
              ],
              fulfilledFragments: [
                ObjectIdentifier(CreateCheckoutMutation.Data.CreateCheckout.Checkout.Backing.self)
              ]
            ))
          }
        }
      }
    }
  }
}
