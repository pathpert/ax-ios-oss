// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Generated Apollo GraphQL query `ShippableLocationsForProjectQuery`.
public class ShippableLocationsForProjectQuery: GraphQLQuery {
  /// Canonical GraphQL operation name.
  public static let operationName: String = "ShippableLocationsForProject"
  /// Compiled Apollo GraphQL operation document definition.
  public static let operationDocument: ApolloAPI.OperationDocument = .init(
    definition: .init(
      #"query ShippableLocationsForProject($id: Int!) { project(pid: $id) { __typename shippableCountriesExpanded { __typename ...LocationFragment } } }"#,
      fragments: [LocationFragment.self]
    ))

  /// Unique GraphQL node identifier.
  public var id: Int

  /// Creates an instance with explicit GraphQL field or variable values.
  public init(id: Int) {
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
      .field("project", Project?.self, arguments: ["pid": .variable("id")]),
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
          ObjectIdentifier(ShippableLocationsForProjectQuery.Data.self)
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
        .field("shippableCountriesExpanded", [ShippableCountriesExpanded].self),
      ] }

      /// All countries in which this project has a shippable reward. Expands results to the country level (ie EU -> [ Austria, Belgium ...])Returns all countries if the project has an unrestricted reward. If this project has only digital or local rewards, returns an empty array.
      public var shippableCountriesExpanded: [ShippableCountriesExpanded] { __data["shippableCountriesExpanded"] }

      /// Creates an instance with explicit GraphQL field or variable values.
      public init(
        shippableCountriesExpanded: [ShippableCountriesExpanded]
      ) {
        self.init(_dataDict: DataDict(
          data: [
            "__typename": GraphAPI.Objects.Project.typename,
            "shippableCountriesExpanded": shippableCountriesExpanded._fieldData,
          ],
          fulfilledFragments: [
            ObjectIdentifier(ShippableLocationsForProjectQuery.Data.Project.self)
          ]
        ))
      }

      /// Project.ShippableCountriesExpanded
      ///
      /// Parent Type: `Location`
      public struct ShippableCountriesExpanded: GraphAPI.SelectionSet {
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
              ObjectIdentifier(ShippableLocationsForProjectQuery.Data.Project.ShippableCountriesExpanded.self),
              ObjectIdentifier(LocationFragment.self)
            ]
          ))
        }
      }
    }
  }
}
