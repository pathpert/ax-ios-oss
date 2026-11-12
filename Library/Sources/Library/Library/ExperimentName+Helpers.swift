import Foundation
import KsApi

/// `Experiment.Name` extensions declared in `ExperimentName+Helpers.swift`.
extension Experiment.Name {
  fileprivate func isEnabled(in environment: Environment = AppEnvironment.current) -> Bool {
    guard
      AppEnvironment.current.mainBundle.isRelease,
      let experiments = environment.config?.abExperiments else { return self.debugDefault }

    if let variant = experiments[self.rawValue] {
      return Experiment.Variant(rawValue: variant) == .experimental
    }

    return false
  }
}
