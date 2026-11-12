import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Project Discovery

/// Isolates legacy `ServiceType` discovery fetch calls behind `AXProblemDetails` errors.
public protocol DiscoveryLegacyBridgeProtocol {
  /// Fetches a page of discovered projects matching the given filter parameters.
  func fetchDiscovery(params: DiscoveryParams) -> Result<DiscoveryEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating project discovery queries to `ServiceType`.
public final class LegacyDiscoveryServiceAdapter: DiscoveryLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Executes `fetchDiscovery` synchronously and translates legacy errors.
  public func fetchDiscovery(params: DiscoveryParams) -> Result<DiscoveryEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.fetchDiscovery(params: params).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on fetchDiscovery"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "fetchDiscovery"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "fetchDiscovery")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Discovery Module Service (Rate Limit Guardrails)

/// Rate-limited service orchestrating project discovery queries into typed page contracts.
///
/// Negative Constraint: Exhausting `rateLimitMax` returns HTTP 429; queries are read-only and require no idempotency key.
public final class DiscoveryModuleService {
  private let bridge: DiscoveryLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int

  /// Creates a `DiscoveryModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: DiscoveryLegacyBridgeProtocol,
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15
  ) {
    self.init(
      bridge: LegacyDiscoveryServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Queries discovered projects using validated filters while enforcing rate-limit quota.
  public func queryDiscovery(
    schema: DiscoveryQueryRequestSchema
  ) -> Result<AXServiceResponse<DiscoveryPageContract>, AXProblemDetails> {
    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) discovery queries exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before querying discovery again.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().flatMap { params in
      self.bridge.fetchDiscovery(params: params).map { envelope in
        let summaries = envelope.projects.map { project in
          DiscoveryProjectSummaryContract(
            projectId: project.id,
            name: project.name,
            blurb: project.blurb,
            state: project.state.rawValue,
            pledged: project.stats.pledged,
            goal: project.stats.goal
          )
        }
        let page = DiscoveryPageContract(
          projects: summaries,
          totalCount: envelope.stats.count,
          moreProjectsUrl: envelope.urls.api.moreProjects
        )
        return AXServiceResponse(
          value: page,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }
}

