// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `SearchQuery`.
public class SearchQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "Search"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query Search($term: String, $sort: ProjectSort, $categoryId: String, $state: PublicProjectState, $raised: RaisedBuckets, $locationId: ID, $pledged: PledgedBuckets, $goal: GoalBuckets, $showRecommended: Boolean, $showSavedProjects: Boolean, $showProjectsWeLove: Boolean, $showFollowing: Boolean, $first: Int, $cursor: String) { projects( term: $term sort: $sort categoryId: $categoryId state: $state raised: $raised locationId: $locationId pledged: $pledged goal: $goal recommended: $showRecommended starred: $showSavedProjects following: $showFollowing staffPicks: $showProjectsWeLove after: $cursor first: $first ) { __typename nodes { __typename ...BackerDashboardProjectCellFragment ...ProjectAnalyticsFragment ...ProjectCardFragment } totalCount pageInfo { __typename endCursor hasNextPage } } }"#,
      fragments: [BackerDashboardProjectCellFragment.self, MoneyFragment.self, ProjectAnalyticsFragment.self, ProjectCardFragment.self, ProjectPamphletMainCellPropertiesFragment.self]
    ))

  /// GraphQL variable or field `term`.
  public var term: GraphQLNullable<String>
  /// GraphQL variable or field `sort`.
  public var sort: GraphQLNullable<GraphQLEnum<ProjectSort>>
  /// GraphQL variable or field `categoryId`.
  public var categoryId: GraphQLNullable<String>
  /// GraphQL variable or field `state`.
  public var state: GraphQLNullable<GraphQLEnum<PublicProjectState>>
  /// GraphQL variable or field `raised`.
  public var raised: GraphQLNullable<GraphQLEnum<RaisedBuckets>>
  /// GraphQL variable or field `locationId`.
  public var locationId: GraphQLNullable<ID>
  /// GraphQL variable or field `pledged`.
  public var pledged: GraphQLNullable<GraphQLEnum<PledgedBuckets>>
  /// GraphQL variable or field `goal`.
  public var goal: GraphQLNullable<GraphQLEnum<GoalBuckets>>
  /// GraphQL variable or field `showRecommended`.
  public var showRecommended: GraphQLNullable<Bool>
  /// GraphQL variable or field `showSavedProjects`.
  public var showSavedProjects: GraphQLNullable<Bool>
  /// GraphQL variable or field `showProjectsWeLove`.
  public var showProjectsWeLove: GraphQLNullable<Bool>
  /// GraphQL variable or field `showFollowing`.
  public var showFollowing: GraphQLNullable<Bool>
  /// GraphQL variable or field `first`.
  public var first: GraphQLNullable<Int>
  /// GraphQL variable or field `cursor`.
  public var cursor: GraphQLNullable<String>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    term: GraphQLNullable<String>,
    sort: GraphQLNullable<GraphQLEnum<ProjectSort>>,
    categoryId: GraphQLNullable<String>,
    state: GraphQLNullable<GraphQLEnum<PublicProjectState>>,
    raised: GraphQLNullable<GraphQLEnum<RaisedBuckets>>,
    locationId: GraphQLNullable<ID>,
    pledged: GraphQLNullable<GraphQLEnum<PledgedBuckets>>,
    goal: GraphQLNullable<GraphQLEnum<GoalBuckets>>,
    showRecommended: GraphQLNullable<Bool>,
    showSavedProjects: GraphQLNullable<Bool>,
    showProjectsWeLove: GraphQLNullable<Bool>,
    showFollowing: GraphQLNullable<Bool>,
    first: GraphQLNullable<Int>,
    cursor: GraphQLNullable<String>
  ) {
    self.term = term
    self.sort = sort
    self.categoryId = categoryId
    self.state = state
    self.raised = raised
    self.locationId = locationId
    self.pledged = pledged
    self.goal = goal
    self.showRecommended = showRecommended
    self.showSavedProjects = showSavedProjects
    self.showProjectsWeLove = showProjectsWeLove
    self.showFollowing = showFollowing
    self.first = first
    self.cursor = cursor
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "term": term,
    "sort": sort,
    "categoryId": categoryId,
    "state": state,
    "raised": raised,
    "locationId": locationId,
    "pledged": pledged,
    "goal": goal,
    "showRecommended": showRecommended,
    "showSavedProjects": showSavedProjects,
    "showProjectsWeLove": showProjectsWeLove,
    "showFollowing": showFollowing,
    "first": first,
    "cursor": cursor
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
      .field("projects", Projects?.self, arguments: [
        "term": .variable("term"),
        "sort": .variable("sort"),
        "categoryId": .variable("categoryId"),
        "state": .variable("state"),
        "raised": .variable("raised"),
        "locationId": .variable("locationId"),
        "pledged": .variable("pledged"),
        "goal": .variable("goal"),
        "recommended": .variable("showRecommended"),
        "starred": .variable("showSavedProjects"),
        "following": .variable("showFollowing"),
        "staffPicks": .variable("showProjectsWeLove"),
        "after": .variable("cursor"),
        "first": .variable("first")
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
          ObjectIdentifier(SearchQuery.Data.self)
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
        .field("totalCount", Int.self),
        .field("pageInfo", PageInfo.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }
      /// GraphQL variable or field `totalCount`.
      public var totalCount: Int { __data["totalCount"] }
      /// Information to aid in pagination.
      public var pageInfo: PageInfo { __data["pageInfo"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        nodes: [Node?]? = nil,
        totalCount: Int,
        pageInfo: PageInfo
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.ProjectsConnectionWithTotalCount.typename,
            "nodes": nodes._fieldData,
            "totalCount": totalCount,
            "pageInfo": pageInfo._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(SearchQuery.Data.Projects.self)
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
          .fragment(BackerDashboardProjectCellFragment.self),
          .fragment(ProjectAnalyticsFragment.self),
          .fragment(ProjectCardFragment.self),
        ] }

        /// GraphQL variable or field `projectId`.
        public var projectId: GraphAPI.ID { __data["projectId"] }
        /// The project's name.
        public var name: String { __data["name"] }
        /// The project's current state in the state machine.
        public var projectState: GraphQLEnum<GraphAPI.ProjectState> { __data["projectState"] }
        /// The project's primary image.
        public var image: Image? { __data["image"] }
        /// The minimum amount to raise for the project to be successful.
        public var goal: Goal? { __data["goal"] }
        /// How much money is pledged to the project.
        public var pledged: Pledged { __data["pledged"] }
        /// The project has launched
        public var isLaunched: Bool { __data["isLaunched"] }
        /// Whether a project has activated prelaunch (can return true if project has been launched)
        public var projectPrelaunchActivated: Bool { __data["projectPrelaunchActivated"] }
        /// When is the project scheduled to end?
        public var deadlineAt: GraphAPI.DateTime? { __data["deadlineAt"] }
        /// When the project launched
        public var projectLaunchedAt: GraphAPI.DateTime? { __data["projectLaunchedAt"] }
        /// Is the current user watching this project?
        public var isWatched: Bool { __data["isWatched"] }
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
        /// When the project launched
        public var launchedAt: GraphAPI.DateTime? { __data["launchedAt"] }
        /// The project's pid.
        public var pid: Int { __data["pid"] }
        /// Is this project currently accepting post-campaign pledges?
        public var isInPostCampaignPledgingPhase: Bool { __data["isInPostCampaignPledgingPhase"] }
        /// What percent the project has towards meeting its funding goal.
        public var percentFunded: Int { __data["percentFunded"] }
        /// Whether a project has activated prelaunch (can return true if project has been launched)
        public var isPrelaunchActivated: Bool { __data["isPrelaunchActivated"] }
        /// Tags project has been tagged with
        public var projectTags: [ProjectTag?] { __data["projectTags"] }
        /// Is this project configured for post-campaign pledges?
        public var postCampaignPledgingEnabled: Bool { __data["postCampaignPledgingEnabled"] }
        /// Project rewards.
        public var rewards: Rewards? { __data["rewards"] }
        /// The project's current state in the state machine.
        public var state: GraphQLEnum<GraphAPI.ProjectState> { __data["state"] }
        /// A project video.
        public var video: Video? { __data["video"] }
        /// Exchange rate for the current user's currency
        public var fxRate: Double { __data["fxRate"] }
        /// Exchange rate to US Dollars (USD), null for draft projects.
        public var usdExchangeRate: Double? { __data["usdExchangeRate"] }
        /// Project updates.
        public var posts: Posts { __data["posts"] }
        /// Whether a project has activated prelaunch (can return true if project has been launched)
        public var prelaunchActivated: Bool { __data["prelaunchActivated"] }
        /// A URL to the project's page.
        public var url: String { __data["url"] }
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

          /// GraphQL variable or field `backerDashboardProjectCellFragment`.
          public var backerDashboardProjectCellFragment: BackerDashboardProjectCellFragment { _toFragment() }
          /// GraphQL variable or field `projectAnalyticsFragment`.
          public var projectAnalyticsFragment: ProjectAnalyticsFragment { _toFragment() }
          /// GraphQL variable or field `projectCardFragment`.
          public var projectCardFragment: ProjectCardFragment { _toFragment() }
          /// GraphQL variable or field `projectPamphletMainCellPropertiesFragment`.
          public var projectPamphletMainCellPropertiesFragment: ProjectPamphletMainCellPropertiesFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          projectId: GraphAPI.ID,
          name: String,
          projectState: GraphQLEnum<GraphAPI.ProjectState>,
          image: Image? = nil,
          goal: Goal? = nil,
          pledged: Pledged,
          isLaunched: Bool,
          projectPrelaunchActivated: Bool,
          deadlineAt: GraphAPI.DateTime? = nil,
          projectLaunchedAt: GraphAPI.DateTime? = nil,
          isWatched: Bool,
          addOns: AddOns? = nil,
          backersCount: Int,
          backing: Backing? = nil,
          category: Category? = nil,
          commentsCount: Int,
          country: Country,
          creator: Creator? = nil,
          currency: GraphQLEnum<GraphAPI.CurrencyCode>,
          launchedAt: GraphAPI.DateTime? = nil,
          pid: Int,
          isInPostCampaignPledgingPhase: Bool,
          percentFunded: Int,
          isPrelaunchActivated: Bool,
          projectTags: [ProjectTag?],
          postCampaignPledgingEnabled: Bool,
          rewards: Rewards? = nil,
          state: GraphQLEnum<GraphAPI.ProjectState>,
          video: Video? = nil,
          fxRate: Double,
          usdExchangeRate: Double? = nil,
          posts: Posts,
          prelaunchActivated: Bool,
          url: String,
          projectDescription: String,
          stateChangedAt: GraphAPI.DateTime,
          projectUsdExchangeRate: Double,
          location: Location? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Project.typename,
              "projectId": projectId,
              "name": name,
              "projectState": projectState,
              "image": image._fieldData,
              "goal": goal._fieldData,
              "pledged": pledged._fieldData,
              "isLaunched": isLaunched,
              "projectPrelaunchActivated": projectPrelaunchActivated,
              "deadlineAt": deadlineAt,
              "projectLaunchedAt": projectLaunchedAt,
              "isWatched": isWatched,
              "addOns": addOns._fieldData,
              "backersCount": backersCount,
              "backing": backing._fieldData,
              "category": category._fieldData,
              "commentsCount": commentsCount,
              "country": country._fieldData,
              "creator": creator._fieldData,
              "currency": currency,
              "launchedAt": launchedAt,
              "pid": pid,
              "isInPostCampaignPledgingPhase": isInPostCampaignPledgingPhase,
              "percentFunded": percentFunded,
              "isPrelaunchActivated": isPrelaunchActivated,
              "projectTags": projectTags._fieldData,
              "postCampaignPledgingEnabled": postCampaignPledgingEnabled,
              "rewards": rewards._fieldData,
              "state": state,
              "video": video._fieldData,
              "fxRate": fxRate,
              "usdExchangeRate": usdExchangeRate,
              "posts": posts._fieldData,
              "prelaunchActivated": prelaunchActivated,
              "url": url,
              "projectDescription": projectDescription,
              "stateChangedAt": stateChangedAt,
              "projectUsdExchangeRate": projectUsdExchangeRate,
              "location": location._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(SearchQuery.Data.Projects.Node.self),
              ObjectIdentifier(BackerDashboardProjectCellFragment.self),
              ObjectIdentifier(ProjectAnalyticsFragment.self),
              ObjectIdentifier(ProjectCardFragment.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Image.self),
                ObjectIdentifier(BackerDashboardProjectCellFragment.Image.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Goal.self),
                ObjectIdentifier(BackerDashboardProjectCellFragment.Goal.self),
                ObjectIdentifier(MoneyFragment.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Goal.self),
                ObjectIdentifier(ProjectCardFragment.Goal.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Pledged.self),
                ObjectIdentifier(BackerDashboardProjectCellFragment.Pledged.self),
                ObjectIdentifier(MoneyFragment.self),
                ObjectIdentifier(ProjectAnalyticsFragment.Pledged.self),
                ObjectIdentifier(ProjectCardFragment.Pledged.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Backing.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Category.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Country.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Creator.self),
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
                ObjectIdentifier(SearchQuery.Data.Projects.Node.Video.self),
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

      /// Projects.PageInfo
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
              ObjectIdentifier(SearchQuery.Data.Projects.PageInfo.self)
            ]
          ))
        }
      }
    }
  }
}
