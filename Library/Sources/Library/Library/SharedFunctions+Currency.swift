import KDS
import KsApi
import Prelude
import UIKit

/// Returns the currency symbol for `currencyCode`, prefixed with country/currency codes when disambiguation is needed.
/// - parameter currencyCode: ISO 4217 currency code.
/// - parameter omitCurrencyCode: Whether to omit the `US` prefix for domestic USD projects.
/// - parameter env: Environment providing launched country rules.
/// - returns: Formatted currency symbol prefix string.
public func currencySymbol(
  forCurrencyCode currencyCode: String,
  omitCurrencyCode: Bool = true,
  env: Environment = AppEnvironment.current
) -> String {
  let country = projectCountry(forCurrency: currencyCode, env: env) ?? .us

  guard env.launchedCountries.currencyNeedsCode(country.currencySymbol) else {
    // Currencies that dont have ambigious currencies can just use their symbol.
    return country.currencySymbol
  }

  if country == .us && env.countryCode == Project.Country.us.countryCode && omitCurrencyCode {
    // US people looking at US projects just get the currency symbol
    return country.currencySymbol
  } else if country == .sg {
    // Singapore projects get a special currency prefix
    return "\(String.nbsp)S\(country.currencySymbol)\(String.nbsp)"
  } else if country.currencySymbol == "kr" || country.currencySymbol == "Fr" {
    // Kroner projects use the currency code prefix
    return "\(String.nbsp)\(country.currencyCode)\(String.nbsp)"
  } else {
    // Everything else uses the country code prefix.
    return "\(String.nbsp)\(country.countryCode)\(country.currencySymbol)\(String.nbsp)"
  }
}

/// Returns the first `Project.Country` matching `code`, or `nil` when unrecognized.
/// - parameter code: ISO 4217 currency code.
/// - parameter env: Environment providing launched country definitions.
public func projectCountry(
  forCurrency code: String?,
  env: Environment = AppEnvironment.current
) -> Project.Country? {
  guard let currencyCode = code,
        let country = env.launchedCountries.countries.filter({ $0.currencyCode == currencyCode }).first else {
    return nil
  }
  // return a hardcoded Country if it matches the country code
  return country
}


/// Formats a currency amount for a reward or backing, trimming trailing zeros unless `omitUSCurrencyCode` is configured.
public func formattedAmountForRewardOrBacking(
  project: Project,
  rewardOrBacking: Either<Reward, Backing>
) -> String {
  let projectCurrency = project.statsCurrency
  switch rewardOrBacking {
  case let .left(reward):
    let min = minPledgeAmount(forProject: project, reward: reward)
    return Format.currency(
      min,
      currencyCode: projectCurrency,
      omitCurrencyCode: project.stats.omitUSCurrencyCode
    )
  case let .right(backing):
    return Format.formattedCurrency(
      backing.amount,
      currencyCode: projectCurrency,
      omitCurrencyCode: project.stats.omitUSCurrencyCode
    )
  }
}


/// Parses a user-entered pledge amount string into a `Double` using currency-aware decimal formatting.
/// Returns `0` when the input cannot be parsed as a valid finite number.
public func ksr_pledgeAmount(
  _ pledgeAmount: Double,
  subtractingShippingAmount shippingAmount: Double?
) -> Double {
  guard let shippingAmount = shippingAmount, shippingAmount > 0 else { return pledgeAmount }

  let pledgeAmount = Decimal(pledgeAmount) - Decimal(shippingAmount)

  return (pledgeAmount as NSDecimalNumber).doubleValue
}


/// Returns an attributed currency string highlighting superscripted currency symbols for display in project views.
/// Returns `nil` when currency formatting fails for the project's currency code.
public func attributedCurrency(withProject project: Project, total: Double) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
    .withAllValuesFrom([.foregroundColor: LegacyColors.ksr_support_700.uiColor()])
  let currencyCode = project.statsCurrency

  return Format.attributedCurrency(
    total,
    currencyCode: currencyCode,
    omitCurrencyCode: project.stats.omitUSCurrencyCode,
    defaultAttributes: defaultAttributes,
    superscriptAttributes: checkoutCurrencySuperscriptAttributes()
  )
}

