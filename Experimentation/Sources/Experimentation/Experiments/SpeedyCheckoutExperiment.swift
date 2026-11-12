/// An experiment to make pages in the pledge flow load much faster.
public struct SpeedyCheckoutExperiment: StatsigExperimentProtocol {
  typealias ExperimentParameters = SpeedyCheckoutExperiment.Parameters

  /// Parameter keys configured on `speedy_checkout_experiment`.
  public enum Parameters: String, CaseIterable {
    case speedy_checkout_enabled
  }

  /// Statsig experiment name identifier.
  public var name: StatsigExperimentName {
    return .speedy_checkout_experiment
  }

  /// Associated Statsig layer, or `nil` when unlayered.
  public var layer: StatsigExperimentLayer? {
    return nil
  }

  /// Creates an instance of `SpeedyCheckoutExperiment`.
  public init() {}
}
