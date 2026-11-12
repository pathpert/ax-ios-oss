// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreatePaymentIntentMutation`.
public class CreatePaymentIntentMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "createPaymentIntent"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createPaymentIntent($input: CreatePaymentIntentInput!) { createPaymentIntent(input: $input) { __typename clientSecret clientMutationId } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreatePaymentIntentInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreatePaymentIntentInput) {
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
      .field("createPaymentIntent", CreatePaymentIntent?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a Stripe PaymentIntent in order to collect an on-session payment via the Stripe PaymentElement
    public var createPaymentIntent: CreatePaymentIntent? { __data["createPaymentIntent"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createPaymentIntent: CreatePaymentIntent? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createPaymentIntent": createPaymentIntent._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreatePaymentIntentMutation.Data.self)
        ]
      ))
    }

    /// CreatePaymentIntent
    ///
    /// Parent Type: `CreatePaymentIntentPayload`
    public struct CreatePaymentIntent: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreatePaymentIntentPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientSecret", String.self),
        .field("clientMutationId", String?.self),
      ] }

      /// the stripe payment intent client secret used to complete a payment
      public var clientSecret: String { __data["clientSecret"] }
      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientSecret: String,
        clientMutationId: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreatePaymentIntentPayload.typename,
            "clientSecret": clientSecret,
            "clientMutationId": clientMutationId,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreatePaymentIntentMutation.Data.CreatePaymentIntent.self)
          ]
        ))
      }
    }
  }
}
