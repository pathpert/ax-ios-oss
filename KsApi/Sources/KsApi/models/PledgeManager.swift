import Foundation

/// Post-campaign pledge manager configuration attached to a `Project`.
public struct PledgeManager {
  /// Numeric identifier of the pledge manager configuration.
  public let id: Int
  /// Whether the pledge manager accepts late backers who did not pledge during the live campaign.
  public let acceptsNewBackers: Bool
}

extension PledgeManager: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case acceptsNewBackers
  }

  /// Decodes `PledgeManager` fields, defaulting absent values to safe sentinel defaults (`0` / `false`).
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
    self.acceptsNewBackers = try values.decodeIfPresent(Bool.self, forKey: .acceptsNewBackers) ?? false
  }
}
