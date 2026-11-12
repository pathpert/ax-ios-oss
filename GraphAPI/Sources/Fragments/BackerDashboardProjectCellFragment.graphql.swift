// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `BackerDashboardProjectCellFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct BackerDashboardProjectCellFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment BackerDashboardProjectCellFragment on Project { __typename projectId: id name projectState: state image { __typename id url(width: 1024) } goal { __typename ...MoneyFragment } pledged { __typename ...MoneyFragment } isLaunched projectPrelaunchActivated: prelaunchActivated deadlineAt projectLaunchedAt: launchedAt isWatched }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", alias: "projectId", GraphAPI.ID.self),
    .field("name", String.self),
    .field("state", alias: "projectState", GraphQLEnum<GraphAPI.ProjectState>.self),
    .field("image", Image?.self),
    .field("goal", Goal?.self),
    .field("pledged", Pledged.self),
    .field("isLaunched", Bool.self),
    .field("prelaunchActivated", alias: "projectPrelaunchActivated", Bool.self),
    .field("deadlineAt", GraphAPI.DateTime?.self),
    .field("launchedAt", alias: "projectLaunchedAt", GraphAPI.DateTime?.self),
    .field("isWatched", Bool.self),
  ] }

  /// Numeric Kickstarter project identifier (`pid`).
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

  /// Synthesizes a selection set instance for tests and previews.
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
    isWatched: Bool
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
      ],
      fulfilledFragments: [
        ObjectIdentifier(BackerDashboardProjectCellFragment.self)
      ]
    ))
  }

  /// Image
  ///
  /// Parent Type: `Photo`
  public struct Image: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Photo }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", GraphAPI.ID.self),
      .field("url", String.self, arguments: ["width": 1024]),
    ] }

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
          ObjectIdentifier(BackerDashboardProjectCellFragment.Image.self)
        ]
      ))
    }
  }

  /// Goal
  ///
  /// Parent Type: `Money`
  public struct Goal: GraphAPI.SelectionSet {
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
          ObjectIdentifier(BackerDashboardProjectCellFragment.Goal.self),
          ObjectIdentifier(MoneyFragment.self)
        ]
      ))
    }
  }

  /// Pledged
  ///
  /// Parent Type: `Money`
  public struct Pledged: GraphAPI.SelectionSet {
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
          ObjectIdentifier(BackerDashboardProjectCellFragment.Pledged.self),
          ObjectIdentifier(MoneyFragment.self)
        ]
      ))
    }
  }
}
