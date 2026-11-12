// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `NoRewardRewardFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct NoRewardRewardFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment NoRewardRewardFragment on Project { __typename minPledge fxRate }"#
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
    .field("minPledge", Int.self),
    .field("fxRate", Double.self),
  ] }

  /// The min pledge amount for a single reward tier.
  public var minPledge: Int { __data["minPledge"] }
  /// Exchange rate for the current user's currency
  public var fxRate: Double { __data["fxRate"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    minPledge: Int,
    fxRate: Double
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Project.typename,
        "minPledge": minPledge,
        "fxRate": fxRate,
      ],
      fulfilledFragments: [
        ObjectIdentifier(NoRewardRewardFragment.self)
      ]
    ))
  }
}
