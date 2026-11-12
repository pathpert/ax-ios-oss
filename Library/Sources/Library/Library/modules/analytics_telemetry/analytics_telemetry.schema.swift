import Foundation
import KsApi

// MARK: - Rule 3: Poka-Yoke Schemas for Analytics Telemetry (Library)

/// Validated telemetry event payload for Segment analytics dispatch.
public struct TrackAnalyticsEventRequestSchema: Codable, Equatable, Sendable {
  /// Canonical Segment event name (e.g., `"Page Viewed"`).
  public let eventName: String
  /// Canonical `KSRAnalytics.PageContext` raw value identifying the originating screen.
  public let pageContext: String
  /// Optional positive project identifier associated with the event.
  public let projectId: Int?
  /// Optional positive pledge amount represented in integer cents.
  public let pledgeAmountInCents: Int?

  private static let allowedEvents: Set<String> = [
    "Page Viewed",
    "CTA Clicked",
    "Card Clicked",
    "Video Playback Started"
  ]

  /// AX field descriptors specifying telemetry constraints and negative constraints.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "eventName": .describe(
      field: "eventName",
      meaning: "Canonical Segment event name.",
      format: "Enum string: Page Viewed | CTA Clicked | Card Clicked | Video Playback Started",
      negativeConstraints: [
        "Do not pass arbitrary ad-hoc event strings.",
        "Do not pass untyped dictionary property bags directly to TrackingClientType."
      ]
    ),
    "pageContext": .describe(
      field: "pageContext",
      meaning: "Canonical KSRAnalytics.PageContext raw value indicating the originating screen.",
      format: "KSRAnalytics.PageContext raw string (e.g. discover, project, checkout, pledge)",
      negativeConstraints: [
        "Do not pass unvalidated screen names outside KSRAnalytics.PageContext."
      ]
    ),
    "pledgeAmountInCents": .describe(
      field: "pledgeAmountInCents",
      meaning: "Optional pledge amount in integer cents for checkout/pledge telemetry.",
      format: "Positive integer cents > 0 or nil",
      negativeConstraints: [
        "Do not pass floating-point currency values in analytics properties; use integer cents."
      ]
    )
  ]

  /// Creates an analytics telemetry request schema.
  public init(
    eventName: String,
    pageContext: String,
    projectId: Int? = nil,
    pledgeAmountInCents: Int? = nil
  ) {
    self.eventName = eventName
    self.pageContext = pageContext
    self.projectId = projectId
    self.pledgeAmountInCents = pledgeAmountInCents
  }

  /// Validates the event name allowlist, page context enum, and positive numeric bounds.
  public func validate() -> Result<(String, KSRAnalytics.PageContext, Int?, Int?), AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !Self.allowedEvents.contains(self.eventName) {
      let allowed = Self.allowedEvents.sorted().joined(separator: ", ")
      violations.append(AXInvalidParam(
        name: "eventName",
        reason: "Must be one of: \(allowed)."
      ))
    }

    let parsedContext = KSRAnalytics.PageContext(rawValue: self.pageContext)
    if parsedContext == nil {
      violations.append(AXInvalidParam(
        name: "pageContext",
        reason: "Unknown KSRAnalytics.PageContext '\(self.pageContext)'."
      ))
    }

    if let pid = self.projectId, pid <= 0 {
      violations.append(AXInvalidParam(
        name: "projectId",
        reason: "Must be a positive integer > 0 when provided."
      ))
    }

    if let cents = self.pledgeAmountInCents, cents <= 0 {
      violations.append(AXInvalidParam(
        name: "pledgeAmountInCents",
        reason: "Must be positive integer cents > 0 when provided."
      ))
    }

    guard violations.isEmpty, let validContext = parsedContext else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Analytics Telemetry Payload",
        status: 400,
        detail: "Analytics telemetry event failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide a valid Segment eventName, a registered KSRAnalytics.PageContext raw value, and integer cents.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success((self.eventName, validContext, self.projectId, self.pledgeAmountInCents))
  }
}

/// Contract returned after dispatching an analytics telemetry event.
public struct AnalyticsTelemetryContract: Codable, Equatable, Sendable {
  /// Dispatched Segment event name.
  public let eventName: String
  /// Validated `KSRAnalytics.PageContext` raw value.
  public let pageContext: String
  /// Associated project identifier, if provided.
  public let projectId: Int?
  /// Associated pledge amount in integer cents, if provided.
  public let pledgeAmountInCents: Int?
  /// Whether this dispatch replayed a previously executed idempotency key.
  public let idempotencyReplayed: Bool
}

