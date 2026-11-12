import Foundation
import KsApi

// MARK: - Rule 2: Navigation Router Controller

/// AX boundary controller resolving validated deep-link URLs into typed `NavigationRouteContract` values.
/// - Negative Constraint: Do not parse navigation routes with ad-hoc regexes in view controllers; route through `NavigationRouterController`.
public final class NavigationRouterController {
  /// AX endpoint metadata for resolving Kickstarter URLs into typed navigation routes.
  public static let resolveEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/library/navigation/resolve",
    summary: "Validates and resolves a Kickstarter URL into a strictly-typed NavigationRouteContract.",
    requiresIdempotencyKey: false
  )

  private let service: NavigationRouterModuleService

  /// Creates a navigation router controller backed by `service`.
  public init(service: NavigationRouterModuleService = NavigationRouterModuleService()) {
    self.service = service
  }

  /// Resolves a deep-link resolution request into a typed navigation contract or RFC 9457 error.
  public func handleResolveRoute(
    request: ResolveDeepLinkRequestSchema
  ) -> Result<AXControllerResponse<NavigationRouteContract>, AXProblemDetails> {
    self.service.resolveRoute(schema: request).map { response in
      AXControllerResponse(
        statusCode: 200,
        headers: response.rateLimitHeaders.httpHeaders,
        body: response.value
      )
    }
  }
}
