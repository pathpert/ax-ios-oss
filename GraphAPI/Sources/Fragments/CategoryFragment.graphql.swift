// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `CategoryFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct CategoryFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment CategoryFragment on Category { __typename id name analyticsName parentCategory { __typename id name analyticsName } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", GraphAPI.ID.self),
    .field("name", String.self),
    .field("analyticsName", String.self),
    .field("parentCategory", ParentCategory?.self),
  ] }

  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// Category name.
  public var name: String { __data["name"] }
  /// Category name in English for analytics use.
  public var analyticsName: String { __data["analyticsName"] }
  /// Category parent
  public var parentCategory: ParentCategory? { __data["parentCategory"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    id: GraphAPI.ID,
    name: String,
    analyticsName: String,
    parentCategory: ParentCategory? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Category.typename,
        "id": id,
        "name": name,
        "analyticsName": analyticsName,
        "parentCategory": parentCategory._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(CategoryFragment.self)
      ]
    ))
  }

  /// ParentCategory
  ///
  /// Parent Type: `Category`
  public struct ParentCategory: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("id", GraphAPI.ID.self),
      .field("name", String.self),
      .field("analyticsName", String.self),
    ] }

    /// Relay global node identifier (`GraphAPI.ID`).
    public var id: GraphAPI.ID { __data["id"] }
    /// Category name.
    public var name: String { __data["name"] }
    /// Category name in English for analytics use.
    public var analyticsName: String { __data["analyticsName"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      id: GraphAPI.ID,
      name: String,
      analyticsName: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Category.typename,
          "id": id,
          "name": name,
          "analyticsName": analyticsName,
        ],
        fulfilledFragments: [
          ObjectIdentifier(CategoryFragment.ParentCategory.self)
        ]
      ))
    }
  }
}
