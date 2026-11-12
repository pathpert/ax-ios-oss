import Foundation
import Prelude

/// Immutable value type representing `NumberFormatterConfig`.
internal struct NumberFormatterConfig: Hashable {
  internal let numberStyle: NumberFormatter.Style
  internal let roundingMode: NumberFormatter.RoundingMode
  internal let maximumFractionDigits: Int
  internal let minimumFractionDigits: Int
  internal let generatesDecimalNumbers: Bool
  internal let locale: Locale
  internal let currencySymbol: String

  private func formatter() -> NumberFormatter {
    let formatter = AttributedNumberFormatter()
    formatter.numberStyle = self.numberStyle
    formatter.roundingMode = self.roundingMode
    formatter.maximumFractionDigits = self.maximumFractionDigits
    formatter.minimumFractionDigits = self.minimumFractionDigits
    formatter.generatesDecimalNumbers = self.generatesDecimalNumbers
    formatter.locale = self.locale
    formatter.currencySymbol = self.currencySymbol
    return formatter
  }

  private static var formatters: [NumberFormatterConfig: NumberFormatter] = [:]

  internal static let defaultWholeNumberConfig = NumberFormatterConfig(
    numberStyle: .decimal,
    roundingMode: .down,
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
    generatesDecimalNumbers: false,
    locale: .current,
    currencySymbol: "$"
  )

  internal static let defaultPercentageConfig = NumberFormatterConfig(
    numberStyle: .percent,
    roundingMode: .down,
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
    generatesDecimalNumbers: false,
    locale: .current,
    currencySymbol: "$"
  )

  internal static let defaultCurrencyConfig = NumberFormatterConfig(
    numberStyle: .currency,
    roundingMode: .down,
    maximumFractionDigits: 0,
    minimumFractionDigits: 0,
    generatesDecimalNumbers: false,
    locale: .current,
    currencySymbol: "$"
  )

  internal static let defaultDecimalCurrencyConfig = NumberFormatterConfig(
    numberStyle: .decimal,
    roundingMode: .down,
    maximumFractionDigits: 2,
    minimumFractionDigits: 2,
    generatesDecimalNumbers: false,
    // Decimal currency amounts are always formatted using En locale for compatibility with the API
    locale: Locale(identifier: "en"),
    currencySymbol: "$"
  )

  internal static func cachedFormatter(forConfig config: NumberFormatterConfig) -> NumberFormatter {
    let formatter = self.formatters[config] ?? config.formatter()
    self.formatters[config] = formatter
    return formatter
  }

  private func copy(
    numberStyle: NumberFormatter.Style? = nil,
    roundingMode: NumberFormatter.RoundingMode? = nil,
    maximumFractionDigits: Int? = nil,
    minimumFractionDigits: Int? = nil,
    generatesDecimalNumbers: Bool? = nil,
    locale: Locale? = nil,
    currencySymbol: String? = nil
  ) -> NumberFormatterConfig {
    return NumberFormatterConfig(
      numberStyle: numberStyle ?? self.numberStyle,
      roundingMode: roundingMode ?? self.roundingMode,
      maximumFractionDigits: maximumFractionDigits ?? self.maximumFractionDigits,
      minimumFractionDigits: minimumFractionDigits ?? self.minimumFractionDigits,
      generatesDecimalNumbers: generatesDecimalNumbers ?? self.generatesDecimalNumbers,
      locale: locale ?? self.locale,
      currencySymbol: currencySymbol ?? self.currencySymbol
    )
  }
}

extension NumberFormatterConfig {
  internal enum lens {
    internal static let numberStyle = Lens<NumberFormatterConfig, NumberFormatter.Style>(
      view: { $0.numberStyle },
      set: { $1.copy(numberStyle: $0) }
    )

    internal static let roundingMode = Lens<NumberFormatterConfig, NumberFormatter.RoundingMode>(
      view: { $0.roundingMode },
      set: { $1.copy(roundingMode: $0) }
    )

    internal static let maximumFractionDigits = Lens<NumberFormatterConfig, Int>(
      view: { $0.maximumFractionDigits },
      set: { $1.copy(maximumFractionDigits: $0) }
    )

    internal static let minimumFractionDigits = Lens<NumberFormatterConfig, Int>(
      view: { $0.minimumFractionDigits },
      set: { $1.copy(minimumFractionDigits: $0) }
    )

    internal static let generatesDecimalNumbers = Lens<NumberFormatterConfig, Bool>(
      view: { $0.generatesDecimalNumbers },
      set: { $1.copy(generatesDecimalNumbers: $0) }
    )

    internal static let locale = Lens<NumberFormatterConfig, Locale>(
      view: { $0.locale },
      set: { $1.copy(locale: $0) }
    )

    internal static let currencySymbol = Lens<NumberFormatterConfig, String>(
      view: { $0.currencySymbol },
      set: { $1.copy(currencySymbol: $0) }
    )
  }
}

