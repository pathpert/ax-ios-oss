extension Project.Country: EncodableType {
  /// Serializes country and currency metadata into a legacy v1 parameter dictionary.
  /// - Negative Constraint: Do not use for GraphQL mutations; use typed GraphQL input structs.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["country"] = self.countryCode
    result["currency"] = self.currencyCode
    result["currency_symbol"] = self.currencySymbol
    result["currency_trailing_code"] = self.trailingCode
    return result
  }
}
