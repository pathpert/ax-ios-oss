import FacebookLogin
import Foundation
import KsApi
import class UIKit.UIAlertAction
import class UIKit.UIAlertController
import class UIKit.UIBarButtonItem
import class UIKit.UIView

public extension UIAlertController {
  /// Returns a configured alert or popover action sheet controller.
  static func alert(
    title: String,
    message: String? = nil,
    preferredStyle: UIAlertController.Style,
    sourceView: UIView? = nil,
    barButtonItem: UIBarButtonItem? = nil
  ) -> UIAlertController {
    let alert = UIAlertController(
      title: title,
      message: message,
      preferredStyle: preferredStyle
    )

    if UIAlertController.requiresPopOverConfiguration(preferredStyle) {
      alert.modalPresentationStyle = .popover
      alert.popoverPresentationController?.sourceView = sourceView
      alert.popoverPresentationController?.barButtonItem = barButtonItem
    }

    return alert
  }

  /// Returns a standard single-button OK alert controller.
  static func alert(
    _ title: String? = nil,
    message: String? = nil,
    handler: ((UIAlertAction) -> Void)? = nil
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: title,
      message: message,
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_alert_buttons_ok(),
        style: .cancel,
        handler: handler
      )
    )

    return alertController
  }

  /// Returns whether presenting the given style requires iPad popover configuration.
  static func requiresPopOverConfiguration(_ preferredStyle: UIAlertController.Style) -> Bool {
    return preferredStyle == .actionSheet && AppEnvironment.current.device.userInterfaceIdiom == .pad
  }

  /// Maps an `AlertError` value to its corresponding `UIAlertController`.
  static func alertController(forError error: AlertError) -> UIAlertController {
    switch error {
    case let .genericError(message):
      return self.genericError(message)
    case .facebookTokenFail:
      return self.facebookTokenFail()
    case let .facebookLoginAttemptFail(error):
      return self.facebookLoginAttemptFail(error)
    case let .genericFacebookError(envelope):
      return self.genericFacebookError(envelope)
    case let .facebookConnectAccountTaken(envelope):
      return self.facebookConnectAccountTaken(envelope)
    case let .facebookConnectEmailTaken(envelope):
      return self.facebookConnectEmailTaken(envelope)
    }
  }

  /// Returns a generic "Oops" alert displaying the given error message.
  static func genericError(_ message: String) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.general_error_oops(),
      message: message,
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_alert_buttons_ok(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns the Kickstarter Games newsletter subscription confirmation alert.
  static func games(subscribeHandler: @escaping ((UIAlertAction) -> Void))
    -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: Strings.project_checkout_games_alert_want_the_coolest_games_delivered_to_your_inbox(),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.project_checkout_games_alert_yes_please(),
        style: .default,
        handler: subscribeHandler
      )
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.project_checkout_games_alert_no_thanks(),
        style: .default,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns an alert confirming opt-in to the specified newsletter.
  static func newsletterOptIn(_ newsletter: String) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.profile_settings_newsletter_opt_in_title(),
      message: Strings.profile_settings_newsletter_opt_in_message(newsletter: newsletter),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_alert_buttons_ok(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns an alert confirming that a project URL was copied to the pasteboard.
  static func projectCopiedToPasteboard(projectURL url: String) -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: Strings.project_checkout_share_link_the_project_url_has_been_copied_to_your_clipboard(
        project_url: url
      ),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.project_checkout_share_link_OK(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns an alert confirming that an update URL was copied to the pasteboard.
  static func updateCopiedToPasteboard(updateURL url: String) -> UIAlertController {
    let alertController = UIAlertController(
      title: nil,
      message: Strings.project_checkout_share_link_the_update_url_has_been_copied_to_your_clipboard(
        update_url: url
      ),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.project_checkout_share_link_OK(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns a confirmation alert before following all friends from a social graph count.
  static func confirmFollowAllFriends(
    friendsCount: Int,
    yesHandler: @escaping ((UIAlertAction) -> Void),
    noHandler: @escaping ((UIAlertAction) -> Void)
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.social_following_stats_button_follow_all_friends(remote_friends_count: friendsCount),
      message: Strings.social_following_nice_youre_about_to_follow_all_friends(),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_navigation_buttons_ok(),
        style: .default,
        handler: yesHandler
      )
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_navigation_buttons_cancel(),
        style: .cancel,
        handler: noHandler
      )
    )

    return alertController
  }

  /// Returns a confirmation alert before turning off social following privacy.
  static func turnOffPrivacyFollowing(
    cancelHandler: @escaping ((UIAlertAction) -> Void),
    turnOffHandler: @escaping ((UIAlertAction) -> Void)
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.Are_you_sure(),
      message: Strings.If_you_turn_following_off(),
      preferredStyle: .alert
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.Yes_turn_off(),
        style: .destructive,
        handler: turnOffHandler
      )
    )
    alertController.addAction(
      UIAlertAction(
        title: Strings.general_navigation_buttons_cancel(),
        style: .cancel,
        handler: cancelHandler
      )
    )

    return alertController
  }
}
