import Foundation

/// Persistent preference keys stored in `UserDefaults` / `NSUbiquitousKeyValueStore`.
///
/// Negative Constraint: Prefer `LocalStorageController` typed schemas for new feature flags and preferences.
public enum AppKeys: String {
  // swiftformat:disable wrap
  case closedFacebookConnectInActivity = "com.kickstarter.KeyValueStoreType.closedFacebookConnectInActivity"
  case closedFindFriendsInActivity = "com.kickstarter.KeyValueStoreType.closedFindFriendsInActivity"
  case deniedNotificationContexts = "com.kickstarter.KeyValueStoreType.deniedNotificationContexts"
  case favoriteCategoryIds = "favorite_category_ids"
  case hasCompletedCategoryPersonalizationFlow = "com.kickstarter.KeyValueStoreType.hasCompletedCategoryPersonalizationFlow"
  case hasDismissedPersonalizationCard = "com.kickstarter.KeyValueStoreType.hasDismissedPersonalizationCard"
  case hasSeenFavoriteCategoryAlert = "com.kickstarter.KeyValueStoreType.hasSeenFavoriteCategoryAlert"
  case hasSeenOnboarding = "com.kickstarter.KeyValueStoreType.hasSeenOnboarding"
  case hasSeenSaveProjectAlert = "com.kickstarter.KeyValueStoreType.hasSeenSaveProjectAlert"
  case lastSeenActivitySampleId = "com.kickstarter.KeyValueStoreType.lastSeenActivitySampleId"
  case onboardingCategories = "com.kickstarter.KeyValueStoreType.onboardingCategories"
  case remoteConfigFeatureFlags = "com.kickstarter.KeyValueStoreType.remoteConfigFeatureFlags"
  case seenAppRating = "com.kickstarter.KeyValueStoreType.hasSeenAppRating"
  case seenGamesNewsletter = "com.kickstarter.KeyValueStoreType.hasSeenGamesNewsletter"
  case statsigFeatureFlags = "com.kickstarter.KeyValueStoreType.statsigFeatureFlags"
  // swiftformat:enable wrap
}

/// @deprecated Legacy key-value store abstraction.
/// Prefer `UpdateFavoriteCategoriesRequestSchema` and `LocalStorageController` in `Library/modules/local_storage`.
public protocol KeyValueStoreType: AnyObject {
  func set(_ value: Bool, forKey defaultName: String)
  func set(_ value: Int, forKey defaultName: String)
  func set(_ value: Any?, forKey defaultName: String)

  func bool(forKey defaultName: String) -> Bool
  func data(forKey defaultName: String) -> Data?
  func integer(forKey defaultName: String) -> Int
  func object(forKey defaultName: String) -> Any?
  func string(forKey defaultName: String) -> String?
  func synchronize() -> Bool

  func removeObject(forKey defaultName: String)
  var deniedNotificationContexts: [String] { get set }
  var favoriteCategoryIds: [Int] { get set }
  var hasClosedFacebookConnectInActivity: Bool { get set }
  var hasClosedFindFriendsInActivity: Bool { get set }
  var hasCompletedCategoryPersonalizationFlow: Bool { get set }
  var hasDismissedPersonalizationCard: Bool { get set }
  var hasSeenAppRating: Bool { get set }
  var hasSeenFavoriteCategoryAlert: Bool { get set }
  var hasSeenGamesNewsletterPrompt: Bool { get set }
  var hasSeenOnboarding: Bool { get set }
  var hasSeenSaveProjectAlert: Bool { get set }
  var lastSeenActivitySampleId: Int { get set }
  var onboardingCategories: Data? { get set }
  var remoteConfigFeatureFlags: [String: Bool] { get set }
  var statsigFeatureFlags: [String: Bool] { get set }
}

extension KeyValueStoreType {
  /// Array of category integer IDs favorited by the user.
  public var favoriteCategoryIds: [Int] {
    get {
      return self.object(forKey: AppKeys.favoriteCategoryIds.rawValue) as? [Int] ?? []
    }
    set {
      self.set(newValue, forKey: AppKeys.favoriteCategoryIds.rawValue)
    }
  }

  /// Identifiers of notification permission prompt contexts dismissed or denied by the user.
  public var deniedNotificationContexts: [String] {
    get {
      return self.object(forKey: AppKeys.deniedNotificationContexts.rawValue) as? [String] ?? []
    }
    set {
      self.set(newValue, forKey: AppKeys.deniedNotificationContexts.rawValue)
    }
  }

  /// Whether the user has dismissed the discovery personalization prompt card.
  public var hasDismissedPersonalizationCard: Bool {
    get {
      return self.bool(forKey: AppKeys.hasDismissedPersonalizationCard.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.hasDismissedPersonalizationCard.rawValue)
    }
  }

  /// Whether the user completed the category personalization onboarding flow.
  public var hasCompletedCategoryPersonalizationFlow: Bool {
    get {
      return self.bool(forKey: AppKeys.hasCompletedCategoryPersonalizationFlow.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.hasCompletedCategoryPersonalizationFlow.rawValue)
    }
  }

