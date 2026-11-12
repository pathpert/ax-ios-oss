import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `PledgeManagementModuleSpec` behavior and contracts.
final class PledgeManagementModuleSpec: XCTestCase {
  private let validCheckoutId = Data("Checkout-999".utf8).base64EncodedString()
  private let validPaymentSourceId = Data("PaymentSource-111".utf8).base64EncodedString()
  private let validKey = "140e8400-e29b-41d4-a716-446655440000"

  func testValidateCheckout_HappyPath_AndIdempotentReplay() {
    let envelope = ValidateCheckoutEnvelope(messages: ["Checkout valid"])
    let controller = MockService(validateCheckoutResult: .success(envelope))
      .makeAXPledgeManagementController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = ValidateCheckoutRequestSchema(
      checkoutId: self.validCheckoutId,
      paymentSourceId: self.validPaymentSourceId,
      paymentIntentClientSecret: "pi_12345_secret_67890"
    )

    let first = controller.handleValidateCheckout(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 200)
    XCTAssertEqual(try? first.get().body.isValid, true)
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleValidateCheckout(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testValidateCheckout_BoundaryRejection_InvalidSecretAndIds() {
    let controller = MockService().makeAXPledgeManagementController()
    let invalidPayload = ValidateCheckoutRequestSchema(
      checkoutId: "999",
      paymentSourceId: "4111-1111",
      paymentIntentClientSecret: "seti_wrong_prefix_secret_123"
    )

    guard case let .failure(problem) = controller.handleValidateCheckout(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected Poka-Yoke boundary rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(
      Set(problem.invalidParams.map(\.name)),
      ["checkoutId", "paymentSourceId", "paymentIntentClientSecret"]
    )
  }

  func testLegacyValidateCheckout_ExposeDeprecationMetadata() {
    XCTAssertTrue(ValidateCheckoutEnvelope.axDeprecationDescriptor.deprecated)
  }
}

