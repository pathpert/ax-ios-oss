// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `RewardImageFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct RewardImageFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment RewardImageFragment on Reward { __typename image { __typename altText url(width: 1024) } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Reward }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("image", Image?.self),
  ] }

  /// The reward image.
  public var image: Image? { __data["image"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    image: Image? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Reward.typename,
        "image": image._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(RewardImageFragment.self)
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
      .field("altText", String.self),
      .field("url", String.self, arguments: ["width": 1024]),
    ] }

    /// Alt text on the image
    public var altText: String { __data["altText"] }
    /// URL of the photo
    public var url: String { __data["url"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      altText: String,
      url: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Photo.typename,
          "altText": altText,
          "url": url,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RewardImageFragment.Image.self)
        ]
      ))
    }
  }
}
