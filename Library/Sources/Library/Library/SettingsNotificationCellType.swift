import KsApi
import UIKit

/// Pair of a notification cell descriptor and the current `User`.
public struct SettingsNotificationCellValue {
  /// Notification preference row type represented by the cell.
  public let cellType: SettingsNotificationCellType
  /// User whose notification settings are rendered and updated.
  public let user: User

  /// Creates a cell configuration value pairing `cellType` with `user`.
  public init(cellType: SettingsNotificationCellType, user: User) {
    self.cellType = cellType
    self.user = user
  }
}

/// Sections grouping notification preference rows on the notification settings screen.
public enum SettingsNotificationSectionType: Int, CaseIterable {
  /// Marketing and Kickstarter announcement notifications.
  case announcements
  /// Updates and reminders for backed projects.
  case backedProjects
  /// Creator activity notifications for launched projects.
  case creator
  /// Social follower and messaging notifications.
  case social

  /// Height applied to the section header spacer view.
  public var sectionHeaderHeight: CGFloat {
    return Styles.grid(9)
  }

  /// Ordered notification cell rows belonging to this section.
  public var cellRowsForSection: [SettingsNotificationCellType] {
    switch self {
    case .announcements:
      return [.marketingUpdate]
    case .backedProjects:
      return [.projectUpdates, .projectNotifications]
    case .creator:
      return [.pledgeActivity, .newComments, .newLikes, .creatorTips]
    case .social:
      return [.messages, .newFollowers, .friendBacksProject, .commentReplyDigest]
    }
  }

  /// Localized section header title string.
  public var sectionTitle: String {
    switch self {
    case .announcements:
      return Strings.Announcements()
    case .backedProjects:
      return Strings.Projects_youve_backed()
    case .creator:
      return Strings.Projects_youve_launched()
    case .social:
      return Strings.profile_settings_social_title()
    }
  }
}

/// Individual notification preference rows displayed in notification settings.
public enum SettingsNotificationCellType: CaseIterable {
  case projectUpdates
  case projectNotifications
  case pledgeActivity
  case emailFrequency
  case newComments
  case newLikes
  case creatorTips
  case marketingUpdate
  case messages
  case newFollowers
  case friendBacksProject
  case commentReplyDigest

  /// VoiceOver traits exposed for the cell (buttons for navigation rows).
  public var accessibilityTraits: UIAccessibilityTraits {
    switch self {
    case .projectNotifications, .emailFrequency:
      return .button
    default:
      return .none
    }
  }

  /// Whether child elements should be hidden from VoiceOver accessibility navigation.
  public var accessibilityElementsHidden: Bool {
    switch self {
    case .projectNotifications:
      return false
    default:
      return true
    }
  }

  /// Whether the email notification toggle button should appear for this row.
  public var shouldShowEmailNotificationButton: Bool {
    switch self {
    case .projectNotifications, .emailFrequency, .newLikes, .marketingUpdate:
      return false
    default:
      return true
    }
  }

  /// Whether the push notification toggle button should appear for this row.
  public var shouldShowPushNotificationButton: Bool {
    switch self {
    case .projectNotifications, .emailFrequency, .creatorTips, .commentReplyDigest:
      return false
    default:
      return true
    }
  }

  /// Whether the managed-projects count badge should be hidden.
  public var projectCountLabelHidden: Bool {
    switch self {
    case .projectNotifications: return false
    default: return true
    }
  }

  /// Whether the disclosure chevron icon should be hidden.
  public var shouldHideArrowView: Bool {
    switch self {
    case .projectNotifications, .emailFrequency: return false
    default: return true
    }
  }

  /// Localized display title for the notification row.
  public var title: String {
    switch self {
    case .projectUpdates:
      return Strings.profile_settings_backer_project_updates()
    case .projectNotifications:
      return Strings.profile_settings_backer_notifications()
    case .pledgeActivity:
      return Strings.Project_activity()
    case .emailFrequency:
      return Strings.Email_frequency()
    case .newComments:
      return Strings.profile_settings_creator_comments()
    case .newLikes:
      return Strings.profile_settings_creator_likes()
    case .creatorTips:
      return Strings.Creator_tips()
    case .marketingUpdate:
      return Strings.Chosen_just_for_you()
    case .messages:
      return Strings.dashboard_buttons_messages()
    case .newFollowers:
      return Strings.profile_settings_social_followers()
    case .friendBacksProject:
      return Strings.profile_settings_social_friend_backs()
    case .commentReplyDigest:
      return Strings.Comment_reply_digest()
    }
  }
}
