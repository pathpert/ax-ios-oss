import Prelude

extension Config {
  /// Functional lenses for `Config`.
  public enum lens {
    private static func copy(
      _ config: Config,
      abExperiments: [String: String]? = nil,
      applePayCountries: [String]? = nil,
      countryCode: String? = nil,
      features: Features? = nil,
      launchedCountries: [Project.Country]? = nil,
      locale: String? = nil,
      stripePublishableKey: String? = nil
    ) -> Config {
      Config(
        abExperiments: abExperiments ?? config.abExperiments,
        appId: config.appId,
        applePayCountries: applePayCountries ?? config.applePayCountries,
        countryCode: countryCode ?? config.countryCode,
        features: features ?? config.features,
        iTunesLink: config.iTunesLink,
        launchedCountries: launchedCountries ?? config.launchedCountries,
        locale: locale ?? config.locale,
        stripePublishableKey: stripePublishableKey ?? config.stripePublishableKey
      )
    }

    /// Lens focusing on active server-supplied A/B experiment assignments.
    public static let abExperiments = Lens<Config, [String: String]>(
      view: { $0.abExperiments },
      set: { copy($1, abExperiments: $0) }
    )

    /// Lens focusing on ISO country codes supporting Apple Pay.
    public static let applePayCountries = Lens<Config, [String]>(
      view: { $0.applePayCountries },
      set: { copy($1, applePayCountries: $0) }
    )

    /// Lens focusing on the active ISO 3166-1 country code.
    public static let countryCode = Lens<Config, String>(
      view: { $0.countryCode },
      set: { copy($1, countryCode: $0) }
    )

    /// Lens focusing on legacy server feature-flag dictionary wrapper.
    public static let features = Lens<Config, Features>(
      view: { $0.features },
      set: { copy($1, features: $0) }
    )

    /// Lens focusing on the list of launched creator countries and currencies.
    public static let launchedCountries = Lens<Config, [Project.Country]>(
      view: { $0.launchedCountries },
      set: { copy($1, launchedCountries: $0) }
    )

    /// Lens focusing on the server-reported locale identifier.
    public static let locale = Lens<Config, String>(
      view: { $0.locale },
      set: { copy($1, locale: $0) }
    )

    /// Lens focusing on the Stripe publishable API key for checkout.
    public static let stripePublishableKey = Lens<Config, String>(
      view: { $0.stripePublishableKey },
      set: { copy($1, stripePublishableKey: $0) }
    )
  }
}
