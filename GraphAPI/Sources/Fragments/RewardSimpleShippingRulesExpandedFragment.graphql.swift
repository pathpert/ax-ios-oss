// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// GraphQL selection set for the `RewardSimpleShippingRulesExpandedFragment` fragment.
/// - Negative Constraint: Generated Apollo fragment model; do not mutate `__data` directly.
public struct RewardSimpleShippingRulesExpandedFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment RewardSimpleShippingRulesExpandedFragment on Reward { __typename simpleShippingRulesExpanded { __typename ...SimpleShippingRuleFragment } }"#
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
    .field("simpleShippingRulesExpanded", [SimpleShippingRulesExpanded?].self),
  ] }

  /// Simple shipping rules expanded as a faster alternative to shippingRulesExpanded since connection type is slow
  public var simpleShippingRulesExpanded: [SimpleShippingRulesExpanded?] { __data["simpleShippingRulesExpanded"] }

  /// Synthesizes a selection set instance for tests and previews.
  public init(
    simpleShippingRulesExpanded: [SimpleShippingRulesExpanded?]
  ) {
    self.init(_dataDict: DataDict(
      data: [
        "__typename": GraphAPI.Objects.Reward.typename,
        "simpleShippingRulesExpanded": simpleShippingRulesExpanded._fieldData,
      ],
      fulfilledFragments: [
        ObjectIdentifier(RewardSimpleShippingRulesExpandedFragment.self)
      ]
    ))
  }

  /// SimpleShippingRulesExpanded
  ///
  /// Parent Type: `SimpleShippingRule`
  public struct SimpleShippingRulesExpanded: GraphAPI.SelectionSet {
    /// Backing Apollo response dictionary.
    public let __data: DataDict
    /// Initializes the selection set wrapper from an Apollo `DataDict`.
    public init(_dataDict: DataDict) { __data = _dataDict }

    /// GraphQL schema parent object or interface type.
    public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.SimpleShippingRule }
    /// GraphQL selection fields requested by this selection set.
    public static var __selections: [ApolloAPI.Selection] { [
      .field("__typename", String.self),
      .fragment(SimpleShippingRuleFragment.self),
    ] }

    /// Formatted shipping cost string, if available.
    public var cost: String? { __data["cost"] }
    /// Lower-bound shipping estimate string.
    public var estimatedMin: String? { __data["estimatedMin"] }
    /// Upper-bound shipping estimate string.
    public var estimatedMax: String? { __data["estimatedMax"] }
    /// ISO 4217 currency code.
    public var currency: String? { __data["currency"] }
    /// GraphQL location node identifier.
    public var locationId: GraphAPI.ID? { __data["locationId"] }
    /// Human-readable location display name.
    public var locationName: String? { __data["locationName"] }
    /// Country code or label for this record.
    public var country: String { __data["country"] }

    /// Typed container providing access to composed Apollo fragments on this selection set.
    public struct Fragments: FragmentContainer {
      /// Backing Apollo response dictionary.
      public let __data: DataDict
      /// Initializes the selection set wrapper from an Apollo `DataDict`.
      public init(_dataDict: DataDict) { __data = _dataDict }

      /// Composed `SimpleShippingRuleFragment` fragment decoded from this selection set.
      public var simpleShippingRuleFragment: SimpleShippingRuleFragment { _toFragment() }
    }

    /// Synthesizes a selection set instance for tests and previews.
    public init(
      cost: String? = nil,
      estimatedMin: String? = nil,
      estimatedMax: String? = nil,
      currency: String? = nil,
      locationId: GraphAPI.ID? = nil,
      locationName: String? = nil,
      country: String
    ) {
      self.init(_dataDict: DataDict(
        data: [
          "__typename": GraphAPI.Objects.SimpleShippingRule.typename,
          "cost": cost,
          "estimatedMin": estimatedMin,
          "estimatedMax": estimatedMax,
          "currency": currency,
          "locationId": locationId,
          "locationName": locationName,
          "country": country,
        ],
        fulfilledFragments: [
          ObjectIdentifier(RewardSimpleShippingRulesExpandedFragment.SimpleShippingRulesExpanded.self),
          ObjectIdentifier(SimpleShippingRuleFragment.self)
        ]
      ))
    }
  }
}
