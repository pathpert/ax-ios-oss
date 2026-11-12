import Foundation
import GraphAPI
import Prelude

/// Monetary amount decoded from GraphQL `MoneyFragment` or JSON responses.
public struct Money: Decodable, Equatable {
  /// Numeric monetary amount in major currency units.
  public var amount: Double
  /// ISO 4217 currency code, when provided by the backend.
  public var currency: CurrencyCode?
  /// Display currency symbol (e.g., `"$"`, `"€"`).
  public var symbol: String?

  /// Supported ISO 4217 currency codes for `Money`.
  public enum CurrencyCode: String, CaseIterable, Decodable, Equatable {
    /// Australian Dollar (`AUD`).
    case aud = "AUD"
    /// Canadian Dollar (`CAD`).
    case cad = "CAD"
    /// Swiss Franc (`CHF`).
    case chf = "CHF"
    /// Danish Krone (`DKK`).
    case dkk = "DKK"
    /// Euro (`EUR`).
    case eur = "EUR"
    /// British Pound Sterling (`GBP`).
    case gbp = "GBP"
    /// Hong Kong Dollar (`HKD`).
    case hkd = "HKD"
    /// Japanese Yen (`JPY`).
    case jpy = "JPY"
    /// Mexican Peso (`MXN`).
    case mxn = "MXN"
    /// Norwegian Krone (`NOK`).
    case nok = "NOK"
    /// New Zealand Dollar (`NZD`).
    case nzd = "NZD"
    /// Polish Zloty (`PLN`).
    case pln = "PLN"
    /// Swedish Krona (`SEK`).
    case sek = "SEK"
    /// Singapore Dollar (`SGD`).
    case sgd = "SGD"
    /// United States Dollar (`USD`).
    case usd = "USD"
  }
}

extension Money {
  private enum CodingKeys: CodingKey {
    case amount
    case currency
    case symbol
  }

  /// Decodes `amount` from its wire string representation together with optional `currency` and `symbol`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)

    guard let amount = (try values.decode(String?.self, forKey: .amount)).flatMap(Double.init) else {
      throw DecodingError.dataCorruptedError(
        forKey: .amount, in: values, debugDescription: "Not a valid double"
      )
    }

    self.amount = amount
    self.currency = try values.decodeIfPresent(CurrencyCode.self, forKey: .currency)
    self.symbol = try values.decodeIfPresent(String.self, forKey: .symbol)
  }
}

extension Money {
  /// Initializes a `Money` value from a GraphQL `MoneyFragment`, returning `nil` if amount or currency is invalid.
  public init?(_ fragment: GraphAPI.MoneyFragment) {
    guard
      let amount = fragment.amount.flatMap(Double.init),
      let currencyCode = fragment.currency.flatMap({ Money.CurrencyCode(rawValue: $0.rawValue) })
    else {
      return nil
    }

    self.amount = amount
    self.currency = currencyCode
    self.symbol = fragment.symbol
  }
}
