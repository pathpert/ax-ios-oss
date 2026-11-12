private let eurMaxPledge: Int = 8_500
private let eurMinPledge: Int = 1

extension Project {
  /// Kickstarter-supported creator country and currency configuration with pledge bounds.
  public struct Country {
    /// ISO 3166-1 alpha-2 country code (e.g., `"US"`, `"GB"`).
    public let countryCode: String
    /// ISO 4217 currency code (e.g., `"USD"`, `"EUR"`).
    public let currencyCode: String
    /// Display currency glyph (e.g., `"$"`, `"€"`).
    public let currencySymbol: String
    /// Maximum allowed pledge amount in whole major currency units, if defined.
    public let maxPledge: Int?
    /// Minimum allowed pledge amount in whole major currency units, if defined.
    public let minPledge: Int?
    /// Whether the currency code trails formatted currency strings in UI copy.
    public let trailingCode: Bool

    /*
     FIXME: The amount for maximum pledge can be found here:
     https://github.com/kickstarter/kickstarter/blob/master/config/currencies.yml
     Ideally we should get the amounts from the API. But for now we have to update them manually.
     */

    // swiftformat:disable wrap
    // swiftformat:disable wrapArguments
    /// Country preset for Austria (`AT`, `EUR`).
    public static let at = Country(countryCode: "AT", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Australia (`AU`, `AUD`).
    public static let au = Country(countryCode: "AU", currencyCode: "AUD", currencySymbol: "$", maxPledge: 13_000, minPledge: 1, trailingCode: true)
    /// Country preset for Belgium (`BE`, `EUR`).
    public static let be = Country(countryCode: "BE", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Canada (`CA`, `CAD`).
    public static let ca = Country(countryCode: "CA", currencyCode: "CAD", currencySymbol: "$", maxPledge: 13_000, minPledge: 1, trailingCode: true)
    /// Country preset for Switzerland (`CH`, `CHF`).
    public static let ch = Country(countryCode: "CH", currencyCode: "CHF", currencySymbol: "Fr", maxPledge: 9_500, minPledge: 1, trailingCode: true)
    /// Country preset for Germany (`DE`, `EUR`).
    public static let de = Country(countryCode: "DE", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Denmark (`DK`, `DKK`).
    public static let dk = Country(countryCode: "DK", currencyCode: "DKK", currencySymbol: "kr", maxPledge: 65_000, minPledge: 5, trailingCode: true)
    /// Country preset for Spain (`ES`, `EUR`).
    public static let es = Country(countryCode: "ES", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for France (`FR`, `EUR`).
    public static let fr = Country(countryCode: "FR", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for the United Kingdom (`GB`, `GBP`).
    public static let gb = Country(countryCode: "GB", currencyCode: "GBP", currencySymbol: "£", maxPledge: 8_000, minPledge: 1, trailingCode: false)
    /// Country preset for Greece (`GR`, `EUR`).
    public static let gr = Country(countryCode: "GR", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Hong Kong (`HK`, `HKD`).
    public static let hk = Country(countryCode: "HK", currencyCode: "HKD", currencySymbol: "$", maxPledge: 75_000, minPledge: 10, trailingCode: true)
    /// Country preset for Ireland (`IE`, `EUR`).
    public static let ie = Country(countryCode: "IE", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Italy (`IT`, `EUR`).
    public static let it = Country(countryCode: "IT", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Japan (`JP`, `JPY`).
    public static let jp = Country(countryCode: "JP", currencyCode: "JPY", currencySymbol: "¥", maxPledge: 1_200_000, minPledge: 100, trailingCode: false)
    /// Country preset for Luxembourg (`LU`, `EUR`).
    public static let lu = Country(countryCode: "LU", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Mexico (`MX`, `MXN`).
    public static let mx = Country(countryCode: "MX", currencyCode: "MXN", currencySymbol: "$", maxPledge: 200_000, minPledge: 10, trailingCode: true)
    /// Country preset for the Netherlands (`NL`, `EUR`).
    public static let nl = Country(countryCode: "NL", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for Norway (`NO`, `NOK`).
    public static let no = Country(countryCode: "NO", currencyCode: "NOK", currencySymbol: "kr", maxPledge: 80_000, minPledge: 5, trailingCode: true)
    /// Country preset for New Zealand (`NZ`, `NZD`).
    public static let nz = Country(countryCode: "NZ", currencyCode: "NZD", currencySymbol: "$", maxPledge: 14_000, minPledge: 1, trailingCode: true)
    /// Country preset for Poland (`PL`, `PLN`).
    public static let pl = Country(countryCode: "PL", currencyCode: "PLN", currencySymbol: "zł", maxPledge: 37_250, minPledge: 5, trailingCode: false)
    /// Country preset for Sweden (`SE`, `SEK`).
    public static let se = Country(countryCode: "SE", currencyCode: "SEK", currencySymbol: "kr", maxPledge: 85_000, minPledge: 5, trailingCode: true)
    /// Country preset for Singapore (`SG`, `SGD`).
    public static let sg = Country(countryCode: "SG", currencyCode: "SGD", currencySymbol: "$", maxPledge: 13_000, minPledge: 2, trailingCode: true)
    /// Country preset for Slovenia (`SI`, `EUR`).
    public static let si = Country(countryCode: "SI", currencyCode: "EUR", currencySymbol: "€", maxPledge: eurMaxPledge, minPledge: eurMinPledge, trailingCode: false)
    /// Country preset for the United States (`US`, `USD`).
    public static let us = Country(countryCode: "US", currencyCode: "USD", currencySymbol: "$", maxPledge: 10_000, minPledge: 1, trailingCode: true)

    /// All Kickstarter-supported countries and currency presets.
    public static let all: [Country] = [
      .au, .at, .be, .ca, .ch, .de, .dk, .es, .fr, .gb, .gr, .hk, .ie, .it, .jp, .lu, .mx, .nl, .no, .nz, .pl, .se, .sg, .si, .us
    ]
    // swiftformat:enable wrap
    // swiftformat:enable wrapArguments
  }
}

extension Project.Country: Decodable {
  enum CodingKeys: String, CodingKey {
    case countryCode = "country",
         currency,
         currencyCode = "currency_code",
         currencySymbol = "currency_symbol",
         currencyTrailingCode = "currency_trailing_code",
         maxPledge = "max_pledge",
         minPledge = "min_pledge",
         name,
         trailingCode = "trailing_code"
  }

  /// Decodes a `Project.Country` from either REST (`name`/`currency_code`) or GraphQL (`country`/`currency`) keys.
  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)

    do {
      self.countryCode = try container.decode(String.self, forKey: .countryCode)
    } catch {
      self.countryCode = try container.decode(String.self, forKey: .name)
    }

    do {
      self.currencyCode = try container.decode(String.self, forKey: .currency)
    } catch {
      self.currencyCode = try container.decode(String.self, forKey: .currencyCode)
    }

    self.currencySymbol = try container.decode(String.self, forKey: .currencySymbol)
    self.maxPledge = try? container.decode(Int.self, forKey: .maxPledge)
    self.minPledge = try? container.decode(Int.self, forKey: .minPledge)

    do {
      self.trailingCode = try container.decode(Bool.self, forKey: .currencyTrailingCode)
    } catch {
      self.trailingCode = try container.decode(Bool.self, forKey: .trailingCode)
    }
  }
}

extension Project.Country {
  /// Looks up the preset `Country` matching the given ISO 4217 `currencyCode`.
  public init?(currencyCode: String) {
    guard
      let country = Project.Country.all.first(where: { $0.currencyCode == currencyCode })
    else { return nil }
    self = country
  }
}

extension Project.Country: Equatable {}

/// Compares two `Project.Country` instances across country, currency, symbol, and formatting flags.
public func == (lhs: Project.Country, rhs: Project.Country) -> Bool {
  return lhs.countryCode == rhs.countryCode
    && lhs.currencySymbol == rhs.currencySymbol
    && lhs.currencyCode == rhs.currencyCode
    && lhs.trailingCode == rhs.trailingCode
}

extension Project.Country: CustomStringConvertible {
  /// Human-readable `(countryCode, currencyCode, currencySymbol)` representation.
  public var description: String {
    return "(\(self.countryCode), \(self.currencyCode), \(self.currencySymbol))"
  }
}
