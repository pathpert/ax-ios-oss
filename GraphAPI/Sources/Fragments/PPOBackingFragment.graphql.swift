// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `PPOBackingFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct PPOBackingFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment PPOBackingFragment on Backing { __typename amount { __typename ...MoneyFragment } id project { __typename ...PPOProjectFragment ...ProjectAnalyticsFragment ...ProjectCardFragment } backerCompleted backingDetailsPageRoute(type: url, tab: survey_responses) deliveryAddress { __typename id addressLine1 addressLine2 city region postalCode phoneNumber recipientName countryCode } clientSecret }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("amount", Amount.self),
    .field("id", GraphAPI.ID.self),
    .field("project", Project?.self),
    .field("backerCompleted", Bool.self),
    .field("backingDetailsPageRoute", String.self, arguments: [
      "type": "url",
      "tab": "survey_responses"
    ]),
    .field("deliveryAddress", DeliveryAddress?.self),
    .field("clientSecret", String?.self),
  ] }

  /// Total amount pledged by the backer to the project, including shipping.
  public var amount: Amount { __data["amount"] }
  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The project
  public var project: Project? { __data["project"] }
  /// If the backer_completed_at is set or not
  public var backerCompleted: Bool { __data["backerCompleted"] }
  /// URL/path for the backing details page
  public var backingDetailsPageRoute: String { __data["backingDetailsPageRoute"] }
  /// The delivery address associated with the backing
  public var deliveryAddress: DeliveryAddress? { __data["deliveryAddress"] }
  /// If `requires_action` is true, `client_secret` should be used to initiate additional client-side authentication steps
  public var clientSecret: String? { __data["clientSecret"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    amount: Amount,
    id: GraphAPI.ID,
    project: Project? = nil,
    backerCompleted: Bool,
    backingDetailsPageRoute: String,
    deliveryAddress: DeliveryAddress? = nil,
    clientSecret: String? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Backing.typename,
        "amount": amount._fieldData,
        "id": id,
        "project": project._fieldData,
        "backerCompleted": backerCompleted,
        "backingDetailsPageRoute": backingDetailsPageRoute,
        "deliveryAddress": deliveryAddress._fieldData,
        "clientSecret": clientSecret,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PPOBackingFragment.self)
      ]
    ))
  }

  /// Amount
  ///
  /// Parent Type: `Money`
  public struct Amount: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(MoneyFragment.self),
    ] }

    /// Floating-point numeric value of monetary amount represented as a string
    public var amount: String? { __data["amount"] }
    /// Currency of the monetary amount
    public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
    /// Symbol of the currency in which the monetary amount appears
    public var symbol: String? { __data["symbol"] }

    /// Typed container providing access to composed Apollo fragments on this selection set.
    public struct Fragments: FragmentContainer {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// Composed `MoneyFragment` fragment decoded from this selection set.
      public var moneyFragment: MoneyFragment { _toFragment() }
    }

    /// Synthesizes a selection set instance for tests and previews.
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
          ObjectIdentifier(PPOBackingFragment.Amount.self),
          ObjectIdentifier(MoneyFragment.self)
        ]
      ))
    }
  }

  /// Project
  ///
  /// Parent Type: `Project`
  public struct Project: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(PPOProjectFragment.self),
      .fragment(ProjectAnalyticsFragment.self),
      .fragment(ProjectCardFragment.self),
    ] }

    /// The project's creator.
    public var creator: Creator? { __data["creator"] }
    /// The project's primary image.
    public var image: Image? { __data["image"] }
    /// The project's name.
    public var name: String { __data["name"] }
    /// The project's pid.
    public var pid: Int { __data["pid"] }
    /// The project's unique URL identifier.
    public var slug: String { __data["slug"] }
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
    /// The project's currency code.
    public var currency: GraphQLEnum<GraphAPI.CurrencyCode> { __data["currency"] }
    /// When is the project scheduled to end?
    public var deadlineAt: GraphAPI.DateTime? { __data["deadlineAt"] }
    /// When the project launched
    public var launchedAt: GraphAPI.DateTime? { __data["launchedAt"] }
    /// Is this project currently accepting post-campaign pledges?
    public var isInPostCampaignPledgingPhase: Bool { __data["isInPostCampaignPledgingPhase"] }
    /// Is the current user watching this project?
    public var isWatched: Bool { __data["isWatched"] }
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
    /// How much money is pledged to the project.
    public var pledged: Pledged { __data["pledged"] }
    /// Exchange rate for the current user's currency
    public var fxRate: Double { __data["fxRate"] }
    /// Exchange rate to US Dollars (USD), null for draft projects.
    public var usdExchangeRate: Double? { __data["usdExchangeRate"] }
    /// Project updates.
    public var posts: Posts { __data["posts"] }
    /// The minimum amount to raise for the project to be successful.
    public var goal: Goal? { __data["goal"] }
    /// The project has launched
    public var isLaunched: Bool { __data["isLaunched"] }
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

    /// Typed container providing access to composed Apollo fragments on this selection set.
    public struct Fragments: FragmentContainer {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// Composed `PPOProjectFragment` fragment decoded from this selection set.
      public var pPOProjectFragment: PPOProjectFragment { _toFragment() }
      /// Composed `ProjectAnalyticsFragment` fragment decoded from this selection set.
      public var projectAnalyticsFragment: ProjectAnalyticsFragment { _toFragment() }
      /// Composed `ProjectCardFragment` fragment decoded from this selection set.
      public var projectCardFragment: ProjectCardFragment { _toFragment() }
      /// Composed `ProjectPamphletMainCellPropertiesFragment` fragment decoded from this selection set.
      public var projectPamphletMainCellPropertiesFragment: ProjectPamphletMainCellPropertiesFragment { _toFragment() }
    }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      creator: Creator? = nil,
      image: Image? = nil,
      name: String,
      pid: Int,
      slug: String,
      addOns: AddOns? = nil,
      backersCount: Int,
      backing: Backing? = nil,
      category: Category? = nil,
      commentsCount: Int,
      country: Country,
      currency: GraphQLEnum<GraphAPI.CurrencyCode>,
      deadlineAt: GraphAPI.DateTime? = nil,
      launchedAt: GraphAPI.DateTime? = nil,
      isInPostCampaignPledgingPhase: Bool,
      isWatched: Bool,
      percentFunded: Int,
      isPrelaunchActivated: Bool,
      projectTags: [ProjectTag?],
      postCampaignPledgingEnabled: Bool,
      rewards: Rewards? = nil,
      state: GraphQLEnum<GraphAPI.ProjectState>,
      video: Video? = nil,
      pledged: Pledged,
      fxRate: Double,
      usdExchangeRate: Double? = nil,
      posts: Posts,
      goal: Goal? = nil,
      isLaunched: Bool,
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
          "creator": creator._fieldData,
          "image": image._fieldData,
          "name": name,
          "pid": pid,
          "slug": slug,
          "addOns": addOns._fieldData,
          "backersCount": backersCount,
          "backing": backing._fieldData,
          "category": category._fieldData,
          "commentsCount": commentsCount,
          "country": country._fieldData,
          "currency": currency,
          "deadlineAt": deadlineAt,
          "launchedAt": launchedAt,
          "isInPostCampaignPledgingPhase": isInPostCampaignPledgingPhase,
          "isWatched": isWatched,
          "percentFunded": percentFunded,
          "isPrelaunchActivated": isPrelaunchActivated,
          "projectTags": projectTags._fieldData,
          "postCampaignPledgingEnabled": postCampaignPledgingEnabled,
          "rewards": rewards._fieldData,
          "state": state,
          "video": video._fieldData,
          "pledged": pledged._fieldData,
          "fxRate": fxRate,
          "usdExchangeRate": usdExchangeRate,
          "posts": posts._fieldData,
          "goal": goal._fieldData,
          "isLaunched": isLaunched,
          "prelaunchActivated": prelaunchActivated,
          "url": url,
          "projectDescription": projectDescription,
          "stateChangedAt": stateChangedAt,
          "projectUsdExchangeRate": projectUsdExchangeRate,
          "location": location._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PPOBackingFragment.Project.self),
          ObjectIdentifier(PPOProjectFragment.self),
          ObjectIdentifier(ProjectAnalyticsFragment.self),
          ObjectIdentifier(ProjectCardFragment.self),
          ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.self)
        ]
      ))
    }

    /// Project.Creator
    ///
    /// Parent Type: `User`
    public struct Creator: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }

      /// A user's email address.
      public var email: String? { __data["email"] }
      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// The user's provided name.
      public var name: String { __data["name"] }
      /// Projects a user has created.
      public var createdProjects: CreatedProjects? { __data["createdProjects"] }
      /// Is user blocked by current user
      public var isBlocked: Bool? { __data["isBlocked"] }
      /// The user's avatar.
      public var imageUrl: String { __data["imageUrl"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        email: String? = nil,
        id: GraphAPI.ID,
        name: String,
        createdProjects: CreatedProjects? = nil,
        isBlocked: Bool? = nil,
        imageUrl: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.User.typename,
            "email": email,
            "id": id,
            "name": name,
            "createdProjects": createdProjects._fieldData,
            "isBlocked": isBlocked,
            "imageUrl": imageUrl,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PPOBackingFragment.Project.Creator.self),
            ObjectIdentifier(PPOProjectFragment.Creator.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Creator.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Creator.self)
          ]
        ))
      }

      /// Shared GraphQL selection set alias mapping `CreatedProjects` to `ProjectAnalyticsFragment.Creator.CreatedProjects`.
      public typealias CreatedProjects = ProjectAnalyticsFragment.Creator.CreatedProjects
    }

    /// Project.Image
    ///
    /// Parent Type: `Photo`
    public struct Image: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Photo }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// URL of the photo
      public var url: String { __data["url"] }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Image.self),
            ObjectIdentifier(PPOProjectFragment.Image.self),
            ObjectIdentifier(ProjectCardFragment.Image.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Image.self)
          ]
        ))
      }
    }

    /// Shared GraphQL selection set alias mapping `AddOns` to `ProjectAnalyticsFragment.AddOns`.
    public typealias AddOns = ProjectAnalyticsFragment.AddOns

    /// Project.Backing
    ///
    /// Parent Type: `Backing`
    public struct Backing: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Backing }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        id: GraphAPI.ID
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Backing.typename,
            "id": id,
          ],
          fulfilledFragments: [
            ObjectIdentifier(PPOBackingFragment.Project.Backing.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Backing.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Backing.self)
          ]
        ))
      }
    }

    /// Project.Category
    ///
    /// Parent Type: `Category`
    public struct Category: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }

      /// Category name in English for analytics use.
      public var analyticsName: String { __data["analyticsName"] }
      /// Category parent
      public var parentCategory: ParentCategory? { __data["parentCategory"] }
      /// Category name.
      public var name: String { __data["name"] }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Category.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Category.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Category.self)
          ]
        ))
      }

      /// Shared GraphQL selection set alias mapping `ParentCategory` to `ProjectAnalyticsFragment.Category.ParentCategory`.
      public typealias ParentCategory = ProjectAnalyticsFragment.Category.ParentCategory
    }

    /// Project.Country
    ///
    /// Parent Type: `Country`
    public struct Country: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Country }

      /// ISO ALPHA-2 code.
      public var code: GraphQLEnum<GraphAPI.CountryCode> { __data["code"] }
      /// Country name.
      public var name: String { __data["name"] }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Country.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Country.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Country.self)
          ]
        ))
      }
    }

    /// Shared GraphQL selection set alias mapping `ProjectTag` to `ProjectAnalyticsFragment.ProjectTag`.
    public typealias ProjectTag = ProjectAnalyticsFragment.ProjectTag

    /// Shared GraphQL selection set alias mapping `Rewards` to `ProjectAnalyticsFragment.Rewards`.
    public typealias Rewards = ProjectAnalyticsFragment.Rewards

    /// Project.Video
    ///
    /// Parent Type: `Video`
    public struct Video: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Video }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// A video's sources (hls, high, base)
      public var videoSources: VideoSources? { __data["videoSources"] }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Video.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Video.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Video.self)
          ]
        ))
      }

      /// Shared GraphQL selection set alias mapping `VideoSources` to `ProjectPamphletMainCellPropertiesFragment.Video.VideoSources`.
      public typealias VideoSources = ProjectPamphletMainCellPropertiesFragment.Video.VideoSources
    }

    /// Project.Pledged
    ///
    /// Parent Type: `Money`
    public struct Pledged: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

      /// Floating-point numeric value of monetary amount represented as a string
      public var amount: String? { __data["amount"] }
      /// Currency of the monetary amount
      public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
      /// Symbol of the currency in which the monetary amount appears
      public var symbol: String? { __data["symbol"] }

      /// Typed container providing access to composed Apollo fragments on this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo response dictionary.
        public let __data: DataDict
        /// Initializes the selection set wrapper from an Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// Composed `MoneyFragment` fragment decoded from this selection set.
        public var moneyFragment: MoneyFragment { _toFragment() }
      }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Pledged.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Pledged.self),
            ObjectIdentifier(ProjectCardFragment.Pledged.self),
            ObjectIdentifier(MoneyFragment.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Pledged.self)
          ]
        ))
      }
    }

    /// Shared GraphQL selection set alias mapping `Posts` to `ProjectAnalyticsFragment.Posts`.
    public typealias Posts = ProjectAnalyticsFragment.Posts

    /// Project.Goal
    ///
    /// Parent Type: `Money`
    public struct Goal: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Money }

      /// Floating-point numeric value of monetary amount represented as a string
      public var amount: String? { __data["amount"] }
      /// Currency of the monetary amount
      public var currency: GraphQLEnum<GraphAPI.CurrencyCode>? { __data["currency"] }
      /// Symbol of the currency in which the monetary amount appears
      public var symbol: String? { __data["symbol"] }

      /// Typed container providing access to composed Apollo fragments on this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo response dictionary.
        public let __data: DataDict
        /// Initializes the selection set wrapper from an Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// Composed `MoneyFragment` fragment decoded from this selection set.
        public var moneyFragment: MoneyFragment { _toFragment() }
      }

      /// Synthesizes a selection set instance for tests and previews.
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
            ObjectIdentifier(PPOBackingFragment.Project.Goal.self),
            ObjectIdentifier(ProjectAnalyticsFragment.Goal.self),
            ObjectIdentifier(ProjectCardFragment.Goal.self),
            ObjectIdentifier(MoneyFragment.self),
            ObjectIdentifier(ProjectPamphletMainCellPropertiesFragment.Goal.self)
          ]
        ))
      }
    }

    /// Shared GraphQL selection set alias mapping `Location` to `ProjectPamphletMainCellPropertiesFragment.Location`.
    public typealias Location = ProjectPamphletMainCellPropertiesFragment.Location
  }

  /// DeliveryAddress
  ///
  /// Parent Type: `Address`
  public struct DeliveryAddress: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Address }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", GraphAPI.ID.self),
      .field("addressLine1", String.self),
      .field("addressLine2", String?.self),
      .field("city", String.self),
      .field("region", String?.self),
      .field("postalCode", String?.self),
      .field("phoneNumber", String?.self),
      .field("recipientName", String?.self),
      .field("countryCode", GraphQLEnum<GraphAPI.CountryCode>.self),
    ] }

    /// Relay global node identifier (`GraphAPI.ID`).
    public var id: GraphAPI.ID { __data["id"] }
    /// Address line 1 (Street address/PO Box/Company name)
    public var addressLine1: String { __data["addressLine1"] }
    /// Address line 2 (Apartment/Suite/Unit/Building)
    public var addressLine2: String? { __data["addressLine2"] }
    /// City
    public var city: String { __data["city"] }
    /// State/County/Province/Region.
    public var region: String? { __data["region"] }
    /// ZIP or postal code
    public var postalCode: String? { __data["postalCode"] }
    /// Recipient's phone number
    public var phoneNumber: String? { __data["phoneNumber"] }
    /// Address recipient name
    public var recipientName: String? { __data["recipientName"] }
    /// 2-letter country code
    public var countryCode: GraphQLEnum<GraphAPI.CountryCode> { __data["countryCode"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      id: GraphAPI.ID,
      addressLine1: String,
      addressLine2: String? = nil,
      city: String,
      region: String? = nil,
      postalCode: String? = nil,
      phoneNumber: String? = nil,
      recipientName: String? = nil,
      countryCode: GraphQLEnum<GraphAPI.CountryCode>
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Address.typename,
          "id": id,
          "addressLine1": addressLine1,
          "addressLine2": addressLine2,
          "city": city,
          "region": region,
          "postalCode": postalCode,
          "phoneNumber": phoneNumber,
          "recipientName": recipientName,
          "countryCode": countryCode,
        ],
        fulfilledFragments: [
          ObjectIdentifier(PPOBackingFragment.DeliveryAddress.self)
        ]
      ))
    }
  }
}
