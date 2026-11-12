import Foundation
import KsApi

/// Protocol defining the analytics tracking client contract.
/// Prefer `track(event: TrackAnalyticsEventRequestSchema)` or `AnalyticsTelemetryController` in `Library/modules/analytics_telemetry`
/// over the legacy untyped `track(name:properties:)` method.
public protocol TrackingClientType {
  /**
   Tracks a strongly-typed, Poka-Yoke validated analytics event.

   - parameter event: Validated `TrackAnalyticsEventRequestSchema` contract.
   - returns: `.success(AnalyticsTelemetryContract)` when valid, or an RFC 9457 `.failure(AXProblemDetails)` if boundary validation fails.
   */
  @discardableResult
  func track(event: TrackAnalyticsEventRequestSchema) -> Result<AnalyticsTelemetryContract, AXProblemDetails>

  /**
   Tracks an event in our analytics system.

   - Note: `@deprecated` Do not pass untyped `[String: Any]?` property bags from new or agent-authored code; use `track(event: TrackAnalyticsEventRequestSchema)` or `AnalyticsTelemetryController` instead.
   - parameter name:       Name of the event.
   - parameter properties: Dictionary of properties associated with event.
   */
  @available(*, deprecated, message: "Use track(event: TrackAnalyticsEventRequestSchema) or AnalyticsTelemetryController instead.")
  func track(name: String, properties: [String: Any]?)
}

extension TrackingClientType {
  /// Validates `event` with `TrackAnalyticsEventRequestSchema` and forwards normalized properties to the underlying tracker.
  @discardableResult
  public func track(event: TrackAnalyticsEventRequestSchema) -> Result<AnalyticsTelemetryContract, AXProblemDetails> {
    switch event.validate() {
    case let .failure(problem):
      return .failure(problem)
    case let .success((validEventName, validContext, validProjectId, validCents)):
      var properties: [String: Any] = [
        "context_page": validContext.rawValue
      ]
      if let validProjectId = validProjectId {
        properties["project_pid"] = validProjectId
      }
      if let validCents = validCents {
        properties["pledge_amount_cents"] = validCents
      }
      self.track(name: validEventName, properties: properties)
      return .success(AnalyticsTelemetryContract(
        eventName: validEventName,
        pageContext: validContext.rawValue,
        projectId: validProjectId,
        pledgeAmountInCents: validCents,
        idempotencyReplayed: false
      ))
    }
  }
}
