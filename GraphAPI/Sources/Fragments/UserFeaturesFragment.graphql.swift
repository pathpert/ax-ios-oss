// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL fragment listing server-evaluated feature flags enabled for the authenticated user.
/// - Negative Constraint: Do not mutate `enabledFeatures` locally; combine with `FeatureFlagTools` overrides at read sites.
public struct UserFeaturesFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment UserFeaturesFragment on User { __typename enabledFeatures }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the fragment wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object type (`User`).
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.User }
  /// GraphQL selection fields requested by this fragment.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("enabledFeatures", [GraphQLEnum<GraphAPI.Feature>].self),
  ] }

  /// Server feature flags currently active for the user.
  public var enabledFeatures: [GraphQLEnum<GraphAPI.Feature>] { __data["enabledFeatures"] }

  /// Synthesizes a `UserFeaturesFragment` instance for tests and previews.
  public init(
    enabledFeatures: [GraphQLEnum<GraphAPI.Feature>]
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.User.typename,
        "enabledFeatures": enabledFeatures,
      ],
      fulfilledFragments: [
        ObjectIdentifier(UserFeaturesFragment.self)
      ]
    ))
  }
}
