@testable import KsApi
@testable import KsApiTestHelpers
import Prelude
import XCTest

/// Unit tests covering `CreateCheckoutInputTests` behavior and contracts.
final class CreateCheckoutInputTests: XCTestCase {
  func testCreateCheckoutInputDictionary() {
    let createCheckoutInput = CreateCheckoutInput(
      projectId: "projectId",
      amount: "200.00",
      locationId: "NY",
      rewardIds: ["rewardId"],
      refParam: "project"
    )

    let input = createCheckoutInput.toInputDictionary()

    XCTAssertEqual(input["projectId"] as? String, "projectId")
    XCTAssertEqual(input["amount"] as? String, "200.00")
    XCTAssertEqual(input["locationId"] as? String, "NY")
    XCTAssertEqual(input["rewardIds"] as? [String], ["rewardId"])
    XCTAssertEqual(input["refParam"] as? String, "project")
  }
}
