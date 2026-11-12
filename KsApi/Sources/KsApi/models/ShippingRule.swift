

/// @deprecated Legacy shipping rule model using floating-point `cost: Double` with silent `?? 0` fallback.
/// Route all new callers to `ShippingRuleItemContract` (integer `costInCents: Int`) via `ShippingController.fetchShippingRulesEndpoint` in `KsApi/modules/shipping`.
public struct ShippingRule {
  /// Machine-readable deprecation descriptor guiding migration away from floating-point `cost`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ShippingRule.cost",
    meaning: "Legacy floating-point shipping cost Double with silent ?? 0 fallback on decode failure.",
    format: "Double (Deprecated)",
    negativeConstraints: ["Do not consume floating-point ShippingRule.cost; use integer cents ShippingRuleItemContract.costInCents."],
    deprecated: true,
    replacementPrimitive: "ShippingRuleItemContract.costInCents via ShippingController.handleFetchShippingRules(query:)"
  )
  /// Legacy shipping cost parsed from string (`0` if unparseable). Negative Constraint: Do not use for monetary math; use `ShippingRuleItemContract.costInCents`.
  public let cost: Double
  /// Optional backend identifier of the shipping rule.
  public let id: Int?
  /// Geographic destination covered by this shipping rule.
  public let location: Location
  /// Optional minimum estimated shipping amount.
  public let estimatedMin: Money?
  /// Optional maximum estimated shipping amount.
  public let estimatedMax: Money?
}

extension ShippingRule: Decodable {
  enum CodingKeys: String, CodingKey {
    case cost
    case id
    case location
    case estimatedMin
    case estimatedMax
  }

  /// Decodes a `ShippingRule`, parsing string `cost` to `Double` with a `0` fallback.
  ///
  /// Negative Constraint: Do not rely on `cost` for exact currency formatting when integer cents are available.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.cost = try Double(values.decode(String.self, forKey: .cost)) ?? 0
    self.id = try values.decodeIfPresent(Int.self, forKey: .id)
    self.location = try values.decode(Location.self, forKey: .location)
    self.estimatedMin = try values.decodeIfPresent(Money.self, forKey: .estimatedMin)
    self.estimatedMax = try values.decodeIfPresent(Money.self, forKey: .estimatedMax)
  }
}

extension ShippingRule: Equatable {}
/// Compares two `ShippingRule` instances by their `location`.
///
/// Negative Constraint: Does not compare `cost` or `id`; only suitable for location uniqueness checks.
public func == (lhs: ShippingRule, rhs: ShippingRule) -> Bool {
  // TODO: change to compare id once that api is deployed
  return lhs.location == rhs.location
}
