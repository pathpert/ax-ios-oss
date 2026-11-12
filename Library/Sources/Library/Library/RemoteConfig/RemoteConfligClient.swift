import FirebaseRemoteConfig

/// Live Firebase Remote Config adapter conforming to `RemoteConfigClientType`.
/// - Negative Constraint: Do not instantiate multiple independent instances in production; share via `AppEnvironment`.
public class RemoteConfigClient: RemoteConfigClientType {
  /// Fetches and activates latest remote config parameters asynchronously.
  public func fetchAndActivate(completionHandler: ((RemoteConfigFetchAndActivateStatus, Error?) -> Void)?) {
    self.sharedClient.fetchAndActivate(completionHandler: completionHandler)
  }

  private var sharedClient: RemoteConfig

  /// Wraps a configured Firebase `RemoteConfig` instance.
  public init(with client: RemoteConfig) {
    self.sharedClient = client
  }

  /// Activates previously fetched remote config values.
  public func activate(completion: ((Bool, Error?) -> Void)?) {
    self.sharedClient.activate(completion: completion)
  }

  /// Fetches remote config values from Firebase without activating them immediately.
  public func fetch(completionHandler: ((RemoteConfigFetchStatus, Error?) -> Void)?) {
    self.sharedClient.fetch(completionHandler: completionHandler)
  }

  /// Registers in-app fallback defaults for remote config parameters.
  public func setDefaults(_ defaults: [String: NSObject]?) {
    self.sharedClient.setDefaults(defaults)
  }

  /// Registers a real-time config update listener on Firebase Remote Config.
  public func addOnConfigUpdateListener(remoteConfigUpdateCompletion listener: @escaping (
    RemoteConfigUpdate?,
    Error?
  ) -> Void) -> ConfigUpdateListenerRegistration {
    self.sharedClient.addOnConfigUpdateListener(remoteConfigUpdateCompletion: listener)
  }

  /// Returns the resolved `RemoteConfigValue` for `key`.
  public func configValue(forKey key: String?) -> RemoteConfigValue {
    self.sharedClient.configValue(forKey: key)
  }
}
