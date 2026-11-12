import KsApi

/// Return remote config values either a value from the cloud, if it found one, or an override value from user defaults.
func featureEnabled(feature: RemoteConfigFeature) -> Bool {
  if let valueFromDefaults = AppEnvironment.current.userDefaults
    .remoteConfigFeatureFlags[feature.rawValue] {
    return valueFromDefaults
  }

  if let valueFromRemoteConfig = AppEnvironment.current.remoteConfigClient?
    .isFeatureEnabled(featureKey: feature) {
    return valueFromRemoteConfig
  }

  return false
}

/// Returns `true` when Pledge Manager decision policy checks should be bypassed.
public func featureBypassPledgeManagerDecisionPolicyEnabled() -> Bool {
  return featureEnabled(feature: .bypassPledgeManagerDecisionPolicy)
}

/// Returns `true` when OAuth tokens should be persisted in the system Keychain rather than UserDefaults.
public func featureUseKeychainForOAuthTokenEnabled() -> Bool {
  featureEnabled(feature: .useKeychainForOAuthToken)
}

/// Returns `true` when the floating tab bar UI is enabled by remote config or debug overrides.
public func featureFloatingTabBarEnabled() -> Bool {
  featureEnabled(feature: .floatingTabBar)
}

/// Returns `true` when Pledged Projects Overview V2 is enabled.
public func featurePledgedProjectsOverviewV2Enabled() -> Bool {
  featureEnabled(feature: .pledgedProjectsOverviewV2Enabled)
}

/// Returns `true` when Pledged Projects Overview V4 is enabled.
public func featurePledgedProjectsOverviewV4Enabled() -> Bool {
  featureEnabled(feature: .pledgedProjectsOverviewV4Enabled)
}
