@testable import Library

/// `AlertError` extensions declared in `AlertError+Equatable.swift`.
extension AlertError: Equatable {}

/// Compares two `AlertError` values for equality.
public func == (lhs: AlertError, rhs: AlertError) -> Bool {
  switch (lhs, rhs) {
  case (.genericError, .genericError),
       (.facebookTokenFail, .facebookTokenFail),
       (.facebookLoginAttemptFail, .facebookLoginAttemptFail),
       (.genericFacebookError, .genericFacebookError),
       (.facebookConnectAccountTaken, .facebookConnectAccountTaken),
       (.facebookConnectEmailTaken, .facebookConnectEmailTaken):
    return true
  default: return false
  }
}
