// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `ClearUserUnseenActivityMutation`.
public class ClearUserUnseenActivityMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "clearUserUnseenActivity"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation clearUserUnseenActivity($input: ClearUserUnseenActivityInput!) { clearUserUnseenActivity(input: $input) { __typename clientMutationId activityIndicatorCount } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: ClearUserUnseenActivityInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: ClearUserUnseenActivityInput) {
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
      .field("clearUserUnseenActivity", ClearUserUnseenActivity?.self, arguments: ["input": .variable("input")]),
    ] }

    /// GraphQL variable or field `clearUserUnseenActivity`.
    public var clearUserUnseenActivity: ClearUserUnseenActivity? { __data["clearUserUnseenActivity"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      clearUserUnseenActivity: ClearUserUnseenActivity? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "clearUserUnseenActivity": clearUserUnseenActivity._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ClearUserUnseenActivityMutation.Data.self)
        ]
      ))
    }

    /// ClearUserUnseenActivity
    ///
    /// Parent Type: `ClearUserUnseenActivityPayload`
    public struct ClearUserUnseenActivity: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ClearUserUnseenActivityPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientMutationId", String?.self),
        .field("activityIndicatorCount", Int.self),
      ] }

      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }
      /// GraphQL variable or field `activityIndicatorCount`.
      public var activityIndicatorCount: Int { __data["activityIndicatorCount"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientMutationId: String? = nil,
        activityIndicatorCount: Int
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.ClearUserUnseenActivityPayload.typename,
            "clientMutationId": clientMutationId,
            "activityIndicatorCount": activityIndicatorCount,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ClearUserUnseenActivityMutation.Data.ClearUserUnseenActivity.self)
          ]
        ))
      }
    }
  }
}
