

/// Join model associating an `Item` and quantity with a `Reward`.
public struct RewardsItem {
  /// Identifier of the reward-item relationship.
  public let id: Int
  /// Bundled `Item` details.
  public let item: Item
  /// Quantity of `item` included in the reward.
  public let quantity: Int
  /// Identifier of the parent `Reward`.
  public let rewardId: Int
}

extension RewardsItem: Decodable {
  enum CodingKeys: String, CodingKey {
    case id
    case item
    case quantity
    case rewardId = "reward_id"
  }
}
