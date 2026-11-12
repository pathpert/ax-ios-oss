import Foundation
import KsApi

/// Protocol defining the analytics tracking client contract.
/// Prefer `track(event: TrackAnalyticsEventRequestSchema)` or `AnalyticsTelemetryController` in `Library/modules/analytics_telemetry`
/// over calling `track(name:properties:)` directly.
public protocol TrackingClientType {
  /**
   Tracks a strongly-typed, Poka-Yoke validated analytics event.

   - parameter event: Validated `TrackAnalyticsEventRequestSchema` contract.
   - returns: `.success(AnalyticsTelemetryContract)` when valid, or an RFC 9457 `.failure(AXProblemDetails)` if boundary validation fails.
   */
  @discardableResult
  func track(event: TrackAnalyticsEventRequestSchema) -> Result<AnalyticsTelemetryContract, AXProblemDetails>

  /**
   Tracks an event with an `Encodable` property payload in our analytics system.

   - Note: Prefer `track(event: TrackAnalyticsEventRequestSchema)` or `AnalyticsTelemetryController` at feature boundaries.
   - parameter name:       Name of the event.
   - parameter properties: Typed `Codable` properties associated with the event.
   */
  func track<P: Codable>(name: String, properties: P?)
}

extension TrackingClientType {
  /// Validates `event` with `TrackAnalyticsEventRequestSchema` and forwards normalized properties to the underlying tracker.
  @discardableResult
  public func track(event: TrackAnalyticsEventRequestSchema) -> Result<AnalyticsTelemetryContract, AXProblemDetails> {
    switch event.validate() {
    case let .failure(problem):
      return .failure(problem)
    case let .success((validEventName, validContext, validProjectId, validCents)):
      var properties = AnalyticsPropertyBag()
      properties["context_page"] = validContext.rawValue
      properties["project_pid"] = validProjectId
      properties["pledge_amount_cents"] = validCents
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
