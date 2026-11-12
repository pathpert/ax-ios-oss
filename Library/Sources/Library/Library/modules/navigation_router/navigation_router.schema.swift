import Foundation
import KsApi

// MARK: - Rule 3: Poka-Yoke Schemas for Navigation & Deep-Link Resolution (Library)

/// Validated deep-link resolution request schema with domain and scheme allowlist enforcement.
///
/// Format: `urlString` must use `https://` or `ksr://` on an official Kickstarter host.
/// Negative Constraint: Do not disable `requireDeepLinkWhitelist` for untrusted universal links or push URLs.
public struct ResolveDeepLinkRequestSchema: Codable, Equatable, Sendable {
  /// Candidate URL string to resolve into an in-app navigation route.
  public let urlString: String
  /// Whether resolution is restricted to `Navigation.allDeepLinkRoutes`.
  public let requireDeepLinkWhitelist: Bool

  private static let allowedHosts: Set<String> = [
    "www.kickstarter.com",
    "kickstarter.com",
    "ksr.com"
  ]

  /// AX field descriptors documenting deep-link schema parameters and constraints.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "urlString": .describe(
      field: "urlString",
      meaning: "Fully-qualified Kickstarter URL to resolve into a typed Navigation route.",
      format: "https://www.kickstarter.com/... URL string",
      negativeConstraints: [
        "Do not pass non-Kickstarter external domains or javascript:/data: schemes.",
        "Do not pass relative path fragments without scheme and host."
      ]
    ),
    "requireDeepLinkWhitelist": .describe(
      field: "requireDeepLinkWhitelist",
      meaning: "Whether to enforce the strict deepLinkRoutes allowlist instead of allRoutes.",
      format: "Boolean",
      negativeConstraints: [
        "Do not disable requireDeepLinkWhitelist for untrusted external push/universal links."
      ]
    )
  ]

  /// Creates a deep-link resolution request.
  public init(urlString: String, requireDeepLinkWhitelist: Bool = true) {
    self.urlString = urlString
    self.requireDeepLinkWhitelist = requireDeepLinkWhitelist
  }

  /// Validates URL syntax, scheme (`https`/`ksr`), and Kickstarter host membership.
  public func validate() -> Result<(URL, Bool), AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    let trimmed = self.urlString.trimmingCharacters(in: .whitespacesAndNewlines)

    guard let url = URL(string: trimmed), let scheme = url.scheme?.lowercased(), let host = url.host?.lowercased() else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Deep-Link URL",
        status: 400,
        detail: "The provided urlString '\(self.urlString)' could not be parsed as a valid URL with scheme and host.",
        suggestedAction: "Pass a full https://www.kickstarter.com/... URL string.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "urlString", reason: "Must be a valid URL with scheme and host.")]
      ))
    }

    if scheme != "https" && scheme != "ksr" {
      violations.append(AXInvalidParam(
        name: "urlString",
        reason: "Unsupported URL scheme '\(scheme)'. Only 'https' and 'ksr' schemes are permitted."
      ))
    }

    if !Self.allowedHosts.contains(host) {
      violations.append(AXInvalidParam(
        name: "urlString",
        reason: "Untrusted host '\(host)'. Allowed hosts: \(Self.allowedHosts.sorted().joined(separator: ", "))."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Deep-Link URL",
        status: 400,
        detail: "Deep-link URL failed Poka-Yoke security and domain boundary checks.",
        suggestedAction: "Ensure urlString uses https:// and an official kickstarter.com host.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success((url, self.requireDeepLinkWhitelist))
  }
}

/// Typed route resolution result returned by `NavigationRouterController`.
public struct NavigationRouteContract: Codable, Equatable, Sendable {
  /// Normalized canonical URL string for the matched route.
  public let normalizedURL: String
  /// High-level route group name (e.g., `"project"`, `"discovery"`, `"checkout"`).
  public let routeCategory: String
  /// Human-readable description of the matched screen/destination.
  public let targetDescription: String
  /// Whether presenting the resolved screen requires a signed-in user session.
  public let requiresAuthentication: Bool
}

