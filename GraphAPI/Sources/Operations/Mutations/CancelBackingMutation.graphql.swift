// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `CancelBackingMutation`.
public class CancelBackingMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "cancelBacking"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation cancelBacking($input: CancelBackingInput!) { cancelBacking(input: $input) { __typename clientMutationId } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: CancelBackingInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: CancelBackingInput) {
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
      .field("cancelBacking", CancelBacking?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Cancel a pledged backing
    public var cancelBacking: CancelBacking? { __data["cancelBacking"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      cancelBacking: CancelBacking? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "cancelBacking": cancelBacking._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CancelBackingMutation.Data.self)
        ]
      ))
    }

    /// CancelBacking
    ///
    /// Parent Type: `CancelBackingPayload`
    public struct CancelBacking: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CancelBackingPayload }
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
            "__typename": GraphAPI.Objects.CancelBackingPayload.typename,
            "clientMutationId": clientMutationId,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CancelBackingMutation.Data.CancelBacking.self)
          ]
        ))
      }
    }
  }
}
