import Experimentation
import FacebookCore
import Foundation
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// A global stack that captures the current state of global objects that the app wants access to.
public struct AppEnvironment: AppEnvironmentType {
  internal static let environmentStorageKey = "com.kickstarter.AppEnvironment.current"
  internal static let oauthTokenStorageKey = "com.kickstarter.AppEnvironment.oauthToken"

  /// A global stack of environments.
  fileprivate static var stack: [Environment] = [Environment()]

  /// Logs a user in by updating `apiService` with `envelope.accessToken`, storing `currentUser`, and updating analytics identity.
  /// - parameter envelope: Access token envelope containing the API access token and user model.
  public static func login(_ envelope: AccessTokenEnvelope) {
    self.replaceCurrentEnvironment(
      apiService: self.current.apiService.login(OauthToken(token: envelope.accessToken)),
      currentUser: envelope.user,
      ksrAnalytics: self.current.ksrAnalytics |> KSRAnalytics.lens.loggedInUser .~ envelope.user
    )
  }

  /// Replaces the current environment's `currentUser` and updates analytics user identity.
  /// - parameter user: Freshly fetched `User` model.
  public static func updateCurrentUser(_ user: User) {
    self.replaceCurrentEnvironment(
      currentUser: user,
      ksrAnalytics: self.current.ksrAnalytics |> KSRAnalytics.lens.loggedInUser .~ user
    )
  }

  /// Replaces the current environment's `currentUserEmail` with `email`.
  /// - parameter email: Updated account email address string.
  public static func updateCurrentUserEmail(_ email: String) {
    self.replaceCurrentEnvironment(
      currentUserEmail: email
    )
  }

  /// Replaces the set of cached server feature flags on the current environment.
  public static func updatecurrentUserServerFeatures(_ features: Set<ServerFeature>) {
    self.replaceCurrentEnvironment(
      currentUserServerFeatures: features
    )
  }

  /// Replaces the App Tracking Transparency helper on the current environment.
  public static func updateAppTrackingTransparency(_ appTrackingTransparency: AppTrackingTransparencyType) {
    self.replaceCurrentEnvironment(
      appTrackingTransparency: appTrackingTransparency
    )
  }

  /// Replaces debug override data on the current environment.
  public static func updateDebugData(_ debugData: DebugData) {
    self.replaceCurrentEnvironment(
      debugData: debugData
    )
  }

  /// Replaces the Remote Config client on the current environment.
  public static func updateRemoteConfigClient(_ remoteConfigClient: RemoteConfigClientType?) {
    self.replaceCurrentEnvironment(
      remoteConfigClient: remoteConfigClient
    )
  }

  /// Replaces the API service with one configured for `config`.
  public static func updateServerConfig(_ config: ServerConfigType) {
    let service = Service(serverConfig: config)

    self.replaceCurrentEnvironment(
      apiService: service
    )
  }

  // MARK: - Statsig

  /// Replaces the Statsig feature-flag client on the current environment.
  public static func updateStatsigClient(_ statsigClient: StatsigClientType?) {
    self.replaceCurrentEnvironment(
      statsigClient: statsigClient
    )
  }

  /// Applies `config` (or the active debug config override) and updates analytics and country code.
  public static func updateConfig(_ config: Config) {
    let debugConfigOrConfig = self.current.debugData?.config ?? config

    self.replaceCurrentEnvironment(
      config: debugConfigOrConfig,
      countryCode: debugConfigOrConfig.countryCode,
      ksrAnalytics: AppEnvironment.current.ksrAnalytics |> KSRAnalytics.lens.config .~ debugConfigOrConfig
    )
  }

  /// Updates the active display `Language` on the current environment.
  public static func updateLanguage(_ language: Language) {
    self.replaceCurrentEnvironment(language: language)
  }

  /// Configures the Facebook SDK with the given application and launch options.
  public static func configureFacebookSDK(
    appID: String?,
    application: UIApplication,
    launchOptions: [UIApplication.LaunchOptionsKey: Any]?
  ) {
    self.current.facebookSDK.configure(
      appID: appID,
      application: application,
      launchOptions: launchOptions
    )
  }

  /// Forwards an incoming URL open event to the Facebook SDK handler.
  public static func didFacebookSDKOpenURL(
    _ app: UIApplication,
    open url: URL,
    options: [UIApplication.OpenURLOptionsKey: Any] = [:]
  ) -> Bool {
    return self.current.facebookSDK.handleOpenURL(app, open: url, options: options)
  }

  /// Ends the user's session, clears cookies, resets analytics identity, and replaces the environment.
  public static func logout() {
    let storage = AppEnvironment.current.cookieStorage
    storage.cookies?.forEach(storage.deleteCookie)

    // Resetting the segment client and Statsig client
    AppEnvironment.current.identify(user: nil)

    self.replaceCurrentEnvironment(
      apiService: AppEnvironment.current.apiService.logout(),
      cache: type(of: AppEnvironment.current.cache).init(),
      currentUser: nil,
      currentUserEmail: nil,
      currentUserPPOSettings: nil,
      currentUserServerFeatures: nil,
      ksrAnalytics: self.current.ksrAnalytics |> KSRAnalytics.lens.loggedInUser .~ nil
    )
  }

  /// The most recent `Environment` on the stack. Must always remain non-empty.
  public static var current: Environment! {
    return stack.last
  }

  /// Pushes a new `Environment` onto the stack and persists it to storage.
  public static func pushEnvironment(_ env: Environment) {
    self.saveEnvironment(
      environment: env, ubiquitousStore: env.ubiquitousStore, userDefaults: env.userDefaults
    )
    self.stack.append(env)
  }

  /// Pops the top `Environment` off the stack, persists the new top environment, and returns the popped item.
  @discardableResult
  public static func popEnvironment() -> Environment? {
    let last = self.stack.popLast()
    let next = self.current ?? Environment()
    self.saveEnvironment(
      environment: next,
      ubiquitousStore: next.ubiquitousStore,
      userDefaults: next.userDefaults
    )

    // If there are no more items in the stack,
    // then the next call to AppEvironment.current will fail.
    assert(self.stack.count > 0)

    return last
  }

  internal static func resetStackForUnitTests() {
    while self.stack.count > 1 {
      _ = self.stack.popLast()
    }

    let next = Environment()
    self.replaceCurrentEnvironment(next)
  }

  /// Replaces the current `Environment` on top of the stack with `env`.
  public static func replaceCurrentEnvironment(_ env: Environment) {
    self.pushEnvironment(env)
    self.stack.remove(at: self.stack.count - 2)
  }
}
