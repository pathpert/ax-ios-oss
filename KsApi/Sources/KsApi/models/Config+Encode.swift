extension Config: EncodableType {
  /// Serializes remote configuration state into a legacy dictionary payload for caching or v1 requests.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["ab_experiments"] = self.abExperiments
    result["app_id"] = self.appId
    result["apple_pay_countries"] = self.applePayCountries
    result["country_code"] = self.countryCode
    result["features"] = self.features
    result["itunes_link"] = self.iTunesLink
    result["launched_countries"] = self.launchedCountries.map { $0.encode() }
    result["locale"] = self.locale
    result["stripe"] = ["publishable_key": self.stripePublishableKey]
    return result
  }
}
