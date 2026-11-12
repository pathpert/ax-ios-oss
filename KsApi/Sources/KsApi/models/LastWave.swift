import Foundation

/// Represents the latest video/livestream wave metadata associated with a project.
///
/// Negative Constraint: Missing API fields fall back to `id = 0` and `active = false`.
public struct LastWave {
  /// Unique identifier of the wave; `0` when absent.
  public let id: Int
  /// `true` when the wave is currently live/active.
  public let active: Bool
}

extension LastWave: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case active
  }

  /// Decodes a `LastWave`, defaulting omitted keys safely.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.id = try values.decodeIfPresent(Int.self, forKey: .id) ?? 0
    self.active = try values.decodeIfPresent(Bool.self, forKey: .active) ?? false
  }
}
