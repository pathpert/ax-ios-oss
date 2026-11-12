import Foundation
import Prelude

extension Reward {
  /// Functional lenses for immutably updating `Reward` fields in checkout and test fixtures.
  public enum lens {
    /// Lens focusing on the number of backers who selected this reward.
    public static let backersCount = Lens<Reward, Int?>(
      view: { $0.backersCount },
      set: { $1.copy(backersCount: $0) }
    )

    /// Lens focusing on the optional local-pickup `Location`.
    public static let localPickup = Lens<Reward, Location?>(
      view: { $0.localPickup },
      set: { $1.copy(localPickup: $0) }
    )

    /// Lens focusing on the reward minimum converted into the viewer's display currency.
    public static let convertedMinimum = Lens<Reward, Double>(
      view: { $0.convertedMinimum },
      set: { $1.copy(convertedMinimum: $0) }
    )

    /// Lens focusing on the reward tier's description copy.
    public static let description = Lens<Reward, String>(
      view: { $0.description },
      set: { $1.copy(description: $0) }
    )

    /// Lens focusing on the optional UNIX timestamp when time-limited availability ends.
    public static let endsAt = Lens<Reward, TimeInterval?>(
      view: { $0.endsAt },
      set: { $1.copy(endsAt: $0) }
    )

    /// Lens focusing on the optional estimated delivery UNIX timestamp.
    public static let estimatedDeliveryOn = Lens<Reward, TimeInterval?>(
      view: { $0.estimatedDeliveryOn },
      set: { $1.copy(estimatedDeliveryOn: $0) }
    )

    /// Lens focusing on whether the reward offers optional add-ons.
    public static let hasAddOns = Lens<Reward, Bool>(
      view: { $0.hasAddOns },
      set: { $1.copy(hasAddOns: $0) }
    )

    /// Lens focusing on the unique numeric reward identifier (`0` represents the no-reward tier).
    public static let id = Lens<Reward, Int>(
      view: { $0.id },
      set: { $1.copy(id: $0) }
    )

    /// Lens focusing on the reward pledge amount during post-campaign late pledging.
    public static let latePledgeAmount = Lens<Reward, Double>(
      view: { $0.latePledgeAmount },
      set: { $1.copy(latePledgeAmount: $0) }
    )

    /// Lens focusing on the total quantity limit for the reward (`nil` when unlimited).
    public static let limit = Lens<Reward, Int?>(
      view: { $0.limit },
      set: { $1.copy(limit: $0) }
    )

    /// Lens focusing on the maximum quantity selectable per backer.
    public static let limitPerBacker = Lens<Reward, Int?>(
      view: { $0.limitPerBacker },
      set: { $1.copy(limitPerBacker: $0) }
    )

    /// Lens focusing on the minimum pledge amount in the project's currency.
    public static let minimum = Lens<Reward, Double>(
      view: { $0.minimum },
      set: { $1.copy(minimum: $0) }
    )

    /// Lens focusing on the active pledge amount override (`latePledgeAmount` getter preserved for compatibility).
    public static let pledgeAmount = Lens<Reward, Double>(
      view: { $0.latePledgeAmount },
      set: { $1.copy(pledgeAmount: $0) }
    )

    /// Lens focusing on whether the reward remains available for post-campaign pledging.
    public static let postCampaignPledgingEnabled = Lens<Reward, Bool>(
      view: { $0.postCampaignPledgingEnabled },
      set: { $1.copy(postCampaignPledgingEnabled: $0) }
    )

    /// Lens focusing on the remaining inventory count (`nil` when unlimited).
    public static let remaining = Lens<Reward, Int?>(
      view: { $0.remaining },
      set: { $1.copy(remaining: $0) }
    )

    /// Lens focusing on the list of physical/digital items included in the reward.
    public static let rewardsItems = Lens<Reward, [RewardsItem]?>(
      view: { $0.rewardsItems },
      set: { $1.copy(rewardsItems: $0) }
    )

    /// Lens focusing on the `Reward.Shipping` configuration struct.
    public static let shipping = Lens<Reward, Reward.Shipping>(
      view: { $0.shipping },
      set: { $1.copy(shipping: $0) }
    )

    /// Lens focusing on the expanded per-country `ShippingRule` entries.
    public static let shippingRulesExpanded = Lens<Reward, [ShippingRule]?>(
      view: { $0.shippingRulesExpanded },
      set: { $1.copy(shippingRulesExpanded: $0) }
    )

