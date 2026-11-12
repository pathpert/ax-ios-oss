import FirebaseRemoteConfig
import Foundation

/// Contract defining `RemoteConfigClientType` capabilities and boundaries.
public protocol RemoteConfigClientType: AnyObject {
  func activate(completion: ((Bool, Error?) -> Void)?)
  func fetch(completionHandler: ((RemoteConfigFetchStatus, Error?) -> Void)?)
  func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?)
  func setDefaults(_ defaults: [String: NSObject]?)
  func addOnConfigUpdateListener(remoteConfigUpdateCompletion listener: @escaping (
    RemoteConfigUpdate?,
    Error?
  ) -> Void) -> ConfigUpdateListenerRegistration
  func configValue(forKey key: String?) -> RemoteConfigValue
}

extension RemoteConfigClientType {
  /// Returns all known `RemoteConfigFeature` flags defined in the client.
  public func allFeatures() -> [RemoteConfigFeature] {
    return RemoteConfigFeature.allCases
  }

  /// Returns `true` when `featureKey`'s boolean Remote Config value evaluates to `true`.
  public func isFeatureEnabled(featureKey: RemoteConfigFeature) -> Bool {
    self.configValue(forKey: featureKey.rawValue).boolValue == true
  }
}
