// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `CountryFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct CountryFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment CountryFragment on Country { __typename code name }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Country }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("code", GraphQLEnum<GraphAPI.CountryCode>.self),
    .field("name", String.self),
  ] }

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
        ObjectIdentifier(CountryFragment.self)
      ]
    ))
  }
}
