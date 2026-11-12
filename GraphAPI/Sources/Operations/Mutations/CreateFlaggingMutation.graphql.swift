// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CreateFlaggingMutation`.
public class CreateFlaggingMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "createFlagging"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation createFlagging($input: CreateFlaggingInput!) { createFlagging(input: $input) { __typename clientMutationId } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CreateFlaggingInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CreateFlaggingInput) {
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
      .field("createFlagging", CreateFlagging?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Create a flagging (report) of a piece flaggable content.
    public var createFlagging: CreateFlagging? { __data["createFlagging"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createFlagging: CreateFlagging? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createFlagging": createFlagging._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CreateFlaggingMutation.Data.self)
        ]
      ))
    }

    /// CreateFlagging
    ///
    /// Parent Type: `CreateFlaggingPayload`
    public struct CreateFlagging: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CreateFlaggingPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientMutationId", String?.self),
      ] }

      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientMutationId: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CreateFlaggingPayload.typename,
            "clientMutationId": clientMutationId,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CreateFlaggingMutation.Data.CreateFlagging.self)
          ]
        ))
      }
    }
  }
}
