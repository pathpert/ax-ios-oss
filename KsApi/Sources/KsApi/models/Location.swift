/// Geographic location metadata associated with projects, discovery filters, and shipping rules.
public struct Location {
  /// ISO 3166-1 alpha-2 country code (e.g., `"US"`).
  public let country: String
  /// Formatted city/region label suitable for UI display (e.g., `"Brooklyn, NY"`).
  public let displayableName: String
  /// Numeric location identifier (uses `-42` for the synthetic `Location.none` sentinel).
  public let id: Int
  /// Localized name matching the API request locale.
  public let localizedName: String
  /// Canonical place name.
  public let name: String

  /// Sentinel value representing "anywhere" / no geographic filter in discovery queries.
  public static let none = Location(country: "", displayableName: "", id: -42, localizedName: "", name: "")
}

extension Location: Codable {
  enum CodingKeys: String, CodingKey {
    case country
    case displayableName = "displayable_name"
    case id
    case localizedName = "localized_name"
    case name
  }

  /// Decodes a `Location` from REST API `snake_case` keys.
  ///
  /// Negative Constraint: Do not pass GraphQL global-node strings directly; use `Location.location(from:)`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.country = try values.decode(String.self, forKey: .country)
    self.displayableName = try values.decode(String.self, forKey: .displayableName)
    self.id = try values.decode(Int.self, forKey: .id)
    self.localizedName = try values.decode(String.self, forKey: .localizedName)
    self.name = try values.decode(String.self, forKey: .name)
  }
}

extension Location: Equatable {}
/// Compares two `Location` instances by their integer `id`.
public func == (lhs: Location, rhs: Location) -> Bool {
  return lhs.id == rhs.id
}

extension Location: GraphIDBridging {
  /// GraphQL global node type name (`"Location"`).
  public static var modelName: String {
    return "Location"
  }
}
