// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `RewardItemsFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct RewardItemsFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment RewardItemsFragment on Reward { __typename id project { __typename id } items { __typename edges { __typename quantity node { __typename id name } } } }"#
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
    .field("id", GraphAPI.ID.self),
    .field("project", Project?.self),
    .field("items", Items?.self),
  ] }

  /// Relay global node identifier (`GraphAPI.ID`).
  public var id: GraphAPI.ID { __data["id"] }
  /// The project
  public var project: Project? { __data["project"] }
  /// Items in the reward.
  public var items: Items? { __data["items"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    id: GraphAPI.ID,
    project: Project? = nil,
    items: Items? = nil
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Reward.typename,
        "id": id,
        "project": project._fieldData,
        "items": items._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(RewardItemsFragment.self)
      ]
    ))
  }

  /// Project
  ///
  /// Parent Type: `Project`
  public struct Project: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Project }
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
          "__typename": GraphAPI.Objects.Project.typename,
          "id": id,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RewardItemsFragment.Project.self)
        ]
      ))
    }
  }

  /// Items
  ///
  /// Parent Type: `RewardItemsConnection`
  public struct Items: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RewardItemsConnection }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .field("edges", [Edge?]?.self),
    ] }

    /// A list of edges.
    public var edges: [Edge?]? { __data["edges"] }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      edges: [Edge?]? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.RewardItemsConnection.typename,
          "edges": edges._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RewardItemsFragment.Items.self)
        ]
      ))
    }

    /// Items.Edge
    ///
    /// Parent Type: `RewardItemEdge`
    public struct Edge: GraphAPI.SelectionSet {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema parent object or interface type.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RewardItemEdge }
      /// GraphQL selection fields requested by this selection set.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("quantity", Int.self),
        .field("node", Node?.self),
      ] }

      /// The quantity of an item associated with a reward
      public var quantity: Int { __data["quantity"] }
      /// The item at the end of the edge.
      public var node: Node? { __data["node"] }

      /// Synthesizes a selection set instance for tests and previews.
      public init(
        quantity: Int,
        node: Node? = nil
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.RewardItemEdge.typename,
            "quantity": quantity,
            "node": node._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(RewardItemsFragment.Items.Edge.self)
          ]
        ))
      }

      /// Items.Edge.Node
      ///
      /// Parent Type: `RewardItem`
      public struct Node: GraphAPI.SelectionSet {
        /// Backing Apollo response dictionary.
        public let __data: DataDict
        /// Initializes the selection set wrapper from an Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema parent object or interface type.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.RewardItem }
        /// GraphQL selection fields requested by this selection set.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .field("id", GraphAPI.ID.self),
          .field("name", String.self),
        ] }

        /// Relay global node identifier (`GraphAPI.ID`).
        public var id: GraphAPI.ID { __data["id"] }
        /// An item name.
        public var name: String { __data["name"] }

        /// Synthesizes a selection set instance for tests and previews.
        public init(
          id: GraphAPI.ID,
          name: String
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.RewardItem.typename,
              "id": id,
              "name": name,
            ],
            fulfilledFragments: [
              ObjectIdentifier(RewardItemsFragment.Items.Edge.Node.self)
            ]
          ))
        }
      }
    }
  }
}
