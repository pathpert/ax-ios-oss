// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL mutation `AddUserToSecretRewardGroupMutation`.
public class AddUserToSecretRewardGroupMutation: GraphQLMutation {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "addUserToSecretRewardGroup"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"mutation addUserToSecretRewardGroup($input: AddUserToSecretRewardGroupInput!) { addUserToSecretRewardGroup(input: $input) { __typename project { __typename id rewards { __typename nodes { __typename id name } } } } }"#
    ))

  /// GraphQL variable or field `input`.
  public var input: AddUserToSecretRewardGroupInput

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(input: AddUserToSecretRewardGroupInput) {
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
      .field("addUserToSecretRewardGroup", AddUserToSecretRewardGroup?.self, arguments: ["input": .variable("input")]),
    ] }

    /// Adds a user to a secret reward user group
    public var addUserToSecretRewardGroup: AddUserToSecretRewardGroup? { __data["addUserToSecretRewardGroup"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      addUserToSecretRewardGroup: AddUserToSecretRewardGroup? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Mutation.typename,
          "addUserToSecretRewardGroup": addUserToSecretRewardGroup._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(AddUserToSecretRewardGroupMutation.Data.self)
        ]
      ))
    }

    /// AddUserToSecretRewardGroup
    ///
    /// Parent Type: `AddUserToSecretRewardGroupPayload`
    public struct AddUserToSecretRewardGroup: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.AddUserToSecretRewardGroupPayload }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("project", Project.self),
      ] }

      /// Project data
      public var project: Project { __data["project"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        project: Project
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.AddUserToSecretRewardGroupPayload.typename,
            "project": project._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(AddUserToSecretRewardGroupMutation.Data.AddUserToSecretRewardGroup.self)
          ]
        ))
      }

      /// AddUserToSecretRewardGroup.Project
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
          .field("rewards", Rewards?.self),
        ] }

        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// Project rewards.
        public var rewards: Rewards? { __data["rewards"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          id: GraphAPI.ID,
          rewards: Rewards? = nil
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Project.typename,
              "id": id,
              "rewards": rewards._fieldData,
            ],
            fulfilledFragments: [
              ObjectIdentifier(AddUserToSecretRewardGroupMutation.Data.AddUserToSecretRewardGroup.Project.self)
            ]
          ))
        }

        /// AddUserToSecretRewardGroup.Project.Rewards
        ///
        /// Parent Type: `ProjectRewardConnection`
        public struct Rewards: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.ProjectRewardConnection }
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
                "__typename": GraphAPI.Objects.ProjectRewardConnection.typename,
                "nodes": nodes._fieldData,
              ],
              fulfilledFragments: [
                ObjectIdentifier(AddUserToSecretRewardGroupMutation.Data.AddUserToSecretRewardGroup.Project.Rewards.self)
              ]
            ))
          }

          /// AddUserToSecretRewardGroup.Project.Rewards.Node
          ///
          /// Parent Type: `Reward`
          public struct Node: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Reward }
            /// Apollo GraphQL selections requested for this type.
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("id", GraphAPI.ID.self),
              .field("name", String?.self),
            ] }

            /// Unique GraphQL node identifier.
            public var id: GraphAPI.ID { __data["id"] }
            /// A reward title.
            public var name: String? { __data["name"] }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              id: GraphAPI.ID,
              name: String? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Reward.typename,
                  "id": id,
                  "name": name,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(AddUserToSecretRewardGroupMutation.Data.AddUserToSecretRewardGroup.Project.Rewards.Node.self)
                ]
              ))
            }
          }
        }
      }
    }
  }
}
