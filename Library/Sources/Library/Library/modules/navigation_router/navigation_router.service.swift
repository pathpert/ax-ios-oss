import Foundation
import KsApi

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Navigation.match & Navigation.deepLinkMatch

/// Legacy bridge protocol resolving URLs into `Navigation` enums or explicit 404 problem errors.
public protocol NavigationRouterLegacyBridgeProtocol {
  /// Resolves a deep-link or internal `URL` to a `Navigation` case.
  func resolve(url: URL, requireDeepLinkWhitelist: Bool) -> Result<Navigation, AXProblemDetails>
}

/// Default adapter delegating route matching to `Navigation.deepLinkMatch` and `Navigation.match`.
public final class LegacyNavigationRouterAdapter: NavigationRouterLegacyBridgeProtocol {
  /// Creates a stateless navigation router adapter.
  public init() {}

  /// Matches `url` against whitelisted deep-link or full internal route patterns, returning `404` on miss.
  public func resolve(url: URL, requireDeepLinkWhitelist: Bool) -> Result<Navigation, AXProblemDetails> {
    let matched = requireDeepLinkWhitelist ? Navigation.deepLinkMatch(url) : Navigation.match(url)
    // Rule 4: Never swallow unmatched routes as silent nil!
    guard let route = matched else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/unmatched-navigation-route",
        title: "Unmatched Navigation Route",
        status: 404,
        detail: "URL path '\(url.path)' did not match any registered \(requireDeepLinkWhitelist ? "deep-link" : "navigation") route template.",
        suggestedAction: "Verify the path structure (e.g. /discover, /activity, /projects/:creator/:project, /messages/:id) or set requireDeepLinkWhitelist=false for internal checkout routes.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "urlString", reason: "No matching route for path '\(url.path)'.")]
      ))
    }
    return .success(route)
  }
}

// MARK: - Rule 2 & Rule 5: Navigation Router Module Service

/// Rate-limited service resolving and describing deep-link navigation contracts.
public final class NavigationRouterModuleService {
  private let bridge: NavigationRouterLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Initializes the navigation service with bridge and rate-limit configuration.
  public init(
    bridge: NavigationRouterLegacyBridgeProtocol = LegacyNavigationRouterAdapter(),
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Validates `schema`, applies rate limiting, and resolves the matching `NavigationRouteContract`.
  public func resolveRoute(
    schema: ResolveDeepLinkRequestSchema
  ) -> Result<AXServiceResponse<NavigationRouteContract>, AXProblemDetails> {
    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) navigation resolutions exceeded.",
        suggestedAction: "Wait 15 seconds before resolving additional deep links.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().flatMap { url, whitelist in
      self.bridge.resolve(url: url, requireDeepLinkWhitelist: whitelist).map { nav in
        let contract = Self.describeNavigation(nav, url: url)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private static func describeNavigation(_ nav: Navigation, url: URL) -> NavigationRouteContract {
    switch nav {
    case let .tab(tab):
      return NavigationRouteContract(
        normalizedURL: url.absoluteString,
        routeCategory: "tab",
        targetDescription: "tab.\(tab)",
        requiresAuthentication: tab == .me || tab == .activity
      )
    case let .project(param, subpage, _, _):
      let requiresAuth: Bool
      if case .pledge(.manage) = subpage {
        requiresAuth = true
      } else if case .messageCreator = subpage {
        requiresAuth = true
      } else {
        requiresAuth = false
      }
      return NavigationRouteContract(
        normalizedURL: url.absoluteString,
        routeCategory: "project",
        targetDescription: "project(\(param.slug ?? String(param.id ?? 0))).\(subpage)",
        requiresAuthentication: requiresAuth
      )
    case let .messages(threadId):
      return NavigationRouteContract(
        normalizedURL: url.absoluteString,
        routeCategory: "messages",
        targetDescription: "messages(\(threadId))",
        requiresAuthentication: true
      )
    case let .checkout(checkoutId, subroute):
      return NavigationRouteContract(
        normalizedURL: url.absoluteString,
        routeCategory: "checkout",
        targetDescription: "checkout(\(checkoutId)).\(subroute)",
        requiresAuthentication: true
      )
    default:
      return NavigationRouteContract(
        normalizedURL: url.absoluteString,
        routeCategory: "other",
        targetDescription: "\(nav)",
        requiresAuthentication: false
      )
    }
  }
}

