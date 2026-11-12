import Foundation
import KsApi
import ReactiveSwift

/// Zero-based tab index for a root tab bar view controller.
public typealias RootViewControllerIndex = Int

/// Badge label update payload emitted for a root tab bar item.
public struct RootTabBarItemBadgeValueData: Equatable {
  /// Formatted badge string (for example `"5"` or `"99+"`), empty string dot indicator, or `nil` to clear.
  public let value: String?
  /// Zero-based index of the target tab bar item.
  public let index: RootViewControllerIndex

  /// Creates a `RootTabBarItemBadgeValueData` update.
  public init(value: String?, index: RootViewControllerIndex) {
    self.value = value
    self.index = index
  }
}

/// Identifies each top-level tab hosted by the root tab bar controller.
public enum RootViewControllerData: Equatable {
  /// Discovery projects feed tab.
  case discovery
  /// Logged-out or non-floating activities feed tab.
  case activities
  /// Combined pledged projects overview and activities tab.
  case pledgedProjectsAndActivities
  /// Search tab.
  case search
  /// User profile tab parameterized by login state.
  case profile(isLoggedIn: Bool)

  public static func == (lhs: RootViewControllerData, rhs: RootViewControllerData) -> Bool {
    switch (lhs, rhs) {
    case (.discovery, .discovery): return true
    case (.activities, .activities): return true
    case (.pledgedProjectsAndActivities, .pledgedProjectsAndActivities): return true
    case (.search, .search): return true
    case let (.profile(lhsIsLoggedIn), .profile(rhsIsLoggedIn)):
      return lhsIsLoggedIn == rhsIsLoggedIn
    default:
      return false
    }
  }

  /// Returns `true` when this tab represents `.profile`.
  var isProfile: Bool {
    switch self {
    case .profile:
      return true
    default:
      return false
    }
  }

  /// Returns `true` when this tab represents an activities or pledged projects overview tab.
  var isActivity: Bool {
    switch self {
    case .activities, .pledgedProjectsAndActivities:
      return true
    case .discovery, .profile, .search:
      return false
    }
  }
}

/// Configuration payload describing visible tab bar items and login state.
public struct TabBarItemsData: Equatable {
  /// Ordered list of tab bar items to style and display.
  public let items: [TabBarItem]
  /// Whether a user is currently authenticated.
  public let isLoggedIn: Bool
}

/// Visual descriptor for a single tab bar item in the root tab bar.
public enum TabBarItem: Equatable {
  /// Activity tab bar item at the specified index.
  case activity(index: RootViewControllerIndex)
  /// Discovery home tab bar item at the specified index.
  case home(index: RootViewControllerIndex)
  /// Profile tab bar item with optional avatar URL and tab index.
  case profile(avatarUrl: URL?, index: RootViewControllerIndex)
  /// Search tab bar item at the specified index.
  case search(index: RootViewControllerIndex)
}

/// Input actions accepted by `RootViewModel`.
public protocol RootViewModelInputs {
  /// Call when the application will enter foreground.
  func applicationWillEnterForeground()

  /// Call when the controller has received a user updated notification.
  func currentUserUpdated()

  /// Call when a badge value was received via push notification.
  func didReceiveBadgeValue(_ value: Int?)

  /// Call when selected tab bar index changes.
  func didSelect(index: RootViewControllerIndex)

  /// Call before selected tab bar index changes.
  func shouldSelect(index: RootViewControllerIndex?)

  /// Call when we should switch to the activities tab.
  func switchToActivities()

  /// Call when we should switch to the discovery tab.
  func switchToDiscovery(params: DiscoveryParams?)

  /// Call when we should switch to the login tab.
  func switchToLogin()

  /// Call when we should switch to the profile tab.
  func switchToProfile()

  /// Call when we should switch to the search tab.
  func switchToSearch()

  /// Call when the a user locale preference has changed.
  /// Used to blow away and re-generate all the tabs, so the entire app reflects changes in user language or currency.
  /// See PR #576.
  func userLocalePreferencesChanged()

  /// Call when the controller has received a user session ended notification.
  func userSessionEnded()

  /// Call when the controller has received a user session started notification.
  func userSessionStarted()

  /// Call from the controller's `viewDidLoad` method.
  func viewDidLoad()

  /// Call when VoiceOver is enabled or disabled.
  func voiceOverStatusDidChange()
}

/// Output signals exposed by `RootViewModel`.
public protocol RootViewModelOutputs {
  /// Emits when the discovery VC should filter with specific params.
  var filterDiscovery: Signal<(RootViewControllerIndex, DiscoveryParams), Never> { get }

  /// Emits a controller index that should be scrolled to the top. This requires figuring out what kind of
  /// controller it is, and setting its `contentOffset`.
  var scrollToTop: Signal<RootViewControllerIndex, Never> { get }

  /// Emits an index that the tab bar should be switched to.
  var selectedIndex: Signal<RootViewControllerIndex, Never> { get }

  /// Emits the badge value to be set at a particular tab index.
  var setBadgeValueAtIndex: Signal<RootTabBarItemBadgeValueData, Never> { get }

  /// Emits the array of view controllers that should be set on the tab bar.
  var setViewControllers: Signal<[RootViewControllerData], Never> { get }

  /// Emits data for setting tab bar item styles.
  var tabBarItemsData: Signal<TabBarItemsData, Never> { get }

  /// Emits a User that can be used to replace the current user in the environment.
  var updateUserInEnvironment: Signal<User, Never> { get }

  /// Emits when the floating tab bar feature is enabled or disabled.
  var floatingTabBarEnabled: Signal<Bool, Never> { get }
}

/// Protocol grouping inputs and outputs for `RootViewModel`.
public protocol RootViewModelType {
  /// View model inputs.
  var inputs: RootViewModelInputs { get }
  /// View model outputs.
  var outputs: RootViewModelOutputs { get }
}

