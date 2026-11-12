import Foundation
import Prelude

/// Kickstarter campaign reward tier or add-on selectable by a backer.
///
/// Format: Numeric `id` with monetary minimums in project currency (`minimum`, `latePledgeAmount`)
/// and converted viewer currency (`convertedMinimum`), plus optional Unix epoch bounds (`startsAt`, `endsAt`).
/// Negative Constraint: Do not confuse integer `id` with `graphID`; check `isNoReward` before rendering
/// shipping/quantity badges or treating `id` as a real tier.
public struct Reward {
  /// Number of backers who have selected this reward tier (`nil` when omitted on sparse payloads).
  public let backersCount: Int?
  /// Minimum pledge threshold converted to the viewer's preferred currency.
  /// Negative Constraint: Display-only estimate; never submit `convertedMinimum` as a GraphQL pledge amount.
  public internal(set) var convertedMinimum: Double
  /// Creator-written reward tier description.
  public let description: String
  /// Limited-time availability end timestamp in Unix epoch seconds (`nil` if no time limit).
  public let endsAt: TimeInterval?
  /// Estimated fulfillment delivery month/year timestamp in Unix epoch seconds (`nil` when unset).
  public let estimatedDeliveryOn: TimeInterval?
  /// `true` when highlighted by the creator as a featured tier.
  public let featured: Bool
  /// `true` when selectable add-on rewards exist alongside this tier.
  public let hasAddOns: Bool
  /// Server-assigned numeric reward identifier (`0` sentinel for `Reward.noReward`).
  /// Negative Constraint: Do not pass `Reward.noReward.id` (`0`) to shipping-rules endpoints.
  public let id: Int
  /// Post-campaign late-pledge price in the project's native currency (`0` when unavailable).
  public let latePledgeAmount: Double
  /// Total maximum backer capacity for a limited-quantity tier (`nil` if unlimited).
  public let limit: Int?
  /// Maximum quantity a single backer may select (`nil` when unrestricted).
  public let limitPerBacker: Int?
  /// Minimum pledge amount in the project's native currency required to claim this tier.
  public internal(set) var minimum: Double
  /// Pre-computed pledge amount returned by GraphQL checkout queries (`0` on v1 payloads).
  public let pledgeAmount: Double
  /// `true` if this reward remains purchasable during post-campaign late pledging.
  public let postCampaignPledgingEnabled: Bool
  /// Remaining inventory count for limited-quantity tiers (`nil` if unlimited).
  public let remaining: Int?
  /// Physical/digital line items included in this tier (`nil` or empty on summary list endpoints).
  public let rewardsItems: [RewardsItem]?
  /// Shipping configuration decoded from REST v1 payloads.
  /// Negative Constraint: REST v1 omits `shippingRulesExpanded`; check `shippingRule(matching:)`.
  public let shipping: Shipping
  /// Expanded per-country shipping rules populated by GraphQL queries (`nil` on REST v1).
  public let shippingRulesExpanded: [ShippingRule]?
  /// Limited-time availability start timestamp in Unix epoch seconds (`nil` if open immediately).
  public let startsAt: TimeInterval?
  /// Optional short reward tier title (`nil` for untitled tiers or no-reward).
  public let title: String?
  /// In-person local pickup location when `shipping.preference == .local` (`nil` on REST v1).
  public let localPickup: Location?
  /// Availability flag provided by GraphQL (`nil` on REST v1; combine with `isNoReward` via `rewardIsAvailable`).
  public let isAvailable: Bool?
  /// Optional reward thumbnail image metadata retrieved from GraphQL (`nil` on REST v1).
  public let image: Image?
  /// Audience segmentation flags for the reward tier (e.g., secret rewards).
  public let audienceData: AudienceData

  /// Returns `true` if this represents the synthetic `"No reward"` bonus-support tier.
  public var isNoReward: Bool {
    return self.id == Reward.noReward.id
  }

  internal static func noReward(withMinimum minimum: Double, convertedMinimum: Double) -> Reward {
    var reward = Reward.noReward
    reward.minimum = minimum
    reward.convertedMinimum = convertedMinimum
    return reward
  }

  /// Returns `true` if this tier enforces a total quantity `limit`.
  public var isLimitedQuantity: Bool {
    return self.limit != nil
  }

