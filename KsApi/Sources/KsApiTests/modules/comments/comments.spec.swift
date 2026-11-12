import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `CommentsModuleSpec` behavior and contracts.
final class CommentsModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-500".utf8).base64EncodedString()
  private let validParentCommentId = Data("Comment-600".utf8).base64EncodedString()
  private let validUserId = Data("User-700".utf8).base64EncodedString()
  private let validKey = "990e8400-e29b-41d4-a716-446655440000"

  func testPostComment_HappyPath_AndIdempotentReplay() {
    let controller = MockService(postCommentResult: .success(.replyTemplate))
      .makeAXCommentsController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = PostCommentRequestSchema(
      commentableId: self.validProjectId,
      body: "  Great project update!  ",
      parentId: self.validParentCommentId
    )

    let first = controller.handlePostComment(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.isReply, true)
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handlePostComment(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testBlockUser_HappyPath_ViaStranglerFigAdapter() {
    let controller = MockService(blockUserResult: .success(EmptyResponseEnvelope()))
      .makeAXCommentsController()

    let payload = BlockUserRequestSchema(blockUserId: self.validUserId)
    let result = controller.handleBlockUser(payload: payload, headers: ["Idempotency-Key": self.validKey])

    switch result {
    case let .success(res):
      XCTAssertEqual(res.statusCode, 200)
      XCTAssertTrue(res.body)
    case let .failure(problem):
      XCTFail("Expected blockUser to succeed, got: \(problem)")
    }
  }

  func testPostComment_RejectsScriptInjectionAndInvalidGraphIDs() {
    let controller = MockService().makeAXCommentsController()
    let invalidPayload = PostCommentRequestSchema(
      commentableId: "500",
      body: "<script>alert('xss')</script>",
      parentId: "not-a-comment-id"
    )

    guard case let .failure(problem) = controller.handlePostComment(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected Poka-Yoke boundary rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(Set(problem.invalidParams.map(\.name)), ["commentableId", "body", "parentId"])
  }

  func testLegacyCommentPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(PostCommentInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(BlockUserInput.axDeprecationDescriptor.deprecated)
  }
}

