// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `VideoFeedQuery`.
public class VideoFeedQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "VideoFeed"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query VideoFeed($first: Int!, $after: String, $categoryId: String) { videoFeed(first: $first, after: $after, categoryId: $categoryId) { __typename pageInfo { __typename hasNextPage endCursor hasPreviousPage startCursor } nodes { __typename badges { __typename type text icon } project { __typename ...ProjectVideoFeedFragment } } } }"#,
      fragments: [ProjectVideoFeedFragment.self]
    ))

  /// GraphQL variable or field `first`.
  public var first: Int
  /// GraphQL variable or field `after`.
  public var after: GraphQLNullable<String>
  /// GraphQL variable or field `categoryId`.
  public var categoryId: GraphQLNullable<String>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    first: Int,
    after: GraphQLNullable<String>,
    categoryId: GraphQLNullable<String>
  ) {
    self.first = first
    self.after = after
    self.categoryId = categoryId
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "first": first,
    "after": after,
    "categoryId": categoryId
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
      .field("videoFeed", VideoFeed?.self, arguments: [
        "first": .variable("first"),
        "after": .variable("after"),
        "categoryId": .variable("categoryId")
      ]),
    ] }

    /// Paginated feed of live projects with vertical videos, for the mobile discovery experience.
    public var videoFeed: VideoFeed? { __data["videoFeed"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      videoFeed: VideoFeed? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "videoFeed": videoFeed._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(VideoFeedQuery.Data.self)
        ]
      ))
    }

    /// VideoFeed
    ///
    /// Parent Type: `VideoFeedConnection`
    public struct VideoFeed: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.VideoFeedConnection }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("pageInfo", PageInfo.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }
      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        pageInfo: PageInfo,
        nodes: [Node?]? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.VideoFeedConnection.typename,
            "pageInfo": pageInfo._fieldData,
            "nodes": nodes._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(VideoFeedQuery.Data.VideoFeed.self)
          ]
        ))
      }

      /// VideoFeed.PageInfo
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
          .field("hasNextPage", Bool.self),
          .field("endCursor", String?.self),
          .field("hasPreviousPage", Bool.self),
          .field("startCursor", String?.self),
        ] }

        /// When paginating forwards, are there more items?
        public var hasNextPage: Bool { __data["hasNextPage"] }
        /// When paginating forwards, the cursor to continue.
        public var endCursor: String? { __data["endCursor"] }
        /// When paginating backwards, are there more items?
        public var hasPreviousPage: Bool { __data["hasPreviousPage"] }
        /// When paginating backwards, the cursor to continue.
        public var startCursor: String? { __data["startCursor"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          hasNextPage: Bool,
          endCursor: String? = nil,
          hasPreviousPage: Bool,
          startCursor: String? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.PageInfo.typename,
              "hasNextPage": hasNextPage,
              "endCursor": endCursor,
              "hasPreviousPage": hasPreviousPage,
              "startCursor": startCursor,
            ],
            fulfilledFragments: [
              ObjectIdentifier(VideoFeedQuery.Data.VideoFeed.PageInfo.self)
            ]
          ))
        }
      }

      /// VideoFeed.Node
      ///
      /// Parent Type: `VideoFeedItem`
      public struct Node: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.VideoFeedItem }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("badges", [Badge].self),
          .field("project", Project.self),
        ] }

        /// Computed badges for this project (e.g. "Project We Love", "3 days left")
        public var badges: [Badge] { __data["badges"] }
        /// The project associated with this feed item
        public var project: Project { __data["project"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          badges: [Badge],
          project: Project
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.VideoFeedItem.typename,
              "badges": badges._fieldData,
              "project": project._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(VideoFeedQuery.Data.VideoFeed.Node.self)
            ]
          ))
        }

        /// VideoFeed.Node.Badge
        ///
        /// Parent Type: `Badge`
        public struct Badge: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Badge }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("type", GraphQLEnum<GraphAPI.BadgeTypeEnum>.self),
            .field("text", String.self),
            .field("icon", String?.self),
          ] }

          /// The category of badge
          public var type: GraphQLEnum<GraphAPI.BadgeTypeEnum> { __data["type"] }
          /// Human-readable badge label (e.g. "3 days left", "Project We Love")
          public var text: String { __data["text"] }
          /// Optional icon identifier for the badge (e.g. "heart", "clock", "fire")
          public var icon: String? { __data["icon"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            type: GraphQLEnum<GraphAPI.BadgeTypeEnum>,
            text: String,
            icon: String? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Badge.typename,
                "type": type,
                "text": text,
                "icon": icon,
              ],
              fulfilledFragments: [
                ObjectIdentifier(VideoFeedQuery.Data.VideoFeed.Node.Badge.self)
              ]
            ))
          }
        }

        /// VideoFeed.Node.Project
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
            .fragment(ProjectVideoFeedFragment.self),
          ] }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }
          /// The project's pid.
          public var pid: Int { __data["pid"] }
          /// The project's name.
          public var name: String { __data["name"] }
          /// The project's unique URL identifier.
          public var slug: String { __data["slug"] }
          /// A URL to the project's page.
          public var url: String { __data["url"] }
          /// What percent the project has towards meeting its funding goal.
          public var percentFunded: Int { __data["percentFunded"] }
          /// When is the project scheduled to end?
          public var deadlineAt: GraphAPI.DateTime? { __data["deadlineAt"] }
          /// When the project launched
          public var launchedAt: GraphAPI.DateTime? { __data["launchedAt"] }
          /// Total backers for the project
          public var backersCount: Int { __data["backersCount"] }
          /// Is the current user watching this project?
          public var isWatched: Bool { __data["isWatched"] }
          /// Exchange rate for the current user's currency
          public var fxRate: Double { __data["fxRate"] }
          /// Currency code for the current user's currency
          public var fxRateCurrency: GraphQLEnum<GraphAPI.CurrencyCode> { __data["fxRateCurrency"] }
          /// How much money is pledged to the project.
          public var pledged: Pledged { __data["pledged"] }
          /// The project's creator.
          public var creator: Creator? { __data["creator"] }
          /// The project's category.
          public var category: Category? { __data["category"] }
          /// A project vertical video.
          public var verticalVideo: VerticalVideo? { __data["verticalVideo"] }
          /// Total number of times the project has been shared to social platforms
          public var sharesCount: Int { __data["sharesCount"] }
          /// Number of watchers a project has.
          public var watchesCount: Int? { __data["watchesCount"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `projectVideoFeedFragment`.
            public var projectVideoFeedFragment: ProjectVideoFeedFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID,
            pid: Int,
            name: String,
            slug: String,
            url: String,
            percentFunded: Int,
            deadlineAt: GraphAPI.DateTime? = nil,
            launchedAt: GraphAPI.DateTime? = nil,
            backersCount: Int,
            isWatched: Bool,
            fxRate: Double,
            fxRateCurrency: GraphQLEnum<GraphAPI.CurrencyCode>,
            pledged: Pledged,
            creator: Creator? = nil,
            category: Category? = nil,
            verticalVideo: VerticalVideo? = nil,
            sharesCount: Int,
            watchesCount: Int? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Project.typename,
                "id": id,
                "pid": pid,
                "name": name,
                "slug": slug,
                "url": url,
                "percentFunded": percentFunded,
                "deadlineAt": deadlineAt,
                "launchedAt": launchedAt,
                "backersCount": backersCount,
                "isWatched": isWatched,
                "fxRate": fxRate,
                "fxRateCurrency": fxRateCurrency,
                "pledged": pledged._fieldData,
                "creator": creator._fieldData,
                "category": category._fieldData,
                "verticalVideo": verticalVideo._fieldData,
                "sharesCount": sharesCount,
                "watchesCount": watchesCount,
              ],
              fulfilledFragments: [
                ObjectIdentifier(VideoFeedQuery.Data.VideoFeed.Node.Project.self),
                ObjectIdentifier(ProjectVideoFeedFragment.self)
              ]
            ))
          }

          /// Type alias for `Pledged` nested GraphQL selection set.
          public typealias Pledged = ProjectVideoFeedFragment.Pledged

          /// Type alias for `Creator` nested GraphQL selection set.
          public typealias Creator = ProjectVideoFeedFragment.Creator

          /// Type alias for `Category` nested GraphQL selection set.
          public typealias Category = ProjectVideoFeedFragment.Category

          /// Type alias for `VerticalVideo` nested GraphQL selection set.
          public typealias VerticalVideo = ProjectVideoFeedFragment.VerticalVideo
        }
      }
    }
  }
}
