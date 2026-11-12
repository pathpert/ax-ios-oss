// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `LocationsByTermQuery`.
public class LocationsByTermQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "LocationsByTerm"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query LocationsByTerm($term: String, $first: Int) { locations(term: $term, first: $first) { __typename nodes { __typename ...LocationFragment } } }"#,
      fragments: [LocationFragment.self]
    ))

  /// GraphQL variable or field `term`.
  public var term: GraphQLNullable<String>
  /// GraphQL variable or field `first`.
  public var first: GraphQLNullable<Int>

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(
    term: GraphQLNullable<String>,
    first: GraphQLNullable<Int>
  ) {
    self.term = term
    self.first = first
  }

  /// Serialized GraphQL operation variables.
  public var __variables: Variables? { [
    "term": term,
    "first": first
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
      .field("locations", Locations?.self, arguments: [
        "term": .variable("term"),
        "first": .variable("first")
      ]),
    ] }

    /// Searches locations.
    public var locations: Locations? { __data["locations"] }

    /// Creates an instance with explicit GraphQL field or variable values.
    public init(
      locations: Locations? = nil
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.Query.typename,
          "locations": locations._fieldData,
        ],
        fulfilledFragments: [
          ObjectIdentifier(LocationsByTermQuery.Data.self)
        ]
      ))
    }

    /// Locations
    ///
    /// Parent Type: `LocationsConnection`
    public struct Locations: GraphAPI.SelectionSet {
      /// Backing Apollo `DataDict` storage.
      public let __data: DataDict
      /// Creates the selection set from a raw Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// GraphQL schema type backing this selection set.
      public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.LocationsConnection }
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
            "__typename": GraphAPI.Objects.LocationsConnection.typename,
            "nodes": nodes._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(LocationsByTermQuery.Data.Locations.self)
          ]
        ))
      }

      /// Locations.Node
      ///
      /// Parent Type: `Location`
      public struct Node: GraphAPI.SelectionSet {
        /// Backing Apollo `DataDict` storage.
        public let __data: DataDict
        /// Creates the selection set from a raw Apollo `DataDict`.
        public init(_dataDict: DataDict) { __data = _dataDict }

        /// GraphQL schema type backing this selection set.
        public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.Location }
        /// Apollo GraphQL selections requested for this type.
        public static var __selections: [ApolloAPI.Selection] { [
          .field("__typename", String.self),
          .fragment(LocationFragment.self),
        ] }

        /// The country code.
        public var country: String { __data["country"] }
        /// The localized country name.
        public var countryName: String? { __data["countryName"] }
        /// The displayable name. It includes the state code for US cities. ex: 'Seattle, WA'
        public var displayableName: String { __data["displayableName"] }
        /// Unique GraphQL node identifier.
        public var id: GraphAPI.ID { __data["id"] }
        /// The localized name
        public var name: String { __data["name"] }

        /// Container of reusable GraphQL fragment views for this selection set.
        public struct Fragments: FragmentContainer {
          /// Backing Apollo `DataDict` storage.
          public let __data: DataDict
          /// Creates the selection set from a raw Apollo `DataDict`.
          public init(_dataDict: DataDict) { __data = _dataDict }

          /// GraphQL variable or field `locationFragment`.
          public var locationFragment: LocationFragment { _toFragment() }
        }

        /// Creates an instance with explicit GraphQL field or variable values.
        public init(
          country: String,
          countryName: String? = nil,
          displayableName: String,
          id: GraphAPI.ID,
          name: String
        ) {
          self.init(_dataDict: DataDict(
            data: [
              "__typename": GraphAPI.Objects.Location.typename,
              "country": country,
              "countryName": countryName,
              "displayableName": displayableName,
              "id": id,
              "name": name,
            ],
            fulfilledFragments: [
              ObjectIdentifier(LocationsByTermQuery.Data.Locations.Node.self),
              ObjectIdentifier(LocationFragment.self)
            ]
          ))
        }
      }
    }
  }
}
