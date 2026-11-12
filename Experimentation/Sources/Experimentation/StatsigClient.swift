internal import Statsig
import Foundation

/// Notification posted on `NotificationCenter.default` whenever Statsig finishes loading or reloading assignments.
public let StatsigLoadedNotification = NSNotification.Name("StatsigClientDataReloaded")

/// SDK keys in Statsig can be associated with "environment tiers" - development, staging or production.
/// The Statsig client needs to be initialized with the same tier that the SDK key supports.
///
/// See Statsig's documentation: https://docs.statsig.com/guides/using-environments
public enum StatsigClientSDKKey {
  /// An SDK key which will be sent to the Production tier of Statsig
  case productionTier(String)

  /// An SDK key which will be sent to the Staging tier of Statsig.
  case stagingTier(String)

  /// An SDK key which will be sent to the Development tier of Statsig.
  case developmentTier(String)
}

/// A thin wrapper around the Statsig class `StatsigClient`.
public final class StatsigWrapper: StatsigClientType {
  private let client: StatsigClient

  /// Initializes and starts `StatsigClient` using the given SDK key, environment tier, and initial user.
  public convenience init(sdkKey: StatsigClientSDKKey, user: StatsigClientUser) {
    let key: String
    let tier: StatsigEnvironment.EnvironmentTier

    switch sdkKey {
    case let .productionTier(prodKey):
      key = prodKey
      tier = .Production
    case let .stagingTier(stagingKey):
      key = stagingKey
      tier = .Staging
    case let .developmentTier(devKey):
      key = devKey
      tier = .Development
    }

    let client = StatsigClient(
      sdkKey: key,
      user: StatsigUser.from(user),
      options: StatsigOptions(environment: StatsigEnvironment(tier: tier))
    ) { error in
      if let error {
        debugPrint("Statsig reload error: \(error.localizedDescription)")
      } else {
        NotificationCenter.default.post(name: StatsigLoadedNotification, object: nil)
        debugPrint("Successfully reloaded Statsig")
      }
    }

    self.init(client: client)
  }

  init(client: StatsigClient) {
    self.client = client
  }

  /// Opens the interactive Statsig debug view.
  public func showDebugger() {
    self.client.openDebugView()
  }

  /// Updates the active user in Statsig and refreshes feature gate and experiment values.
  public func reload(withUser user: StatsigClientUser) {
    let user = StatsigUser.from(user)
    self.client.updateUserWithResult(user) { error in
      if let error {
        debugPrint("Statsig reload error: \(error.localizedDescription)")
      } else {
        NotificationCenter.default.post(name: StatsigLoadedNotification, object: nil)
        debugPrint("Successfully reloaded Statsig")
      }
    }
  }

  /// Checks whether the specified feature gate is enabled, or returns `nil` if Statsig is uninitialized.
  public func checkGate(for feature: StatsigFeature) -> Bool? {
    guard self.client.isInitialized() else {
      return nil
    }

    return self.client.checkGate(feature.rawValue)
  }

  /// Looks up a boolean experiment parameter, or returns `nil` if Statsig is uninitialized.
  public func boolValue<T: StatsigExperimentProtocol>(
    forKey key: T.Parameters,
    inExperiment experiment: T
  ) -> Bool? {
    guard self.client.isInitialized() else {
      return nil
    }

    if let layer = experiment.layer {
      return self.client
        .getLayer(layer.rawValue)
        .getValue(forKey: key.rawValue)
    }

    return self.client
      .getExperiment(experiment.name.rawValue)
      .getValue(forKey: key.rawValue)
  }
}

private extension StatsigUser {
  /// Create a `StatsigUser` (Statsig's model object) from a `StatsigClientUser` (our model object)
  static func from(_ clientUser: StatsigClientUser) -> StatsigUser {
    let ksrStringId = clientUser.ksrUserId != nil ? String(clientUser.ksrUserId!) : nil

    if let segmentId = clientUser.segmentAnonymousId {
      return StatsigUser(userID: ksrStringId, customIDs: ["segmentAnonymousID": segmentId])
    } else {
      return StatsigUser(userID: ksrStringId)
    }
  }
}
