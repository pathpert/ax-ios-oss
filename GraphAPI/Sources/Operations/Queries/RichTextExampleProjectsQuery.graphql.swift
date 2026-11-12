// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `RichTextExampleProjectsQuery`.
public class RichTextExampleProjectsQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "RichTextExampleProjectsQuery"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query RichTextExampleProjectsQuery($storyRichText: Boolean!) { projects(recommended: true, first: 10) { __typename nodes { __typename id name storyRichText { __typename ...RichTextComponentFragment } } } }"#,
      fragments: [RichTextComponentFragment.self, RichTextItemFragment.self]
    ))

  /// GraphQL variable or field `storyRichText`.
  public var storyRichText: Bool

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(storyRichText: Bool) {
    self.storyRichText = storyRichText
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["storyRichText": storyRichText] }

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
      .field("projects", Projects?.self, arguments: [
        "recommended": true,
        "first": 10
      ]),
    ] }

    /// Get some projects
    public var projects: Projects? { __data["projects"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      projects: Projects? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "projects": projects._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RichTextExampleProjectsQuery.Data.self)
        ]
      ))
    }

    /// Projects
    ///
    /// Parent Type: `ProjectsConnectionWithTotalCount`
    public struct Projects: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectsConnectionWithTotalCount }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("nodes", [Node?]?.self),
      ] }

      /// A list of nodes.
      public var nodes: [Node?]? { __data["nodes"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        nodes: [Node?]? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.ProjectsConnectionWithTotalCount.typename,
            "nodes": nodes._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RichTextExampleProjectsQuery.Data.Projects.self)
          ]
        ))
      }

      /// Projects.Node
      ///
      /// Parent Type: `Project`
      public struct Node: GraphAPI.SelectionSet {
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
              ObjectIdentifier(RichTextExampleProjectsQuery.Data.Projects.Node.self)
            ]
          ))
        }

        /// Projects.Node.StoryRichText
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
                ObjectIdentifier(RichTextExampleProjectsQuery.Data.Projects.Node.StoryRichText.self),
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
}
