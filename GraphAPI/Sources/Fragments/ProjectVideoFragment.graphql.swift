// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `ProjectVideoFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct ProjectVideoFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment ProjectVideoFragment on Video { __typename id videoSources { __typename high { __typename src } hls { __typename src } } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Video }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("id", GraphAPI.ID.self),
    .field("videoSources", VideoSources?.self),
  ] }

  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// A video's sources (hls, high, base)
  public var videoSources: VideoSources? { __data["videoSources"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    id: GraphAPI.ID,
    videoSources: VideoSources? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Video.typename,
        "id": id,
        "videoSources": videoSources._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(ProjectVideoFragment.self)
      ]
    ))
  }

  /// VideoSources
  ///
  /// Parent Type: `VideoSources`
  public struct VideoSources: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.VideoSources }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("high", High?.self),
      .field("hls", Hls?.self),
    ] }

    /// High-resolution video format metadata.
    public var high: High? { __data["high"] }
    /// HTTP Live Streaming (HLS) playlist format metadata.
    public var hls: Hls? { __data["hls"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      high: High? = nil,
      hls: Hls? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.VideoSources.typename,
          "high": high._fieldData,
          "hls": hls._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(ProjectVideoFragment.VideoSources.self)
        ]
      ))
    }

    /// VideoSources.High
    ///
    /// Parent Type: `VideoSourceInfo`
    public struct High: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.VideoSourceInfo }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("src", String?.self),
      ] }

      /// Source media asset URL string.
      public var src: String? { __data["src"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        src: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.VideoSourceInfo.typename,
            "src": src,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ProjectVideoFragment.VideoSources.High.self)
          ]
        ))
      }
    }

    /// VideoSources.Hls
    ///
    /// Parent Type: `VideoSourceInfo`
    public struct Hls: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.VideoSourceInfo }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("src", String?.self),
      ] }

      /// Source media asset URL string.
      public var src: String? { __data["src"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        src: String? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.VideoSourceInfo.typename,
            "src": src,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ProjectVideoFragment.VideoSources.Hls.self)
          ]
        ))
      }
    }
  }
}
