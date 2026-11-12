import Foundation

extension Project {
  /// Funding metrics, currency metadata, and exchange rates for a `Project`.
  ///
  /// Negative Constraint: Do not pass raw `goal` or `pledged` across currency displays without checking
  /// `projectCurrency` and `userCurrency` via `needsConversion`.
  public struct Stats {
    /// Total count of active backers supporting the campaign.
    public var backersCount: Int
    /// Total published comments count (`nil` on sparse list projections).
    public var commentsCount: Int?
    /// Pledged total already converted by the backend into the user's preferred currency.
    public var convertedPledgedAmount: Float?
    /// Three-letter ISO 4217 currency code of the project's native currency (e.g., `"USD"`).
    public var projectCurrency: String
    /// Three-letter ISO 4217 currency code of the viewer's preferred currency (e.g., `"SEK"`).
    public var userCurrency: String?
    /// FX conversion multiplier from `projectCurrency` to `userCurrency`.
    public var userCurrencyRate: Float?
    /// Target funding goal in whole major currency units of `projectCurrency`.
    /// Negative Constraint: Do not treat `goal` as cents or assume USD without `staticUsdRate`.
    public var goal: Int
    /// Amount pledged so far in whole major currency units of `projectCurrency`.
    public var pledged: Int
    /// Snapshot FX rate from `projectCurrency` to USD captured at campaign creation.
    public var staticUsdRate: Float
    /// Count of creator updates posted (`nil` on sparse list projections).
    public var updatesCount: Int?
    /// Live market FX rate from `projectCurrency` to USD (`nil` when unavailable).
    public var usdExchangeRate: Float?

    /// Percent funded normalized to `[0.0, +inf)` (`1.0` == 100%).
    /// Negative Constraint: For integer percentage display (`0...100`), use `percentFunded`.
    public var fundingProgress: Float {
      return self.goal == 0 ? 0.0 : Float(self.pledged) / Float(self.goal)
    }

    /// Percent funded floored to whole percentage points (`0...100+`).
    /// Negative Constraint: Use `fundingProgress` for normalized progress-bar ratios (`0.0...1.0`).
    public var percentFunded: Int {
      return Int(floor(self.fundingProgress * 100.0))
    }

    /// Pledged amount converted to USD using `staticUsdRate`.
    public var pledgedUsd: Float {
      return floor(Float(self.pledged) * self.staticUsdRate)
    }

    /// Total amount currently pledged converted to USD using live `usdExchangeRate`, regardless of user currency.
    public var totalAmountPledgedUsdCurrency: Float? {
      return self.usdExchangeRate.map { Float(self.pledged) * $0 }
    }

    /// Goal amount converted to USD using `staticUsdRate`.
    public var goalUsd: Float {
      return floor(Float(self.goal) * self.staticUsdRate)
    }

    /// Goal amount converted into the user's preferred currency (`userCurrency`), if `userCurrencyRate` is present.
    public var goalUserCurrency: Float? {
      return self.userCurrencyRate.map { floor(Float(self.goal) * $0) }
    }

    /// Goal amount converted to USD via live `usdExchangeRate` (`0` when `usdExchangeRate` is `nil`).
    public var goalUsdCurrency: Float {
      return Float(self.goal) * (self.usdExchangeRate ?? 0)
    }

    /// Best-effort `Project.Country` inferred from `userCurrency`.
    public var userCountry: Project.Country? {
      guard let userCurrency = self.userCurrency else {
        return nil
      }

      return Project.Country(currencyCode: userCurrency)
    }

    /// `true` when currency formatting should omit `"US"` prefix (i.e. viewer uses USD).
    public var omitUSCurrencyCode: Bool {
      let userCurrency = self.userCurrency ?? Project.Country.us.currencyCode

      return userCurrency == Project.Country.us.currencyCode
    }

    /// `true` when `projectCurrency` differs from the viewer's `userCurrency` and FX display is required.
    public var needsConversion: Bool {
      let userCurrency = self.userCurrency ?? Project.Country.us.currencyCode

      return self.projectCurrency != userCurrency
    }

    /// `true` when `pledged >= goal`.
    public var goalMet: Bool {
      return self.pledged >= self.goal
    }
  }
}

extension Project.Stats: Decodable {
  enum CodingKeys: String, CodingKey {
    case backersCount = "backers_count"
    case commentsCount = "comments_count"
    case convertedPledgedAmount = "converted_pledged_amount"
    case currency
    case currentCurrency = "current_currency"
    case currentCurrencyRate = "fx_rate"
    case goal
    case pledged
    case staticUsdRate = "static_usd_rate"
    case updatesCount = "updates_count"
    case usdExchangeRate = "usd_exchange_rate"
  }

  /// Decodes project funding statistics, coercing double-precision `pledged` values to `Int`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.backersCount = try values.decode(Int.self, forKey: .backersCount)
    self.commentsCount = try values.decodeIfPresent(Int.self, forKey: .commentsCount)
    self.convertedPledgedAmount = try values.decodeIfPresent(Float.self, forKey: .convertedPledgedAmount)
    self.projectCurrency = try values.decode(String.self, forKey: .currency)
    self.userCurrency = try values.decodeIfPresent(String.self, forKey: .currentCurrency)
    self.userCurrencyRate = try values.decodeIfPresent(Float.self, forKey: .currentCurrencyRate)
    self.goal = try values.decode(Int.self, forKey: .goal)
    let value = try values.decode(Double.self, forKey: .pledged)
    self.pledged = Int(value)
    self.staticUsdRate = try values.decodeIfPresent(Float.self, forKey: .staticUsdRate) ?? 1.0
    self.updatesCount = try values.decodeIfPresent(Int.self, forKey: .updatesCount)
    self.usdExchangeRate = try values.decodeIfPresent(Float.self, forKey: .usdExchangeRate)
  }
}

