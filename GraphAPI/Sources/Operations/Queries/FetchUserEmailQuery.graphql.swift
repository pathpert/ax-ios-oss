// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchUserEmailQuery`.
public class FetchUserEmailQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchUserEmail"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchUserEmail { me { __typename ...UserEmailFragment } }"#,
      fragments: [UserEmailFragment.self]
    ))

  /// Creates an instance with explicit GraphQL field or variable values.
  public init() {}

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Query }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("me", Me?.self),
    ] }

    /// You.
    public var me: Me? { __data["me"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      me: Me? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "me": me._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchUserEmailQuery.Data.self)
        ]
      ))
    }

    /// Me
    ///
    /// Parent Type: `User`
    public struct Me: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .fragment(UserEmailFragment.self),
      ] }

      /// A user's email address.
      public var email: String? { __data["email"] }

      /// Container of reusable GraphQL fragment views for this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL variable or field `userEmailFragment`.
        public var userEmailFragment: UserEmailFragment { _toFragment() }
      }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        email: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.User.typename,
            "email": email,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchUserEmailQuery.Data.Me.self),
            ObjectIdentifier(UserEmailFragment.self)
          ]
        ))
      }
    }
  }
}
