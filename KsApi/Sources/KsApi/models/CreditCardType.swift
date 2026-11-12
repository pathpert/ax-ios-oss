import Foundation

/// Supported payment card brands decoded from Stripe and Kickstarter card metadata.
public enum CreditCardType: String, Decodable, CaseIterable {
  /// American Express card network.
  case amex = "AMEX"
  /// Diners Club card network.
  case diners = "DINERS"
  /// Discover card network.
  case discover = "DISCOVER"
  /// JCB card network.
  case jcb = "JCB"
  /// Mastercard network.
  case mastercard = "MASTERCARD"
  /// China UnionPay card network.
  case unionPay = "UNION_PAY"
  /// Visa card network.
  case visa = "VISA"
  /// Fallback generic/unknown card brand marker.
  case generic = "----"

  /// Human-readable brand name, or `nil` for unknown/generic card types.
  public var description: String? {
    switch self {
    case .amex, .discover, .jcb, .mastercard, .visa, .diners:
      return self.rawValue.capitalized
    case .unionPay:
      return self.rawValue
        .capitalized
        .replacingOccurrences(of: "_", with: " ")
    default:
      return nil
    }
  }

  /// Decodes a card brand string, falling back to `.generic` for unrecognized values.
  public init(from decoder: Decoder) throws {
    let decodedValue = try decoder.singleValueContainer().decode(String.self)

    self = CreditCardType(rawValue: decodedValue) ?? .generic
  }
}
