import Prelude

extension RewardsItem {
  /// Functional optics namespace for `RewardsItem`.
  public enum lens {
    /// Lens focusing on rewards-item row `id`.
    public static let id = Lens<RewardsItem, Int>(
      view: { $0.id },
      set: { .init(id: $0, item: $1.item, quantity: $1.quantity, rewardId: $1.rewardId) }
    )

    /// Lens focusing on associated `Item`.
    public static let item = Lens<RewardsItem, Item>(
      view: { $0.item },
      set: { .init(id: $1.id, item: $0, quantity: $1.quantity, rewardId: $1.rewardId) }
    )

    /// Lens focusing on item `quantity`.
    public static let quantity = Lens<RewardsItem, Int>(
      view: { $0.quantity },
      set: { .init(id: $1.id, item: $1.item, quantity: $0, rewardId: $1.rewardId) }
    )

    /// Lens focusing on owning `rewardId`.
    public static let rewardId = Lens<RewardsItem, Int>(
      view: { $0.rewardId },
      set: { .init(id: $1.id, item: $1.item, quantity: $1.quantity, rewardId: $0) }
    )
  }
}
