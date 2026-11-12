import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Strongly-typed pairing of a feature flag enum and its enabled state.
///
/// Negative Constraint: Do not pass raw string feature names; use typed `Feature` cases.
public struct FeatureEnabled: Equatable {
  /// Strongly-typed feature flag identifier.
  public let feature: Feature
  /// `true` when the feature flag is currently enabled.
  public let isEnabled: Bool

  /// Creates a typed `FeatureEnabled` contract.
  public init(feature: Feature, isEnabled: Bool) {
    self.feature = feature
    self.isEnabled = isEnabled
  }
}

/// Outputs emitted by `FeatureFlagToolsViewModel`.
public protocol FeatureFlagToolsViewModelOutputs {
  /// Emits notification signaling that configuration feature flags were updated.
  var postNotification: Signal<Notification, Never> { get }
  /// Emits known server `Feature` dictionaries sorted alphabetically for display.
  var reloadWithData: Signal<[Features], Never> { get }
  /// Emits mutated config feature dictionaries when a debug switch is toggled.
  var updateConfigWithFeatures: Signal<Features, Never> { get }
}

/// Inputs accepted by `FeatureFlagToolsViewModel`.
public protocol FeatureFlagToolsViewModelInputs {
  /// Signals that updated environment config values finished saving.
  func didUpdateConfig()
  /// Toggles the feature flag at row `index` in the server config list.
  func setFeatureAtIndexEnabled(index: Int, isEnabled: Bool)
  /// Signals that the feature flag debug screen has loaded.
  func viewDidLoad()
}

/// Interface combining inputs and outputs for `FeatureFlagToolsViewModel`.
public protocol FeatureFlagToolsViewModelType {
  /// Input receiver for config feature flag overrides.
  var inputs: FeatureFlagToolsViewModelInputs { get }
  /// Output signals driving config feature list rows and updates.
  var outputs: FeatureFlagToolsViewModelOutputs { get }
}

/// View model managing internal overrides for server-delivered `Feature` flags.
public final class FeatureFlagToolsViewModel: FeatureFlagToolsViewModelType, FeatureFlagToolsViewModelInputs,
  FeatureFlagToolsViewModelOutputs {
  /// Initializes the feature flag tools view model.
  public init() {
    let didUpdateConfigAndUI = self.didUpdateConfigProperty.signal
      .ksr_debounce(.seconds(1), on: AppEnvironment.current.scheduler)

    let features = Signal.merge(
      self.viewDidLoadProperty.signal,
      didUpdateConfigAndUI
    )
    .map { _ in AppEnvironment.current.config?.features }
    .skipNil()

    let sortedFeatures = features
      .map { features in Array(features)
        .filter { Feature(rawValue: $0.0) != nil }
        .sorted(by: { $0.0 < $1.0 })
      }

    self.reloadWithData = sortedFeatures.map { featureTuples in
      featureTuples.map { key, value in [key: value] }
    }

    self.updateConfigWithFeatures = sortedFeatures
      .takePairWhen(self.setFeatureEnabledAtIndexProperty.signal.skipNil())
      .map(unpack)
      .map { features, index, enabled -> Features? in
        guard features.count > index else {
          return nil
        }
        let featureEnabledPair = features[index]

        guard featureEnabledPair.value != enabled else {
          return nil
        }

        var environmentFeatures = AppEnvironment.current.config?.features
        environmentFeatures?[featureEnabledPair.key] = enabled

        return environmentFeatures
      }
      .skipNil()

    self.postNotification = self.didUpdateConfigProperty.signal
      .mapConst(Notification(name: .ksr_configUpdated, object: nil))
  }

  private let setFeatureEnabledAtIndexProperty = MutableProperty<(Int, Bool)?>(nil)
  /// Updates the enabled flag value for the feature at `index`.
  public func setFeatureAtIndexEnabled(index: Int, isEnabled: Bool) {
    self.setFeatureEnabledAtIndexProperty.value = (index, isEnabled)
  }

  private let didUpdateConfigProperty = MutableProperty(())
  /// Triggers reload notification after updating app config.
  public func didUpdateConfig() {
    self.didUpdateConfigProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the feature-flag tools view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits `.ksr_configUpdated` notification after config changes.
  public let postNotification: Signal<Notification, Never>
  /// Emits filtered feature-flag dictionaries to populate rows.
  public let reloadWithData: Signal<[Features], Never>
  /// Emits updated config dictionary when a toggle changes.
  public let updateConfigWithFeatures: Signal<Features, Never>

  /// Returns `self` as `FeatureFlagToolsViewModelInputs`.
  public var inputs: FeatureFlagToolsViewModelInputs { return self }
  /// Returns `self` as `FeatureFlagToolsViewModelOutputs`.
  public var outputs: FeatureFlagToolsViewModelOutputs { return self }
}

/// Converts raw `[Features]` flag dictionaries into typed `FeatureEnabled` entries, discarding unknown keys.
public func featureEnabledFromDictionaries(_ dictionaryArray: [Features]) -> [FeatureEnabled] {
  return dictionaryArray.compactMap { dictionary -> FeatureEnabled? in
    dictionary.compactMap { key, value in
      guard let feature = Feature(rawValue: key) else { return nil }
      return FeatureEnabled(feature: feature, isEnabled: value)
    }
    .first
  }
}
