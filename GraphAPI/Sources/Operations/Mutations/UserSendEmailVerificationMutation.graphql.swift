// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `UserSendEmailVerificationMutation`.
public class UserSendEmailVerificationMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "userSendEmailVerification"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation userSendEmailVerification($input: UserSendEmailVerificationInput!) { userSendEmailVerification(input: $input) { __typename clientMutationId } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: UserSendEmailVerificationInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: UserSendEmailVerificationInput) {
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
      .field("userSendEmailVerification", UserSendEmailVerification?.self, arguments: ["input": .variable("input")]),
    ] }

    /// send email verification
    public var userSendEmailVerification: UserSendEmailVerification? { __data["userSendEmailVerification"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      userSendEmailVerification: UserSendEmailVerification? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "userSendEmailVerification": userSendEmailVerification._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UserSendEmailVerificationMutation.Data.self)
        ]
      ))
    }

    /// UserSendEmailVerification
    ///
    /// Parent Type: `UserSendEmailVerificationPayload`
    public struct UserSendEmailVerification: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UserSendEmailVerificationPayload }
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
            "__typename": GraphAPI.Objects.UserSendEmailVerificationPayload.typename,
            "clientMutationId": clientMutationId,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UserSendEmailVerificationMutation.Data.UserSendEmailVerification.self)
          ]
        ))
      }
    }
  }
}
