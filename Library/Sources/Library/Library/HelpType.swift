import KDS
import UIKit

/// Catalog of Kickstarter support, legal policy, and trust web destinations exposed in Help Settings.
/// - Negative Constraint: Do not hardcode help URLs in view controllers; compute from `url(withBaseUrl:)`.
public enum HelpType: SettingsCellTypeProtocol, CaseIterable, Equatable {
  case helpCenter
  case community
  case contact
  case howItWorks
  case terms
  case privacy
  case cookie
  case trust
  case accessibility
  case environment
  case aiDisclosure
  case prohibitedItems

  /// Maps a help destination URL back to its matching `HelpType`, if recognized.
  public static func helpType(from url: URL) -> HelpType? {
    let helpType = HelpType.allCases.filter { helpType in
      url.absoluteString == helpType.url(
        withBaseUrl: AppEnvironment.current.apiService.serverConfig.webBaseUrl
      )?.absoluteString
    }
    .first

    return helpType
  }

  /// Accessibility traits applied to help list items (`.button` for Contact, `.link` for web pages).
  public var accessibilityTraits: UIAccessibilityTraits {
    switch self {
    case .contact:
      return .button
    default:
      return .link
    }
  }

  /// Localized display label shown in Settings, or `""` for web-only destinations without menu rows.
  public var title: String {
    switch self {
    case .helpCenter:
      return Strings.Help_center()
    case .community:
      return ""
    case .contact:
      return Strings.profile_settings_about_contact()
    case .howItWorks:
      return Strings.profile_settings_about_how_it_works()
    case .terms:
      return Strings.profile_settings_about_terms()
    case .privacy:
      return Strings.profile_settings_about_privacy()
    case .cookie:
      return Strings.profile_settings_about_cookie()
    case .trust:
      return ""
    case .accessibility:
      return Strings.Accessibility_statement()
    case .environment:
      return ""
    case .aiDisclosure:
      return ""
    case .prohibitedItems:
      return ""
    }
  }

  /// Whether the settings row displays a trailing chevron arrow.
  public var showArrowImageView: Bool {
    switch self {
    case .contact:
      return false
    default:
      return true
    }
  }

  /// Foreground text color applied to the help row label.
  public var textColor: UIColor {
    return LegacyColors.ksr_support_700.uiColor()
  }

  /// Resolves the full destination URL against `baseUrl`, or `nil` for native `.contact` mail compose.
  public func url(withBaseUrl baseUrl: URL) -> URL? {
    switch self {
    case .community:
      return baseUrl.appendingPathComponent("help/community")
    case .cookie:
      return baseUrl.appendingPathComponent("cookies")
    case .contact:
      return nil
    case .helpCenter:
      return baseUrl.appendingPathComponent("help")
    case .howItWorks:
      return baseUrl.appendingPathComponent("about")
    case .privacy:
      return baseUrl.appendingPathComponent("privacy")
    case .terms:
      return baseUrl.appendingPathComponent("terms-of-use")
    case .trust:
      return baseUrl.appendingPathComponent("trust")
    case .accessibility:
      return baseUrl.appendingPathComponent("accessibility")
    case .environment:
      return baseUrl.appendingPathComponent("environment")
    case .aiDisclosure:
      return baseUrl.appendingPathComponent("hc/en-us/articles/16848396410267")
    case .prohibitedItems:
      return baseUrl.appendingPathComponent("rules/prohibited")
    }
  }
}
