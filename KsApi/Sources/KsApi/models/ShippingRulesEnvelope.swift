

/// Response envelope returning available shipping destinations and costs for a reward.
public struct ShippingRulesEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case shippingRules = "shipping_rules"
  }

  /// List of supported `ShippingRule` options for the requested reward.
  public let shippingRules: [ShippingRule]
}
