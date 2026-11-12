import FirebaseCrashlytics
import Foundation
import KsApi
import Prelude

extension AppEnvironment {
  internal static let accountNameForKeychain = "kickstarter_currently_logged_in_user"

  private static func withKeychain<T>(defaultValue: T, _ body: () throws -> T) -> T {
    guard featureUseKeychainForOAuthTokenEnabled() else {
      return defaultValue
    }

    do {
      return try body()
    } catch let error as KeychainError {
      Crashlytics.crashlytics().record(error: error.nsError)
    } catch {
      Crashlytics.crashlytics().record(error: error)
    }

    return defaultValue
  }

  private static func makeService(
    serverConfig: ServerConfigType,
    oauthToken: OauthTokenAuthType?
  ) -> Service {
    Service(
      serverConfig: serverConfig,
      oauthToken: oauthToken,
      language: self.current.language.rawValue,
      currency: self.current.locale.currencyCode ?? "USD"
    )
  }

  /// Restores the last saved `Environment` from user defaults and Keychain storage.
  /// Returns an `Environment` with an authenticated user only when an OAuth token is present.
  public static func fromStorage(
    ubiquitousStore _: KeyValueStoreType,
    userDefaults: KeyValueStoreType
  ) -> Environment {
    let payload: StoredEnvironmentData = userDefaults.data(forKey: self.environmentStorageKey)
      .flatMap { try? JSONDecoder().decode(StoredEnvironmentData.self, from: $0) }
      ?? StoredEnvironmentData()

    var service = self.current.apiService
    var currentUser: User? // Will only be set if an OAuth token is also set
    var currentUserServerFeatures: [ServerFeature]? // Will only be set if an OAuth token is also set
    let config: Config? = payload.config

    // If there is an oauth token stored, then we can authenticate our api service
    let keychainToken: String? = self.withKeychain(defaultValue: nil) {
      try Keychain.fetchPassword(forAccount: self.accountNameForKeychain)
    }
    if let oauthToken = keychainToken ?? payload.oauthToken {
      service = service.login(OauthToken(token: oauthToken))
    }

    // Try restoring the client id for the api service
    if let clientId = payload.clientId {
      service = self.makeService(
        serverConfig: ServerConfig(
          apiBaseUrl: service.serverConfig.apiBaseUrl,
          webBaseUrl: service.serverConfig.webBaseUrl,
          apiClientAuth: ClientAuth(clientId: clientId),
          basicHTTPAuth: service.serverConfig.basicHTTPAuth,
          graphQLEndpointUrl: service.serverConfig.graphQLEndpointUrl
        ),
        oauthToken: service.oauthToken
      )
    }

    // Try restoring the base urls for the api service
    if let apiBaseUrlString = payload.apiBaseUrl,
       let apiBaseUrl = URL(string: apiBaseUrlString),
       let webBaseUrlString = payload.webBaseUrl,
       let webBaseUrl = URL(string: webBaseUrlString) {
      service = self.makeService(
        serverConfig: ServerConfig(
          apiBaseUrl: apiBaseUrl,
          webBaseUrl: webBaseUrl,
          apiClientAuth: service.serverConfig.apiClientAuth,
          basicHTTPAuth: service.serverConfig.basicHTTPAuth,
          graphQLEndpointUrl: service.serverConfig.graphQLEndpointUrl
        ),
        oauthToken: service.oauthToken
      )
    }

    // Try restoring the basic auth data for the api service
    if let username = payload.basicHTTPAuthUsername,
       let password = payload.basicHTTPAuthPassword {
      service = self.makeService(
        serverConfig: ServerConfig(
          apiBaseUrl: service.serverConfig.apiBaseUrl,
          webBaseUrl: service.serverConfig.webBaseUrl,
          apiClientAuth: service.serverConfig.apiClientAuth,
          basicHTTPAuth: BasicHTTPAuth(username: username, password: password),
          graphQLEndpointUrl: service.serverConfig.graphQLEndpointUrl
        ),
        oauthToken: service.oauthToken
      )
    }

    // Try restoring the environment
    if let environment = payload.environment,
       let environmentType = EnvironmentType(rawValue: environment) {
      service = self.makeService(
        serverConfig: ServerConfig.config(for: environmentType),
        oauthToken: service.oauthToken
      )
    }

    // Try restore the current user
    if service.oauthToken != nil {
      currentUser = payload.currentUser
      currentUserServerFeatures = payload.currentUserServerFeatureRawValues?
        .compactMap { ServerFeature(rawValue: $0) }
    }

    // Try restore the PPO settings
    let currentUserPPOSettings: PPOUserSettings? = payload.currentUserPPOSettings

    return Environment(
      apiService: service,
      config: config,
      currentUser: currentUser,
      currentUserPPOSettings: currentUserPPOSettings,
      currentUserServerFeatures: currentUserServerFeatures.flatMap(Set.init),
      ksrAnalytics: self.current.ksrAnalytics |> KSRAnalytics.lens.loggedInUser .~ currentUser |> KSRAnalytics
        .lens.appTrackingTransparency .~ self.current.appTrackingTransparency
    )
  }

  // Saves some key data for the current environment
  internal static func saveEnvironment(
    environment env: Environment = AppEnvironment.current,
    ubiquitousStore _: KeyValueStoreType,
    userDefaults: KeyValueStoreType
  ) {
    var payload = StoredEnvironmentData()

    if let oauthToken = env.apiService.oauthToken?.token {
      // Try to save to the keychain, but if that fails, save to user defaults
      let stored = self.withKeychain(defaultValue: false) {
        try Keychain.storePassword(oauthToken, forAccount: self.accountNameForKeychain)
        return true
      }
      if !stored {
        payload.oauthToken = oauthToken
      }
    } else {
      _ = self.withKeychain(defaultValue: false) {
        try Keychain.deletePassword(forAccount: self.accountNameForKeychain)
        return true
      }
    }

    payload.apiBaseUrl = env.apiService.serverConfig.apiBaseUrl.absoluteString
    payload.clientId = env.apiService.serverConfig.apiClientAuth.clientId
    payload.basicHTTPAuthUsername = env.apiService.serverConfig.basicHTTPAuth?.username
    payload.basicHTTPAuthPassword = env.apiService.serverConfig.basicHTTPAuth?.password
    payload.webBaseUrl = env.apiService.serverConfig.webBaseUrl.absoluteString
    payload.environment = env.apiService.serverConfig.environment.description
    payload.language = env.apiService.language
    payload.currency = env.apiService.currency
    payload.config = env.config
    payload.currentUser = env.currentUser
    payload.currentUserServerFeatureRawValues = env.currentUserServerFeatures?.map(\.rawValue)
    payload.currentUserPPOSettings = env.currentUserPPOSettings

    if let encoded = try? JSONEncoder().encode(payload) {
      userDefaults.set(encoded, forKey: self.environmentStorageKey)
    }
  }
}

private struct StoredEnvironmentData: Codable {
  var oauthToken: String?
  var apiBaseUrl: String?
  var clientId: String?
  var basicHTTPAuthUsername: String?
  var basicHTTPAuthPassword: String?
  var webBaseUrl: String?
  var environment: String?
  var language: String?
  var currency: String?
  var config: Config?
  var currentUser: User?
  var currentUserServerFeatureRawValues: [String]?
  var currentUserPPOSettings: PPOUserSettings?
}
