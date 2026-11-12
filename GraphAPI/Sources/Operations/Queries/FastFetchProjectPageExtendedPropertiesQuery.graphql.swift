// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FastFetchProjectPageExtendedPropertiesQuery`.
public class FastFetchProjectPageExtendedPropertiesQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FastFetchProjectPageExtendedPropertiesQuery"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FastFetchProjectPageExtendedPropertiesQuery($projectId: Int, $slug: String, $storyRichText: Boolean!) { project(pid: $projectId, slug: $slug) { __typename ...ExtendedProjectPropertiesFragment video { __typename ...ProjectVideoFragment } flagging { __typename kind } } }"#,
      fragments: [ExtendedProjectPropertiesFragment.self, ProjectVideoFragment.self, RichTextComponentFragment.self, RichTextItemFragment.self]
    ))

  /// GraphQL variable or field `projectId`.
  public var projectId: GraphQLNullable<Int>
  /// GraphQL variable or field `slug`.
  public var slug: GraphQLNullable<String>
  /// GraphQL variable or field `storyRichText`.
  public var storyRichText: Bool

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    projectId: GraphQLNullable<Int>,
    slug: GraphQLNullable<String>,
    storyRichText: Bool
  ) {
    self.projectId = projectId
    self.slug = slug
    self.storyRichText = storyRichText
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "projectId": projectId,
    "slug": slug,
    "storyRichText": storyRichText
  ] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Query }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("project", Project?.self, arguments: [
        "pid": .variable("projectId"),
        "slug": .variable("slug")
      ]),
    ] }

    /// Fetches a project given its slug or pid.
    public var project: Project? { __data["project"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      project: Project? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "project": project._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.self)
        ]
      ))
    }

    /// Project
    ///
    /// Parent Type: `Project`
    public struct Project: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("video", Video?.self),
        .field("flagging", Flagging?.self),
        .fragment(ExtendedProjectPropertiesFragment.self),
      ] }

      /// A project video.
      public var video: Video? { __data["video"] }
      /// A report by the current user for the project.
      public var flagging: Flagging? { __data["flagging"] }
      /// GraphQL variable or field `aiDisclosure`.
      public var aiDisclosure: AiDisclosure? { __data["aiDisclosure"] }
      /// The environmental commitments of the project.
      public var environmentalCommitments: [EnvironmentalCommitment?]? { __data["environmentalCommitments"] }
      /// List of FAQs of a project
      public var faqs: Faqs? { __data["faqs"] }
      /// The min pledge amount for a single reward tier.
      public var minPledge: Int { __data["minPledge"] }
      /// The text of the currently applied project notice, empty if there is no notice
      public var projectNotice: String? { __data["projectNotice"] }
      /// Potential hurdles to project completion.
      public var risks: String { __data["risks"] }
      /// The story behind the project, parsed for presentation.
      public var story: GraphAPI.HTML { __data["story"] }
      /// The project has launched
      public var isLaunched: Bool { __data["isLaunched"] }
      /// Return an itemized version of the prelaunch story. This feature is in BETA: types can change anytime!
      public var prelaunchStoryRichText: PrelaunchStoryRichText { __data["prelaunchStoryRichText"] }
      /// Return an itemized version of the story. This feature is in BETA: types can change anytime!
      public var storyRichText: StoryRichText { __data["storyRichText"] }

      /// Container of reusable GraphQL fragment views for this selection set.
      public struct Fragments: FragmentContainer {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL variable or field `extendedProjectPropertiesFragment`.
        public var extendedProjectPropertiesFragment: ExtendedProjectPropertiesFragment { _toFragment() }
      }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        video: Video? = nil,
        flagging: Flagging? = nil,
        aiDisclosure: AiDisclosure? = nil,
        environmentalCommitments: [EnvironmentalCommitment?]? = nil,
        faqs: Faqs? = nil,
        minPledge: Int,
        projectNotice: String? = nil,
        risks: String,
        story: GraphAPI.HTML,
        isLaunched: Bool,
        prelaunchStoryRichText: PrelaunchStoryRichText,
        storyRichText: StoryRichText
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "video": video._fieldData,
            "flagging": flagging._fieldData,
            "aiDisclosure": aiDisclosure._fieldData,
            "environmentalCommitments": environmentalCommitments._fieldData,
            "faqs": faqs._fieldData,
            "minPledge": minPledge,
            "projectNotice": projectNotice,
            "risks": risks,
            "story": story,
            "isLaunched": isLaunched,
            "prelaunchStoryRichText": prelaunchStoryRichText._fieldData,
            "storyRichText": storyRichText._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.Project.self),
            ObjectIdentifier(ExtendedProjectPropertiesFragment.self)
          ]
        ))
      }

      /// Project.Video
      ///
      /// Parent Type: `Video`
      public struct Video: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Video }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(ProjectVideoFragment.self),
        ] }

        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// A video's sources (hls, high, base)
        public var videoSources: VideoSources? { __data["videoSources"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `projectVideoFragment`.
          public var projectVideoFragment: ProjectVideoFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
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
              ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.Project.Video.self),
              ObjectIdentifier(ProjectVideoFragment.self)
            ]
          ))
        }

        /// Type alias for `VideoSources` nested GraphQL selection set.
        public typealias VideoSources = ProjectVideoFragment.VideoSources
      }

      /// Project.Flagging
      ///
      /// Parent Type: `Flagging`
      public struct Flagging: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Flagging }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("kind", GraphQLEnum<GraphAPI.FlaggingKind>?.self),
        ] }

        /// The general reason for the flagging.
        public var kind: GraphQLEnum<GraphAPI.FlaggingKind>? { __data["kind"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          kind: GraphQLEnum<GraphAPI.FlaggingKind>? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Flagging.typename,
              "kind": kind,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.Project.Flagging.self)
            ]
          ))
        }
      }

      /// Type alias for `AiDisclosure` nested GraphQL selection set.
      public typealias AiDisclosure = ExtendedProjectPropertiesFragment.AiDisclosure

      /// Type alias for `EnvironmentalCommitment` nested GraphQL selection set.
      public typealias EnvironmentalCommitment = ExtendedProjectPropertiesFragment.EnvironmentalCommitment

      /// Type alias for `Faqs` nested GraphQL selection set.
      public typealias Faqs = ExtendedProjectPropertiesFragment.Faqs

      /// Project.PrelaunchStoryRichText
      ///
      /// Parent Type: `RichTextComponent`
      public struct PrelaunchStoryRichText: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextComponent }

        /// GraphQL variable or field `items`.
        public var items: [Item]? { __data["items"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `richTextComponentFragment`.
          public var richTextComponentFragment: RichTextComponentFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          items: [Item]? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.RichTextComponent.typename,
              "items": items._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.Project.PrelaunchStoryRichText.self),
              ObjectIdentifier(ExtendedProjectPropertiesFragment.PrelaunchStoryRichText.self),
              ObjectIdentifier(RichTextComponentFragment.self)
            ]
          ))
        }

        /// Type alias for `Item` nested GraphQL selection set.
        public typealias Item = RichTextComponentFragment.Item
      }

      /// Project.StoryRichText
      ///
      /// Parent Type: `RichTextComponent`
      public struct StoryRichText: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RichTextComponent }

        /// GraphQL variable or field `items`.
        public var items: [Item]? { __data["items"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `richTextComponentFragment`.
          public var richTextComponentFragment: RichTextComponentFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          items: [Item]? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.RichTextComponent.typename,
              "items": items._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FastFetchProjectPageExtendedPropertiesQuery.Data.Project.StoryRichText.self),
              ObjectIdentifier(ExtendedProjectPropertiesFragment.StoryRichText.self),
              ObjectIdentifier(RichTextComponentFragment.self)
            ]
          ))
        }

        /// Type alias for `Item` nested GraphQL selection set.
        public typealias Item = RichTextComponentFragment.Item
      }
    }
  }
}
