// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchSimilarProjectsQuery`.
public class FetchSimilarProjectsQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchSimilarProjects"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchSimilarProjects($projectID: String!) { projects(recommended: true, first: 4, similarToPid: $projectID, state: LIVE) { __typename nodes { __typename ...ProjectCardFragment } } }"#,
      fragments: [MoneyFragment.self, ProjectAnalyticsFragment.self, ProjectCardFragment.self, ProjectPamphletMainCellPropertiesFragment.self]
    ))

  /// GraphQL variable or field `projectID`.
  public var projectID: String

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(projectID: String) {
    self.projectID = projectID
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["projectID": projectID] }

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
      .field("projects", Projects?.self, arguments: [
        "recommended": true,
        "first": 4,
        "similarToPid": .variable("projectID"),
        "state": "LIVE"
      ]),
    ] }

    /// Get some projects
    public var projects: Projects? { __data["projects"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      projects: Projects? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "projects": projects._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchSimilarProjectsQuery.Data.self)
        ]
      ))
    }

    /// Projects
    ///
    /// Parent Type: `ProjectsConnectionWithTotalCount`
    public struct Projects: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectsConnectionWithTotalCount }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        nodes: [Node?]? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.ProjectsConnectionWithTotalCount.typename,
            "nodes": nodes._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.self)
          ]
        ))
      }

      /// Projects.Node
      ///
      /// Parent Type: `Project`
      public struct Node: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(ProjectCardFragment.self),
        ] }

        /// The project's primary image.
        public var image: Image? { __data["image"] }
        /// The project's pid.
        public var pid: Int { __data["pid"] }
        /// The project's name.
        public var name: String { __data["name"] }
        /// The project's current state in the state machine.
        public var state: GraphQLEnum<GraphAPI.ProjectState> { __data["state"] }
        /// The project has launched
        public var isLaunched: Bool { __data["isLaunched"] }
        /// When is the project scheduled to end?
        public var deadlineAt: GraphAPI.DateTime? { __data["deadlineAt"] }
        /// What percent the project has towards meeting its funding goal.
        public var percentFunded: Int { __data["percentFunded"] }
        /// Whether a project has activated prelaunch (can return true if project has been launched)
        public var prelaunchActivated: Bool { __data["prelaunchActivated"] }
        /// When the project launched
        public var launchedAt: GraphAPI.DateTime? { __data["launchedAt"] }
        /// Is this project currently accepting post-campaign pledges?
        public var isInPostCampaignPledgingPhase: Bool { __data["isInPostCampaignPledgingPhase"] }
        /// Is this project configured for post-campaign pledges?
        public var postCampaignPledgingEnabled: Bool { __data["postCampaignPledgingEnabled"] }
        /// A URL to the project's page.
        public var url: String { __data["url"] }
        /// Is the current user watching this project?
        public var isWatched: Bool { __data["isWatched"] }
        /// The minimum amount to raise for the project to be successful.
        public var goal: Goal? { __data["goal"] }
        /// How much money is pledged to the project.
        public var pledged: Pledged { __data["pledged"] }
        /// Backing Add-ons
        public var addOns: AddOns? { __data["addOns"] }
        /// Total backers for the project
        public var backersCount: Int { __data["backersCount"] }
        /// The current user's backing of this project.  Does not include inactive backings.
        public var backing: Backing? { __data["backing"] }
        /// The project's category.
        public var category: Category? { __data["category"] }
        /// Comment count - defaults to root level comments only
        public var commentsCount: Int { __data["commentsCount"] }
        /// The project's country
        public var country: Country { __data["country"] }
        /// The project's creator.
        public var creator: Creator? { __data["creator"] }
        /// The project's currency code.
        public var currency: GraphQLEnum<GraphAPI.CurrencyCode> { __data["currency"] }
        /// Whether a project has activated prelaunch (can return true if project has been launched)
        public var isPrelaunchActivated: Bool { __data["isPrelaunchActivated"] }
        /// Tags project has been tagged with
        public var projectTags: [ProjectTag?] { __data["projectTags"] }
        /// Project rewards.
        public var rewards: Rewards? { __data["rewards"] }
        /// A project video.
        public var video: Video? { __data["video"] }
        /// Exchange rate for the current user's currency
        public var fxRate: Double { __data["fxRate"] }
        /// Exchange rate to US Dollars (USD), null for draft projects.
        public var usdExchangeRate: Double? { __data["usdExchangeRate"] }
        /// Project updates.
        public var posts: Posts { __data["posts"] }
        /// A short description of the project.
        public var projectDescription: String { __data["projectDescription"] }
        /// The last time a project's state changed, time since epoch
        public var stateChangedAt: GraphAPI.DateTime { __data["stateChangedAt"] }
        /// Exchange rate to US Dollars (USD) for the project's currency
        public var projectUsdExchangeRate: Double { __data["projectUsdExchangeRate"] }
        /// Where the project is based.
        public var location: Location? { __data["location"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `projectCardFragment`.
          public var projectCardFragment: ProjectCardFragment { _toFragment() }
          /// GraphQL variable or field `projectAnalyticsFragment`.
          public var projectAnalyticsFragment: ProjectAnalyticsFragment { _toFragment() }
          /// GraphQL variable or field `projectPamphletMainCellPropertiesFragment`.
          public var projectPamphletMainCellPropertiesFragment: ProjectPamphletMainCellPropertiesFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          image: Image? = nil,
          pid: Int,
          name: String,
          state: GraphQLEnum<GraphAPI.ProjectState>,
          isLaunched: Bool,
          deadlineAt: GraphAPI.DateTime? = nil,
          percentFunded: Int,
          prelaunchActivated: Bool,
          launchedAt: GraphAPI.DateTime? = nil,
          isInPostCampaignPledgingPhase: Bool,
          postCampaignPledgingEnabled: Bool,
          url: String,
          isWatched: Bool,
          goal: Goal? = nil,
          pledged: Pledged,
          addOns: AddOns? = nil,
          backersCount: Int,
          backing: Backing? = nil,
          category: Category? = nil,
          commentsCount: Int,
          country: Country,
          creator: Creator? = nil,
          currency: GraphQLEnum<GraphAPI.CurrencyCode>,
          isPrelaunchActivated: Bool,
          projectTags: [ProjectTag?],
          rewards: Rewards? = nil,
          video: Video? = nil,
          fxRate: Double,
          usdExchangeRate: Double? = nil,
          posts: Posts,
          projectDescription: String,
          stateChangedAt: GraphAPI.DateTime,
          projectUsdExchangeRate: Double,
          location: Location? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Project.typename,
              "image": image._fieldData,
              "pid": pid,
              "name": name,
              "state": state,
              "isLaunched": isLaunched,
              "deadlineAt": deadlineAt,
              "percentFunded": percentFunded,
              "prelaunchActivated": prelaunchActivated,
              "launchedAt": launchedAt,
              "isInPostCampaignPledgingPhase": isInPostCampaignPledgingPhase,
              "postCampaignPledgingEnabled": postCampaignPledgingEnabled,
              "url": url,
              "isWatched": isWatched,
              "goal": goal._fieldData,
              "pledged": pledged._fieldData,
              "addOns": addOns._fieldData,
              "backersCount": backersCount,
              "backing": backing._fieldData,
              "category": category._fieldData,
              "commentsCount": commentsCount,
              "country": country._fieldData,
              "creator": creator._fieldData,
              "currency": currency,
              "isPrelaunchActivated": isPrelaunchActivated,
              "projectTags": projectTags._fieldData,
              "rewards": rewards._fieldData,
              "video": video._fieldData,
              "fxRate": fxRate,
              "usdExchangeRate": usdExchangeRate,
              "posts": posts._fieldData,
              "projectDescription": projectDescription,
              "stateChangedAt": stateChangedAt,
              "projectUsdExchangeRate": projectUsdExchangeRate,
              "location": location._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.self),
              ObjectIdentifier(ProjectCardFragment.self),
              ObjectIdentifier(ProjectAnalyticsFragment.self),
              ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.self)
            ]
          ))
        }

        /// Projects.Node.Image
        ///
        /// Parent Type: `Photo`
        public struct Image: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Photo }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }
          /// URL of the photo
          public var url: String { __data["url"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID,
            url: String
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Photo.typename,
                "id": id,
                "url": url,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Image.self),
                ObjectIdentifier(ProjectCardFragment.Image.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Image.self)
              ]
            ))
          }
        }

        /// Projects.Node.Goal
        ///
        /// Parent Type: `Money`
        public struct Goal: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

          /// Floating-point numeric value of monetary amount represented as a string
          public var amount: String? { __data["amount"] }
          /// Currency of the monetary amount
          public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
          /// Symbol of the currency in which the monetary amount appears
          public var symbol: String? { __data["symbol"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `moneyFragment`.
            public var moneyFragment: MoneyFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            amount: String? = nil,
            currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
            symbol: String? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Money.typename,
                "amount": amount,
                "currency": currency,
                "symbol": symbol,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Goal.self),
                ObjectIdentifier(ProjectCardFragment.Goal.self),
                ObjectIdentifier(MoneyFragment.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Goal.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Goal.self)
              ]
            ))
          }
        }

        /// Projects.Node.Pledged
        ///
        /// Parent Type: `Money`
        public struct Pledged: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

          /// Floating-point numeric value of monetary amount represented as a string
          public var amount: String? { __data["amount"] }
          /// Currency of the monetary amount
          public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
          /// Symbol of the currency in which the monetary amount appears
          public var symbol: String? { __data["symbol"] }

          /// Container of reusable GraphQL fragment views for this selection set.
          public struct Fragments: FragmentContainer {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL variable or field `moneyFragment`.
            public var moneyFragment: MoneyFragment { _toFragment() }
          }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            amount: String? = nil,
            currency: GraphQLEnum<GraphAPI.CurrencyCode>? = nil,
            symbol: String? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Money.typename,
                "amount": amount,
                "currency": currency,
                "symbol": symbol,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Pledged.self),
                ObjectIdentifier(ProjectCardFragment.Pledged.self),
                ObjectIdentifier(MoneyFragment.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Pledged.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Pledged.self)
              ]
            ))
          }
        }

        /// Type alias for `AddOns` nested GraphQL selection set.
        public typealias AddOns = ProjectAnalyticsFragment.AddOns

        /// Projects.Node.Backing
        ///
        /// Parent Type: `Backing`
        public struct Backing: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Backing.typename,
                "id": id,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Backing.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Backing.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Backing.self)
              ]
            ))
          }
        }

        /// Projects.Node.Category
        ///
        /// Parent Type: `Category`
        public struct Category: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }

          /// Category name in English for analytics use.
          public var analyticsName: String { __data["analyticsName"] }
          /// Category parent
          public var parentCategory: ParentCategory? { __data["parentCategory"] }
          /// Category name.
          public var name: String { __data["name"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            analyticsName: String,
            parentCategory: ParentCategory? = nil,
            name: String
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Category.typename,
                "analyticsName": analyticsName,
                "parentCategory": parentCategory._fieldData,
                "name": name,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Category.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Category.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Category.self)
              ]
            ))
          }

          /// Type alias for `ParentCategory` nested GraphQL selection set.
          public typealias ParentCategory = ProjectAnalyticsFragment.Category.ParentCategory
        }

        /// Projects.Node.Country
        ///
        /// Parent Type: `Country`
        public struct Country: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Country }

          /// ISO ALPHA-2 code.
          public var code: GraphQLEnum<GraphAPI.CountryCode> { __data["code"] }
          /// Country name.
          public var name: String { __data["name"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            code: GraphQLEnum<GraphAPI.CountryCode>,
            name: String
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Country.typename,
                "code": code,
                "name": name,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Country.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Country.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Country.self)
              ]
            ))
          }
        }

        /// Projects.Node.Creator
        ///
        /// Parent Type: `User`
        public struct Creator: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }
          /// Projects a user has created.
          public var createdProjects: CreatedProjects? { __data["createdProjects"] }
          /// The user's provided name.
          public var name: String { __data["name"] }
          /// Is user blocked by current user
          public var isBlocked: Bool? { __data["isBlocked"] }
          /// The user's avatar.
          public var imageUrl: String { __data["imageUrl"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID,
            createdProjects: CreatedProjects? = nil,
            name: String,
            isBlocked: Bool? = nil,
            imageUrl: String
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.User.typename,
                "id": id,
                "createdProjects": createdProjects._fieldData,
                "name": name,
                "isBlocked": isBlocked,
                "imageUrl": imageUrl,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Creator.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Creator.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Creator.self)
              ]
            ))
          }

          /// Type alias for `CreatedProjects` nested GraphQL selection set.
          public typealias CreatedProjects = ProjectAnalyticsFragment.Creator.CreatedProjects
        }

        /// Type alias for `ProjectTag` nested GraphQL selection set.
        public typealias ProjectTag = ProjectAnalyticsFragment.ProjectTag

        /// Type alias for `Rewards` nested GraphQL selection set.
        public typealias Rewards = ProjectAnalyticsFragment.Rewards

        /// Projects.Node.Video
        ///
        /// Parent Type: `Video`
        public struct Video: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Video }

          /// Unique GraphQL node identifier.
          public var id: GraphAPI.ID { __data["id"] }
          /// A video's sources (hls, high, base)
          public var videoSources: VideoSources? { __data["videoSources"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            id: GraphAPI.ID,
            videoSources: VideoSources? = nil
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.Video.typename,
                "id": id,
                "videoSources": videoSources._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchSimilarProjectsQuery.Data.Projects.Node.Video.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Video.self),
                ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Video.self)
              ]
            ))
          }

          /// Type alias for `VideoSources` nested GraphQL selection set.
          public typealias VideoSources = ProjectPamphletMainCellPropertiesFragment.Video.VideoSources
        }

        /// Type alias for `Posts` nested GraphQL selection set.
        public typealias Posts = ProjectAnalyticsFragment.Posts

        /// Type alias for `Location` nested GraphQL selection set.
        public typealias Location = ProjectPamphletMainCellPropertiesFragment.Location
      }
    }
  }
}
