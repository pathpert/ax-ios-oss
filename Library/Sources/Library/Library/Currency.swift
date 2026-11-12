import KsApi
import UIKit

/// Supported Kickstarter pledge currencies and their localized display names.
public enum Currency: String, Encodable, CaseIterable, Equatable {
  /// Euro (`EUR`).
  case EUR
  /// Australian Dollar (`AUD`).
  case AUD
  /// Canadian Dollar (`CAD`).
  case CAD
  /// Swiss Franc (`CHF`).
  case CHF
  /// Danish Krone (`DKK`).
  case DKK
  /// British Pound (`GBP`).
  case GBP
  /// Hong Kong Dollar (`HKD`).
  case HKD
  /// Japanese Yen (`JPY`).
  case JPY
  /// Mexican Peso (`MXN`).
  case MXN
  /// Norwegian Krone (`NOK`).
  case NOK
  /// New Zealand Dollar (`NZD`).
  case NZD
  /// Polish Zloty (`PLN`).
  case PLN
  /// Swedish Krona (`SEK`).
  case SEK
  /// Singapore Dollar (`SGD`).
  case SGD
  /// United States Dollar (`USD`).
  case USD

  /// Localized currency display label (for example `"US Dollar"`).
  public var descriptionText: String {
    switch self {
    case .EUR:
      return Strings.Currency_EUR()
    case .AUD:
      return Strings.Currency_AUD()
    case .CAD:
      return Strings.Currency_CAD()
    case .CHF:
      return Strings.Currency_CHF()
    case .DKK:
      return Strings.Currency_DKK()
    case .GBP:
      return Strings.Currency_GBP()
    case .HKD:
      return Strings.Currency_HKD()
    case .JPY:
      return Strings.Currency_JPY()
    case .MXN:
      return Strings.Currency_MXN()
    case .NOK:
      return Strings.Currency_NOK()
    case .NZD:
      return Strings.Currency_NZD()
    case .PLN:
      return Strings.Currency_PLN()
    case .SEK:
      return Strings.Currency_SEK()
    case .SGD:
      return Strings.Currency_SGD()
    case .USD:
      return Strings.Currency_USD()
    }
  }
}
