import Prelude

extension Project.RewardData {
  /// Functional optics namespace for `Project.RewardData`.
  public enum lens {
    /// Lens focusing on optional add-on rewards list.
    public static let addOns = Lens<Project.RewardData, [Reward]?>(
      view: { $0.addOns },
      set: { Project.RewardData(addOns: $0, rewards: $1.rewards) }
    )

    /// Lens focusing on primary project rewards list.
    public static let rewards = Lens<Project.RewardData, [Reward]>(
      view: { $0.rewards },
      set: { Project.RewardData(addOns: $1.addOns, rewards: $0) }
    )
  }
}
