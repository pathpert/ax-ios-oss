import Foundation

extension Reward: Decodable {
  enum CodingKeys: String, CodingKey {
    case audienceData
    case backersCount = "backers_count"
    case convertedMinimum = "converted_minimum"
    case description
    case reward
    case endsAt = "ends_at"
    case estimatedDeliveryOn = "estimated_delivery_on"
    case featured
    case hasAddOns = "has_addons"
    case id
    case latePledgeAmount
    case limit
    case limitPerBacker = "limit_per_backer"
    case minimum
    case pledgeAmount
    case postCampaignPledgingEnabled = "post_campaign_pledging_enabled"
    case remaining
    case rewardsItems = "rewards_items"
    case shippingRules = "shipping_rules"
    case shippingRulesExpanded = "shipping_rules_expanded"
    case startsAt = "starts_at"
    case title
  }

  /// Decodes a `Reward` from REST JSON payload keys (`snake_case`).
  ///
  /// Negative Constraint: `v1` REST payloads omit `localPickup`, `isAvailable`, and `image` (all set to `nil`); use GraphQL fragment adapters when those fields are required.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.audienceData = try AudienceData(from: decoder)
    self.backersCount = try values.decodeIfPresent(Int.self, forKey: .backersCount)
    self.convertedMinimum = try values.decode(Double.self, forKey: .convertedMinimum)
    if let description = try? values.decode(String.self, forKey: .description) {
      self.description = description
    } else {
      self.description = try values.decode(String.self, forKey: .reward)
    }
    self.endsAt = try values.decodeIfPresent(TimeInterval.self, forKey: .endsAt)
    self.estimatedDeliveryOn = try values.decodeIfPresent(TimeInterval.self, forKey: .estimatedDeliveryOn)
    self.featured = try values.decodeIfPresent(Bool.self, forKey: .featured) ?? false
    self.hasAddOns = try values.decodeIfPresent(Bool.self, forKey: .hasAddOns) ?? false
    self.id = try values.decode(Int.self, forKey: .id)
    self.latePledgeAmount = try values.decodeIfPresent(Double.self, forKey: .latePledgeAmount) ?? 0
    self.limit = try values.decodeIfPresent(Int.self, forKey: .limit)
    self.limitPerBacker = try values.decodeIfPresent(Int.self, forKey: .limitPerBacker)
    self.minimum = try values.decode(Double.self, forKey: .minimum)
    self.pledgeAmount = try values.decodeIfPresent(Double.self, forKey: .pledgeAmount) ?? 0
    self.postCampaignPledgingEnabled =
      try values.decodeIfPresent(Bool.self, forKey: .postCampaignPledgingEnabled) ?? false
    self.remaining = try values.decodeIfPresent(Int.self, forKey: .remaining)
    self.rewardsItems = try values.decodeIfPresent([RewardsItem].self, forKey: .rewardsItems) ?? []
    self.shipping = try Shipping(from: decoder)
    self.shippingRulesExpanded = try values.decodeIfPresent(
      [ShippingRule].self,
      forKey: .shippingRulesExpanded
    ) ?? []
    self.startsAt = try values.decodeIfPresent(TimeInterval.self, forKey: .startsAt)
    self.title = try values.decodeIfPresent(String.self, forKey: .title)
    // NOTE: `v1` is deprecated and doesn't contain any location pickup information.
    self.localPickup = nil
    self.isAvailable = nil
    self.image = nil
  }
}

extension Reward.Shipping {
  private enum CodingKeys: String, CodingKey {
    case enabled = "shipping_enabled"
    case location = "shipping_single_location"
    case preference = "shipping_preference"
    case summary = "shipping_summary"
    case type = "shipping_type"
  }

  /// Decodes `Reward.Shipping` configuration with `enabled` defaulting to `false`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.enabled = try values.decodeIfPresent(Bool.self, forKey: .enabled) ?? false
    self.location = try? values.decode(Location.self, forKey: .location)
    self.preference = try? values.decode(Preference.self, forKey: .preference)
    self.summary = try? values.decode(String.self, forKey: .summary)
    self.type = try? values.decode(ShippingType.self, forKey: .type)
  }
}

extension Reward.AudienceData: Decodable {
  private enum CodingKeys: String, CodingKey {
    case secret
  }

  /// Decodes `Reward.AudienceData` (`isSecretReward` defaulting to `false`).
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    self.isSecretReward = try values.decodeIfPresent(Bool.self, forKey: .secret) ?? false
  }
}

