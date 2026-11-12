/// Parameter keys defined for the A/A null validation experiment.
public enum NullExperimentParameters: String, CaseIterable {
  case test_parameter
}

/// This is an A/A experiment to test that our A/B testing infrastructure works correctly.
/// Nothing is actually changed by this experiment.
public struct NullExperimentWithUserID: StatsigExperimentProtocol {
  /// Parameter enum type for this experiment.
  public typealias Parameters = NullExperimentParameters

  /// Creates an instance of the logged-in A/A experiment descriptor.
  public init() {}

  /// Statsig experiment name for logged-in A/A validation.
  public var name: StatsigExperimentName {
    return .logged_in_aa_experiment
  }

  /// Associated Statsig layer, or `nil` when unlayered.
  public var layer: StatsigExperimentLayer? {
    return nil
  }
}

/// This is an A/A experiment to test that our A/B testing infrastructure works correctly.
/// Nothing is actually changed by this experiment.
public struct NullExperimentWithAnonymousID: StatsigExperimentProtocol {
  /// Parameter enum type for this experiment.
  public typealias Parameters = NullExperimentParameters

  /// Creates an instance of the logged-out A/A experiment descriptor.
  public init() {}

  /// Statsig experiment name for logged-out A/A validation.
  public var name: StatsigExperimentName {
    return .logged_out_aa_experiment
  }

  /// Associated Statsig layer, or `nil` when unlayered.
  public var layer: StatsigExperimentLayer? {
    return nil
  }
}
