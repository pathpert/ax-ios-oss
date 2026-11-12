@testable import KsApi
@testable import KsApiTestHelpers
import Prelude
import XCTest

/// Unit tests covering `CreatePaymentSourceSetupIntentInputTests` behavior and contracts.
final class CreatePaymentSourceSetupIntentInputTests: XCTestCase {
  func testCreatePaymentSourceSetupIntentInputDictionary_WithValue_Success() {
    let createSetupIntentInput =
      CreatePaymentSourceSetupIntentInput(intentClientSecret: "UHJvamVjdC0yMzEyODc5ODc", reuseable: false)

    let input = createSetupIntentInput.toInputDictionary()

    XCTAssertEqual(input["intentClientSecret"] as? String, "UHJvamVjdC0yMzEyODc5ODc")
    XCTAssertEqual(input["reusable"] as? Bool, false)
  }
}
