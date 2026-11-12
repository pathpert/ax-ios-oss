

/// Physical or digital item bundled within a `Reward` via `RewardsItem`.
public struct Item {
  /// Optional creator-supplied description of the item.
  public let description: String?
  /// Numeric identifier of the item.
  public let id: Int
  /// Display name of the item.
  public let name: String
  /// Identifier of the project that owns this item.
  public let projectId: Int
}

extension Item: Decodable {
  enum CodingKeys: String, CodingKey {
    case description
    case id
    case name
    case projectId = "project_id"
  }
}
