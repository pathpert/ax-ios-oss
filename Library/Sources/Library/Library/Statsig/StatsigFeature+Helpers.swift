import Experimentation
import KsApi

/// Returns the value for a given Statsig feature flag. User defaults are checked first and,
/// if a value is found, it is returned immediately as an "override" (e.g. via beta tools).
/// Otherwise, the value from the Statsig client is used, falling back to
/// `false` if neither place has a value.
public func statsigFeatureEnabled(feature: StatsigFeature) -> Bool {
  if let valueFromDefaults = AppEnvironment.current.userDefaults
    .statsigFeatureFlags[feature.rawValue] {
    return valueFromDefaults
  }

  if let valueFromStatsig = AppEnvironment.current.statsigClient?
    .isFeatureEnabled(featureKey: feature) {
    return valueFromStatsig
  }

  return false
}

/// Returns whether the project story rich text feature is enabled for the current user.
public func featureProjectStoryRichTextEnabled() -> Bool {
  statsigFeatureEnabled(feature: .projectStoryRichText)
}

/// Returns whether the video feed feature is enabled for the current user.
public func featureVideoFeedEnabled() -> Bool {
  statsigFeatureEnabled(feature: .videoFeed)
}

extension StatsigClientType {
  /// Returns all known `StatsigFeature` gates defined in the client.
  public func allFeatures() -> [StatsigFeature] {
    return StatsigFeature.allCases
  }

  /// Checks whether the given Statsig feature gate `key` is enabled for the active environment's client.
  public func isFeatureEnabled(featureKey key: StatsigFeature) -> Bool {
    AppEnvironment.current.statsigClient?.checkGate(for: key) == true
  }
}