  /// Returns `true` if this tier expires at a scheduled `endsAt` deadline.
  public var isLimitedTime: Bool {
    return self.endsAt != nil
  }

  /// `true` when shipping is restricted to specific allowed locations.
  public var isRestrictedShippingPreference: Bool {
    return self.shipping.preference == .restricted
  }

  /// `true` when shipping is unrestricted (ships anywhere).
  public var isUnRestrictedShippingPreference: Bool {
    return self.shipping.preference == .unrestricted
  }

  /// `true` when the reward must be picked up in person at `localPickup`.
  public var isLocalShippingPreference: Bool {
    return self.shipping.preference == .local
  }

  /// `true` when the reward requires no shipping (`Shipping.Preference.none`).
  public var hasNoShippingPreference: Bool {
    return self.shipping.preference == Reward.Shipping.Preference.none
  }

  /// Returns `true` if this reward is a secret reward restricted via private link/audience.
  public var isSecretReward: Bool {
    return self.audienceData.isSecretReward
  }

  /// Returns the closest matching `ShippingRule` for this `Reward` to `otherShippingRule`.
  /// Falls back to `otherShippingRule` when missing to stay backward-compatible with v1 Rewards that omit `shippingRulesExpanded`.
  public func shippingRule(matching otherShippingRule: ShippingRule?) -> ShippingRule? {
    return self.shippingRulesExpanded?
      .first { shippingRule in
        shippingRule.location.id == otherShippingRule?.location.id
      }
      ?? otherShippingRule
  }

  /// Shipping capability and destination metadata for a `Reward`.
  public struct Shipping: Decodable {
    /// `true` when physical shipping applies to this reward tier.
    public let enabled: Bool
    /// Single shipping destination provided by v1 when `type == .singleLocation`.
    public let location: Location?
    /// High-level shipping policy category (`.local`, `.none`, `.restricted`, `.unrestricted`).
    public let preference: Preference?
    /// Localized summary copy describing where the creator ships.
    public let summary: String?
    /// Granular shipping rule shape (`anywhere`, `multipleLocations`, `noShipping`, `singleLocation`).
    public let type: ShippingType?

    /// Minimal location descriptor embedded in v1 single-location shipping payloads.
    public struct Location: Equatable, Decodable {
      private enum CodingKeys: String, CodingKey {
        case id
        case localizedName = "localized_name"
      }

      /// Numeric shipping location ID.
      public let id: Int
      /// Localized country or region display name.
      public let localizedName: String
    }

    /// Creator-configured shipping scope preference.
    public enum Preference: String, Decodable {
      case local
      case none
      case restricted
      case unrestricted
    }

    /// API shipping rule classification.
    public enum ShippingType: String, Decodable {
      case anywhere
      case multipleLocations = "multiple_locations"
      case noShipping = "no_shipping"
      case singleLocation = "single_location"
    }
  }

  /// Visual asset metadata associated with a `Reward`.
  public struct Image {
    /// Accessible alt text describing the reward image.
    public let altText: String
    /// HTTPS image URL string (`nil` when unavailable).
    public let url: String?
  }

  /// Audience-targeting flags determining reward visibility.
  public struct AudienceData {
    /// `true` when the tier is a secret reward visible only via special link/campaign context.
    public let isSecretReward: Bool
  }
}

extension Reward: Equatable {}
/// Compares two rewards by their canonical `id`.
/// - Negative Constraint: Do not assume equal `id` values mean identical mutable local state; compare fields explicitly if needed.
public func == (lhs: Reward, rhs: Reward) -> Bool {
  return lhs.id == rhs.id
}

private let minimumAndIdComparator = Reward.lens.minimum.comparator <> Reward.lens.id.comparator

extension Reward: Comparable {}
/// Orders rewards by ascending minimum pledge amount, breaking ties by `id`.
public func < (lhs: Reward, rhs: Reward) -> Bool {
  return minimumAndIdComparator.isOrdered(lhs, rhs)
}

extension Reward: GraphIDBridging {
  /// GraphQL global node type name (`"Reward"`) used when bridging base64 GraphIDs.
  public static var modelName: String {
    return "Reward"
  }
}
