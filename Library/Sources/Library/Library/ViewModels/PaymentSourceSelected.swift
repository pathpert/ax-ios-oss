import Foundation

/// Stripe payment method identifier (`pm_*`).
public typealias StripePaymentMethodID = String
/// Kickstarter saved credit card identifier.
public typealias KSRCreditCardId = String

/// Selected payment instrument returned from saved payment method selection.
/// Previously supported additional payment types; now represents saved credit cards.
/// - Negative Constraint: Do not treat `savedCreditCardId` as a Stripe `pm_` token; use `stripePaymentMethodId` when calling Stripe SDKs.
public enum PaymentSourceSelected: Equatable {
  /// Saved credit card carrying Kickstarter card ID and optional Stripe `pm_` token.
  case savedCreditCard(KSRCreditCardId, StripePaymentMethodID?)

  /// Kickstarter internal credit card identifier for the selected card.
  public var savedCreditCardId: KSRCreditCardId {
    switch self {
    case let .savedCreditCard(savedCardId, _):
      return savedCardId
    }
  }

  /// Optional Stripe `pm_` payment method identifier paired with this saved card.
  public var stripePaymentMethodId: StripePaymentMethodID? {
    switch self {
    case let .savedCreditCard(_, paymentMethodId):
      return paymentMethodId
    }
  }
}
