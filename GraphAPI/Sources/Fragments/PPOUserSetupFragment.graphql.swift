// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `PPOUserSetupFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct PPOUserSetupFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment PPOUserSetupFragment on User { __typename ppoHasAction backingActionCount }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("ppoHasAction", Bool?.self),
    .field("backingActionCount", Int?.self),
  ] }

  /// Whether backer has any action in PPO
  public var ppoHasAction: Bool? { __data["ppoHasAction"] }
  /// Count of pledges with pending action
  public var backingActionCount: Int? { __data["backingActionCount"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    ppoHasAction: Bool? = nil,
    backingActionCount: Int? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.User.typename,
        "ppoHasAction": ppoHasAction,
        "backingActionCount": backingActionCount,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PPOUserSetupFragment.self)
      ]
    ))
  }
}
