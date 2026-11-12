/// An experiment to make the `Back this Project` button on the Project page load much faster.
public struct InstantPledgeButtonExperiment: StatsigExperimentProtocol {
  typealias ExperimentParameters = InstantPledgeButtonExperiment.Parameters

  /// Parameter keys configured on `instant_pledge_button_experiment`.
  public enum Parameters: String, CaseIterable {
    case instant_pledge_enabled
  }

  /// Statsig experiment name identifier.
  public var name: StatsigExperimentName {
    return .instant_pledge_button_experiment
  }

  /// Associated Statsig layer, or `nil` when unlayered.
  public var layer: StatsigExperimentLayer? {
    return nil
  }

  /// Creates an instance of `InstantPledgeButtonExperiment`.
  public init() {}
}
