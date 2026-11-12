import Foundation
import GraphAPI
import KsApi
import Prelude

/// UTC (`GMT+0`) time zone shared by server-date parsing and formatting helpers.
public let UTCTimeZone = TimeZone(secondsFromGMT: 0)!

/// Stateless numeric, currency, date, and duration formatting utilities.
public enum Format {
  /// Formats an integer using localized grouping separators.
  public static func wholeNumber(_ x: Int, env: Environment = AppEnvironment.current) -> String {
    let formatter = NumberFormatterConfig.cachedFormatter(
      forConfig: .defaultWholeNumberConfig
        |> NumberFormatterConfig.lens.locale .~ env.locale
    )
    return formatter.string(for: x) ?? String(x)
  }

  /// Formats an integer percentage where `100` corresponds to `100%`.
  public static func percentage(_ percentage: Int, env: Environment = AppEnvironment.current) -> String {
    return Format.percentage(Double(percentage) / 100.0, env: env)
  }

  /// Formats a floating-point ratio percentage where `0.10` corresponds to `10%`.
  public static func percentage(_ percentage: Double, env: Environment = AppEnvironment.current) -> String {
    let formatter = NumberFormatterConfig.cachedFormatter(
      forConfig: .defaultPercentageConfig
        |> NumberFormatterConfig.lens.locale .~ env.locale
    )

    return formatter.string(for: percentage) ?? (String(percentage) + "%")
  }

  /// Formats a floating-point currency amount with two fraction digits using the API-compatible English locale.
  public static func decimalCurrency(for amount: Double) -> String {
    let formatter = NumberFormatterConfig.cachedFormatter(
      forConfig: .defaultDecimalCurrencyConfig
    )

    return formatter.string(for: amount) ?? String(format: "%.2f", amount)
  }

  /// Formats an integer amount with the currency symbol matching `currencyCode`.
  public static func currency(
    _ amount: Int,
    currencyCode: String,
    omitCurrencyCode: Bool = true,
    env: Environment = AppEnvironment.current
  ) -> String {
    return Format.formattedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitCurrencyCode,
      env: env
    )
  }

  /// Formats a floating-point amount with the currency symbol matching `currencyCode`.
  public static func currency(
    _ amount: Double,
    currencyCode: String,
    omitCurrencyCode: Bool = true,
    roundingMode: NumberFormatter.RoundingMode = .down,
    maximumFractionDigits: Int = 0,
    minimumFractionDigits: Int = 0,
    env: Environment = AppEnvironment.current
  ) -> String {
    return Format.formattedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitCurrencyCode,
      roundingMode: roundingMode,
      maximumFractionDigits: maximumFractionDigits,
      minimumFractionDigits: minimumFractionDigits,
      env: env
    )
  }

  /// Formats an arbitrary numeric currency value with custom rounding and fraction digit precision.
  public static func formattedCurrency(
    _ amount: Any,
    currencyCode: String,
    omitCurrencyCode: Bool = true,
    roundingMode: NumberFormatter.RoundingMode = .down,
    maximumFractionDigits: Int = 0,
    minimumFractionDigits: Int = 0,
    env: Environment = AppEnvironment.current
  ) -> String {
    let symbol = currencySymbol(
      forCurrencyCode: currencyCode,
      omitCurrencyCode: omitCurrencyCode,
      env: env
    )

    let formatter = NumberFormatterConfig.cachedFormatter(
      forConfig: .defaultCurrencyConfig
        |> NumberFormatterConfig.lens.roundingMode .~ roundingMode
        |> NumberFormatterConfig.lens.maximumFractionDigits .~ maximumFractionDigits
        |> NumberFormatterConfig.lens.minimumFractionDigits .~ minimumFractionDigits
        |> NumberFormatterConfig.lens.locale .~ env.locale
        |> NumberFormatterConfig.lens.currencySymbol .~ symbol
    )

    return formatter.string(for: amount)?
      .trimmed()
      .replacingOccurrences(of: String.nbsp + String.nbsp, with: String.nbsp)
      ?? (symbol + "\(amount)")
  }

  /// Formats a floating-point currency amount into an `NSAttributedString` supporting superscripted symbols and fractions.
  public static func attributedCurrency(
    _ amount: Double,
    currencyCode: String,
    omitCurrencyCode: Bool = true,
    defaultAttributes: String.Attributes = [:],
    superscriptAttributes: String.Attributes = [:],
    maximumFractionDigits: Int = 2,
    minimumFractionDigits: Int = 2,
    env: Environment = AppEnvironment.current
  ) -> NSAttributedString? {
    let symbol = currencySymbol(forCurrencyCode: currencyCode, omitCurrencyCode: omitCurrencyCode, env: env)
    let config = NumberFormatterConfig.defaultCurrencyConfig
      |> NumberFormatterConfig.lens.locale .~ env.locale
      |> NumberFormatterConfig.lens.currencySymbol .~ symbol
      |> NumberFormatterConfig.lens.minimumFractionDigits .~ maximumFractionDigits
      |> NumberFormatterConfig.lens.maximumFractionDigits .~ minimumFractionDigits

    guard let formatter = NumberFormatterConfig.cachedFormatter(forConfig: config)
      as? AttributedNumberFormatter else { return nil }

    _ = formatter
      |> \.defaultAttributes .~ defaultAttributes
      |> \.currencySymbolAttributes .~ superscriptAttributes
      |> \.decimalSeparatorAttributes .~ superscriptAttributes
      |> \.fractionDigitsAttributes .~ superscriptAttributes

    return formatter.attributedString(for: amount)
  }

  /// Formats the localized `+` prefix attributed string used alongside add-on shipping amounts.
  public static func attributedPlusSign(_ attributes: String.Attributes = [:]) -> NSAttributedString {
    return NSAttributedString(string: Strings.plus_shipping_cost(shipping_cost: ""), attributes: attributes)
  }

  /// Formats a GraphQL `MoneyFragment` into a localized currency string, or returns `nil` when incomplete.
  public static func currency(
    _ money: GraphAPI.MoneyFragment,
    env: Environment = AppEnvironment.current
  ) -> String? {
    guard
      case let .case(currency) = money.currency,
      let amountString = money.amount,
      let decimal = try? Decimal(amountString, format: .number)
    else { return nil }

    return decimal.formatted(
      .currency(code: currency.rawValue)
        .locale(env.locale)
    )
  }
}
