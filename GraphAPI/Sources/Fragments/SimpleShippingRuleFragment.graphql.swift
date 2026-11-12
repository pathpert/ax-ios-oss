// @generated
// This file was automatically generated and should not be edited.

@_exported import ApolloAPI

/// Lightweight GraphQL fragment containing estimated shipping bounds, flat cost, and destination country.
/// - Negative Constraint: Use only for shipping estimate previews; full rule tier IDs require `ShippingRuleFragment`.
public struct SimpleShippingRuleFragment: GraphAPI.SelectionSet, Fragment {
  /// Raw GraphQL fragment definition string.
  public static var fragmentDefinition: StaticString {
    #"fragment SimpleShippingRuleFragment on SimpleShippingRule { __typename cost estimatedMin estimatedMax currency locationId locationName country }"#
  }

  /// Backing Apollo response dictionary.
  public let __data: DataDict
  /// Initializes the fragment wrapper from an Apollo `DataDict`.
  public init(_dataDict: DataDict) { __data = _dataDict }

  /// GraphQL schema parent object type (`SimpleShippingRule`).
  public static var __parentType: ApolloAPI.ParentType { GraphAPI.Objects.SimpleShippingRule }
  /// GraphQL selection fields requested by this fragment.
  public static var __selections: [ApolloAPI.Selection] { [
    .field("__typename", String.self),
    .field("cost", String?.self),
    .field("estimatedMin", String?.self),
    .field("estimatedMax", String?.self),
    .field("currency", String?.self),
    .field("locationId", GraphAPI.ID?.self),
    .field("locationName", String?.self),
    .field("country", String.self),
  ] }

  /// Formatted shipping cost string returned by GraphQL, if available.
  public var cost: String? { __data["cost"] }
  /// Lower-bound shipping cost estimate string, when variable.
  public var estimatedMin: String? { __data["estimatedMin"] }
  /// Upper-bound shipping cost estimate string, when variable.
  public var estimatedMax: String? { __data["estimatedMax"] }
  /// ISO 4217 currency code for shipping cost values.
  public var currency: String? { __data["currency"] }
  /// GraphQL destination location node ID.
  public var locationId: GraphAPI.ID? { __data["locationId"] }
  /// Human-readable shipping destination name.
  public var locationName: String? { __data["locationName"] }
  /// ISO country code or country label for this shipping rule.
  public var country: String { __data["country"] }

  /// Synthesizes a `SimpleShippingRuleFragment` instance for tests and previews.
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
        ObjectIdentifier(SimpleShippingRuleFragment.self)
      ]
    ))
  }
}
