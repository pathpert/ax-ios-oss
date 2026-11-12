// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `PledgeManagerFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct PledgeManagerFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment PledgeManagerFragment on PledgeManager { __typename id acceptsNewBackers }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.PledgeManager }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", GraphAPI.ID.self),
    .field("acceptsNewBackers", Bool.self),
  ] }

  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// Whether the pledge manager accepts new backers or not
  public var acceptsNewBackers: Bool { __data["acceptsNewBackers"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    id: GraphAPI.ID,
    acceptsNewBackers: Bool
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.PledgeManager.typename,
        "id": id,
        "acceptsNewBackers": acceptsNewBackers,
      ],
      fulfilledFragments: [
        ObjectIdentifier(PledgeManagerFragment.self)
      ]
    ))
  }
}
