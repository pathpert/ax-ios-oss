// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `LocationFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct LocationFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment LocationFragment on Location { __typename country countryName displayableName id name }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Location }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("country", String.self),
    .field("countryName", String?.self),
    .field("displayableName", String.self),
    .field("id", GraphAPI.ID.self),
    .field("name", String.self),
  ] }

  /// The country code.
  public var country: String { __data["country"] }
  /// The localized country name.
  public var countryName: String? { __data["countryName"] }
  /// The displayable name. It includes the state code for US cities. ex: 'Seattle, WA'
  public var displayableName: String { __data["displayableName"] }
  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The localized name
  public var name: String { __data["name"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    country: String,
    countryName: String? = nil,
    displayableName: String,
    id: GraphAPI.ID,
    name: String
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Location.typename,
        "country": country,
        "countryName": countryName,
        "displayableName": displayableName,
        "id": id,
        "name": name,
      ],
      fulfilledFragments: [
        ObjectIdentifier(LocationFragment.self)
      ]
    ))
  }
}
