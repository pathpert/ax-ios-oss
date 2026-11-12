// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `ProjectDatesFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct ProjectDatesFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectDatesFragment on Project { __typename isProjectOfTheDay deadlineAt finalCollectionDate launchedAt stateChangedAt }"#
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
    .field("isProjectOfTheDay", Bool?.self),
    .field("deadlineAt", GraphAPI.DateTime?.self),
    .field("finalCollectionDate", GraphAPI.ISO8601DateTime?.self),
    .field("launchedAt", GraphAPI.DateTime?.self),
    .field("stateChangedAt", GraphAPI.DateTime.self),
  ] }

  /// Whether or not this is a Project of the Day.
  public var isProjectOfTheDay: Bool? { __data["isProjectOfTheDay"] }
  /// When is the project scheduled to end?
  public var deadlineAt: GraphAPI.DateTime? { __data["deadlineAt"] }
  /// The date at which pledge collections will end
  public var finalCollectionDate: GraphAPI.ISO8601DateTime? { __data["finalCollectionDate"] }
  /// When the project launched
  public var launchedAt: GraphAPI.DateTime? { __data["launchedAt"] }
  /// The last time a project's state changed, time since epoch
  public var stateChangedAt: GraphAPI.DateTime { __data["stateChangedAt"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    isProjectOfTheDay: Bool? = nil,
    deadlineAt: GraphAPI.DateTime? = nil,
    finalCollectionDate: GraphAPI.ISO8601DateTime? = nil,
    launchedAt: GraphAPI.DateTime? = nil,
    stateChangedAt: GraphAPI.DateTime
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Project.typename,
        "isProjectOfTheDay": isProjectOfTheDay,
        "deadlineAt": deadlineAt,
        "finalCollectionDate": finalCollectionDate,
        "launchedAt": launchedAt,
        "stateChangedAt": stateChangedAt,
      ],
      fulfilledFragments: [
        ObjectIdentifier(ProjectDatesFragment.self)
      ]
    ))
  }
}
