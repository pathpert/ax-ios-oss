// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `FetchRootCategoriesQuery`.
public class FetchRootCategoriesQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "FetchRootCategories"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query FetchRootCategories { rootCategories { __typename id name analyticsName subcategories { __typename nodes { __typename ...CategoryFragment parentId totalProjectCount } totalCount } totalProjectCount } }"#,
      fragments: [CategoryFragment.self]
    ))

  /// Creates an instance with explicit GraphQL field or variable values.
  public init() {}

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
      .field("rootCategories", [RootCategory].self),
    ] }

    /// Root project categories.
    public var rootCategories: [RootCategory] { __data["rootCategories"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      rootCategories: [RootCategory]
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "rootCategories": rootCategories._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(FetchRootCategoriesQuery.Data.self)
        ]
      ))
    }

    /// RootCategory
    ///
    /// Parent Type: `Category`
    public struct RootCategory: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Category }
      /// Apollo GraphQL selections requested for this type.
      public static var __selections: [ApolloAPI.Selection] { [
        .field("__typename", String.self),
        .field("id", GraphAPI.ID.self),
        .field("name", String.self),
        .field("analyticsName", String.self),
        .field("subcategories", Subcategories?.self),
        .field("totalProjectCount", Int.self),
      ] }

      /// Unique GraphQL node identifier.
      public var id: GraphAPI.ID { __data["id"] }
      /// Category name.
      public var name: String { __data["name"] }
      /// Category name in English for analytics use.
      public var analyticsName: String { __data["analyticsName"] }
      /// Subcategories.
      public var subcategories: Subcategories? { __data["subcategories"] }
      /// GraphQL variable or field `totalProjectCount`.
      public var totalProjectCount: Int { __data["totalProjectCount"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        id: GraphAPI.ID,
        name: String,
        analyticsName: String,
        subcategories: Subcategories? = nil,
        totalProjectCount: Int
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Category.typename,
            "id": id,
            "name": name,
            "analyticsName": analyticsName,
            "subcategories": subcategories._fieldData,
            "totalProjectCount": totalProjectCount,
          ],
          fulfilledFragments: [
            ObjectIdentifier(FetchRootCategoriesQuery.Data.RootCategory.self)
          ]
        ))
      }

      /// RootCategory.Subcategories
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
              ObjectIdentifier(FetchRootCategoriesQuery.Data.RootCategory.Subcategories.self)
            ]
          ))
        }

        /// RootCategory.Subcategories.Node
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
                ObjectIdentifier(FetchRootCategoriesQuery.Data.RootCategory.Subcategories.Node.self),
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
