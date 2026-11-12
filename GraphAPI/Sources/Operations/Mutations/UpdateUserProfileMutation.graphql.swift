// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `UpdateUserProfileMutation`.
public class UpdateUserProfileMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "UpdateUserProfile"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation UpdateUserProfile($input: UpdateUserProfileInput!) { updateUserProfile(input: $input) { __typename clientMutationId } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: UpdateUserProfileInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: UpdateUserProfileInput) {
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
      .field("updateUserProfile", UpdateUserProfile?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Update user's profile
    public var updateUserProfile: UpdateUserProfile? { __data["updateUserProfile"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      updateUserProfile: UpdateUserProfile? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "updateUserProfile": updateUserProfile._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UpdateUserProfileMutation.Data.self)
        ]
      ))
    }

    /// UpdateUserProfile
    ///
    /// Parent Type: `UpdateUserProfilePayload`
    public struct UpdateUserProfile: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UpdateUserProfilePayload }
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
            "__typename": GraphAPI.Objects.UpdateUserProfilePayload.typename,
            "clientMutationId": clientMutationId,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UpdateUserProfileMutation.Data.UpdateUserProfile.self)
          ]
        ))
      }
    }
  }
}
