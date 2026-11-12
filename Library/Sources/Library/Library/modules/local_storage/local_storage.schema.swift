import Foundation
import KsApi

// MARK: - Rule 3: Poka-Yoke Schemas for Local Storage & Keychain (Library)

/// Validated payload for persisting the user's favorite category IDs in local storage.
public struct UpdateFavoriteCategoriesRequestSchema: Codable, Equatable, Sendable {
  /// Deduplicated positive category IDs (max 50).
  public let categoryIds: [Int]

  /// AX field metadata describing validation constraints for `UpdateFavoriteCategoriesRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "categoryIds": .describe(
      field: "categoryIds",
      meaning: "Deduplicated list of positive Kickstarter root/subcategory IDs saved by the user.",
      format: "Array of unique positive integers > 0 (max 50 items)",
      negativeConstraints: [
        "Do not pass untyped Any dictionaries via KeyValueStoreType.set(_: Any?, forKey:).",
        "Do not pass 0, negative category IDs, or duplicate IDs."
      ]
    )
  ]

  /// Creates a favorite-categories storage request schema.
  public init(categoryIds: [Int]) {
    self.categoryIds = categoryIds
  }

  /// Validates category count, uniqueness, and positivity constraints.
  public func validate() -> Result<[Int], AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.categoryIds.count > 50 {
      violations.append(AXInvalidParam(
        name: "categoryIds",
        reason: "Cannot store more than 50 favorite categories."
      ))
    }

    if self.categoryIds.contains(where: { $0 <= 0 }) {
      violations.append(AXInvalidParam(
        name: "categoryIds",
        reason: "All category IDs must be positive integers > 0."
      ))
    }

    if Set(self.categoryIds).count != self.categoryIds.count {
      violations.append(AXInvalidParam(
        name: "categoryIds",
        reason: "Duplicate category IDs are forbidden."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Favorite Categories Payload",
        status: 400,
        detail: "Favorite categories storage update failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide up to 50 unique positive integer categoryIds (> 0).",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(self.categoryIds)
  }
}

/// Validated payload for persisting an account credential in the Keychain enclave.
public struct StoreKeychainCredentialRequestSchema: Codable, Equatable, Sendable {
  /// Keychain account identifier (3–128 non-whitespace characters).
  public let accountName: String
  /// Secret OAuth or session token stored in Keychain.
  public let secretToken: String

  /// AX field metadata describing validation constraints for `StoreKeychainCredentialRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "accountName": .describe(
      field: "accountName",
      meaning: "Account identifier under which the credential is stored in Keychain.",
      format: "Non-empty trimmed string (3-128 chars)",
      negativeConstraints: [
        "Do not pass empty or whitespace-only account identifiers."
      ]
    ),
    "secretToken": .describe(
      field: "secretToken",
      meaning: "OAuth or session secret token to persist in the secure Keychain enclave.",
      format: "Non-empty token string (>= 8 chars)",
      negativeConstraints: [
        "Do not store secret tokens in UserDefaults or KeyValueStoreType.",
        "Do not pass tokens shorter than 8 characters."
      ]
    )
  ]

  /// Creates a Keychain credential storage request schema.
  public init(accountName: String, secretToken: String) {
    self.accountName = accountName
    self.secretToken = secretToken
  }

  /// Validates account identifier length and minimum secret token length.
  public func validate() -> Result<(String, String), AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    let trimmedAccount = self.accountName.trimmingCharacters(in: .whitespacesAndNewlines)

    if trimmedAccount.count < 3 || trimmedAccount.count > 128 {
      violations.append(AXInvalidParam(
        name: "accountName",
        reason: "Must be between 3 and 128 characters."
      ))
    }

    if self.secretToken.trimmingCharacters(in: .whitespacesAndNewlines).count < 8 {
      violations.append(AXInvalidParam(
        name: "secretToken",
        reason: "Must be at least 8 non-whitespace characters."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Keychain Credential Payload",
        status: 400,
        detail: "Keychain credential storage request failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide an accountName (3-128 chars) and a secretToken (>= 8 chars).",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success((trimmedAccount, self.secretToken))
  }
}

/// Contract returned after updating stored favorite category IDs.
public struct FavoriteCategoriesContract: Codable, Equatable, Sendable {
  /// Normalized category identifiers stored locally.
  public let categoryIds: [Int]
  /// Whether this operation replayed a previously executed idempotency key.
  public let idempotencyReplayed: Bool
}

/// Contract returned after persisting a credential in the Keychain enclave.
public struct KeychainCredentialContract: Codable, Equatable, Sendable {
  /// Account name saved in Keychain.
  public let accountName: String
  /// Indicates that the credential was written to the secure Keychain enclave.
  public let storedInSecureEnclave: Bool
  /// Whether this operation replayed a previously executed idempotency key.
  public let idempotencyReplayed: Bool
}

