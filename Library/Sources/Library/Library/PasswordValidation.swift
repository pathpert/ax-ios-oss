import Foundation

/// Raw user-entered password string validated by local length/matching helpers.
/// - Negative Constraint: Never log, cache, or persist plaintext `Password` values.
public typealias Password = String

/// Returns `true` if `pw` meets the minimum character count requirement (`>= 6` characters).
public func passwordLengthValid(_ pw: Password) -> Bool {
  return pw.count > 5
}

/// Returns `true` when password fields are non-empty, matching, and meet length rules.
public func passwordFormValid(_ requirements: (notEmpty: Bool, match: Bool, length: Bool)) -> Bool {
  return requirements.notEmpty && requirements.match && requirements.length
}

/// Returns localized validation copy for password length state, or `nil` when valid.
public func passwordValidationText(_ length: Bool) -> String? {
  return passwordValidationText((length, true))
}

/// Returns localized validation copy for password length and confirmation match state, or `nil` when valid.
public func passwordValidationText(_ requirements: (length: Bool, match: Bool)) -> String? {
  if !requirements.length {
    return Strings.Password_min_length_message()
  } else if !requirements.match {
    return Strings.Passwords_matching_message()
  } else {
    return nil
  }
}
