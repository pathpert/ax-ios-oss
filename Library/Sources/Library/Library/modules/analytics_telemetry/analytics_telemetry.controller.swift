import Foundation
import KsApi

// MARK: - Rule 2 & Rule 5: Analytics Telemetry Controller

/// AX boundary controller validating `Idempotency-Key` headers and forwarding analytics events to `TrackingClientType`.
/// - Negative Constraint: Do not record client telemetry directly from views when an AX contract endpoint exists.
public final class AnalyticsTelemetryController {
  /// AX endpoint metadata for tracking typed analytics events.
  public static let trackEventEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/library/analytics/track",
    summary: "Validates and dispatches a Poka-Yoke typed analytics event to TrackingClientType.",
    requiresIdempotencyKey: true
  )

  private let service: AnalyticsTelemetryModuleService

  /// Creates an analytics telemetry controller backed by `service`.
  public init(service: AnalyticsTelemetryModuleService) {
    self.service = service
  }

  /// Validates the `Idempotency-Key` header and records the typed analytics event.
  public func handleTrackEvent(
    headers: [String: String],
    request: TrackAnalyticsEventRequestSchema
  ) -> Result<AXControllerResponse<AnalyticsTelemetryContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.trackEvent(schema: request, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }
}
