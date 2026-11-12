import Foundation

/// Manages presentation eligibility, denial history, and localized copy for push opt-in prompts.
/// - Negative Constraint: Do not bypass `canShowDialog(for:)` checks when triggering permission alerts.
public struct PushNotificationDialog: PushNotificationDialogType {
  /// User action context where a push notification prompt can appear.
  public enum Context: String {
    case login
    case message
    case pledge
    case save
  }

  private static let maxDeniedContexts: Int = 3

  /// Returns `true` if the prompt has not exceeded denial limits and wasn't dismissed in `context`.
  public static func canShowDialog(for context: PushNotificationDialog.Context) -> Bool {
    return !AppEnvironment.current.userDefaults.deniedNotificationContexts.contains(context.rawValue) &&
      AppEnvironment.current.userDefaults.deniedNotificationContexts.count < self.maxDeniedContexts
  }

  /// Records that the user dismissed the push prompt in `context`.
  public static func didDenyAccess(for context: Context) {
    if !AppEnvironment.current.userDefaults.deniedNotificationContexts.contains(context.rawValue) {
      AppEnvironment.current.userDefaults.deniedNotificationContexts.append(context.rawValue)
    }
  }

  /// Clears stored push denial history on user logout.
  public static func resetAllContexts() {
    AppEnvironment.current.userDefaults.deniedNotificationContexts.removeAll()
  }

  /// Localized dismissal button title ("Not now" vs "Never") based on prior denial count.
  public static var titleForDismissal: String {
    return (
      AppEnvironment.current.userDefaults.deniedNotificationContexts.count < 2
    ) ? Strings.Not_now() : Strings.Never()
  }
}

extension PushNotificationDialog.Context {
  /// Localized alert title tailored to the push permission trigger context.
  public var title: String {
    switch self {
    case .login: return Strings.Stay_up_to_date()
    case .message: return Strings.Get_notified_about_new_messages()
    case .pledge: return Strings.Stay_updated_on_this_project()
    case .save: return Strings.Get_reminded_about_this_project()
    }
  }

  /// Localized alert body explaining push notification benefits for this context.
  public var message: String {
    switch self {
    case .login: return Strings.Receive_project_updates_messages_and_more()
    case .message: return Strings.Know_when_creators_and_backers_message_you()
    case .pledge: return Strings.Receive_project_updates_and_more()
    case .save: return Strings.Receive_a_reminder_forty_eight_hours_before_this_project_ends()
    }
  }
}
