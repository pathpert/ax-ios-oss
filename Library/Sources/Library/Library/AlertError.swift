import Foundation
import KsApi

/// Enumeration representing Facebook alert failure categories.
public enum AlertError {
  /// Generic Facebook alert error carrying a display message.
  case genericError(message: String)
  /// Facebook SDK failed to return an OAuth token.
  case facebookTokenFail
  /// Facebook SDK login attempt failed with an underlying `NSError`.
  case facebookLoginAttemptFail(error: NSError)
  /// Backend returned a structured `ErrorEnvelope` for a generic Facebook failure.
  case genericFacebookError(envelope: ErrorEnvelope)
  /// Facebook account is already linked to another Kickstarter user.
  case facebookConnectAccountTaken(envelope: ErrorEnvelope)
  /// Email address on the Facebook account is already taken by another Kickstarter account.
  case facebookConnectEmailTaken(envelope: ErrorEnvelope)

  var code: Int {
    switch self {
    case .genericError:
      0
    case .facebookTokenFail:
      1
    case .facebookLoginAttemptFail:
      2
    case .genericFacebookError:
      3
    case .facebookConnectAccountTaken:
      4
    case .facebookConnectEmailTaken:
      5
    }
  }

  /// Bridges this error to an `NSError` in domain `"Facebook.AlertError"` for Crashlytics logging.
  public var nsError: NSError {
    return NSError(
      domain: "Facebook.AlertError",
      code: self.code,
      userInfo: [
        NSLocalizedDescriptionKey: "Facebook login failure"
      ]
    )
  }
}
