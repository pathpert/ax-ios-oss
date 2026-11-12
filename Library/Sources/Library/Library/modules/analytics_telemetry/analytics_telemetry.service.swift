import Foundation
import KsApi

// MARK: - Rule 1: Strangler Fig Legacy Adapter for TrackingClientType

/// Legacy bridge protocol adapting `TrackingClientType` into structured `AXProblemDetails` results.
public protocol AnalyticsTelemetryLegacyBridgeProtocol {
  /// Dispatches a named analytics event with structured context metadata.
  func dispatchEvent(
    name: String,
    pageContext: KSRAnalytics.PageContext,
    projectId: Int?,
    pledgeAmountInCents: Int?
  ) -> Result<Void, AXProblemDetails>
}

/// Default bridge forwarding telemetry events into `TrackingClientType`.
public final class LegacyAnalyticsTelemetryAdapter: AnalyticsTelemetryLegacyBridgeProtocol {
  private let trackingClient: TrackingClientType

  /// Creates an adapter backed by the provided tracking client.
  public init(trackingClient: TrackingClientType) {
    self.trackingClient = trackingClient
  }

  /// Tracks an analytics event via the legacy tracking client using typed metadata keys.
  public func dispatchEvent(
    name: String,
    pageContext: KSRAnalytics.PageContext,
    projectId: Int?,
    pledgeAmountInCents: Int?
  ) -> Result<Void, AXProblemDetails> {
    var props = AnalyticsPropertyBag()
    props["context_page"] = pageContext.rawValue
    props["project_pid"] = projectId
    props["pledge_amount_cents"] = pledgeAmountInCents
    self.trackingClient.track(name: name, properties: props.rawDictionary)
    return .success(())
  }
}

// MARK: - Rule 2 & Rule 5: Analytics Telemetry Module Service

/// Rate-limited, idempotent service layer for dispatching AX analytics events.
/// - Negative Constraint: Do not reuse an `IdempotencyKey` across distinct telemetry payloads.
public final class AnalyticsTelemetryModuleService {
  private let bridge: AnalyticsTelemetryLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int
  private var idempotencyStore: [IdempotencyKey: (TrackAnalyticsEventRequestSchema, AnalyticsTelemetryContract)] = [:]

  /// Creates a telemetry service with custom bridge and rate-limit configuration.
  public init(
    bridge: AnalyticsTelemetryLegacyBridgeProtocol,
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Convenience initializer wrapping `TrackingClientType` in `LegacyAnalyticsTelemetryAdapter`.
  public convenience init(
    trackingClient: TrackingClientType,
    rateLimitMax: Int = 120,
    initialRemainingQuota: Int? = nil
  ) {
    self.init(
      bridge: LegacyAnalyticsTelemetryAdapter(trackingClient: trackingClient),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota
    )
  }

  /// Validates, rate-limits, deduplicates, and dispatches an analytics event schema.
  public func trackEvent(
    schema: TrackAnalyticsEventRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<AnalyticsTelemetryContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.idempotencyStore[idempotencyKey] {
      guard savedSchema == schema else {
        return .failure(AXProblemDetails(
          type: "https://docs.kickstarter.com/errors/idempotency-key-conflict",
          title: "Idempotency Key Reused With Different Payload",
          status: 409,
          detail: "Idempotency-Key '\(idempotencyKey.rawValue)' was already used for a different telemetry payload.",
          suggestedAction: "Generate a fresh UUID v4 Idempotency-Key for each distinct analytics event.",
          isRetriable: false
        ))
      }
      let replayed = AnalyticsTelemetryContract(
        eventName: contract.eventName,
        pageContext: contract.pageContext,
        projectId: contract.projectId,
        pledgeAmountInCents: contract.pledgeAmountInCents,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit exceeded on analytics_telemetry module.",
        suggestedAction: "Batch or throttle telemetry events and wait 15 seconds before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().flatMap { eventName, context, projectId, cents in
      self.bridge.dispatchEvent(
        name: eventName,
        pageContext: context,
        projectId: projectId,
        pledgeAmountInCents: cents
      ).map { _ in
        let contract = AnalyticsTelemetryContract(
          eventName: eventName,
          pageContext: context.rawValue,
          projectId: projectId,
          pledgeAmountInCents: cents,
          idempotencyReplayed: false
        )
        self.idempotencyStore[idempotencyKey] = (schema, contract)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }
}

