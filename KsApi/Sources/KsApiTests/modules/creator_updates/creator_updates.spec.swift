import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `CreatorUpdatesModuleSpec` behavior and contracts.
final class CreatorUpdatesModuleSpec: XCTestCase {
  private let validKey = "120e8400-e29b-41d4-a716-446655440000"

  func testUpdateAndPublishDraft_HappyPath_AndIdempotentReplay() {
    let controller = MockService().makeAXCreatorUpdatesController(rateLimitMax: 5, initialRemainingQuota: 5)
    let updatePayload = UpdateCreatorDraftRequestSchema(
      draftId: 10,
      projectId: 20,
      title: "  Milestone 1 Reached!  ",
      body: "Tooling has started.",
      isPublic: true
    )

    let firstUpdate = controller.handleUpdateDraft(
      payload: updatePayload,
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? firstUpdate.get().statusCode, 200)
    XCTAssertEqual(try? firstUpdate.get().body.title, "Milestone 1 Reached!")
    XCTAssertEqual(try? firstUpdate.get().body.idempotencyReplayed, false)

    let replayUpdate = controller.handleUpdateDraft(
      payload: updatePayload,
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? replayUpdate.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replayUpdate.get().headers["X-RateLimit-Remaining"], "4")

    let publishResult = controller.handlePublishDraft(
      payload: PublishCreatorDraftRequestSchema(draftId: 10, projectId: 20),
      headers: ["Idempotency-Key": "130e8400-e29b-41d4-a716-446655440000"]
    )
    XCTAssertEqual(try? publishResult.get().statusCode, 201)
  }

  func testUpdateDraft_BoundaryRejection_InvalidIdsAndScriptInjection() {
    let controller = MockService().makeAXCreatorUpdatesController()
    let invalidPayload = UpdateCreatorDraftRequestSchema(
      draftId: 0,
      projectId: -1,
      title: "   ",
      body: "<script>evil()</script>",
      isPublic: false
    )

    guard case let .failure(problem) = controller.handleUpdateDraft(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected Poka-Yoke boundary rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(Set(problem.invalidParams.map(\.name)), ["draftId", "projectId", "title", "body"])
  }

  func testLegacyUpdateDraft_ExposeDeprecationMetadata() {
    XCTAssertTrue(UpdateDraft.axDeprecationDescriptor.deprecated)
  }
}

