import GraphAPI
import XCTest

final class GraphScalarsModuleSpec: XCTestCase {
  func testValidateScalars_HappyPath() {
    let controller = GraphScalarsController(service: GraphScalarsModuleService(rateLimitMax: 10))
    let resp = controller.handleValidateScalars(
      request: ValidateGraphScalarsRequestSchema(
        iso8601DateTime: "2026-11-11T14:00:00Z",
        email: "Creator@Kickstarter.com",
        jsonObjectString: #"{"theme":"dark","version":2}"#
      )
    )
    XCTAssertEqual(resp.statusCode, 200)
    XCTAssertEqual(resp.body?.normalizedEmail, "creator@kickstarter.com")
    XCTAssertEqual(resp.body?.jsonKeyCount, 2)
    XCTAssertEqual(resp.headers["X-RateLimit-Remaining"], "9")
  }

  func testValidateScalars_RejectsMalformedISOEmailAndJSON() {
    let controller = GraphScalarsController()
    let resp = controller.handleValidateScalars(
      request: ValidateGraphScalarsRequestSchema(
        iso8601DateTime: "11/11/2026",
        email: "not-an-email",
        jsonObjectString: "[1, 2, 3]"
      )
    )
    XCTAssertEqual(resp.statusCode, 400)
    XCTAssertEqual(resp.problem?.invalidParams.count, 3)
  }
}

