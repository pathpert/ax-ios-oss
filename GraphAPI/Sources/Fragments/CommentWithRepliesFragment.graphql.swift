// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `CommentWithRepliesFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct CommentWithRepliesFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment CommentWithRepliesFragment on Comment { __typename ...CommentBaseFragment replies(before: $cursor, last: $limit) { __typename edges { __typename node { __typename ...CommentFragment } } pageInfo { __typename hasPreviousPage startCursor } totalCount } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Comment }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("replies", Replies?.self, arguments: [
      "before": .variable("cursor"),
      "last": .variable("limit")
    ]),
    .fragment(CommentBaseFragment.self),
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
  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The ID of the parent comment
  public var parentId: String? { __data["parentId"] }
  /// Whether a comment has any flaggings
  public var hasFlaggings: Bool { __data["hasFlaggings"] }
  /// Whether the comment author has been removed by kickstarter
  public var removedPerGuidelines: Bool { __data["removedPerGuidelines"] }
  /// Whether this comment has been reviewed and sustained by an admin
  public var sustained: Bool { __data["sustained"] }

  /// Typed container providing access to composed Apollo fragments on this selection set.
  public struct Fragments: FragmentContainer {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Composed `CommentBaseFragment` fragment decoded from this selection set.
    public var commentBaseFragment: CommentBaseFragment { _toFragment() }
  }

  /// Synthesizes a selection set instance for tests and previews.
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
        ObjectIdentifier(CommentWithRepliesFragment.self),
        ObjectIdentifier(CommentBaseFragment.self)
      ]
    ))
  }

  /// Replies
  ///
  /// Parent Type: `CommentConnection`
  public struct Replies: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CommentConnection }
    /// GraphQL selection fields requested by this selection set.
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
    /// Total number of matching records in the connection.
    public var totalCount: Int { __data["totalCount"] }

    /// Synthesizes a selection set instance for tests and previews.
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
          ObjectIdentifier(CommentWithRepliesFragment.Replies.self)
        ]
      ))
    }

    /// Replies.Edge
    ///
    /// Parent Type: `CommentEdge`
    public struct Edge: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CommentEdge }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("node", Node?.self),
      ] }

      /// The item at the end of the edge.
      public var node: Node? { __data["node"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        node: Node? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.CommentEdge.typename,
            "node": node._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CommentWithRepliesFragment.Replies.Edge.self)
          ]
        ))
      }

      /// Replies.Edge.Node
      ///
      /// Parent Type: `Comment`
      public struct Node: GraphAPI.SelectionSet {
        /// Backing Apollo response dictionary.
        public let __data: DataDict
        /// Initializes the selection set wrapper from an Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema parent object or interface type.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Comment }
        /// GraphQL selection fields requested by this selection set.
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
        /// Relay global node identifier (`GraphAPI.ID`).
        public var id: GraphAPI.ID { __data["id"] }
        /// The ID of the parent comment
        public var parentId: String? { __data["parentId"] }
        /// Whether a comment has any flaggings
        public var hasFlaggings: Bool { __data["hasFlaggings"] }
        /// Whether the comment author has been removed by kickstarter
        public var removedPerGuidelines: Bool { __data["removedPerGuidelines"] }
        /// Whether this comment has been reviewed and sustained by an admin
        public var sustained: Bool { __data["sustained"] }

        /// Typed container providing access to composed Apollo fragments on this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo response dictionary.
          public let __data: DataDict
          /// Initializes the selection set wrapper from an Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// Composed `CommentFragment` fragment decoded from this selection set.
          public var commentFragment: CommentFragment { _toFragment() }
          /// Composed `CommentBaseFragment` fragment decoded from this selection set.
          public var commentBaseFragment: CommentBaseFragment { _toFragment() }
        }

        /// Synthesizes a selection set instance for tests and previews.
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
              ObjectIdentifier(CommentWithRepliesFragment.Replies.Edge.Node.self),
              ObjectIdentifier(CommentFragment.self),
              ObjectIdentifier(CommentBaseFragment.self)
            ]
          ))
        }

        /// Shared GraphQL selection set alias mapping `Replies` to `CommentFragment.Replies`.
        public typealias Replies = CommentFragment.Replies

        /// Shared GraphQL selection set alias mapping `Author` to `CommentBaseFragment.Author`.
        public typealias Author = CommentBaseFragment.Author
      }
    }

    /// Replies.PageInfo
    ///
    /// Parent Type: `PageInfo`
    public struct PageInfo: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PageInfo }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("hasPreviousPage", Bool.self),
        .field("startCursor", String?.self),
      ] }

      /// When paginating backwards, are there more items?
      public var hasPreviousPage: Bool { __data["hasPreviousPage"] }
      /// When paginating backwards, the cursor to continue.
      public var startCursor: String? { __data["startCursor"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        hasPreviousPage: Bool,
        startCursor: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.PageInfo.typename,
            "hasPreviousPage": hasPreviousPage,
            "startCursor": startCursor,
          ],
          fulfilledFragments: [
            ObjectIdentifier(CommentWithRepliesFragment.Replies.PageInfo.self)
          ]
        ))
      }
    }
  }

  /// Shared GraphQL selection set alias mapping `Author` to `CommentBaseFragment.Author`.
  public typealias Author = CommentBaseFragment.Author
}
