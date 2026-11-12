@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `BlockUserInputTests` behavior and contracts.
public class BlockUserInputTests: XCTestCase {
  func test_toInputDictionary() {
    let userId = "123"
    let input = BlockUserInput(blockUserId: userId)

    let dictionary = input.toInputDictionary()

    XCTAssertEqual(dictionary["blockUserId"] as! String, userId)
  }
}
