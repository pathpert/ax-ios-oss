import Foundation

/// Represents a user's pledge (`Backing`) on a Kickstarter campaign.
///
/// Format: Numeric `id` and monetary amounts (`amount`, `bonusAmount`, `shippingAmount`, `rewardsAmount`)
/// expressed in major units of `projectCountry`'s currency, with `pledgedAt` as Unix epoch seconds.
/// Negative Constraint: Do not use `rewardId` as a backing identifier or cache key; always key by `id` (`Backing.id`).
/// Also do not infer payment success solely from `status == .pledged` when `status == .authenticationRequired`.
public struct Backing {
  /// Optional add-on rewards included alongside the primary `reward`.
  public let addOns: [Reward]?
  /// Total committed pledge amount including reward, add-ons, shipping, and bonus support.
  /// Format: Major currency units (`Double`). Do not pass `amount` directly as integer cents.
  public let amount: Double
  /// Profile of the user who created this backing (`nil` in nested `User`-owned summaries).
  public let backer: User?
  /// Server-assigned numeric ID of the backing user.
  /// Negative Constraint: Do not confuse `backerId` with `id` (the backing record ID).
  public let backerId: Int
  /// `true` when the creator marked reward fulfillment complete for this backer (`nil` if unknown).
  public let backerCompleted: Bool?

  /// Relative route used to load backing survey/details without triggering a webview re-login prompt.
  /// Points to `backing/survey_responses` rather than `backing/details`.
  public let backingDetailsPageRoute: String
  /// Extra voluntary bonus pledge amount beyond reward/shipping minimums (`0.0` if none).
  public let bonusAmount: Double
  /// `true` if the backing is eligible for self-service cancellation under current project state.
  public let cancelable: Bool
  /// Unique numeric identifier of this backing record.
  /// Negative Constraint: Use `graphID` (via `GraphIDBridging`) instead of raw `id` for GraphQL mutations.
  public let id: Int
  /// `true` when created during post-campaign late pledging after the campaign deadline.
  public let isLatePledge: Bool
  /// Selected shipping rule location numeric ID (`nil` for no-shipping/digital tiers).
  public let locationId: Int?
  /// Localized display name of the chosen shipping destination (`nil` when unshipped).
  public let locationName: String?
  /// Post-campaign Pledge Manager checkout order details when available.
  public let order: Order?
  /// Installment payment schedule when Pledge Over Time applies (empty array for single-charge pledges).
  public let paymentIncrements: [PledgePaymentIncrement]
  /// Stored payment method summary used for this backing (`nil` if stripped or unavailable).
  public let paymentSource: PaymentSource?
  /// Timestamp when the pledge was submitted, in Unix epoch seconds (`TimeInterval`).
  public let pledgedAt: TimeInterval
  /// Two-letter ISO country code of the project (e.g., `"US"`, `"GB"`).
  /// Negative Constraint: Represents project country, not necessarily the backer's billing country.
  public let projectCountry: String
  /// Numeric identifier of the backed `Project`.
  public let projectId: Int
  /// Primary selected `Reward` tier (`nil` if omitted by endpoint; check `rewardId`).
  public let reward: Reward?
  /// Subtotal attributable to selected rewards/add-ons (GraphQL-only; `nil` in REST v1 responses).
  public let rewardsAmount: Double?
  /// Numeric ID of the primary reward tier (`nil` if pledge was made without selecting a reward).
  /// Negative Constraint: Do not use `rewardId` as a backing cache key; use `id` (`Backing.id`) instead.
  public let rewardId: Int?
  /// Sequential backer number within the campaign (e.g., backer #42).
  public let sequence: Int
  /// Shipping surcharge included in `amount` (`nil` when shipping is not applicable).
  public let shippingAmount: Double?
  /// Lifecycle collection status of the pledge (`pledged`, `collected`, `errored`, `canceled`, etc.).
  public let status: Status

  /// Masked payment instrument metadata attached to a `Backing`.
  public struct PaymentSource {
    /// Card expiration string formatted as `YYYY-MM` (`nil` for Apple Pay / non-card instruments).
    public var expirationDate: String?
    /// Stripe / Kickstarter payment source identifier (`nil` when unavailable).
    public var id: String?
    /// Last 4 digits of the payment card (`nil` when unavailable).
    public var lastFour: String?
    /// Payment instrument category (`creditCard`, `applePay`, `bankAccount`, etc.).
    public var paymentType: PaymentType
    /// Verification/status string of the saved payment source (`nil` unless returned by GraphQL).
    public var state: String?
    /// Card brand (`visa`, `mastercard`, `amex`, etc.) when `paymentType == .creditCard`.
    public var type: CreditCardType?
  }

