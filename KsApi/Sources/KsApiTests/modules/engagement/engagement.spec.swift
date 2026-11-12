import Foundation
import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `EngagementModuleSpec` behavior and contracts.
final class EngagementModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-1313717082".utf8).base64EncodedString()
  private let validKey = "cc0e8400-e29b-41d4-a716-446655440000"

  func testWatchAndUnwatchProject_HappyPath_AndIdempotentReplay() {
    let controller = MockService(
      unwatchProjectMutationResult: .success(.unwatchTemplate),
      watchProjectMutationResult: .success(.watchTemplate)
    ).makeAXEngagementController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = WatchProjectRequestSchema(projectId: self.validProjectId, trackingContext: "discovery_feed")

    let firstWatch = controller.handleWatchProject(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? firstWatch.get().statusCode, 201)
    XCTAssertEqual(try? firstWatch.get().body.watchesCount, 10)
    XCTAssertEqual(try? firstWatch.get().body.idempotencyReplayed, false)

    let replayWatch = controller.handleWatchProject(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replayWatch.get().statusCode, 200)
    XCTAssertEqual(try? replayWatch.get().body.idempotencyReplayed, true)

    let unwatchResult = controller.handleUnwatchProject(
      payload: payload,
      headers: ["Idempotency-Key": "dd0e8400-e29b-41d4-a716-446655440000"]
    )
    XCTAssertEqual(try? unwatchResult.get().statusCode, 200)
    XCTAssertEqual(try? unwatchResult.get().body.watchesCount, 9)
  }

  func testCreateFlagging_HappyPath_AndBoundaryValidation() {
    let controller = MockService(createFlaggingResult: .success(EmptyResponseEnvelope()))
      .makeAXEngagementController()

    let validFlagging = CreateFlaggingRequestSchema(
      contentId: self.validProjectId,
      kind: .spam,
      details: "Automated spam link campaign"
    )
    let successResult = controller.handleCreateFlagging(
      payload: validFlagging,
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? successResult.get().statusCode, 201)

    let invalidFlagging = CreateFlaggingRequestSchema(
      contentId: "9999",
      kind: .spam,
      details: "   "
    )
    guard case let .failure(problem) = controller.handleCreateFlagging(
      payload: invalidFlagging,
      headers: ["Idempotency-Key": "ee0e8400-e29b-41d4-a716-446655440000"]
    ) else {
      return XCTFail("Expected Poka-Yoke boundary rejection on invalid flagging payload")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(Set(problem.invalidParams.map(\.name)), ["contentId", "details"])
  }

  func testLegacyEngagementPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(WatchProjectInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(CreateFlaggingInput.axDeprecationDescriptor.deprecated)
  }
}

