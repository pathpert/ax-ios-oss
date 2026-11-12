import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Returns the unseen activity count for the signed-in user.
func currentUserActivitiesAndErroredPledgeCount() -> Int {
  return AppEnvironment.current.currentUser?.unseenActivityCount ?? 0
}

/// Builds the ordered list of root tabs for the current login and floating-tab-bar state.
func generateViewControllers(
  isLoggedIn: Bool,
  isFloatingTabBarEnabled: Bool
) -> [RootViewControllerData] {
  var controllers: [RootViewControllerData] = []
  controllers.append(.discovery)

  guard isFloatingTabBarEnabled == false else {
    controllers.append(.search)
    controllers.append(.profile(isLoggedIn: isLoggedIn))

    return controllers
  }

  if isLoggedIn {
    controllers.append(.pledgedProjectsAndActivities)
  } else {
    controllers.append(.activities)
  }

  controllers.append(.search)
  controllers.append(.profile(isLoggedIn: isLoggedIn))

  return controllers
}

/// Constructs tab bar item display data for the current user and floating tab bar configuration.
func tabData(forUser user: User?, isFloatingTabBarEnabled: Bool) -> TabBarItemsData {
  let items: [TabBarItem]

  if isFloatingTabBarEnabled {
    items = [
      .home(index: 0),
      .search(index: 1),
      .profile(avatarUrl: (user?.avatar.small).flatMap(URL.init(string:)), index: 2)
    ]
  } else {
    items = [
      .home(index: 0),
      .activity(index: 1),
      .search(index: 2),
      .profile(avatarUrl: (user?.avatar.small).flatMap(URL.init(string:)), index: 3)
    ]
  }

  return TabBarItemsData(
    items: items,
    isLoggedIn: user != nil
  )
}

/// Formats the badge string shown on the activity tab, or an empty string dot for pending PPO actions.
func activitiesBadgeValue(with value: Int?, hasPPOAction: Bool) -> String? {
  guard !hasPPOAction else {
    // An empty string renders a dot as the badge.
    return ""
  }

  let isVoiceOverRunning = AppEnvironment.current.isVoiceOverRunning()
  let badgeValue = value ?? 0
  let maxBadgeValue = !isVoiceOverRunning ? 99 : badgeValue
  let clampedBadgeValue = min(badgeValue, maxBadgeValue)

  guard clampedBadgeValue > 0 else { return nil }

  return (badgeValue > maxBadgeValue) && !isVoiceOverRunning
    ? Strings.activities_badge_value_plus(activities_badge_value: "\(clampedBadgeValue)")
    : "\(clampedBadgeValue)"
}

/// Maps a `TabBarItem` to its analytics `KSRAnalytics.TabBarItemLabel`.
func tabBarItemLabel(for tabBarItem: TabBarItem) -> KSRAnalytics.TabBarItemLabel {
  switch tabBarItem {
  case .activity:
    return .activity
  case .home:
    return .discovery
  case .profile:
    return .profile
  case .search:
    return .search
  }
}

/// Combines lifecycle, push notification, user update, and tab selection events into badge updates.
func makeRootBadgeSignals(
  activityViewControllerIndex: Signal<RootViewControllerIndex, Never>,
  selectedIndexAndActivityViewControllerIndex: Signal<(RootViewControllerIndex, RootViewControllerIndex), Never>,
  lifecycleEvents: Signal<Void, Never>,
  currentUserUpdated: Signal<Void, Never>,
  didReceiveBadgeValue: Signal<Int?, Never>,
  userSessionEnded: Signal<Void, Never>
) -> (
  integerBadgeValueAndIndex: Signal<(Int?, RootViewControllerIndex), Never>,
  clearBadgeValueOnActivitiesTabSelected: Signal<(Int?, RootViewControllerIndex), Never>,
  currentBadgeValue: MutableProperty<String?>
) {
  let updateBadgeValueOnLifecycleEvents = activityViewControllerIndex
    .takeWhen(lifecycleEvents)
    .map { index -> (Int?, RootViewControllerIndex) in
      (AppEnvironment.current.application.applicationIconBadgeNumber, index)
    }

  let badgeValueOnUserUpdated = currentUserUpdated
    .map { _ in currentUserActivitiesAndErroredPledgeCount() }
    .wrapInOptional()

  let updateBadgeValueFromNotification = selectedIndexAndActivityViewControllerIndex
    .takePairWhen(didReceiveBadgeValue)

  let updateBadgeValueOnUserUpdated = selectedIndexAndActivityViewControllerIndex
    .takePairWhen(badgeValueOnUserUpdated)

  let updateBadgeValueOnUserUpdatedOrFromNotification = Signal.merge(
    updateBadgeValueOnUserUpdated,
    updateBadgeValueFromNotification
  )
  .map(unpack)
  .map { args in (args.2, args.1) }

  let clearBadgeValueOnUserSessionEnded = activityViewControllerIndex
    .takePairWhen(userSessionEnded)
    .map { args -> (Int?, RootViewControllerIndex) in (nil, args.0) }

  let currentBadgeValue = MutableProperty<String?>(nil)

  let clearBadgeValueOnActivitiesTabSelected = selectedIndexAndActivityViewControllerIndex.filter(==)
    .flatMap { _, index in currentBadgeValue.producer.map { ($0, index) }.take(first: 1) }
    .filter { value, _ in value != nil }
    .map { args -> (Int?, RootViewControllerIndex) in
      (AppEnvironment.current.currentUser?.erroredBackingsCount, args.1)
    }

  let integerBadgeValueAndIndex = Signal.merge(
    updateBadgeValueOnLifecycleEvents,
    updateBadgeValueOnUserUpdatedOrFromNotification,
    clearBadgeValueOnUserSessionEnded,
    clearBadgeValueOnActivitiesTabSelected
  )

  return (integerBadgeValueAndIndex, clearBadgeValueOnActivitiesTabSelected, currentBadgeValue)
}

