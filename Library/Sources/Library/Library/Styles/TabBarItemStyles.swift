import KDS
import UIKit

/// Unselected tab bar icon and label color.
public let tabBarDeselectedColor = LegacyColors.ksr_support_400.uiColor()
/// Selected tab bar icon and label tint color.
public let tabBarSelectedColor = LegacyColors.ksr_create_700.uiColor()
/// Tab bar background tint color.
public let tabBarTintColor = LegacyColors.ksr_white.uiColor()
/// Avatar icon size rendered inside the profile tab bar item.
public let tabBarAvatarSize = CGSize(width: 25, height: 25)

/// Functional style closure configuring a `UITabBarItem`.
public typealias TabBarItemStyle = (UITabBarItem) -> UITabBarItem

private let paddingY: CGFloat = 6.0

/// Configures title, icons, and accessibility label for the Activity tab item.
public let activityTabBarItemStyle: TabBarItemStyle = { button in
  button.title = Strings.tabbar_activity()
  button.image = image(named: "tabbar-icon-activity")
  button.image = image(named: "tabbar-icon-activity-selected")
  button.accessibilityLabel = Strings.tabbar_activity()
  return button
}

/// Configures title, icons, and accessibility label for the Creator Dashboard tab item.
public let dashboardTabBarItemStyle: TabBarItemStyle = { button in
  button.title = Strings.tabbar_dashboard()
  button.image = image(named: "tabbar-icon-dashboard")
  button.selectedImage = image(named: "tabbar-icon-dashboard-selected")
  button.accessibilityLabel = Strings.tabbar_dashboard()
  return button
}

/// Configures title, icons, and accessibility label for the Explore tab item.
public let homeTabBarItemStyle: TabBarItemStyle = { button in
  button.title = Strings.Explore()
  button.image = image(named: "tabbar-icon-home")
  button.selectedImage = image(named: "tabbar-icon-home-selected")
  button.accessibilityLabel = Strings.Explore()
  return button
}

/// Configures the Profile / Login tab bar item appearance based on sign-in state.
public func profileTabBarItemStyle(isLoggedIn: Bool) -> TabBarItemStyle {
  let imageName = isLoggedIn ? "tabbar-icon-profile-logged-in" : "tabbar-icon-profile-logged-out"
  let accLabel = isLoggedIn ? Strings.tabbar_profile() : Strings.tabbar_login()

  return { button in
    button.title = Strings.tabbar_profile()
    button.image = image(named: imageName)
    button.image = image(named: "tabbar-icon-profile-selected")
    button.accessibilityLabel = accLabel

    return button
  }
}

/// Configures title, icons, and accessibility label for the Search tab item.
public let searchTabBarItemStyle: TabBarItemStyle = { button in
  button.title = Strings.tabbar_search()
  button.image = image(named: "tabbar-icon-search")
  button.selectedImage = image(named: "tabbar-icon-search-selected")
  button.accessibilityLabel = Strings.tabbar_search()
  return button
}

/// Configures title, icons, and accessibility label for the Backings tab item.
public let backingsTabBarItemStyle: TabBarItemStyle = { button in
  button.title = Strings.tabbar_backings()
  button.image = image(named: "tabbar-icon-backings")
  button.selectedImage = image(named: "tabbar-icon-backings-selected")
  button.accessibilityLabel = Strings.tabbar_backings()
  return button
}