  /// Lifecycle state of a pledge collection.
  public enum Status: String, CaseIterable, Decodable {
    /// Backer or creator canceled the pledge.
    case canceled
    /// Funds successfully captured after campaign deadline.
    case collected
    /// Repeated charge attempts failed permanently and pledge was dropped.
    case dropped
    /// Synthetic `$0.0` placeholder backing created behind the scenes to hold a Pledge Manager cart.
    /// Negative Constraint: Never show `.dummy` as a charged monetary commitment.
    case dummy
    /// Payment capture failed and requires backer intervention to fix payment method.
    case errored
    /// Active pledge awaiting campaign completion and collection.
    case pledged
    /// Pre-authorized pending final capture.
    case preauth
    /// Requires 3DS / SCA cardholder authentication before capture can proceed.
    case authenticationRequired = "authentication_required"
  }
}

extension Backing: Equatable {}

/// Compares two `Backing` records by their integer `id`.
public func == (lhs: Backing, rhs: Backing) -> Bool {
  return lhs.id == rhs.id
}

extension Backing: Decodable {
  private enum CodingKeys: String, CodingKey {
    case addOns = "add_ons"
    case amount
    case backer
    case backerId = "backer_id"
    case backerCompleted = "backer_completed_at"
    case backingDetailsUrl
    case bonusAmount = "bonus_amount"
    case cancelable
    case id
    case isLatePledge
    case locationId = "location_id"
    case locationName = "location_name"
    case order
    case paymentIncrements = "payment_increments"
    case paymentSource = "payment_source"
    case pledgedAt = "pledged_at"
    case projectCountry = "project_country"
    case projectId = "project_id"
    case reward
    case rewardsAmount = "rewards_amount" // Only available in GraphQL.
    case rewardId = "reward_id"
    case sequence
    case shippingAmount = "shipping_amount"
    case status
  }

  /// Decodes a `Backing` from REST JSON payload keys (`snake_case`).
  ///
  /// Negative Constraint: Do not pass raw GraphQL fragment payloads here; use `Backing.backingProducer(from:)` adapters.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.addOns = try values.decodeIfPresent([Reward].self, forKey: .addOns)
    self.amount = try values.decode(Double.self, forKey: .amount)
    self.backer = try values.decodeIfPresent(User.self, forKey: .backer)
    self.backerId = try values.decode(Int.self, forKey: .backerId)
    self.backerCompleted = try values.decodeIfPresent(Int.self, forKey: .backerCompleted) != nil
    self.backingDetailsPageRoute = try values.decodeIfPresent(String.self, forKey: .backingDetailsUrl) ?? ""
    self.bonusAmount = try values.decodeIfPresent(Double.self, forKey: .bonusAmount) ?? 0.0
    self.cancelable = try values.decode(Bool.self, forKey: .cancelable)
    self.id = try values.decode(Int.self, forKey: .id)
    self.isLatePledge = try values.decodeIfPresent(Bool.self, forKey: .isLatePledge) ?? false
    self.locationId = try values.decodeIfPresent(Int.self, forKey: .locationId)
    self.locationName = try values.decodeIfPresent(String.self, forKey: .locationName)
    self.order = try? values.decodeIfPresent(Order.self, forKey: .order)
    self.paymentIncrements = try values.decodeIfPresent(
      [PledgePaymentIncrement].self,
      forKey: .paymentIncrements
    ) ?? []
    self.paymentSource = try? values.decodeIfPresent(PaymentSource.self, forKey: .paymentSource)
    self.pledgedAt = try values.decode(TimeInterval.self, forKey: .pledgedAt)
    self.projectCountry = try values.decode(String.self, forKey: .projectCountry)
    self.projectId = try values.decode(Int.self, forKey: .projectId)
    self.reward = try values.decodeIfPresent(Reward.self, forKey: .reward)
    self.rewardsAmount = try? values.decodeIfPresent(Double.self, forKey: .rewardsAmount)
    self.rewardId = try values.decodeIfPresent(Int.self, forKey: .rewardId)
    self.sequence = try values.decode(Int.self, forKey: .sequence)
    self.shippingAmount = try values.decodeIfPresent(Double.self, forKey: .shippingAmount)
    self.status = try values.decode(Status.self, forKey: .status)
  }
}

extension Backing: EncodableType {
  /// Encodes mutable backing survey completion state (`backer_completed_at`) for API requests.
  ///
  /// Negative Constraint: Do not use for creating or updating pledge amounts; use typed GraphQL mutation inputs instead.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["backer_completed_at"] = self.backerCompleted
    return result
  }
}

extension Backing.PaymentSource: Decodable {
  private enum CodingKeys: String, CodingKey {
    case expirationDate = "expiration_date"
    case id
    case lastFour = "last_four"
    case paymentType = "payment_type"
    case type
  }
}

extension Backing.PaymentSource: Equatable {}
/// Compares two `Backing.PaymentSource` entries by their `id`.
public func == (lhs: Backing.PaymentSource, rhs: Backing.PaymentSource) -> Bool {
  return lhs.id == rhs.id
}

extension Backing: GraphIDBridging {
  /// GraphQL type name (`"Backing"`) used for global node ID encoding.
  public static var modelName: String {
    return "Backing"
  }
}
