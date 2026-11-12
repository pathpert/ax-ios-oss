import Foundation
import KsApi

/// Typed configuration payload passed to the pledge CTA container view (`PledgeViewCTAContainerView`).
///
/// Negative Constraint: Replaces an untyped 6-element tuple; do not pass unvalidated amounts or logged-out assumptions.
public struct PledgeViewCTAContainerViewData: Equatable {
  /// The campaign being pledged to.
  public let project: Project
  /// Total pledge commitment in the campaign's native currency (`>= 0`).
  public let total: Double
  /// Whether a Kickstarter user session is currently authenticated.
  public let isLoggedIn: Bool
  /// Whether the submit/pledge action CTA is enabled for interaction.
  public let isEnabled: Bool
  /// Active pledge flow mode (`.pledge`, `.update`, `.updateReward`, `.changePaymentMethod`, `.fixPaymentMethod`, `.latePledge`).
  public let context: PledgeViewContext
  /// `true` when fixing a failed payment with the exact card previously used on the backing.
  public let willRetryPaymentMethod: Bool

  /// Initializes CTA container view configuration from project, pledge total, auth state, and context.
  public init(
    project: Project,
    total: Double,
    isLoggedIn: Bool,
    isEnabled: Bool,
    context: PledgeViewContext,
    willRetryPaymentMethod: Bool
  ) {
    self.project = project
    self.total = total
    self.isLoggedIn = isLoggedIn
    self.isEnabled = isEnabled
    self.context = context
    self.willRetryPaymentMethod = willRetryPaymentMethod
  }
}

/// Typed Stripe SDK runtime configuration derived from environment secrets.
///
/// Negative Constraint: Never persist `publishableKey` to analytics or logs.
public struct StripeConfigurationData: Equatable {
  /// Apple Pay merchant identifier registered with Apple Developer & Stripe.
  public let merchantIdentifier: String
  /// Environment-scoped Stripe publishable API key (`pk_test_*` or `pk_live_*`).
  public let publishableKey: String

  /// Initializes Stripe SDK configuration with merchant and publishable key credentials.
  public init(merchantIdentifier: String, publishableKey: String) {
    self.merchantIdentifier = merchantIdentifier
    self.publishableKey = publishableKey
  }
}

/// Typed input contract used by `CreateBackingInput.input(from:isApplePay:)` to submit a new backing.
///
/// Negative Constraint: Never populate both `paymentSourceId` and `setupIntentClientSecret` for Apple Pay flows.
public struct CreateBackingData {
  /// Target campaign being backed.
  public let project: Project
  /// Selected reward tiers and add-ons included in the pledge.
  public let rewards: [Reward]
  /// Total pledge amount in major currency units.
  public let pledgeTotal: Double
  /// Mapping of `Reward.id` to selected item quantity.
  public let selectedQuantities: SelectedRewardQuantities
  /// Optional shipping rule when physical fulfillment applies.
  public let shippingRule: ShippingRule?
  /// Saved credit card payment source ID (`nil` for Apple Pay or SetupIntent flows).
  public let paymentSourceId: String?
  /// Stripe SetupIntent client secret for newly entered payment methods.
  public let setupIntentClientSecret: String?
  /// Tokenized Apple Pay payload when paying via Apple Pay.
  public let applePayParams: ApplePayParams?
  /// Attribution referral tag tracked on checkout (`nil` when direct).
  public let refTag: RefTag?
  /// `true` if Pledge Over Time installments apply; `false`/`nil` for single charge.
  public let incremental: Bool?

  /// Initializes typed backing creation data from reward selections, shipping, payment source, and attribution.
  public init(
    project: Project,
    rewards: [Reward],
    pledgeTotal: Double,
    selectedQuantities: SelectedRewardQuantities,
    shippingRule: ShippingRule?,
    paymentSourceId: String?,
    setupIntentClientSecret: String?,
    applePayParams: ApplePayParams?,
    refTag: RefTag?,
    incremental: Bool?
  ) {
    self.project = project
    self.rewards = rewards
    self.pledgeTotal = pledgeTotal
    self.selectedQuantities = selectedQuantities
    self.shippingRule = shippingRule
    self.paymentSourceId = paymentSourceId
    self.setupIntentClientSecret = setupIntentClientSecret
    self.applePayParams = applePayParams
    self.refTag = refTag
    self.incremental = incremental
  }
}

