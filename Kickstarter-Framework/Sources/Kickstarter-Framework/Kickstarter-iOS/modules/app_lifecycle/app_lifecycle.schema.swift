import Foundation
import KsApi
import Library

// MARK: - Rule 3: Poka-Yoke Schemas for App & Scene Lifecycle Coordination (Kickstarter-Framework)

/// Request schema validating a home-screen quick-action shortcut identifier.
public struct TriggerHomeScreenShortcutRequestSchema: Codable, Equatable, Sendable {
  /// Registered `ShortcutItem` type string.
  public let shortcutType: String

  private static let allowedShortcuts: Set<String> = [
    "projects_we_love",
    "recommended_for_you",
    "search"
  ]

  /// AX metadata descriptors explaining valid values and constraints for `shortcutType`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "shortcutType": .describe(
      field: "shortcutType",
      meaning: "Canonical UIApplicationShortcutItem type identifier registered in Info.plist.",
      format: "Enum string: projects_we_love | recommended_for_you | search",
      negativeConstraints: [
        "Do not pass arbitrary unvalidated shortcut item strings (legacy SceneDelegateViewModel silently drops unknown shortcuts via .skipNil())."
      ]
    )
  ]

  /// Creates a shortcut invocation request schema.
  public init(shortcutType: String) {
    self.shortcutType = shortcutType
  }

  /// Validates `shortcutType` and maps it to a typed `ShortcutItem` or RFC 9457 error.
  public func validate() -> Result<ShortcutItem, AXProblemDetails> {
    let trimmed = self.shortcutType.trimmingCharacters(in: .whitespacesAndNewlines)
    guard let item = ShortcutItem(typeString: trimmed) else {
      let allowed = Self.allowedShortcuts.sorted().joined(separator: ", ")
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Home Screen Shortcut",
        status: 400,
        detail: "Shortcut type '\(self.shortcutType)' is not a registered ShortcutItem.",
        suggestedAction: "Pass one of the registered ShortcutItem type strings: \(allowed).",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "shortcutType", reason: "Must be one of: \(allowed).")]
      ))
    }
    return .success(item)
  }
}

/// Request schema validating a universal link URL for profile email verification.
public struct VerifyEmailSceneLinkRequestSchema: Codable, Equatable, Sendable {
  /// Full HTTPS Kickstarter verification URL containing an `at` query parameter.
  public let verificationURLString: String

  /// AX metadata descriptors for `verificationURLString`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "verificationURLString": .describe(
      field: "verificationURLString",
      meaning: "Universal link URL targeting /profile/verify_email with an at= token query parameter.",
      format: "https://www.kickstarter.com/profile/verify_email?at=<token>",
      negativeConstraints: [
        "Do not pass URLs missing the 'at' access_token query parameter.",
        "Do not pass non-Kickstarter URLs."
      ]
    )
  ]

  /// Creates an email-verification scene link request schema.
  public init(verificationURLString: String) {
    self.verificationURLString = verificationURLString
  }

  /// Validates the Kickstarter host, `/profile/verify_email` route, and `at` token parameter.
  public func validate() -> Result<(URL, String), AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    let trimmed = self.verificationURLString.trimmingCharacters(in: .whitespacesAndNewlines)

    guard
      let url = URL(string: trimmed),
      url.scheme?.lowercased() == "https",
      let host = url.host?.lowercased(),
      host == "www.kickstarter.com" || host == "kickstarter.com"
    else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Email Verification Link",
        status: 400,
        detail: "URL '\(self.verificationURLString)' is not a valid https://www.kickstarter.com link.",
        suggestedAction: "Provide a valid https://www.kickstarter.com/profile/verify_email?at=<token> URL.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "verificationURLString", reason: "Must be an https://kickstarter.com URL.")]
      ))
    }

    if Navigation.match(url) != .profile(.verifyEmail) {
      violations.append(AXInvalidParam(
        name: "verificationURLString",
        reason: "URL path must match /profile/verify_email."
      ))
    }

    let components = URLComponents(url: url, resolvingAgainstBaseURL: false)
    let token = components?.queryItems?.first(where: { $0.name == "at" })?.value?
      .trimmingCharacters(in: .whitespacesAndNewlines)

    if token == nil || (token?.count ?? 0) < 6 {
      violations.append(AXInvalidParam(
        name: "verificationURLString",
        reason: "Query parameter 'at' (verification access token) is required and must be >= 6 chars."
      ))
    }

    guard violations.isEmpty, let validToken = token else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Email Verification Link",
        status: 400,
        detail: "Email verification universal link failed Poka-Yoke boundary validation.",
        suggestedAction: "Include path /profile/verify_email and query parameter ?at=<token> (>= 6 chars).",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success((url, validToken))
  }
}

/// Structured navigation response returned after handling a home-screen shortcut action.
public struct SceneShortcutNavigationContract: Codable, Equatable, Sendable {
  /// Shortcut type string that triggered navigation.
  public let shortcutType: String
  /// Resolved root tab bar destination identifier.
  public let destinationTab: String
  /// Whether the Staff Picks filter was enabled on the destination discovery tab.
  public let staffPicksFilter: Bool
  /// Whether the Recommended filter was enabled on the destination discovery tab.
  public let recommendedFilter: Bool
}

/// Structured verification result contract returned for email verification scene links.
public struct EmailVerificationSceneContract: Codable, Equatable, Sendable {
  /// The canonical verified URL string that was processed.
  public let verifiedURL: String
  /// Server-supplied confirmation or error message.
  public let message: String
  /// `true` when email verification succeeded.
  public let isVerified: Bool
  /// `true` when this response was served from an idempotent replay cache.
  public let idempotencyReplayed: Bool
}

