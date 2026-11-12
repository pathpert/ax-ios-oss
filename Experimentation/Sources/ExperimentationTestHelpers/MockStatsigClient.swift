import Experimentation
import Foundation

/// In-memory mock implementation of `StatsigClientType` for unit tests.
public final class MockStatsigWrapper: StatsigClientType {
  /// Dictionary of feature gate overrides keyed by `StatsigFeature`.
  public var features: [StatsigFeature: Bool] = [:]

  // Set experiments by calling overrideExperiment(_,withMock:)
  // This array is more like [String: MockExperiment<some StatsigExperimentProtocol>],
  // but the type system doesn't like undefined generics in a container - so we get AnyObject.
  private var experiments: [String: AnyObject] = [:]

  /// Creates an empty mock Statsig wrapper.
  public init() {}

  /// No-op test stub for `initialize(withUser:)`.
  public func initialize(withUser _: StatsigClientUser) {}

  /// No-op test stub for `reload(withUser:)`.
  public func reload(withUser _: StatsigClientUser) {}

  /// No-op test stub for `showDebugger()`.
  public func showDebugger() {}

  /// Returns the mocked boolean override for the given feature gate, if configured.
  public func checkGate(for feature: StatsigFeature) -> Bool? {
    self.features[feature]
  }

  /// Set mock values for an experiment using MockStatsigExperiment.
  public func overrideExperiment<T: StatsigExperimentProtocol>(
    _ experiment: T,
    withMock mock: MockExperiment<T>
  ) {
    self.experiments[experiment.name.rawValue] = mock as AnyObject
  }

  /// Returns the mocked boolean parameter value for an overridden experiment, if present.
  public func boolValue<T: StatsigExperimentProtocol>(
    forKey key: T.Parameters,
    inExperiment experiment: T
  ) -> Bool? {
    guard let mockExperiment = self.experiments[experiment.name.rawValue] as? MockExperiment<T>
    else {
      return nil
    }

    return mockExperiment.boolValue(forKey: key)
  }
}

/// Allows us to mock a Statsig experiment for testing purposes.
///
/// Example usage:
/// ```swift
/// MockExperiment<iOSTestExperiment> = MockExperiment([
///   .test_parameter_one: true
/// ])
/// ```
public struct MockExperiment<T> where T: StatsigExperimentProtocol {
  private let parameters: [T.Parameters: Bool]

  /// Initializes a mock experiment with explicit boolean parameter values.
  public init(_ parameters: [T.Parameters: Bool]) {
    self.parameters = parameters
  }

  func boolValue(forKey key: T.Parameters) -> Bool? {
    return self.parameters[key]
  }
}
