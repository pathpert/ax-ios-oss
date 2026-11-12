import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Apple Sign-In & Email Verification

/// Poka-Yoke request schema for authenticating via Sign in with Apple.
///
/// - Negative constraint: `iosAppBundleId` must be a reverse-DNS bundle identifier and `authCode` must be a non-expired single-use Apple authorization token.
public struct SignInWithAppleRequestSchema: Codable, Equatable, Sendable {
  /// Reverse-DNS iOS application bundle identifier (e.g. `"com.kickstarter.kickstarter"`).
  public let iosAppBundleId: String
  /// Single-use Apple authorization code (`>= 10` non-whitespace characters).
  public let authCode: String
  /// Optional given name disclosed by Apple on first sign-in.
  public let firstName: String?
  /// Optional family name disclosed by Apple on first sign-in.
  public let lastName: String?

  /// Field-level descriptors and negative constraints for `SignInWithAppleRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "iosAppBundleId": .describe(
      field: "iosAppBundleId",
      meaning: "Reverse-DNS iOS application bundle identifier registered with Apple Sign-In.",
      format: "Reverse-DNS string with at least 2 dot-separated segments (e.g. 'com.kickstarter.kickstarter')",
      negativeConstraints: [
        "Do not pass numeric App Store IDs or Apple Team IDs.",
        "Do not pass empty strings or strings containing spaces."
      ]
    ),
    "authCode": .describe(
      field: "authCode",
      meaning: "Single-use Apple authorization code token.",
      format: "Non-empty UTF-8 authorization code >= 10 characters",
      negativeConstraints: [
        "Do not pass expired or empty authorization codes.",
        "Do not pass raw user passwords."
      ]
    )
  ]

  /// Creates a `SignInWithAppleRequestSchema` payload.
  public init(
    iosAppBundleId: String,
    authCode: String,
    firstName: String? = nil,
    lastName: String? = nil
  ) {
    self.iosAppBundleId = iosAppBundleId
    self.authCode = authCode
    self.firstName = firstName
    self.lastName = lastName
  }

  /// Validates reverse-DNS bundle ID and authorization code format boundaries.
  public func validate() -> Result<SignInWithAppleRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    let segments = self.iosAppBundleId.split(separator: ".", omittingEmptySubsequences: false)
    if segments.count < 2 || segments.contains(where: { $0.isEmpty }) || self.iosAppBundleId.contains(" ") {
      violations.append(AXInvalidParam(
        name: "iosAppBundleId",
        reason: "Must be a valid reverse-DNS bundle identifier (e.g. 'com.kickstarter.kickstarter')."
      ))
    }

    if self.authCode.trimmingCharacters(in: .whitespacesAndNewlines).count < 10 {
      violations.append(AXInvalidParam(
        name: "authCode",
        reason: "Apple authorization code must be at least 10 non-whitespace characters."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "SignInWithApple request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Pass a valid reverse-DNS iosAppBundleId and a single-use Apple authCode >= 10 characters.",
        isRetriable: false,
        invalidParams: violations
      ))
    }
    return .success(self)
  }
}

/// Poka-Yoke request schema for verifying a user's email address with an access token.
///
/// - Negative constraint: Pass only the extracted token parameter (`16...256` chars), never a full verification URL or email address.
public struct VerifyEmailRequestSchema: Codable, Equatable, Sendable {
  /// Cryptographic single-use token from the verification email link.
  public let emailAccessToken: String

  /// Field-level descriptors and negative constraints for `VerifyEmailRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "emailAccessToken": .describe(
      field: "emailAccessToken",
      meaning: "Cryptographic email verification token from verification link.",
      format: "Alphanumeric/dash/underscore token between 16 and 256 characters",
      negativeConstraints: [
        "Do not pass full verification URLs; extract only the token parameter.",
        "Do not pass raw email addresses."
      ]
    )
  ]

  /// Creates a `VerifyEmailRequestSchema` payload.
  public init(emailAccessToken: String) {
    self.emailAccessToken = emailAccessToken
  }

  /// Validates that `emailAccessToken` is a bare token without URL schemes or `@` symbols.
  public func validate() -> Result<String, AXProblemDetails> {
    let trimmed = self.emailAccessToken.trimmingCharacters(in: .whitespacesAndNewlines)
    let isValid = trimmed.count >= 16 && trimmed.count <= 256 && !trimmed.contains("://") && !trimmed.contains("@")
    guard isValid else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "emailAccessToken is malformed; expected bare token (16..256 chars) without URLs or '@' symbols.",
        suggestedAction: "Extract the 'email_access_token' query parameter from the verification link and pass only the token string.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(
          name: "emailAccessToken",
          reason: "Must be a 16..256 character bare token without URL schemes or '@'."
        )]
      ))
    }
    return .success(trimmed)
  }
}

/// Authenticated session contract returned after completing Sign in with Apple.
public struct AppleAuthSessionContract: Codable, Equatable, Sendable {
  /// Authenticated user identifier.
  public let userUid: String
  /// Issued Kickstarter API OAuth bearer token.
  public let apiAccessToken: String
  /// `true` when this response was replayed from the idempotency cache.
  public let idempotencyReplayed: Bool

  /// Creates an `AppleAuthSessionContract`.
  public init(userUid: String, apiAccessToken: String, idempotencyReplayed: Bool = false) {
    self.userUid = userUid
    self.apiAccessToken = apiAccessToken
    self.idempotencyReplayed = idempotencyReplayed
  }
}

