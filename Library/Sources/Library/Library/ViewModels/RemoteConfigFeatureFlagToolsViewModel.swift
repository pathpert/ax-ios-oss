import Experimentation
import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// List of Remote Config feature flags paired with their resolved boolean states.
public typealias RemoteConfigFeatures = [(RemoteConfigFeature, Bool)]
/// List of Statsig feature flags paired with their resolved boolean states.
public typealias StatsigFeatures = [(StatsigFeature, Bool)]

/// Outputs emitted by `RemoteConfigFeatureFlagToolsViewModel`.
public protocol RemoteConfigFeatureFlagToolsViewModelOutputs {
  /// Emits Remote Config feature flags whenever the debug list reloads.
  var reloadWithRemoteConfigData: Signal<RemoteConfigFeatures, Never> { get }
  /// Emits updated Remote Config feature flags after a toggle modifies UserDefaults.
  var updateUserDefaultsWithRemoteConfigFeatures: Signal<RemoteConfigFeatures, Never> { get }
  /// Emits Statsig feature flags whenever the debug list reloads.
  var reloadWithStatsigData: Signal<StatsigFeatures, Never> { get }
  /// Emits updated Statsig feature flags after a toggle modifies UserDefaults.
  var updateUserDefaultsWithStatsigFeatures: Signal<StatsigFeatures, Never> { get }
}

/// Inputs accepted by `RemoteConfigFeatureFlagToolsViewModel`.
public protocol RemoteConfigFeatureFlagToolsViewModelInputs {
  /// Notifies the view model that UserDefaults flag overrides changed externally.
  func didUpdateUserDefaults()
  /// Sets the local UserDefaults override for the Remote Config feature at `index`.
  func setFeatureAtIndexEnabled(index: Int, isEnabled: Bool)
  /// Sets the local UserDefaults override for the Statsig feature at `index`.
  func setStatsigFeatureAtIndexEnabled(index: Int, isEnabled: Bool)
  /// Signals that the feature-flag debug tool view has loaded.
  func viewDidLoad()
}

/// Interface combining inputs and outputs for `RemoteConfigFeatureFlagToolsViewModel`.
public protocol RemoteConfigFeatureFlagToolsViewModelType {
  /// Input receiver for feature-flag override interactions.
  var inputs: RemoteConfigFeatureFlagToolsViewModelInputs { get }
  /// Output signals driving Remote Config and Statsig debug rows.
  var outputs: RemoteConfigFeatureFlagToolsViewModelOutputs { get }
}

/// View model powering internal feature-flag inspection and override tools.
public final class RemoteConfigFeatureFlagToolsViewModel: RemoteConfigFeatureFlagToolsViewModelType,
  RemoteConfigFeatureFlagToolsViewModelInputs,
  RemoteConfigFeatureFlagToolsViewModelOutputs {
  /// Initializes the feature-flag tools view model.
  public init() {
    let didUpdateUserDefaultsAndUI = self.didUpdateUserDefaultsProperty.signal
      .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler)

    let features = Signal.merge(
      self.viewDidLoadProperty.signal,
      didUpdateUserDefaultsAndUI
    )

    let remoteConfigFeatures = features
      .map { _ in RemoteConfigFeature.allCases }
      .map { features in
        features.map { feature -> (RemoteConfigFeature, Bool) in
          (feature, isFeatureEnabled(feature))
        }
      }

    self.reloadWithRemoteConfigData = remoteConfigFeatures

    self.updateUserDefaultsWithRemoteConfigFeatures = remoteConfigFeatures
      .takePairWhen(self.setFeatureEnabledAtIndexProperty.signal.skipNil())
      .map(unpack)
      .map { features, index, isEnabled -> RemoteConfigFeatures? in
        let (feature, _) = features[index]
        var mutatedFeatures = features

        setValueInUserDefaults(for: feature, and: isEnabled)

        mutatedFeatures[index] = (feature, isEnabled)
        return mutatedFeatures
      }
      .skipNil()

    // MARK: Statsig

    let statsigFeatures = features
      .map { _ in StatsigFeature.allCases }
      .map { features in
        features.map { feature -> (StatsigFeature, Bool) in
          (feature, statsigFeatureEnabled(feature: feature))
        }
      }

    self.reloadWithStatsigData = statsigFeatures

    self.updateUserDefaultsWithStatsigFeatures = statsigFeatures
      .takePairWhen(self.setStatsigFeatureEnabledAtIndexProperty.signal.skipNil())
      .map(unpack)
      .map { features, index, isEnabled -> StatsigFeatures? in
        let (feature, _) = features[index]
        var mutatedFeatures = features

        setStatsigValueInUserDefaults(for: feature, and: isEnabled)

        mutatedFeatures[index] = (feature, isEnabled)
        return mutatedFeatures
      }
      .skipNil()
  }

  // MARK: - Inputs

  private let setFeatureEnabledAtIndexProperty = MutableProperty<(Int, Bool)?>(nil)
  /// Updates the enabled override for a Remote Config feature flag at `index`.
  public func setFeatureAtIndexEnabled(index: Int, isEnabled: Bool) {
    self.setFeatureEnabledAtIndexProperty.value = (index, isEnabled)
  }

  private let setStatsigFeatureEnabledAtIndexProperty = MutableProperty<(Int, Bool)?>(nil)
  /// Updates the enabled override for a Statsig feature flag at `index`.
  public func setStatsigFeatureAtIndexEnabled(index: Int, isEnabled: Bool) {
    self.setStatsigFeatureEnabledAtIndexProperty.value = (index, isEnabled)
  }

  private let didUpdateUserDefaultsProperty = MutableProperty(())
  /// Signals that feature-flag values in UserDefaults were updated.
  public func didUpdateUserDefaults() {
    self.didUpdateUserDefaultsProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the feature-flag tools view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  // MARK: - Outputs

  /// Emits current Remote Config flags and values.
  public let reloadWithRemoteConfigData: Signal<RemoteConfigFeatures, Never>
  /// Emits updated Remote Config flags after overriding UserDefaults.
  public let updateUserDefaultsWithRemoteConfigFeatures: Signal<RemoteConfigFeatures, Never>
  /// Emits current Statsig flags and values.
  public let reloadWithStatsigData: Signal<StatsigFeatures, Never>
  /// Emits updated Statsig flags after overriding UserDefaults.
  public let updateUserDefaultsWithStatsigFeatures: Signal<StatsigFeatures, Never>

  /// Returns `self` as `RemoteConfigFeatureFlagToolsViewModelInputs`.
  public var inputs: RemoteConfigFeatureFlagToolsViewModelInputs { return self }
  /// Returns `self` as `RemoteConfigFeatureFlagToolsViewModelOutputs`.
  public var outputs: RemoteConfigFeatureFlagToolsViewModelOutputs { return self }
}

// MARK: - Private Helpers (Remote Config)

private func isFeatureEnabled(_ feature: RemoteConfigFeature) -> Bool {
  return featureEnabled(feature: feature)
}

private func setValueInUserDefaults(for feature: RemoteConfigFeature, and value: Bool) {
  AppEnvironment.current.userDefaults
    .remoteConfigFeatureFlags[feature.rawValue] = value
}

// MARK: - Private Helpers (Statsig)

private func setStatsigValueInUserDefaults(for feature: StatsigFeature, and value: Bool) {
  AppEnvironment.current.userDefaults
    .statsigFeatureFlags[feature.rawValue] = value
}
