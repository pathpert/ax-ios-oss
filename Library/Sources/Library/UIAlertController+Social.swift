import FacebookLogin
import Foundation
import KsApi
import class UIKit.UIAlertAction
import class UIKit.UIAlertController
import class UIKit.UIView

public extension UIAlertController {
  /// Returns an informational alert explaining the following privacy setting.
  static func followingPrivacyInfo() -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.Following(),
      message: Strings.When_following_is_on_you_can_follow_the_acticity_of_others(),
      preferredStyle: .alert
    )

    alertController.addAction(
      UIAlertAction(
        title: Strings.Got_it(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns an alert shown when the Facebook access token is invalid.
  static func facebookTokenFail() -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.login_tout_errors_facebook_invalid_token_title(),
      message: Strings.login_tout_errors_facebook_invalid_token_message(),
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

  /// Returns an alert describing a failed Facebook SDK login attempt.
  static func facebookLoginAttemptFail(_ error: NSError) -> UIAlertController {
    let alertController = UIAlertController(
      title: error.userInfo[ErrorLocalizedTitleKey] as? String ??
        Strings.login_tout_errors_facebook_settings_disabled_title(),
      message: error.userInfo[ErrorLocalizedDescriptionKey] as? String ??
        Strings.login_tout_errors_facebook_settings_disabled_message(),
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

  /// Returns a generic Facebook error alert from an error envelope.
  static func genericFacebookError(_ envelope: ErrorEnvelope) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.login_tout_errors_facebook_generic_error_title(),
      message: envelope.errorMessages.first ?? Strings.login_tout_errors_facebook_generic_error_message(),
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

  /// Returns an alert indicating the Facebook account is already linked to another user.
  static func facebookConnectAccountTaken(_ envelope: ErrorEnvelope) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.login_tout_errors_facebook_generic_error_title(),
      message: envelope.errorMessages.first ??
        Strings.This_facebook_account_is_already_linked_to_another_Kickstarter_user(),
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

  /// Returns an alert indicating the Facebook email is already registered.
  static func facebookConnectEmailTaken(_ envelope: ErrorEnvelope) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.login_tout_errors_facebook_generic_error_title(),
      message: envelope.errorMessages.first ??
        Strings.The_email_associated_with_this_Facebook_account_is_already_registered(),
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

  /// Returns a confirmation alert before blocking a user.
  static func blockUserAlert(
    username: String,
    blockUserHandler: @escaping (UIAlertAction) -> Void
  ) -> UIAlertController {
    let alertController = UIAlertController(
      title: Strings.Block_username(username: username),
      message: Strings.Blocked_user_confirmation(),
      preferredStyle: .alert
    )

    // Scott TODO: Use localized strings once translations can be done [mbl-1037](https://kickstarter.atlassian.net/browse/MBL-1037)
    alertController.addAction(
      UIAlertAction(
        title: Strings.Block(),
        style: .destructive,
        handler: blockUserHandler
      )
    )

    alertController.addAction(
      UIAlertAction(
        title: Strings.Cancel(),
        style: .cancel,
        handler: nil
      )
    )

    return alertController
  }

  /// Returns an action sheet for blocking a user or viewing their profile.
  static func blockUserActionSheet(
    blockUserHandler: @escaping (UIAlertAction) -> Void,
    viewProfileHandler: ((UIAlertAction) -> Void)? = nil,
    sourceView: UIView? = nil,
    isIPad: Bool
  ) -> UIAlertController {
    let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

    if let profileHandler = viewProfileHandler {
      alertController
        .addAction(UIAlertAction(title: Strings.View_profile(), style: .default, handler: profileHandler))
    }

    alertController
      .addAction(UIAlertAction(
        title: Strings.Block_this_user(),
        style: .destructive,
        handler: blockUserHandler
      ))

    alertController
      .addAction(UIAlertAction(title: Strings.Cancel(), style: .cancel, handler: nil))

    if isIPad {
      alertController.modalPresentationStyle = .popover
      alertController.popoverPresentationController?.sourceView = sourceView
    }

    return alertController
  }
}
