import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Discovery Controller & Deprecation Guardrails

/// Agent-native REST controller for bounded project discovery queries.
///
/// Negative Constraint: Pagination is bounded by `DiscoveryQueryRequestSchema`; do not route agents through unbounded legacy `DiscoveryParams`.
public final class DiscoveryController {
  /// Endpoint metadata for `GET /ax/v1/discover`.
  public static let queryDiscoveryEndpoint = AXEndpointDescriptor(
    method: "GET",
    path: "/ax/v1/discover",
    summary: "Queries Kickstarter project discovery with bounded pagination (perPage <= 50) and concise agent-ready summaries.",
    requiresIdempotencyKey: false,
    deprecated: false
  )

  private let service: DiscoveryModuleService

  /// Creates a `DiscoveryController` backed by `service`.
  public init(service: DiscoveryModuleService) {
    self.service = service
  }

  /// Handles `GET /ax/v1/discover` and returns bounded `DiscoveryPageContract` summaries.
  public func handleQueryDiscovery(
    query: DiscoveryQueryRequestSchema
  ) -> Result<AXControllerResponse<DiscoveryPageContract>, AXProblemDetails> {
    self.service.queryDiscovery(schema: query).map { res in
      AXControllerResponse(
        statusCode: 200,
        headers: res.rateLimitHeaders.httpHeaders,
        body: res.value
      )
    }
  }
}

extension DiscoveryParams {
  /// Deprecation descriptor redirecting callers to `DiscoveryQueryRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "DiscoveryParams",
    meaning: "Legacy 22-field mutable struct with unbounded pagination and untyped queryParams dictionary.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows directly through DiscoveryParams.",
      "Do not request unbounded perPage values."
    ],
    deprecated: true,
    replacementPrimitive: "DiscoveryQueryRequestSchema via DiscoveryController.handleQueryDiscovery(query:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `DiscoveryController` backed by `self`.
  public func makeAXDiscoveryController(
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15
  ) -> DiscoveryController {
    let service = DiscoveryModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return DiscoveryController(service: service)
  }
}

