import GraphAPI
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `GraphAPI_DeletePaymentSourceInput_DeletePaymentSourceInputTests` behavior and contracts.
class GraphAPI_DeletePaymentSourceInput_DeletePaymentSourceInputTests: XCTestCase {
  func testDeletePaymentSourceInputCreation_WithValidData_Success() {
    let input = PaymentSourceDeleteInput(paymentSourceId: "69021330")

    let graphInput = GraphAPI.PaymentSourceDeleteInput.from(input)

    XCTAssertEqual(graphInput.paymentSourceId, "69021330")
  }
}
