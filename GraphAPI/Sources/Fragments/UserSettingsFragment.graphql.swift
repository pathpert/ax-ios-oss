// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `UserSettingsFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct UserSettingsFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment UserSettingsFragment on User { __typename chosenCurrency }"#
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
    .field("chosenCurrency", String?.self),
  ] }

  /// The user's chosen currency
  public var chosenCurrency: String? { __data["chosenCurrency"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    chosenCurrency: String? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.User.typename,
        "chosenCurrency": chosenCurrency,
      ],
      fulfilledFragments: [
        ObjectIdentifier(UserSettingsFragment.self)
      ]
    ))
  }
}
