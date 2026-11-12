/// Client A/B experiment identifiers and variant enums.
///
/// Negative Constraint: For remote feature gates, prefer typed `Feature` enums and the `feature_gates` module rather than adding ad-hoc string keys here.
public enum Experiment {
  /// Named legacy Optimizely/config A/B experiment keys.
  public enum Name: String {
    /// Experiment controlling creator name display on discovery cards.
    case creatorsNameDiscovery = "show_created_by_discovery"

    /// Default debug-mode state for this experiment.
    public var debugDefault: Bool {
      switch self {
      case .creatorsNameDiscovery: return true
      }
    }
  }

  /// Experiment treatment assignment bucket.
  public enum Variant: String {
    /// Default baseline control group.
    case control // default
    /// Experimental treatment variant.
    case experimental
  }
}

/// Map of feature flag keys to enabled booleans returned by `/v1/app/ios/config`.
public typealias Features = [String: Bool]

/// Remote application configuration payload fetched at launch from `/v1/app/ios/config`.
///
/// Negative Constraint: Do not hardcode `stripePublishableKey` or `features`; read them from the decoded `Config` on `AppEnvironment.current.config`.
public struct Config {
  /// Server-assigned A/B experiment variants keyed by experiment name.
  public var abExperiments: [String: String]
  /// Numeric iTunes / App Store application identifier.
  public var appId: Int
  /// ISO country codes where Apple Pay is supported for backing projects.
  public var applePayCountries: [String]
  /// Resolved ISO 3166-1 alpha-2 country code for the requester IP/locale.
  public var countryCode: String
  /// Server-controlled boolean feature flags keyed by feature string identifier.
  public var features: Features
  /// App Store URL string for rating/updating the Kickstarter iOS app.
  public var iTunesLink: String
  /// Countries where Kickstarter creators are eligible to launch campaigns.
  public var launchedCountries: [Project.Country]
  /// Active server locale identifier string.
  public var locale: String
  /// Stripe publishable API key for tokenizing payment methods on the client.
  public var stripePublishableKey: String

  /// Formatted `"name[variant]"` strings used in analytics and diagnostics.
  public var abExperimentsArray: [String] {
    let stringsArray = self.abExperiments.map { key, value in
      key + "[\(value)]"
    }
    return stringsArray
  }
}

extension Config: Decodable {
  enum CodingKeys: String, CodingKey {
    case abExperiments = "ab_experiments"
    case appId = "app_id"
    case applePayCountries = "apple_pay_countries"
    case countryCode = "country_code"
    case features
    case iTunesLink = "itunes_link"
    case launchedCountries = "launched_countries"
    case locale
    case stripe

    enum StripeCodingKeys: String, CodingKey {
      case stripePublishableKey = "publishable_key"
    }
  }

  /// Decodes the remote client configuration payload including experiments, feature flags, and Stripe key.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.abExperiments = try values.decode([String: String].self, forKey: .abExperiments)
    self.appId = try values.decode(Int.self, forKey: .appId)
    self.applePayCountries = try values.decode([String].self, forKey: .applePayCountries)
    self.countryCode = try values.decode(String.self, forKey: .countryCode)
    self.features = try values.decode([String: Bool].self, forKey: .features)
    self.iTunesLink = try values.decode(String.self, forKey: .iTunesLink)
    self.launchedCountries = try values.decode([Project.Country].self, forKey: .launchedCountries)
    self.locale = try values.decode(String.self, forKey: .locale)
    self.stripePublishableKey = try values
      .nestedContainer(keyedBy: CodingKeys.StripeCodingKeys.self, forKey: .stripe)
      .decode(String.self, forKey: .stripePublishableKey)
  }
}

extension Config: Equatable {}

/// Compares two `Config` snapshots across all experiment, feature-flag, country, and Stripe fields.
public func == (lhs: Config, rhs: Config) -> Bool {
  return lhs.abExperiments == rhs.abExperiments &&
    lhs.appId == rhs.appId &&
    lhs.applePayCountries == rhs.applePayCountries &&
    lhs.countryCode == rhs.countryCode &&
    lhs.features == rhs.features &&
    lhs.iTunesLink == rhs.iTunesLink &&
    lhs.launchedCountries == rhs.launchedCountries &&
    lhs.locale == rhs.locale &&
    lhs.stripePublishableKey == rhs.stripePublishableKey
}
