// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `BlockUserMutation`.
public class BlockUserMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "blockUser"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation blockUser($input: BlockUserInput!) { blockUser(input: $input) { __typename success } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: BlockUserInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: BlockUserInput) {
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
      .field("blockUser", BlockUser?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Block a user
    public var blockUser: BlockUser? { __data["blockUser"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      blockUser: BlockUser? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "blockUser": blockUser._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(BlockUserMutation.Data.self)
        ]
      ))
    }

    /// BlockUser
    ///
    /// Parent Type: `BlockUserPayload`
    public struct BlockUser: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.BlockUserPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("success", Bool.self),
      ] }

      /// GraphQL variable or field `success`.
      public var success: Bool { __data["success"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        success: Bool
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.BlockUserPayload.typename,
            "success": success,
          ],
          fulfilledFragments: [
            ObjectIdentifier(BlockUserMutation.Data.BlockUser.self)
          ]
        ))
      }
    }
  }
}
