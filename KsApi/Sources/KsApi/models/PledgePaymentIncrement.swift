import Foundation

/// A single scheduled installment in a pledge-over-time payment plan.
public struct PledgePaymentIncrement: Equatable, Decodable {
  /// Status badge displayed next to a scheduled or collected installment.
  public struct Badge: Equatable, Decodable {
    /// Visual badge style variant mapped from GraphQL.
    public enum Variant: String, Decodable {
      /// Purple accent badge style.
      case purple = "PURPLE"
      /// Green confirmation badge style.
      case green = "GREEN"
      /// Red error/warning badge style.
      case red = "RED"
      /// Critical danger badge style.
      case danger = "DANGER"
      /// Neutral gray badge style.
      case gray = "GRAY"
    }

    /// Localized badge label text.
    public internal(set) var copy: String
    /// Badge color/semantic variant.
    public internal(set) var variant: PledgePaymentIncrement.Badge.Variant
  }

  /// Installment monetary amount formatted in project currency.
  public internal(set) var amount: PledgePaymentIncrementAmount
  /// Badge will only be set for pledge increments with a backing.
  public internal(set) var badge: PledgePaymentIncrement.Badge?
  /// Refund status will only be set for pledge increments with a backing. Otherwise, it will be `.unknown`
  public internal(set) var refundStatus: RefundStatus
  /// Unix timestamp (seconds since epoch) when this installment is scheduled to be collected.
  public internal(set) var scheduledCollection: TimeInterval

  /// Creates a `PledgePaymentIncrement`.
  public init(
    amount: PledgePaymentIncrementAmount,
    badge: PledgePaymentIncrement.Badge? = nil,
    refundStatus: RefundStatus,
    scheduledCollection: TimeInterval
  ) {
    self.amount = amount
    self.badge = badge
    self.refundStatus = refundStatus
    self.scheduledCollection = scheduledCollection
  }
}

/// Currency code and preformatted installment amount for a `PledgePaymentIncrement`.
public struct PledgePaymentIncrementAmount: Equatable, Decodable {
  /// ISO 4217 currency code.
  public internal(set) var currency: String
  /// Display amount preformatted in the project's native currency.
  public internal(set) var amountFormattedInProjectNativeCurrency: String

  /// Creates a `PledgePaymentIncrementAmount`.
  public init(
    currency: String,
    amountFormattedInProjectNativeCurrency: String
  ) {
    self.currency = currency
    self.amountFormattedInProjectNativeCurrency = amountFormattedInProjectNativeCurrency
  }
}

extension PledgePaymentIncrement {
  /// Represents the refund status of a payment increment.
  public enum RefundStatus: Equatable, Decodable {
    /// No refund has been issued for this payment increment.
    case notRefunded
    /// A refund has been issued for this payment increment.
    /// The associated `PledgePaymentIncrementAmount` equals the total collected amount,
    /// i.e. the increment minus any refunds.
    case partialRefund(PledgePaymentIncrementAmount)
    /// A full refund has been issued for this payment increment.
    case fullRefund
    /// The refund status could not be determined (e.g. data not fetched).
    case unknown
  }
}
