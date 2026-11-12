/// A test experiment for Statsig, in a layer, defined as `ios_test_experiment_in_layer` in the console.
public struct iOSTestExperimentInLayer: StatsigExperimentProtocol {
  typealias ExperimentParameters = iOSTestExperimentInLayer.Parameters

  /// Parameter keys configured on `ios_test_experiment_in_layer`.
  public enum Parameters: String, CaseIterable {
    case test_parameter
  }

  /// Statsig experiment name identifier.
  public var name: StatsigExperimentName {
    return .ios_test_experiment_in_layer
  }

  /// Associated Statsig layer (`.ios_test_layer`).
  public var layer: StatsigExperimentLayer? {
    return .ios_test_layer
  }

  /// Creates an instance of `iOSTestExperimentInLayer`.
  public init() {}
}
