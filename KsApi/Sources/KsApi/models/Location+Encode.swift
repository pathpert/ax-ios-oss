extension Location: EncodableType {
  /// Serializes location metadata to a legacy dictionary payload using snake_case v1 keys.
  /// - Negative Constraint: Do not use in GraphQL mutations.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["country"] = self.country
    result["displayable_name"] = self.displayableName
    result["id"] = self.id
    result["localized_name"] = self.localizedName
    result["name"] = self.name
    return result
  }
}
