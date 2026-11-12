/// A test experiment for Statsig, defined as `ios_test_experiment` in the console.
public struct iOSTestExperiment: StatsigExperimentProtocol {
  typealias ExperimentParameters = iOSTestExperiment.Parameters

  /// Parameter keys configured on `ios_test_experiment`.
  public enum Parameters: String, CaseIterable {
    case experiment_parameter_one
    case experiment_parameter_two
  }

  /// Statsig experiment name identifier.
  public var name: StatsigExperimentName {
    return .ios_test_experiment
  }

  /// Associated Statsig layer, or `nil` when unlayered.
  public var layer: StatsigExperimentLayer? {
    return nil
  }

  /// Creates an instance of `iOSTestExperiment`.
  public init() {}
}
