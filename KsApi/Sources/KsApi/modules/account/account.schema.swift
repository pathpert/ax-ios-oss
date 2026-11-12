import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Account Security & Preferences

/// ISO 4217 uppercase currency codes supported for Kickstarter account preferences.
///
/// - Negative constraint: Do not pass currency symbols (`"$"`, `"€"`) or lowercase strings.
public enum AXSupportedCurrencyCode: String, Codable, CaseIterable, Equatable, Sendable {
  /// US, Canadian, British, Euro, and Australian dollars/pounds/euros.
  case usd = "USD", cad = "CAD", gbp = "GBP", eur = "EUR", aud = "AUD"
  /// New Zealand, Swedish, Danish, Norwegian, and Swiss currencies.
  case nzd = "NZD", sek = "SEK", dkk = "DKK", nok = "NOK", chf = "CHF"
  /// Hong Kong, Singapore, Mexican, Japanese, and Polish currencies.
  case hkd = "HKD", sgd = "SGD", mxn = "MXN", jpy = "JPY", pln = "PLN"
}

/// Poka-Yoke request schema for updating the signed-in user's account email address.
///
/// - Negative constraint: Requires bare RFC 5322 email syntax and current password re-authentication.
public struct ChangeEmailRequestSchema: Codable, Equatable, Sendable {
  /// New primary email address for the Kickstarter account.
  public let newEmail: String
  /// Current account password for re-authentication (`>= 6` characters).
  public let currentPassword: String

  /// Field-level descriptors and negative constraints for `ChangeEmailRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "newEmail": .describe(
      field: "newEmail",
      meaning: "New primary email address for the Kickstarter account.",
      format: "Valid RFC 5322 email address (lowercase, containing '@' and domainTLD)",
      negativeConstraints: [
        "Do not pass display names (e.g. 'Alice <alice@example.com>'); pass only the bare email address.",
        "Do not pass multiple comma-separated email addresses."
      ]
    ),
    "currentPassword": .describe(
      field: "currentPassword",
      meaning: "Current account password for re-authentication.",
      format: "Non-empty UTF-8 string >= 6 characters",
      negativeConstraints: [
        "Do not pass OAuth bearer tokens in place of currentPassword.",
        "Do not pass empty or whitespace-only strings."
      ]
    )
  ]

  /// Creates a `ChangeEmailRequestSchema` payload.
  public init(newEmail: String, currentPassword: String) {
    self.newEmail = newEmail
    self.currentPassword = currentPassword
  }

  /// Validates `newEmail` and `currentPassword` boundaries, returning an `AXProblemDetails` on failure.
  public func validate() -> Result<ValidatedChangeEmailContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    let trimmedEmail = self.newEmail.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()

    if !Self.isValidEmail(trimmedEmail) {
      violations.append(AXInvalidParam(
        name: "newEmail",
        reason: "Must be a valid bare email address without display names or spaces."
      ))
    }
    if self.currentPassword.trimmingCharacters(in: .whitespacesAndNewlines).count < 6 {
      violations.append(AXInvalidParam(
        name: "currentPassword",
        reason: "Current password must be at least 6 characters."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "ChangeEmail request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a valid bare email address (e.g. 'user@example.com') and a currentPassword of at least 6 characters.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedChangeEmailContract(
      normalizedEmail: trimmedEmail,
      currentPassword: self.currentPassword
    ))
  }

  private static func isValidEmail(_ email: String) -> Bool {
    guard !email.contains(" "), !email.contains("<"), !email.contains(",") else { return false }
    let parts = email.split(separator: "@", omittingEmptySubsequences: false)
    guard parts.count == 2, !parts[0].isEmpty else { return false }
    let domainParts = parts[1].split(separator: ".", omittingEmptySubsequences: false)
    return domainParts.count >= 2 && domainParts.allSatisfy { !$0.isEmpty }
  }
}

/// Validated and normalized email-change contract emitted by `ChangeEmailRequestSchema.validate()`.
public struct ValidatedChangeEmailContract: Equatable, Sendable {
  /// Trimmed, lowercased bare email address ready for submission.
  public let normalizedEmail: String
  /// Current account password validated to meet minimum length rules.
  public let currentPassword: String
}

/// Poka-Yoke request schema for updating the signed-in user's account password.
///
/// - Negative constraint: `newPassword` must be `>= 10` characters, match `newPasswordConfirmation`, and differ from `currentPassword`.
public struct ChangePasswordRequestSchema: Codable, Equatable, Sendable {
  /// Existing account password (`>= 6` characters).
  public let currentPassword: String
  /// New password (`>= 10` characters, distinct from `currentPassword`).
  public let newPassword: String
  /// Exact confirmation string matching `newPassword`.
  public let newPasswordConfirmation: String

