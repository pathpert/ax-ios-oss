import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `GraphAPI_BackingState_BackingStateTests` behavior and contracts.
final class GraphAPI_BackingState_BackingStateTests: XCTestCase {
  func testErroredState_Success() {
    XCTAssertEqual(
      GraphAPI.BackingState(rawValue: "errored"),
      GraphAPI.BackingState.from(BackingState.errored)
    )
  }
}
