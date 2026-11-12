import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `DiscoveryModuleSpec` behavior and contracts.
final class DiscoveryModuleSpec: XCTestCase {
  func testQueryDiscovery_HappyPath_ReturnsConciseProjectSummaries() {
    let envelope = DiscoveryEnvelope.template
    let controller = MockService(fetchDiscoveryResponse: envelope)
      .makeAXDiscoveryController(rateLimitMax: 10, initialRemainingQuota: 10)

    let request = DiscoveryQueryRequestSchema(
      query: "tabletop rpg",
      state: "live",
      sort: "magic",
      page: 1,
      perPage: 15,
      staffPicks: true
    )

    let result = controller.handleQueryDiscovery(query: request)
    switch result {
    case let .success(res):
      XCTAssertEqual(res.statusCode, 200)
      XCTAssertEqual(res.body.projects.count, envelope.projects.count)
      XCTAssertEqual(res.body.totalCount, envelope.stats.count)
      XCTAssertEqual(res.headers["X-RateLimit-Remaining"], "9")
    case let .failure(problem):
      XCTFail("Expected discovery query to succeed, got: \(problem)")
    }
  }

  func testQueryDiscovery_BoundaryRejection_RejectsUnboundedPerPageAndInvalidEnums() {
    let controller = MockService().makeAXDiscoveryController()
    let invalidRequest = DiscoveryQueryRequestSchema(
      query: "   ",
      state: "invalid_state",
      sort: "DROP TABLE projects",
      page: 0,
      perPage: 500
    )

    guard case let .failure(problem) = controller.handleQueryDiscovery(query: invalidRequest) else {
      return XCTFail("Expected Poka-Yoke boundary rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(
      Set(problem.invalidParams.map(\.name)),
      ["query", "state", "sort", "page", "perPage"]
    )
  }

  func testLegacyDiscoveryParams_ExposeDeprecationMetadata() {
    XCTAssertTrue(DiscoveryParams.axDeprecationDescriptor.deprecated)
  }
}

