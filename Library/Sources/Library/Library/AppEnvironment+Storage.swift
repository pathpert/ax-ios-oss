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
    let data = userDefaults.dictionary(forKey: self.environmentStorageKey) ?? [:]

    var service = self.current.apiService
    var currentUser: User? // Will only be set if an OAuth token is also set
    var currentUserServerFeatures: [ServerFeature]? // Will only be set if an OAuth token is also set
    let config: Config? = data["config"].flatMap(Config.decodeJSONDictionary)

    // If there is an oauth token stored, then we can authenticate our api service
    let keychainToken: String? = self.withKeychain(defaultValue: nil) {
      try Keychain.fetchPassword(forAccount: self.accountNameForKeychain)
    }
    if let oauthToken = keychainToken ?? (data["apiService.oauthToken.token"] as? String) {
      service = service.login(OauthToken(token: oauthToken))
    }

    // Try restoring the client id for the api service
    if let clientId = data["apiService.serverConfig.apiClientAuth.clientId"] as? String {
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
    if let apiBaseUrlString = data["apiService.serverConfig.apiBaseUrl"] as? String,
       let apiBaseUrl = URL(string: apiBaseUrlString),
       let webBaseUrlString = data["apiService.serverConfig.webBaseUrl"] as? String,
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
    if let username = data["apiService.serverConfig.basicHTTPAuth.username"] as? String,
       let password = data["apiService.serverConfig.basicHTTPAuth.password"] as? String {
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
    if let environment = data["apiService.serverConfig.environment"] as? String,
       let environmentType = EnvironmentType(rawValue: environment) {
      service = self.makeService(
        serverConfig: ServerConfig.config(for: environmentType),
        oauthToken: service.oauthToken
      )
    }

    // Try restore the current user
    if service.oauthToken != nil {
      currentUser = data["currentUser"].flatMap(tryDecode)
      currentUserServerFeatures = (data["currentUserServerFeatures"] as? [String])?
        .compactMap { ServerFeature(rawValue: $0) }
    }

    // Try restore the PPO settings
    let currentUserPPOSettings: PPOUserSettings? = data["currentUserPPOSettings"].flatMap(tryDecode)

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
    var data: [String: Any] = [:]

    // swiftformat:disable wrap
    if let oauthToken = env.apiService.oauthToken?.token {
      // Try to save to the keychain, but if that fails, save to user defaults
      let stored = self.withKeychain(defaultValue: false) {
        try Keychain.storePassword(oauthToken, forAccount: self.accountNameForKeychain)
        return true
      }
      if !stored {
        data["apiService.oauthToken.token"] = oauthToken
      }
    } else {
      _ = self.withKeychain(defaultValue: false) {
        try Keychain.deletePassword(forAccount: self.accountNameForKeychain)
        return true
      }
    }

    data["apiService.serverConfig.apiBaseUrl"] = env.apiService.serverConfig.apiBaseUrl.absoluteString
    data["apiService.serverConfig.apiClientAuth.clientId"] = env.apiService.serverConfig.apiClientAuth.clientId
    data["apiService.serverConfig.basicHTTPAuth.username"] = env.apiService.serverConfig.basicHTTPAuth?.username
    data["apiService.serverConfig.basicHTTPAuth.password"] = env.apiService.serverConfig.basicHTTPAuth?.password
    data["apiService.serverConfig.webBaseUrl"] = env.apiService.serverConfig.webBaseUrl.absoluteString
    data["apiService.serverConfig.environment"] = env.apiService.serverConfig.environment.description
    data["apiService.language"] = env.apiService.language
    data["apiService.currency"] = env.apiService.currency
    data["config"] = env.config?.encode()
    data["currentUser"] = env.currentUser?.encode()
    data["currentUserServerFeatures"] = env.currentUserServerFeatures?.map { $0.rawValue }
    data["currentUserPPOSettings"] = env.currentUserPPOSettings?.encode()
    // swiftformat:enable wrap

    userDefaults.set(data, forKey: self.environmentStorageKey)
  }
}
