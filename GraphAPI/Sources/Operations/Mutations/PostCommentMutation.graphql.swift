// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `PostCommentMutation`.
public class PostCommentMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "PostComment"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation PostComment($input: PostCommentInput!) { createComment(input: $input) { __typename comment { __typename ...CommentFragment } } }"#,
      fragments: [CommentBaseFragment.self, CommentFragment.self]
    ))

  /// GraphQL variable or field `input`.
  public var input: PostCommentInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: PostCommentInput) {
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
      .field("createComment", CreateComment?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Post a comment
    public var createComment: CreateComment? { __data["createComment"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      createComment: CreateComment? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "createComment": createComment._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PostCommentMutation.Data.self)
        ]
      ))
    }

    /// CreateComment
    ///
    /// Parent Type: `PostCommentPayload`
    public struct CreateComment: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PostCommentPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("comment", Comment?.self),
      ] }

      /// GraphQL variable or field `comment`.
      public var comment: Comment? { __data["comment"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        comment: Comment? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.PostCommentPayload.typename,
            "comment": comment._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PostCommentMutation.Data.CreateComment.self)
          ]
        ))
      }

      /// CreateComment.Comment
      ///
      /// Parent Type: `Comment`
      public struct Comment: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Comment }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(CommentFragment.self),
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

          /// GraphQL variable or field `commentFragment`.
          public var commentFragment: CommentFragment { _toFragment() }
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
              ObjectIdentifier(PostCommentMutation.Data.CreateComment.Comment.self),
              ObjectIdentifier(CommentFragment.self),
              ObjectIdentifier(CommentBaseFragment.self)
            ]
          ))
        }

        /// Type alias for `Replies` nested GraphQL selection set.
        public typealias Replies = CommentFragment.Replies

        /// Type alias for `Author` nested GraphQL selection set.
        public typealias Author = CommentBaseFragment.Author
      }
    }
  }
}
