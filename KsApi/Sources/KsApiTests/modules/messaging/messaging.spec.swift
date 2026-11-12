import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `MessagingModuleSpec` behavior and contracts.
final class MessagingModuleSpec: XCTestCase {
  private let validKey = "440e8400-e29b-41d4-a716-446655440000"

  func testSendMessage_HappyPath_AndIdempotentReplay() {
    let controller = MockService().makeAXMessagingController(rateLimitMax: 5, initialRemainingQuota: 5)
    let payload = SendMessageRequestSchema(
      targetKind: .project,
      targetNumericId: 101,
      targetName: "Open Source Hardware Synth",
      body: "  Hello creator, does this ship to Thailand?  "
    )

    let first = controller.handleSendMessage(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.body, "Hello creator, does this ship to Thailand?")
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleSendMessage(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testSendMessage_BoundaryRejection_InvalidIdAndScriptPayload() {
    let controller = MockService().makeAXMessagingController()
    let invalidPayload = SendMessageRequestSchema(
      targetKind: .project,
      targetNumericId: 0,
      targetName: "Synth",
      body: "<script>stealCookies()</script>"
    )

    guard case let .failure(problem) = controller.handleSendMessage(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected Poka-Yoke rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(Set(problem.invalidParams.map(\.name)), ["targetNumericId", "body"])
  }

  func testLegacyMessagingPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(MessageSubject.axDeprecationDescriptor.deprecated)
  }
}

