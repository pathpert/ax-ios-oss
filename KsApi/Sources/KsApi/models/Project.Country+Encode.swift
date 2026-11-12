extension Project.Country: Encodable {
  /// Encodes country and currency metadata cleanly using `Codable` keys.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.countryCode, forKey: .countryCode)
    try container.encode(self.currencyCode, forKey: .currency)
    try container.encode(self.currencySymbol, forKey: .currencySymbol)
    try container.encode(self.trailingCode, forKey: .currencyTrailingCode)
    try container.encodeIfPresent(self.maxPledge, forKey: .maxPledge)
    try container.encodeIfPresent(self.minPledge, forKey: .minPledge)
  }
}
