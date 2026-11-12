import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `PledgeManager_PledgeManagerFragmentTests` behavior and contracts.
final class PledgeManager_PledgeManagerFragmentTests: XCTestCase {
  func test() {
    let pmFragment: GraphAPI.PledgeManagerFragment = try! testGraphObject(
      jsonString:
      """
        {
              "__typename": "PledgeManager",
              "id": "UGxlZGdlTWFuYWdlci05MQ==",
              "acceptsNewBackers": true
        }
      """
    )

    let pledgeManager = PledgeManager(fromFragment: pmFragment)
    XCTAssertNotNil(pledgeManager)
    XCTAssertEqual(pledgeManager.id, 91)
    XCTAssertTrue(pledgeManager.acceptsNewBackers)
  }
}
