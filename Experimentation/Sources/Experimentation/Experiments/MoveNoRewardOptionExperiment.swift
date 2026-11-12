/// An experiment to move the 'Pledge without a reward' (aka No Reward) card in the Rewards carousel.
public struct MoveNoRewardOptionExperiment: StatsigExperimentProtocol {
  typealias ExperimentParameters = MoveNoRewardOptionExperiment.Parameters

  /// Parameter keys configured on `move_no_reward_option_ios`.
  public enum Parameters: String, CaseIterable {
    case show_no_reward_after_available_rewards
  }

  /// Statsig experiment name identifier.
  public var name: StatsigExperimentName {
    return .move_no_reward_option_ios
  }

  /// Associated Statsig layer (`.ios_checkout`).
  public var layer: StatsigExperimentLayer? {
    return .ios_checkout
  }

  /// Creates an instance of `MoveNoRewardOptionExperiment`.
  public init() {}
}
