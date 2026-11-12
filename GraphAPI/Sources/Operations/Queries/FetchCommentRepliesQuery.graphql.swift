// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchCommentRepliesQuery`.
public class FetchCommentRepliesQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchCommentReplies"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchCommentReplies($commentId: ID!, $cursor: String, $limit: Int!) { comment: node(id: $commentId) { __typename ...CommentWithRepliesFragment } }"#,
      fragments: [CommentBaseFragment.self, CommentFragment.self, CommentWithRepliesFragment.self]
    ))

  /// GraphQL variable or field `commentId`.
  public var commentId: ID
  /// GraphQL variable or field `cursor`.
  public var cursor: GraphQLNullable<String>
  /// GraphQL variable or field `limit`.
  public var limit: Int

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    commentId: ID,
    cursor: GraphQLNullable<String>,
    limit: Int
  ) {
    self.commentId = commentId
    self.cursor = cursor
    self.limit = limit
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "commentId": commentId,
    "cursor": cursor,
    "limit": limit
  ] }

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
      .field("node", alias: "comment", Comment?.self, arguments: ["id": .variable("commentId")]),
    ] }

    /// Fetches an object given its ID.
    public var comment: Comment? { __data["comment"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      comment: Comment? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "comment": comment._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchCommentRepliesQuery.Data.self)
        ]
      ))
    }

    /// Comment
    ///
    /// Parent Type: `Node`
    public struct Comment: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Interfaces.Node }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .inlineFragment(AsComment.self),
      ] }

      /// GraphQL variable or field `asComment`.
      public var asComment: AsComment? { _asInlineFragment() }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        __typename: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": __typename,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchCommentRepliesQuery.Data.Comment.self)
          ]
        ))
      }

      /// Comment.AsComment
      ///
      /// Parent Type: `Comment`
      public struct AsComment: GraphAPI.InlineFragment {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// Type alias for `RootEntityType` nested GraphQL selection set.
        public typealias RootEntityType = FetchCommentRepliesQuery.Data.Comment
        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Comment }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .fragment(CommentWithRepliesFragment.self),
        ] }

        /// The replies on a comment
        public var replies: Replies? { __data["replies"] }
        /// The author of the comment
        public var author: Author? { __data["author"] }
        /// The badges for the comment author
        public var authorBadges: [GraphQLEnum<GraphAPI.CommentBadge>?]? { __data["authorBadges"] }
        /// The body of the comment
        public var body: String { __data["body"] }
        /// When was this comment posted
        public var createdAt: GraphAPI.DateTime? { __data["createdAt"] }
        /// Whether the comment is deleted
        public var deleted: Bool { __data["deleted"] }
        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// The ID of the parent comment
        public var parentId: String? { __data["parentId"] }
        /// Whether a comment has any flaggings
        public var hasFlaggings: Bool { __data["hasFlaggings"] }
        /// Whether the comment author has been removed by kickstarter
        public var removedPerGuidelines: Bool { __data["removedPerGuidelines"] }
        /// Whether this comment has been reviewed and sustained by an admin
        public var sustained: Bool { __data["sustained"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `commentWithRepliesFragment`.
          public var commentWithRepliesFragment: CommentWithRepliesFragment { _toFragment() }
          /// GraphQL variable or field `commentBaseFragment`.
          public var commentBaseFragment: CommentBaseFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          replies: Replies? = nil,
          author: Author? = nil,
          authorBadges: [GraphQLEnum<GraphAPI.CommentBadge>?]? = nil,
          body: String,
          createdAt: GraphAPI.DateTime? = nil,
          deleted: Bool,
          id: GraphAPI.ID,
          parentId: String? = nil,
          hasFlaggings: Bool,
          removedPerGuidelines: Bool,
          sustained: Bool
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Comment.typename,
              "replies": replies._fieldData,
              "author": author._fieldData,
              "authorBadges": authorBadges,
              "body": body,
              "createdAt": createdAt,
              "deleted": deleted,
              "id": id,
              "parentId": parentId,
              "hasFlaggings": hasFlaggings,
              "removedPerGuidelines": removedPerGuidelines,
              "sustained": sustained,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchCommentRepliesQuery.Data.Comment.self),
              ObjectIdentifier(FetchCommentRepliesQuery.Data.Comment.AsComment.self),
              ObjectIdentifier(CommentWithRepliesFragment.self),
              ObjectIdentifier(CommentBaseFragment.self)
            ]
          ))
        }

        /// Type alias for `Replies` nested GraphQL selection set.
        public typealias Replies = CommentWithRepliesFragment.Replies

        /// Type alias for `Author` nested GraphQL selection set.
        public typealias Author = CommentBaseFragment.Author
      }
    }
  }
}
