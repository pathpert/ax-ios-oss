extension Config: Encodable {
  /// Encodes remote configuration state for `Codable` persistence and typed request payloads.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.abExperiments, forKey: .abExperiments)
    try container.encode(self.appId, forKey: .appId)
    try container.encode(self.applePayCountries, forKey: .applePayCountries)
    try container.encode(self.countryCode, forKey: .countryCode)
    try container.encode(self.features, forKey: .features)
    try container.encode(self.iTunesLink, forKey: .iTunesLink)
    try container.encode(self.launchedCountries, forKey: .launchedCountries)
    try container.encode(self.locale, forKey: .locale)
    var stripeContainer = container.nestedContainer(
      keyedBy: CodingKeys.StripeCodingKeys.self,
      forKey: .stripe
    )
    try stripeContainer.encode(self.stripePublishableKey, forKey: .stripePublishableKey)
  }
}
