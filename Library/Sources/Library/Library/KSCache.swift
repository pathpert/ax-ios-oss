import Foundation

/// Thread-safe in-memory object cache backed by `NSCache` for transient session state.
/// - Negative Constraint: Do not store persistent credentials or durable settings here; use `LocalStorageController` or `KeyValueStoreType`.
public final class KSCache {
  private let cache = NSCache<NSString, AnyObject>()

  /// Cache key storing friend-follow state for the activity feed.
  public static let ksr_activityFriendsFollowing = "activity_friend_follow_view_model"
  /// Cache key storing fetched root discovery filter categories.
  public static let ksr_discoveryFiltersCategories = "discovery_filters_view_model_root_categories"
  /// Cache key storing friend-follow state for the Find Friends screen.
  public static let ksr_findFriendsFollowing = "find_friends_follow_view_model"
  /// Cache key tracking whether message threads have unread replies.
  public static let ksr_messageThreadHasUnreadMessages = "message_thread_has_unread_messages"
  /// Cache key storing local watched/starred project toggles.
  public static let ksr_projectSaved = "project_saved"

  /// Creates an empty in-memory `KSCache`.
  public init() {}

  /// Gets, sets, or removes (`nil`) an untyped cached object for `key`.
  public subscript(key: String) -> Any? {
    get {
      return self.cache.object(forKey: key as NSString)
    }
    set {
      if let newValue = newValue {
        self.cache.setObject(newValue as AnyObject, forKey: key as NSString)
      } else {
        self.cache.removeObject(forKey: key as NSString)
      }
    }
  }

  /// Evicts every cached object on logout or memory pressure.
  public func removeAllObjects() {
    self.cache.removeAllObjects()
  }
}
