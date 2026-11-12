import Foundation

/// Supported GraphQL payment instrument types accepted by payment source mutations.
///
/// - Negative constraint: Do not pass raw lowercase strings or arbitrary display names; use a defined case matching the backend GraphQL `PaymentTypes` enum.
public enum PaymentType: String, Codable {
  /// Apple Pay tokenized payment method.
  case applePay = "APPLE_PAY"
  /// Standard credit or debit card tokenized via Stripe.
  case creditCard = "CREDIT_CARD"
  /// Google Pay / Android Pay tokenized payment method.
  case googlePay = "ANDROID_PAY"
  /// Direct bank account payment method.
  case bankAccount = "BANK_ACCOUNT"

  /// Analytics tracking identifier for the payment type, or `nil` when untracked.
  /// - Negative Constraint: Do not send this string to GraphQL mutations; encode enum `rawValue` instead.
  public var trackingString: String? {
    switch self {
    case .applePay:
      return "apple_pay"
    case .googlePay:
      return nil
    case .bankAccount:
      return nil
    case .creditCard:
      return "credit_card"
    }
  }
}