    /// Lens focusing on the optional UNIX timestamp when reward availability begins.
    public static let startsAt = Lens<Reward, TimeInterval?>(
      view: { $0.startsAt },
      set: { $1.copy(startsAt: $0) }
    )

    /// Lens focusing on the optional reward tier title string.
    public static let title = Lens<Reward, String?>(
      view: { $0.title },
      set: { $1.copy(title: $0) }
    )

    /// Lens focusing on whether the reward is currently available to back.
    public static let isAvailable = Lens<Reward, Bool?>(
      view: { $0.isAvailable },
      set: { $1.copy(isAvailable: $0) }
    )

    /// Lens focusing on the optional reward tier preview `Reward.Image`.
    public static let image = Lens<Reward, Reward.Image?>(
      view: { $0.image },
      set: { $1.copy(image: $0) }
    )

    /// Lens focusing on reward audience targeting metadata.
    public static let audienceData = Lens<Reward, Reward.AudienceData>(
      view: { $0.audienceData },
      set: { $1.copy(audienceData: $0) }
    )
  }

  private func copy(
    backersCount: Int?? = nil,
    convertedMinimum: Double? = nil,
    description: String? = nil,
    endsAt: TimeInterval?? = nil,
    estimatedDeliveryOn: TimeInterval?? = nil,
    featured: Bool? = nil,
    hasAddOns: Bool? = nil,
    id: Int? = nil,
    latePledgeAmount: Double? = nil,
    limit: Int?? = nil,
    limitPerBacker: Int?? = nil,
    minimum: Double? = nil,
    pledgeAmount: Double? = nil,
    postCampaignPledgingEnabled: Bool? = nil,
    remaining: Int?? = nil,
    rewardsItems: [RewardsItem]?? = nil,
    shipping: Reward.Shipping? = nil,
    shippingRulesExpanded: [ShippingRule]?? = nil,
    startsAt: TimeInterval?? = nil,
    title: String?? = nil,
    localPickup: Location?? = nil,
    isAvailable: Bool?? = nil,
    image: Reward.Image?? = nil,
    audienceData: Reward.AudienceData? = nil
  ) -> Reward {
    return Reward(
      backersCount: backersCount ?? self.backersCount,
      convertedMinimum: convertedMinimum ?? self.convertedMinimum,
      description: description ?? self.description,
      endsAt: endsAt ?? self.endsAt,
      estimatedDeliveryOn: estimatedDeliveryOn ?? self.estimatedDeliveryOn,
      featured: featured ?? self.featured,
      hasAddOns: hasAddOns ?? self.hasAddOns,
      id: id ?? self.id,
      latePledgeAmount: latePledgeAmount ?? self.latePledgeAmount,
      limit: limit ?? self.limit,
      limitPerBacker: limitPerBacker ?? self.limitPerBacker,
      minimum: minimum ?? self.minimum,
      pledgeAmount: pledgeAmount ?? self.pledgeAmount,
      postCampaignPledgingEnabled: postCampaignPledgingEnabled ?? self.postCampaignPledgingEnabled,
      remaining: remaining ?? self.remaining,
      rewardsItems: rewardsItems ?? self.rewardsItems,
      shipping: shipping ?? self.shipping,
      shippingRulesExpanded: shippingRulesExpanded ?? self.shippingRulesExpanded,
      startsAt: startsAt ?? self.startsAt,
      title: title ?? self.title,
      localPickup: localPickup ?? self.localPickup,
      isAvailable: isAvailable ?? self.isAvailable,
      image: image ?? self.image,
      audienceData: audienceData ?? self.audienceData
    )
  }
}

extension Lens where Whole == Reward, Part == Reward.Shipping {
  /// Composed lens focusing on whether shipping is enabled on the reward.
  public var enabled: Lens<Reward, Bool> {
    return Reward.lens.shipping .. Reward.Shipping.lens.enabled
  }

  /// Composed lens focusing on the reward's shipping preference.
  public var preference: Lens<Reward, Reward.Shipping.Preference?> {
    return Reward.lens.shipping .. Reward.Shipping.lens.preference
  }

  /// Composed lens focusing on the reward's human-readable shipping summary.
  public var summary: Lens<Reward, String?> {
    return Reward.lens.shipping .. Reward.Shipping.lens.summary
  }
}