  /// Whether the Facebook Connect banner in Activity was closed.
  public var hasClosedFacebookConnectInActivity: Bool {
    get {
      return self.object(forKey: AppKeys.closedFacebookConnectInActivity.rawValue) as? Bool ?? false
    }
    set {
      self.set(newValue, forKey: AppKeys.closedFacebookConnectInActivity.rawValue)
    }
  }

  /// Whether the Find Friends banner in Activity was closed.
  public var hasClosedFindFriendsInActivity: Bool {
    get {
      return self.object(forKey: AppKeys.closedFindFriendsInActivity.rawValue) as? Bool ?? false
    }
    set {
      self.set(newValue, forKey: AppKeys.closedFindFriendsInActivity.rawValue)
    }
  }

  /// Whether the app rating prompt has already been displayed.
  public var hasSeenAppRating: Bool {
    get {
      return self.bool(forKey: AppKeys.seenAppRating.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.seenAppRating.rawValue)
    }
  }

  /// Whether the favorite category explainer alert has been shown.
  public var hasSeenFavoriteCategoryAlert: Bool {
    get {
      return self.bool(forKey: AppKeys.hasSeenFavoriteCategoryAlert.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.hasSeenFavoriteCategoryAlert.rawValue)
    }
  }

  /// Whether the Kickstarter Games newsletter prompt was shown.
  public var hasSeenGamesNewsletterPrompt: Bool {
    get {
      return self.bool(forKey: AppKeys.seenGamesNewsletter.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.seenGamesNewsletter.rawValue)
    }
  }

  /// Whether the initial app onboarding flow has been seen.
  public var hasSeenOnboarding: Bool {
    get {
      return self.bool(forKey: AppKeys.hasSeenOnboarding.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.hasSeenOnboarding.rawValue)
    }
  }

  /// Whether the save/watch project confirmation alert has been shown.
  public var hasSeenSaveProjectAlert: Bool {
    get {
      return self.bool(forKey: AppKeys.hasSeenSaveProjectAlert.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.hasSeenSaveProjectAlert.rawValue)
    }
  }

  /// Identifier of the last activity sample item rendered to avoid duplicate prompts.
  public var lastSeenActivitySampleId: Int {
    get {
      return self.integer(forKey: AppKeys.lastSeenActivitySampleId.rawValue)
    }
    set {
      self.set(newValue, forKey: AppKeys.lastSeenActivitySampleId.rawValue)
    }
  }

  /// Serialized JSON `Data` of selected onboarding categories.
  public var onboardingCategories: Data? {
    get {
      return self.data(forKey: AppKeys.onboardingCategories.rawValue)
    }

    set {
      self.set(newValue, forKey: AppKeys.onboardingCategories.rawValue)
    }
  }

  /// Cached Remote Config boolean overrides keyed by feature identifier.
  public var remoteConfigFeatureFlags: [String: Bool] {
    get {
      return self
        .object(forKey: AppKeys.remoteConfigFeatureFlags.rawValue) as? [String: Bool] ?? [:]
    }
    set {
      self.set(newValue, forKey: AppKeys.remoteConfigFeatureFlags.rawValue)
    }
  }

  /// Cached Statsig feature gate overrides keyed by feature identifier.
  public var statsigFeatureFlags: [String: Bool] {
    get {
      return self
        .object(forKey: AppKeys.statsigFeatureFlags.rawValue) as? [String: Bool] ?? [:]
    }
    set {
      self.set(newValue, forKey: AppKeys.statsigFeatureFlags.rawValue)
    }
  }
}

extension UserDefaults: KeyValueStoreType {}

extension NSUbiquitousKeyValueStore: KeyValueStoreType {
  /// Reads an `Int` bridged via `longLong(forKey:)` from iCloud key-value storage.
  public func integer(forKey defaultName: String) -> Int {
    return Int(longLong(forKey: defaultName))
  }

  /// Writes an `Int` bridged as `Int64` to iCloud key-value storage.
  public func set(_ value: Int, forKey defaultName: String) {
    return self.set(Int64(value), forKey: defaultName)
  }
}

private struct MockStoreBox {
  let value: Any
}

internal class MockKeyValueStore: KeyValueStoreType {
  private var store: [String: MockStoreBox] = [:]

  func set(_ value: Bool, forKey defaultName: String) {
    self.store[defaultName] = MockStoreBox(value: value)
  }

  func set(_ value: Int, forKey defaultName: String) {
    self.store[defaultName] = MockStoreBox(value: value)
  }

  func set(_ value: Any?, forKey key: String) {
    self.store[key] = value.map(MockStoreBox.init)
  }

  func bool(forKey defaultName: String) -> Bool {
    return self.store[defaultName]?.value as? Bool ?? false
  }

  func data(forKey defaultName: String) -> Data? {
    return self.store[defaultName]?.value as? Data
  }

  func integer(forKey defaultName: String) -> Int {
    return self.store[defaultName]?.value as? Int ?? 0
  }

  func object(forKey key: String) -> Any? {
    return self.store[key]?.value
  }

  func string(forKey defaultName: String) -> String? {
    return self.store[defaultName]?.value as? String
  }

  func removeObject(forKey defaultName: String) {
    self.set(nil, forKey: defaultName)
  }

  func synchronize() -> Bool {
    return true
  }
}
