import KDS
import KsApi
import UIKit

/// Value passed to configure a cell in the Settings screen.
public struct SettingsCellValue {
  /// The row definition describing title, color, and chevron visibility.
  public let cellType: SettingsCellTypeProtocol
  /// Optional active currency displayed on currency rows.
  public let currency: Currency?
  /// Optional signed-in `User` associated with the row.
  public let user: User?

  /// Creates a `SettingsCellValue` configuration payload.
  public init(cellType: SettingsCellTypeProtocol, currency: Currency? = nil, user: User? = nil) {
    self.cellType = cellType
    self.currency = currency
    self.user = user
  }
}

/// Shared display contract implemented by Settings and Help cell enums.
public protocol SettingsCellTypeProtocol {
  /// Accessibility traits applied to the row.
  var accessibilityTraits: UIAccessibilityTraits { get }
  /// Whether the trailing disclosure chevron should be displayed.
  var showArrowImageView: Bool { get }
  /// Text color for the row's primary label.
  var textColor: UIColor { get }
  /// Localized display title for the row.
  var title: String { get }
}

/// Sections displayed on the top-level Settings screen.
public enum SettingsSectionType: Int, CaseIterable {
  /// Account management section.
  case account
  /// Notification and newsletter preferences section.
  case notificationNewsletters
  /// Help and support section.
  case help
  /// Log out action section.
  case logout
  /// App Store rating and app version footer section.
  case ratingAppVersion

  /// Standard section header height.
  public static var sectionHeaderHeight: CGFloat {
    return Styles.grid(5)
  }

  /// Ordered row types belonging to this section.
  public var cellRowsForSection: [SettingsCellType] {
    switch self {
    case .account:
      return [SettingsCellType.account]
    case .notificationNewsletters:
      return [.notifications, .newsletters]
    case .help:
      return [.help]
    case .logout:
      return [SettingsCellType.logout]
    case .ratingAppVersion:
      return [.rateInAppStore]
    }
  }

  /// Whether this section renders a footer view.
  public var hasSectionFooter: Bool {
    switch self {
    case .ratingAppVersion:
      return true
    default:
      return false
    }
  }

  /// Localized footer copy for this section (e.g., app version string), if any.
  public var footerText: String? {
    switch self {
    case .ratingAppVersion:
      let appVersionString = AppEnvironment.current.mainBundle.appVersionString
      return "\(Strings.App_version()) \(appVersionString)"
    default:
      return nil
    }
  }
}

// TODO: When the decision to add the Facebook friends feature back in is confirmed, refer to this PR:
// https://github.com/kickstarter/ios-oss/pull/1655
/// Individual rows available in the top-level Settings screen.
public enum SettingsCellType: SettingsCellTypeProtocol {
  /// Account settings row.
  case account
  /// Notifications settings row.
  case notifications
  /// Newsletters settings row.
  case newsletters
  /// Help & Support row.
  case help
  /// Log out row.
  case logout
  /// Rate in the App Store row.
  case rateInAppStore
  /// Find Facebook friends row.
  case findFriends

  /// Accessibility traits for the row (`.button`).
  public var accessibilityTraits: UIAccessibilityTraits {
    return .button
  }

  /// Localized title text for the row.
  public var title: String {
    switch self {
    case .account:
      return Strings.Account()
    case .notifications:
      return Strings.profile_settings_navbar_title_notifications()
    case .newsletters:
      return Strings.profile_settings_newsletter_title()
    case .help:
      return Strings.general_navigation_buttons_help()
    case .logout:
      return Strings.profile_settings_logout_alert_title()
    case .rateInAppStore:
      return Strings.Rate_us_in_the_App_Store()
    case .findFriends:
      return Strings.profile_settings_social_find_friends()
    }
  }

  /// Whether a right disclosure arrow icon is displayed for this row.
  public var showArrowImageView: Bool {
    switch self {
    case .account, .notifications, .newsletters, .help, .findFriends, .rateInAppStore:
      return true
    default:
      return false
    }
  }

  /// Text color used for the row title.
  public var textColor: UIColor {
    switch self {
    case .logout:
      return LegacyColors.ksr_alert.uiColor()
    default:
      return LegacyColors.ksr_support_700.uiColor()
    }
  }
}

/// Sections displayed in the Help & Legal information screen.
public enum HelpSectionType: Int {
  /// Support resources section.
  case help
  /// Legal policies and accessibility section.
  case privacy

  /// Standard section header height.
  public static var sectionHeaderHeight: CGFloat {
    return Styles.grid(5)
  }

  /// Ordered Help screen sections.
  public static var allCases: [HelpSectionType] = [.help, .privacy]

  /// Ordered `HelpType` items displayed within this section.
  public var cellRowsForSection: [HelpType] {
    switch self {
    case .help:
      return [.helpCenter, .contact]
    case .privacy:
      return [.terms, .privacy, .cookie, .accessibility]
    }
  }
}
