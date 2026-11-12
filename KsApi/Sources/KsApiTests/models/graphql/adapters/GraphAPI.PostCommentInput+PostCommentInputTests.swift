import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `GraphAPI_PostCommentInput_PostCommentInputTests` behavior and contracts.
final class GraphAPI_PostCommentInput_PostCommentInputTests: XCTestCase {
  func test_validInput() {
    let input = PostCommentInput(body: "body", commentableId: "commentableId", parentId: "parentId")

    let graphInput = GraphAPI.PostCommentInput.from(input)

    XCTAssertEqual(graphInput.body, "body")
    XCTAssertEqual(graphInput.commentableId, "commentableId")
    XCTAssertEqual(graphInput.parentId, "parentId")
  }
}
