// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `RichTextItemFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct RichTextItemFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment RichTextItemFragment on RichTextItem { __typename ... on RichText { text link styles } ... on RichTextHeader { text link styles } ... on RichTextListItem { text link styles } ... on RichTextListOpen { _present } ... on RichTextListClose { _present } ... on RichTextPhoto { altText asset { __typename id url(width: 99999) } caption } ... on RichTextAudio { altText asset { __typename id } caption url } ... on RichTextVideo { altText asset { __typename id poster formats { __typename encoding height width profile url } } caption url } ... on RichTextOembed { width height version title type iframeUrl originalUrl } }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the selection set wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object or interface type.
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Unions.RichTextItem }
  /// GraphQL selection fields requested by this selection set.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .inlineFragment(AsRichText.self),
    .inlineFragment(AsRichTextHeader.self),
    .inlineFragment(AsRichTextListItem.self),
    .inlineFragment(AsRichTextListOpen.self),
    .inlineFragment(AsRichTextListClose.self),
    .inlineFragment(AsRichTextPhoto.self),
    .inlineFragment(AsRichTextAudio.self),
    .inlineFragment(AsRichTextVideo.self),
    .inlineFragment(AsRichTextOembed.self),
  ] }

  /// Inline fragment projection as `AsRichText?`, or `nil` if `__typename` differs.
  public var asRichText: AsRichText? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextHeader?`, or `nil` if `__typename` differs.
  public var asRichTextHeader: AsRichTextHeader? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextListItem?`, or `nil` if `__typename` differs.
  public var asRichTextListItem: AsRichTextListItem? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextListOpen?`, or `nil` if `__typename` differs.
  public var asRichTextListOpen: AsRichTextListOpen? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextListClose?`, or `nil` if `__typename` differs.
  public var asRichTextListClose: AsRichTextListClose? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextPhoto?`, or `nil` if `__typename` differs.
  public var asRichTextPhoto: AsRichTextPhoto? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextAudio?`, or `nil` if `__typename` differs.
  public var asRichTextAudio: AsRichTextAudio? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextVideo?`, or `nil` if `__typename` differs.
  public var asRichTextVideo: AsRichTextVideo? { _asInlineFragment() }
  /// Inline fragment projection as `AsRichTextOembed?`, or `nil` if `__typename` differs.
  public var asRichTextOembed: AsRichTextOembed? { _asInlineFragment() }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    __typename: String
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": __typename,
      ],
      fulfilledFragments: [
        ObjectIdentifier(RichTextItemFragment.self)
      ]
    ))
  }

  /// AsRichText
  ///
  /// Parent Type: `RichText`
  public struct AsRichText: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichText }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("text", String?.self),
      .field("link", String?.self),
      .field("styles", [String]?.self),
    ] }

    /// Text content for this GraphQL node.
    public var text: String? { __data["text"] }
    /// Optional hyperlink URL associated with this node.
    public var link: String? { __data["link"] }
    /// Inline formatting style identifiers (for example bold, italic, link).
    public var styles: [String]? { __data["styles"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      text: String? = nil,
      link: String? = nil,
      styles: [String]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichText.typename,
          "text": text,
          "link": link,
          "styles": styles,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichText.self)
        ]
      ))
    }
  }

  /// AsRichTextHeader
  ///
  /// Parent Type: `RichTextHeader`
  public struct AsRichTextHeader: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextHeader }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("text", String?.self),
      .field("link", String?.self),
      .field("styles", [String]?.self),
    ] }

    /// Text content for this GraphQL node.
    public var text: String? { __data["text"] }
    /// Optional hyperlink URL associated with this node.
    public var link: String? { __data["link"] }
    /// Inline formatting style identifiers (for example bold, italic, link).
    public var styles: [String]? { __data["styles"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      text: String? = nil,
      link: String? = nil,
      styles: [String]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextHeader.typename,
          "text": text,
          "link": link,
          "styles": styles,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextHeader.self)
        ]
      ))
    }
  }

  /// AsRichTextListItem
  ///
  /// Parent Type: `RichTextListItem`
  public struct AsRichTextListItem: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextListItem }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("text", String?.self),
      .field("link", String?.self),
      .field("styles", [String]?.self),
    ] }

    /// Text content for this GraphQL node.
    public var text: String? { __data["text"] }
    /// Optional hyperlink URL associated with this node.
    public var link: String? { __data["link"] }
    /// Inline formatting style identifiers (for example bold, italic, link).
    public var styles: [String]? { __data["styles"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      text: String? = nil,
      link: String? = nil,
      styles: [String]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextListItem.typename,
          "text": text,
          "link": link,
          "styles": styles,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextListItem.self)
        ]
      ))
    }
  }

  /// AsRichTextListOpen
  ///
  /// Parent Type: `RichTextListOpen`
  public struct AsRichTextListOpen: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextListOpen }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("_present", Bool.self),
    ] }

    /// Placeholder to avoid empty type
    public var _present: Bool { __data["_present"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      _present: Bool
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextListOpen.typename,
          "_present": _present,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextListOpen.self)
        ]
      ))
    }
  }

  /// AsRichTextListClose
  ///
  /// Parent Type: `RichTextListClose`
  public struct AsRichTextListClose: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextListClose }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("_present", Bool.self),
    ] }

    /// Placeholder to avoid empty type
    public var _present: Bool { __data["_present"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      _present: Bool
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextListClose.typename,
          "_present": _present,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextListClose.self)
        ]
      ))
    }
  }

  /// AsRichTextPhoto
  ///
  /// Parent Type: `RichTextPhoto`
  public struct AsRichTextPhoto: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextPhoto }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("altText", String.self),
      .field("asset", Asset?.self),
      .field("caption", String.self),
    ] }

    /// Accessibility alternative text description.
    public var altText: String { __data["altText"] }
    /// GraphQL field `asset` decoded as `Asset?`.
    public var asset: Asset? { __data["asset"] }
    /// Human-readable caption text, if provided.
    public var caption: String { __data["caption"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      altText: String,
      asset: Asset? = nil,
      caption: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextPhoto.typename,
          "altText": altText,
          "asset": asset._fieldData,
          "caption": caption,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextPhoto.self)
        ]
      ))
    }

    /// AsRichTextPhoto.Asset
    ///
    /// Parent Type: `Photo`
    public struct Asset: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Photo }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GraphAPI.ID.self),
        .field("url", String.self, arguments: ["width": 99999]),
      ] }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// URL of the photo
      public var url: String { __data["url"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        id: GraphAPI.ID,
        url: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Photo.typename,
            "id": id,
            "url": url,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RichTextItemFragment.AsRichTextPhoto.Asset.self)
          ]
        ))
      }
    }
  }

  /// AsRichTextAudio
  ///
  /// Parent Type: `RichTextAudio`
  public struct AsRichTextAudio: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextAudio }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("altText", String.self),
      .field("asset", Asset?.self),
      .field("caption", String.self),
      .field("url", String.self),
    ] }

    /// Accessibility alternative text description.
    public var altText: String { __data["altText"] }
    /// GraphQL field `asset` decoded as `Asset?`.
    public var asset: Asset? { __data["asset"] }
    /// Human-readable caption text, if provided.
    public var caption: String { __data["caption"] }
    /// Canonical URL string returned by GraphQL.
    public var url: String { __data["url"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      altText: String,
      asset: Asset? = nil,
      caption: String,
      url: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextAudio.typename,
          "altText": altText,
          "asset": asset._fieldData,
          "caption": caption,
          "url": url,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextAudio.self)
        ]
      ))
    }

    /// AsRichTextAudio.Asset
    ///
    /// Parent Type: `AttachedAudio`
    public struct Asset: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.AttachedAudio }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GraphAPI.ID.self),
      ] }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        id: GraphAPI.ID
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.AttachedAudio.typename,
            "id": id,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RichTextItemFragment.AsRichTextAudio.Asset.self)
          ]
        ))
      }
    }
  }

  /// AsRichTextVideo
  ///
  /// Parent Type: `RichTextVideo`
  public struct AsRichTextVideo: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextVideo }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("altText", String.self),
      .field("asset", Asset?.self),
      .field("caption", String.self),
      .field("url", String.self),
    ] }

    /// Accessibility alternative text description.
    public var altText: String { __data["altText"] }
    /// GraphQL field `asset` decoded as `Asset?`.
    public var asset: Asset? { __data["asset"] }
    /// Human-readable caption text, if provided.
    public var caption: String { __data["caption"] }
    /// Canonical URL string returned by GraphQL.
    public var url: String { __data["url"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      altText: String,
      asset: Asset? = nil,
      caption: String,
      url: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextVideo.typename,
          "altText": altText,
          "asset": asset._fieldData,
          "caption": caption,
          "url": url,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextVideo.self)
        ]
      ))
    }

    /// AsRichTextVideo.Asset
    ///
    /// Parent Type: `AttachedVideo`
    public struct Asset: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.AttachedVideo }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GraphAPI.ID.self),
        .field("poster", String?.self),
        .field("formats", [Format?]?.self),
      ] }

      /// Relay global node identifier (`GraphAPI.ID`).
      public var id: GraphAPI.ID { __data["id"] }
      /// Image preview url
      public var poster: String? { __data["poster"] }
      /// GraphQL field `formats` decoded as `[Format?]?`.
      public var formats: [Format?]? { __data["formats"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        id: GraphAPI.ID,
        poster: String? = nil,
        formats: [Format?]? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.AttachedVideo.typename,
            "id": id,
            "poster": poster,
            "formats": formats._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RichTextItemFragment.AsRichTextVideo.Asset.self)
          ]
        ))
      }

      /// AsRichTextVideo.Asset.Format
      ///
      /// Parent Type: `AttachedVideoFormat`
      public struct Format: GraphAPI.SelectionSet {
        /// Backing Apollo response dictionary.
        public let __data: DataDict
        /// Initializes the selection set wrapper from an Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema parent object or interface type.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.AttachedVideoFormat }
        /// GraphQL selection fields requested by this selection set.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("encoding", String.self),
          .field("height", String.self),
          .field("width", String.self),
          .field("profile", String.self),
          .field("url", String.self),
        ] }

        /// Media stream encoding identifier.
        public var encoding: String { __data["encoding"] }
        /// Rendered media height dimension.
        public var height: String { __data["height"] }
        /// Rendered media width dimension.
        public var width: String { __data["width"] }
        /// Video encoding profile identifier.
        public var profile: String { __data["profile"] }
        /// Canonical URL string returned by GraphQL.
        public var url: String { __data["url"] }

        /// Synthesizes a selection set instance for tests and previews.
        public init(
          encoding: String,
          height: String,
          width: String,
          profile: String,
          url: String
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.AttachedVideoFormat.typename,
              "encoding": encoding,
              "height": height,
              "width": width,
              "profile": profile,
              "url": url,
            ],
            fulfilledFragments: [
              ObjectIdentifier(RichTextItemFragment.AsRichTextVideo.Asset.Format.self)
            ]
          ))
        }
      }
    }
  }

  /// AsRichTextOembed
  ///
  /// Parent Type: `RichTextOembed`
  public struct AsRichTextOembed: GraphAPI.InlineFragment {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// Shared GraphQL selection set alias mapping `RootEntityType` to `RichTextItemFragment`.
    public typealias RootEntityType = RichTextItemFragment
    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextOembed }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("width", Int.self),
      .field("height", Int.self),
      .field("version", String.self),
      .field("title", String.self),
      .field("type", String.self),
      .field("iframeUrl", String.self),
      .field("originalUrl", String.self),
    ] }

    /// ex: 480
    public var width: Int { __data["width"] }
    /// ex: 270
    public var height: Int { __data["height"] }
    /// always "1.0"
    public var version: String { __data["version"] }
    /// ex: Bird Photo Booth bird feeder kickstarter preview 2
    public var title: String { __data["title"] }
    /// one of: photo, video, link, rich
    public var type: String { __data["type"] }
    /// ex: https://www.youtube.com/embed/ijeaVn8znJ8?feature=oembed
    public var iframeUrl: String { __data["iframeUrl"] }
    /// ex: https://youtu.be/ijeaVn8znJ8
    public var originalUrl: String { __data["originalUrl"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      width: Int,
      height: Int,
      version: String,
      title: String,
      type: String,
      iframeUrl: String,
      originalUrl: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RichTextOembed.typename,
          "width": width,
          "height": height,
          "version": version,
          "title": title,
          "type": type,
          "iframeUrl": iframeUrl,
          "originalUrl": originalUrl,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextItemFragment.self),
          ObjectIdentifier(RichTextItemFragment.AsRichTextOembed.self)
        ]
      ))
    }
  }
}
