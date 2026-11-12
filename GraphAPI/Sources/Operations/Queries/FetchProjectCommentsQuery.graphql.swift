// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchProjectCommentsQuery`.
public class FetchProjectCommentsQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchProjectComments"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchProjectComments($slug: String!, $cursor: String, $limit: Int) { project(slug: $slug) { __typename comments(after: $cursor, first: $limit) { __typename edges { __typename node { __typename ...CommentFragment } } pageInfo { __typename endCursor hasNextPage } totalCount } id slug } }"#,
      fragments: [CommentBaseFragment.self, CommentFragment.self]
    ))

  /// GraphQL variable or field `slug`.
  public var slug: String
  /// GraphQL variable or field `cursor`.
  public var cursor: GraphQLNullable<String>
  /// GraphQL variable or field `limit`.
  public var limit: GraphQLNullable<Int>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    slug: String,
    cursor: GraphQLNullable<String>,
    limit: GraphQLNullable<Int>
  ) {
    self.slug = slug
    self.cursor = cursor
    self.limit = limit
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "slug": slug,
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
      .field("project", Project?.self, arguments: ["slug": .variable("slug")]),
    ] }

    /// Fetches a project given its slug or pid.
    public var project: Project? { __data["project"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      project: Project? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "project": project._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchProjectCommentsQuery.Data.self)
        ]
      ))
    }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("comments", Comments?.self, arguments: [
          "after": .variable("cursor"),
          "first": .variable("limit")
        ]),
        .field("id", GraphAPI.ID.self),
        .field("slug", String.self),
      ] }

      /// List of comments on the commentable
      public var comments: Comments? { __data["comments"] }
      /// Unique GraphQL node identifier.
      public var id: GraphAPI.ID { __data["id"] }
      /// The project's unique URL identifier.
      public var slug: String { __data["slug"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        comments: Comments? = nil,
        id: GraphAPI.ID,
        slug: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "comments": comments._fieldData,
            "id": id,
            "slug": slug,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchProjectCommentsQuery.Data.Project.self)
          ]
        ))
      }

      /// Project.Comments
      ///
      /// Parent Type: `CommentConnection`
      public struct Comments: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CommentConnection }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("edges", [Edge?]?.self),
          .field("pageInfo", PageInfo.self),
          .field("totalCount", Int.self),
        ] }

        /// A list of edges.
        public var edges: [Edge?]? { __data["edges"] }
        /// Information to aid in pagination.
        public var pageInfo: PageInfo { __data["pageInfo"] }
        /// GraphQL variable or field `totalCount`.
        public var totalCount: Int { __data["totalCount"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          edges: [Edge?]? = nil,
          pageInfo: PageInfo,
          totalCount: Int
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.CommentConnection.typename,
              "edges": edges._fieldData,
              "pageInfo": pageInfo._fieldData,
              "totalCount": totalCount,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchProjectCommentsQuery.Data.Project.Comments.self)
            ]
          ))
        }

        /// Project.Comments.Edge
        ///
        /// Parent Type: `CommentEdge`
        public struct Edge: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CommentEdge }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("node", Node?.self),
          ] }

          /// The item at the end of the edge.
          public var node: Node? { __data["node"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            node: Node? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.CommentEdge.typename,
                "node": node._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchProjectCommentsQuery.Data.Project.Comments.Edge.self)
              ]
            ))
          }

          /// Project.Comments.Edge.Node
          ///
          /// Parent Type: `Comment`
          public struct Node: GraphAPI.SelectionSet {
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
                  ObjectIdentifier(FetchProjectCommentsQuery.Data.Project.Comments.Edge.Node.self),
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

        /// Project.Comments.PageInfo
        ///
        /// Parent Type: `PageInfo`
        public struct PageInfo: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PageInfo }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("endCursor", String?.self),
            .field("hasNextPage", Bool.self),
          ] }

          /// When paginating forwards, the cursor to continue.
          public var endCursor: String? { __data["endCursor"] }
          /// When paginating forwards, are there more items?
          public var hasNextPage: Bool { __data["hasNextPage"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            endCursor: String? = nil,
            hasNextPage: Bool
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.PageInfo.typename,
                "endCursor": endCursor,
                "hasNextPage": hasNextPage,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchProjectCommentsQuery.Data.Project.Comments.PageInfo.self)
              ]
            ))
          }
        }
      }
    }
  }
}
