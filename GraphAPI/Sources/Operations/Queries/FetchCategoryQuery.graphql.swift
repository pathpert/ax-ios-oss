// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchCategoryQuery`.
public class FetchCategoryQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchCategory"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchCategory($id: ID!) { node(id: $id) { __typename ... on Category { analyticsName id name subcategories { __typename nodes { __typename ...CategoryFragment parentId totalProjectCount } totalCount } totalProjectCount } } }"#,
      fragments: [CategoryFragment.self]
    ))

  /// Unique GraphQL node identifier.
  public var id: ID

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(id: ID) {
    self.id = id
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { ["id": id] }

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
      .field("node", Node?.self, arguments: ["id": .variable("id")]),
    ] }

    /// Fetches an object given its ID.
    public var node: Node? { __data["node"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      node: Node? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "node": node._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchCategoryQuery.Data.self)
        ]
      ))
    }

    /// Node
    ///
    /// Parent Type: `Node`
    public struct Node: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Interfaces.Node }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .inlineFragment(AsCategory.self),
      ] }

      /// GraphQL variable or field `asCategory`.
      public var asCategory: AsCategory? { _asInlineFragment() }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        __typename: String
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": __typename,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchCategoryQuery.Data.Node.self)
          ]
        ))
      }

      /// Node.AsCategory
      ///
      /// Parent Type: `Category`
      public struct AsCategory: GraphAPI.InlineFragment {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// Type alias for `RootEntityType` nested GraphQL selection set.
        public typealias RootEntityType = FetchCategoryQuery.Data.Node
        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("analyticsName", String.self),
          .field("id", GraphAPI.ID.self),
          .field("name", String.self),
          .field("subcategories", Subcategories?.self),
          .field("totalProjectCount", Int.self),
        ] }

        /// Category name in English for analytics use.
        public var analyticsName: String { __data["analyticsName"] }
        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// Category name.
        public var name: String { __data["name"] }
        /// Subcategories.
        public var subcategories: Subcategories? { __data["subcategories"] }
        /// GraphQL variable or field `totalProjectCount`.
        public var totalProjectCount: Int { __data["totalProjectCount"] }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          analyticsName: String,
          id: GraphAPI.ID,
          name: String,
          subcategories: Subcategories? = nil,
          totalProjectCount: Int
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Category.typename,
              "analyticsName": analyticsName,
              "id": id,
              "name": name,
              "subcategories": subcategories._fieldData,
              "totalProjectCount": totalProjectCount,
            ],
            fulfilledFragments: [
              ObjectIdentifier(FetchCategoryQuery.Data.Node.self),
              ObjectIdentifier(FetchCategoryQuery.Data.Node.AsCategory.self)
            ]
          ))
        }

        /// Node.AsCategory.Subcategories
        ///
        /// Parent Type: `CategorySubcategoriesConnection`
        public struct Subcategories: GraphAPI.SelectionSet {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL schema type backing this selection set.
          public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.CategorySubcategoriesConnection }
          /// Apollo GraphQL selections requested for this type.
          public static var __selections: [ApolloAPI.Selection] { [
            .field("__typename", String.self),
            .field("nodes", [Node?]?.self),
            .field("totalCount", Int.self),
          ] }

          /// A list of nodes.
          public var nodes: [Node?]? { __data["nodes"] }
          /// GraphQL variable or field `totalCount`.
          public var totalCount: Int { __data["totalCount"] }

          /// Creates an instance with explicit GraphQL field or variable values.
          public init(
            nodes: [Node?]? = nil,
            totalCount: Int
          ) {
            self.init(_dataDict: DataDict(
              data: [
                "__typename": GraphAPI.Objects.CategorySubcategoriesConnection.typename,
                "nodes": nodes._fieldData,
                "totalCount": totalCount,
              ],
              fulfilledFragments: [
                ObjectIdentifier(FetchCategoryQuery.Data.Node.AsCategory.Subcategories.self)
              ]
            ))
          }

          /// Node.AsCategory.Subcategories.Node
          ///
          /// Parent Type: `Category`
          public struct Node: GraphAPI.SelectionSet {
            /// Backing Apollo `DataDict` storage.
            public let __data: DataDict
            /// Creates the selection set from a raw Apollo `DataDict`.
            public init(_dataDict: DataDict) { __data = _dataDict }

            /// GraphQL schema type backing this selection set.
            public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }
            /// Apollo GraphQL selections requested for this type.
            public static var __selections: [ApolloAPI.Selection] { [
              .field("__typename", String.self),
              .field("parentId", GraphAPI.ID?.self),
              .field("totalProjectCount", Int.self),
              .fragment(CategoryFragment.self),
            ] }

            /// Parent id of the category.
            public var parentId: GraphAPI.ID? { __data["parentId"] }
            /// GraphQL variable or field `totalProjectCount`.
            public var totalProjectCount: Int { __data["totalProjectCount"] }
            /// Unique GraphQL node identifier.
            public var id: GraphAPI.ID { __data["id"] }
            /// Category name.
            public var name: String { __data["name"] }
            /// Category name in English for analytics use.
            public var analyticsName: String { __data["analyticsName"] }
            /// Category parent
            public var parentCategory: ParentCategory? { __data["parentCategory"] }

            /// Container of reusable GraphQL fragment views for this selection set.
            public struct Fragments: FragmentContainer {
              /// Backing Apollo `DataDict` storage.
              public let __data: DataDict
              /// Creates the selection set from a raw Apollo `DataDict`.
              public init(_dataDict: DataDict) { __data = _dataDict }

              /// GraphQL variable or field `categoryFragment`.
              public var categoryFragment: CategoryFragment { _toFragment() }
            }

            /// Creates an instance with explicit GraphQL field or variable values.
            public init(
              parentId: GraphAPI.ID? = nil,
              totalProjectCount: Int,
              id: GraphAPI.ID,
              name: String,
              analyticsName: String,
              parentCategory: ParentCategory? = nil
            ) {
              self.init(_dataDict: DataDict(
                data: [
                  "__typename": GraphAPI.Objects.Category.typename,
                  "parentId": parentId,
                  "totalProjectCount": totalProjectCount,
                  "id": id,
                  "name": name,
                  "analyticsName": analyticsName,
                  "parentCategory": parentCategory._fieldData,
                ],
                fulfilledFragments: [
                  ObjectIdentifier(FetchCategoryQuery.Data.Node.AsCategory.Subcategories.Node.self),
                  ObjectIdentifier(CategoryFragment.self)
                ]
              ))
            }

            /// Type alias for `ParentCategory` nested GraphQL selection set.
            public typealias ParentCategory = CategoryFragment.ParentCategory
          }
        }
      }
    }
  }
}
