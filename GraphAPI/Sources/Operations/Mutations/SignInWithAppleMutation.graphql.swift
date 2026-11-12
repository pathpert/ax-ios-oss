// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `SignInWithAppleMutation`.
public class SignInWithAppleMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "signInWithApple"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation signInWithApple($input: SignInWithAppleInput!) { signInWithApple(input: $input) { __typename apiAccessToken user { __typename uid } } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: SignInWithAppleInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: SignInWithAppleInput) {
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
      .field("signInWithApple", SignInWithApple?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Signs in or sign up a user via the Sign in With Apple service
    public var signInWithApple: SignInWithApple? { __data["signInWithApple"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      signInWithApple: SignInWithApple? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "signInWithApple": signInWithApple._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(SignInWithAppleMutation.Data.self)
        ]
      ))
    }

    /// SignInWithApple
    ///
    /// Parent Type: `SignInWithApplePayload`
    public struct SignInWithApple: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.SignInWithApplePayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("apiAccessToken", String?.self),
        .field("user", User?.self),
      ] }

      /// GraphQL variable or field `apiAccessToken`.
      public var apiAccessToken: String? { __data["apiAccessToken"] }
      /// GraphQL variable or field `user`.
      public var user: User? { __data["user"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        apiAccessToken: String? = nil,
        user: User? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.SignInWithApplePayload.typename,
            "apiAccessToken": apiAccessToken,
            "user": user._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SignInWithAppleMutation.Data.SignInWithApple.self)
          ]
        ))
      }

      /// SignInWithApple.User
      ///
      /// Parent Type: `User`
      public struct User: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("uid", String.self),
        ] }

        /// A user's uid
        public var uid: String { __data["uid"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          uid: String
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.User.typename,
              "uid": uid,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SignInWithAppleMutation.Data.SignInWithApple.User.self)
            ]
          ))
        }
      }
    }
  }
}
