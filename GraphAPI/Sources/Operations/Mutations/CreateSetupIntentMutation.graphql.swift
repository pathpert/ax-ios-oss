// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateSetupIntentMutation`.
public class CreateSetupIntentMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "CreateSetupIntent"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation CreateSetupIntent($input: CreateSetupIntentInput!) { createSetupIntent(input: $input) { __typename clientSecret } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateSetupIntentInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateSetupIntentInput) {
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
      .field("createSetupIntent", CreateSetupIntent?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a Stripe SetupIntent in order to render new Stripe Elements
    public var createSetupIntent: CreateSetupIntent? { __data["createSetupIntent"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createSetupIntent: CreateSetupIntent? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createSetupIntent": createSetupIntent._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateSetupIntentMutation.Data.self)
        ]
      ))
    }

    /// CreateSetupIntent
    ///
    /// Parent Type: `CreateSetupIntentPayload`
    public struct CreateSetupIntent: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateSetupIntentPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientSecret", String.self),
      ] }

      /// GraphQL variable or field `clientSecret`.
      public var clientSecret: String { __data["clientSecret"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientSecret: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreateSetupIntentPayload.typename,
            "clientSecret": clientSecret,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateSetupIntentMutation.Data.CreateSetupIntent.self)
          ]
        ))
      }
    }
  }
}
