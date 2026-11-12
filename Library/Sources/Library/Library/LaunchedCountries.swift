import struct KsApi.Project

/// Lookup registry of countries where Kickstarter campaigns have launched, used to format currency disambiguation suffixes.
/// - Negative Constraint: Pass configured `Project.Country` arrays for testing rather than mutating global country lists.
public struct LaunchedCountries {
  /// Supported launched country definitions carrying currency symbols and trailing code preferences.
  public let countries: [Project.Country]

  /// Initializes the lookup registry with `countries` (defaults to `Project.Country.all`).
  public init(countries: [Project.Country] = Project.Country.all) {
    self.countries = countries
  }

  /// Determines if a currency symbol needs a country code suffix (e.g., `$10 CAD`) to avoid ambiguity.
  /// - parameter currencySymbol: A currency symbol string.
  /// - returns: `true` if a matching country requires a trailing currency code.
  public func currencyNeedsCode(_ currencySymbol: String) -> Bool {
    for country in self.countries where country.currencySymbol == currencySymbol {
      return country.trailingCode
    }
    return false
  }
}
