// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `UnwatchProjectMutation`.
public class UnwatchProjectMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "unwatchProject"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation unwatchProject($input: UnwatchProjectInput!) { watchProject: unwatchProject(input: $input) { __typename clientMutationId project { __typename id isWatched watchesCount } } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: UnwatchProjectInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: UnwatchProjectInput) {
    self.input = input
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["input": input] }

  /// Root selection set returned by the GraphQL operation.
  public struct Data: GraphAPI.SelectionSet {
    /// Backing Apollo `DataDict` storage.
    public let __data: DataDict
    /// Creates the selection set from a raw Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema type backing this selection set.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Mutation }
    /// Apollo GraphQL selections requested for this type.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("unwatchProject", alias: "watchProject", WatchProject?.self, arguments: ["input": .variable("input")]),
    ] }

    /// GraphQL variable or field `watchProject`.
    public var watchProject: WatchProject? { __data["watchProject"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      watchProject: WatchProject? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "watchProject": watchProject._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(UnwatchProjectMutation.Data.self)
        ]
      ))
    }

    /// WatchProject
    ///
    /// Parent Type: `UnwatchProjectPayload`
    public struct WatchProject: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.UnwatchProjectPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("clientMutationId", String?.self),
        .field("project", Project?.self),
      ] }

      /// A unique identifier for the client performing the mutation.
      public var clientMutationId: String? { __data["clientMutationId"] }
      /// GraphQL variable or field `project`.
      public var project: Project? { __data["project"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        clientMutationId: String? = nil,
        project: Project? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.UnwatchProjectPayload.typename,
            "clientMutationId": clientMutationId,
            "project": project._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(UnwatchProjectMutation.Data.WatchProject.self)
          ]
        ))
      }

      /// WatchProject.Project
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
          .field("isWatched", Bool.self),
          .field("watchesCount", Int?.self),
        ] }

        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// Is the current user watching this project?
        public var isWatched: Bool { __data["isWatched"] }
        /// Number of watchers a project has.
        public var watchesCount: Int? { __data["watchesCount"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          id: GraphAPI.ID,
          isWatched: Bool,
          watchesCount: Int? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Project.typename,
              "id": id,
              "isWatched": isWatched,
              "watchesCount": watchesCount,
            ],
            fulfilledFragments: [
              ObjectIdentifier(UnwatchProjectMutation.Data.WatchProject.Project.self)
            ]
          ))
        }
      }
    }
  }
}
