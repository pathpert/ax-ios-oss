import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `GraphAPI_UpdateUserProfileInput_UpdateUserProfileInputTests` behavior and contracts.
class GraphAPI_UpdateUserProfileInput_UpdateUserProfileInputTests: XCTestCase {
  func testChangeCurrency_WithNewCurrency_Success() {
    let input = ChangeCurrencyInput(chosenCurrency: "DKK")

    let graphInput = GraphAPI.UpdateUserProfileInput.from(input)

    XCTAssertEqual(graphInput.chosenCurrency.unwrapped?.value, GraphAPI.CurrencyCode.dkk)
  }
}