  /// Field-level descriptors and negative constraints for `ChangePasswordRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "currentPassword": .describe(
      field: "currentPassword",
      meaning: "Existing user password.",
      format: "Non-empty UTF-8 string >= 6 characters",
      negativeConstraints: ["Do not pass empty strings."]
    ),
    "newPassword": .describe(
      field: "newPassword",
      meaning: "New account password.",
      format: "UTF-8 string >= 10 characters, distinct from currentPassword",
      negativeConstraints: [
        "Do not reuse currentPassword as newPassword.",
        "Do not pass passwords shorter than 10 characters."
      ]
    ),
    "newPasswordConfirmation": .describe(
      field: "newPasswordConfirmation",
      meaning: "Exact confirmation match of newPassword.",
      format: "UTF-8 string identical to newPassword",
      negativeConstraints: ["Do not pass a value that differs from newPassword."]
    )
  ]

  /// Creates a `ChangePasswordRequestSchema` payload.
  public init(currentPassword: String, newPassword: String, newPasswordConfirmation: String) {
    self.currentPassword = currentPassword
    self.newPassword = newPassword
    self.newPasswordConfirmation = newPasswordConfirmation
  }

  /// Validates password length, novelty, and confirmation equality boundaries.
  public func validate() -> Result<ChangePasswordRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.currentPassword.count < 6 {
      violations.append(AXInvalidParam(name: "currentPassword", reason: "Must be at least 6 characters."))
    }
    if self.newPassword.count < 10 {
      violations.append(AXInvalidParam(name: "newPassword", reason: "Must be at least 10 characters."))
    } else if self.newPassword == self.currentPassword {
      violations.append(AXInvalidParam(name: "newPassword", reason: "Must not be identical to currentPassword."))
    }
    if self.newPassword != self.newPasswordConfirmation {
      violations.append(AXInvalidParam(name: "newPasswordConfirmation", reason: "Must match newPassword exactly."))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "ChangePassword request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a newPassword of >= 10 characters that differs from currentPassword and matches newPasswordConfirmation.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(self)
  }
}

/// Poka-Yoke request schema for changing the account's preferred currency.
public struct ChangeCurrencyRequestSchema: Codable, Equatable, Sendable {
  /// Three-letter uppercase ISO 4217 currency code.
  public let chosenCurrency: String

  /// Field-level descriptors and negative constraints for `ChangeCurrencyRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "chosenCurrency": .describe(
      field: "chosenCurrency",
      meaning: "Three-letter ISO 4217 currency code supported by Kickstarter.",
      format: "One of: USD, CAD, GBP, EUR, AUD, NZD, SEK, DKK, NOK, CHF, HKD, SGD, MXN, JPY, PLN",
      negativeConstraints: [
        "Do not pass currency symbols (e.g. '$', '€', '£').",
        "Do not pass unsupported ISO codes or lowercase strings."
      ]
    )
  ]

  /// Creates a `ChangeCurrencyRequestSchema` payload.
  public init(chosenCurrency: String) {
    self.chosenCurrency = chosenCurrency
  }

  /// Validates `chosenCurrency` against `AXSupportedCurrencyCode`.
  public func validate() -> Result<AXSupportedCurrencyCode, AXProblemDetails> {
    guard let code = AXSupportedCurrencyCode(rawValue: self.chosenCurrency) else {
      let allowed = AXSupportedCurrencyCode.allCases.map(\.rawValue).joined(separator: ", ")
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "Currency '\(self.chosenCurrency)' is not a supported uppercase ISO 4217 Kickstarter currency.",
        suggestedAction: "Pass one of the supported uppercase 3-letter currency codes: \(allowed).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "chosenCurrency", reason: "Must be one of: \(allowed).")]
      ))
    }
    return .success(code)
  }
}

/// Idempotent receipt emitted by account security and preference mutations.
public struct AccountMutationReceipt: Codable, Equatable, Sendable {
  /// Identifier of the completed account mutation operation (e.g. `"changeEmail"`).
  public let operation: String
  /// Normalized target value applied by the mutation.
  public let updatedValue: String
  /// `true` when this receipt was replayed from the idempotency store instead of re-executing.
  public let idempotencyReplayed: Bool

  /// Creates an `AccountMutationReceipt`.
  public init(operation: String, updatedValue: String, idempotencyReplayed: Bool = false) {
    self.operation = operation
    self.updatedValue = updatedValue
    self.idempotencyReplayed = idempotencyReplayed
  }
}

