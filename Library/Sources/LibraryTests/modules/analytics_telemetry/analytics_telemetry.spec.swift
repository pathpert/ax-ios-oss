import KsApi
@testable import Library
@testable import LibraryTestHelpers
import XCTest

/// Unit tests covering `AnalyticsTelemetryModuleSpec` behavior and contracts.
final class AnalyticsTelemetryModuleSpec: XCTestCase {
  func testTrackEvent_HappyPathAndIdempotencyReplay() {
    let client = MockTrackingClient()
    let service = AnalyticsTelemetryModuleService(trackingClient: client, rateLimitMax: 10)
    let controller = AnalyticsTelemetryController(service: service)

    let headers = ["Idempotency-Key": "d4d4d4d4-1111-4222-8333-444444444444"]
    let request = TrackAnalyticsEventRequestSchema(
      eventName: "CTA Clicked",
      pageContext: "checkout",
      projectId: 501,
      pledgeAmountInCents: 2500
    )

    let firstResp = try? controller.handleTrackEvent(headers: headers, request: request).get()
    XCTAssertEqual(firstResp?.statusCode, 201)
    XCTAssertEqual(firstResp?.body.pledgeAmountInCents, 2500)
    XCTAssertEqual(client.tracks.count, 1)
    XCTAssertEqual(client.tracks.first?.event, "CTA Clicked")

    let replayResp = try? controller.handleTrackEvent(headers: headers, request: request).get()
    XCTAssertEqual(replayResp?.statusCode, 200)
    XCTAssertEqual(replayResp?.body.idempotencyReplayed, true)
    XCTAssertEqual(client.tracks.count, 1)
  }

  func testTrackEvent_RejectsInvalidEventAndContext() {
    let client = MockTrackingClient()
    let controller = AnalyticsTelemetryController(
      service: AnalyticsTelemetryModuleService(trackingClient: client)
    )

    let badResp = controller.handleTrackEvent(
      headers: ["Idempotency-Key": "d4d4d4d4-2222-4222-8333-555555555555"],
      request: TrackAnalyticsEventRequestSchema(
        eventName: "Untyped Random Event",
        pageContext: "unknown_screen",
        projectId: 0,
        pledgeAmountInCents: -100
      )
    )
    guard case let .failure(problem) = badResp else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.count, 4)
    XCTAssertEqual(client.tracks.count, 0)
  }

  func testTrackingClientType_TypedTrackSchemaContract() {
    let client: TrackingClientType = MockTrackingClient()
    let validResult = client.track(
      event: TrackAnalyticsEventRequestSchema(
        eventName: "Page Viewed",
        pageContext: "discover",
        projectId: 42,
        pledgeAmountInCents: 1500
      )
    )
    XCTAssertNotNil(try? validResult.get())

    let invalidResult = client.track(
      event: TrackAnalyticsEventRequestSchema(
        eventName: "Invalid Event",
        pageContext: "invalid_page"
      )
    )
    if case let .failure(problem) = invalidResult {
      XCTAssertEqual(problem.status, 400)
      XCTAssertFalse(problem.isRetriable)
    } else {
      XCTFail("Expected RFC 9457 problem details for invalid schema")
    }
  }
}