/// Typed input contract used by `UpdateBackingInput.input(from:isApplePay:)` to modify an existing backing.
public struct UpdateBackingData {
  /// Existing backing record being updated.
  public let backing: Backing
  /// Updated rewards and add-on selection.
  public let rewards: [Reward]
  /// Updated total pledge amount in major currency units.
  public let pledgeTotal: Double
  /// Updated mapping of `Reward.id` to selected quantity.
  public let selectedQuantities: SelectedRewardQuantities
  /// Selected shipping rule (`nil` for digital/no-reward updates).
  public let shippingRule: ShippingRule?
  /// Selected saved credit card ID (`nil` for Apple Pay or new SetupIntent).
  public let paymentSourceId: String?
  /// SetupIntent client secret when attaching a new card.
  public let setupIntentClientSecret: String?
  /// Apple Pay token metadata when authorizing via Apple Pay.
  public let applePayParams: ApplePayParams?
  /// Mode of pledge modification determining whether amount/rewards are sent.
  public let pledgeContext: PledgeViewContext
  /// `true` if Pledge Over Time installments are active for this update.
  public let incremental: Bool

  /// Initializes backing update data from the existing backing, updated rewards, total, and payment context.
  public init(
    backing: Backing,
    rewards: [Reward],
    pledgeTotal: Double,
    selectedQuantities: SelectedRewardQuantities,
    shippingRule: ShippingRule?,
    paymentSourceId: String?,
    setupIntentClientSecret: String?,
    applePayParams: ApplePayParams?,
    pledgeContext: PledgeViewContext,
    incremental: Bool
  ) {
    self.backing = backing
    self.rewards = rewards
    self.pledgeTotal = pledgeTotal
    self.selectedQuantities = selectedQuantities
    self.shippingRule = shippingRule
    self.paymentSourceId = paymentSourceId
    self.setupIntentClientSecret = setupIntentClientSecret
    self.applePayParams = applePayParams
    self.pledgeContext = pledgeContext
    self.incremental = incremental
  }
}

/// Typed payload configuring a `PKPaymentAuthorizationViewController` sheet.
public struct PaymentAuthorizationData: Equatable {
  /// Campaign being pledged to.
  public let project: Project
  /// Base reward selected by the backer (`Reward.noReward` for bonus-only pledges).
  public let reward: Reward
  /// Combined cost of base reward and add-ons before bonus and shipping.
  public let allRewardsTotal: Double
  /// Extra voluntary bonus pledge amount.
  public let additionalPledgeAmount: Double
  /// Total shipping charge across all selected physical items.
  public let allRewardsShippingTotal: Double
  /// Apple Pay merchant identifier configured for Stripe tokenization.
  public let merchantIdentifier: String

  /// Initializes Apple Pay authorization sheet totals and merchant configuration.
  public init(
    project: Project,
    reward: Reward,
    allRewardsTotal: Double,
    additionalPledgeAmount: Double,
    allRewardsShippingTotal: Double,
    merchantIdentifier: String
  ) {
    self.project = project
    self.reward = reward
    self.allRewardsTotal = allRewardsTotal
    self.additionalPledgeAmount = additionalPledgeAmount
    self.allRewardsShippingTotal = allRewardsShippingTotal
    self.merchantIdentifier = merchantIdentifier
  }
}

/// Normalized Apple Pay `PKPayment` metadata passed to GraphQL backing inputs.
public struct PKPaymentData: Equatable {
  /// Payment instrument display name from PassKit (`PKPaymentMethod.displayName`).
  public let displayName: String
  /// Payment network string (e.g., `"Visa"`, `"MasterCard"`).
  public let network: String
  /// Unique PassKit payment transaction identifier.
  public let transactionIdentifier: String

  /// Initializes normalized PassKit payment token metadata.
  public init(displayName: String, network: String, transactionIdentifier: String) {
    self.displayName = displayName
    self.network = network
    self.transactionIdentifier = transactionIdentifier
  }
}

/// Strongly-typed validated pledge amount payload emitted by `PledgeAmountViewModel`.
///
/// Format: Monetary values are rounded to 2 decimal places in project currency units.
/// Negative Constraint: Do not submit when `isValid == false`; check `amount >= min && amount <= max`.
public struct PledgeAmountData: Equatable, Sendable {
  /// Currently entered pledge or bonus amount.
  public let amount: Double
  /// Minimum allowed pledge/bonus amount.
  public let min: Double
  /// Maximum allowed pledge/bonus amount.
  public let max: Double
  /// `true` when `min <= amount && amount <= max`.
  public let isValid: Bool

  /// Creates a typed `PledgeAmountData` contract.
  public init(amount: Double, min: Double, max: Double, isValid: Bool) {
    self.amount = amount
    self.min = min
    self.max = max
    self.isValid = isValid
  }
}

