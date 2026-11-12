import FirebaseRemoteConfig
import Foundation

private class MockRemoteConfigValue: RemoteConfigValue {
  var bool = false

  override var boolValue: Bool { self.bool }
}

/// In-memory mock implementation of `RemoteConfigClientType` for unit tests and previews.
/// - Negative Constraint: Do not register in production `AppEnvironment`; use `RemoteConfigClient`.
public class MockRemoteConfigClient: RemoteConfigClientType {
  /// No-op stub simulating Firebase fetch-and-activate completion.
  public func fetchAndActivate(completionHandler _: (
    (RemoteConfigFetchAndActivateStatus, Error?)
      -> Void
  )?) {}

  /// Dictionary of feature flag keys to boolean values served by `configValue(forKey:)`.
  public var features: [String: Bool]

  /// Creates an empty mock remote config client with no flags enabled.
  public init() {
    self.features = [:]
  }

  /// No-op stub simulating remote config activation.
  public func activate(completion _: ((Bool, Error?) -> Void)?) {}

  /// Returns a synthetic `RemoteConfigValue` reflecting `features[key]`.
  public func configValue(forKey key: String?) -> RemoteConfigValue {
    let value = MockRemoteConfigValue()

    guard let keyValue = key else {
      return value
    }

    value.bool = self.features[keyValue] == true

    return value
  }

  /// No-op stub simulating remote config fetch.
  public func fetch(completionHandler _: ((RemoteConfigFetchStatus, Error?) -> Void)?) {}

  /// No-op stub simulating default parameter registration.
  public func setDefaults(_: [String: NSObject]?) {}

  /// Returns a dummy `ConfigUpdateListenerRegistration` without subscribing to Firebase updates.
  public func addOnConfigUpdateListener(remoteConfigUpdateCompletion _: @escaping (
    RemoteConfigUpdate?,
    Error?
  ) -> Void) -> ConfigUpdateListenerRegistration {
    return ConfigUpdateListenerRegistration()
  }
}
