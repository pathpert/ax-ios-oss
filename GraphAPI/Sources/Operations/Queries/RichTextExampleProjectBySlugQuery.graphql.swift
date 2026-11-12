// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `RichTextExampleProjectBySlugQuery`.
public class RichTextExampleProjectBySlugQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "RichTextExampleProjectBySlugQuery"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RichTextExampleProjectBySlugQuery($slug: String!, $storyRichText: Boolean!) { project(slug: $slug) { __typename id name storyRichText { __typename ...RichTextComponentFragment } } }"#,
      fragments: [RichTextComponentFragment.self, RichTextItemFragment.self]
    ))

  /// GraphQL variable or field `slug`.
  public var slug: String
  /// GraphQL variable or field `storyRichText`.
  public var storyRichText: Bool

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    slug: String,
    storyRichText: Bool
  ) {
    self.slug = slug
    self.storyRichText = storyRichText
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
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
      .field("project", Project?.self, arguments: ["slug": .variable("slug")]),
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
          ObjectIdentifier(RichTextExampleProjectBySlugQuery.Data.self)
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
        .field("id", GraphAPI.ID.self),
        .field("name", String.self),
        .field("storyRichText", StoryRichText.self),
      ] }

      /// Unique GraphQL node identifier.
      public var id: GraphAPI.ID { __data["id"] }
      /// The project's name.
      public var name: String { __data["name"] }
      /// Return an itemized version of the story. This feature is in BETA: types can change anytime!
      public var storyRichText: StoryRichText { __data["storyRichText"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        id: GraphAPI.ID,
        name: String,
        storyRichText: StoryRichText
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "id": id,
            "name": name,
            "storyRichText": storyRichText._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RichTextExampleProjectBySlugQuery.Data.Project.self)
          ]
        ))
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
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(RichTextComponentFragment.self),
        ] }

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
              ObjectIdentifier(RichTextExampleProjectBySlugQuery.Data.Project.StoryRichText.self),
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
