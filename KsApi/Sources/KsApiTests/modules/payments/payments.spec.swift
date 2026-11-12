import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `PaymentsModuleSpec` behavior and contracts.
final class PaymentsModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-55".utf8).base64EncodedString()
  private let validBackingId = Data("Backing-66".utf8).base64EncodedString()
  private let validCheckoutId = Data("Checkout-77".utf8).base64EncodedString()
  private let validPaymentSourceId = Data("PaymentSource-88".utf8).base64EncodedString()
  private let validKey = "880e8400-e29b-41d4-a716-446655440000"

  func testCreatePaymentIntent_HappyPath_AndIdempotentReplay() {
    let envelope = PaymentIntentEnvelope(clientSecret: "pi_3MtwBwLkdIwHu7ix28a3tqPa_secret_YrKJUKribcBjcG8HVhfZluoGH")
    let controller = MockService(createPaymentIntentResult: .success(envelope))
      .makeAXPaymentsController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = CreatePaymentIntentRequestSchema(
      projectId: self.validProjectId,
      backingId: self.validBackingId,
      checkoutId: self.validCheckoutId,
      amountInCents: 4200,
      digitalMarketingAttributed: true
    )

    let first = controller.handleCreatePaymentIntent(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.amountInCents, 4200)
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleCreatePaymentIntent(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testDeletePaymentSource_HappyPath_ViaStranglerFigAdapter() {
    let envelope = DeletePaymentMethodEnvelope(storedCards: [])
    let controller = MockService(deletePaymentMethodResult: .success(envelope)).makeAXPaymentsController()

    let payload = DeletePaymentSourceRequestSchema(paymentSourceId: self.validPaymentSourceId)
    let result = controller.handleDeletePaymentSource(payload: payload, headers: ["Idempotency-Key": self.validKey])

    switch result {
    case let .success(res):
      XCTAssertEqual(res.statusCode, 200)
      XCTAssertEqual(res.body.deletedPaymentSourceId, self.validPaymentSourceId)
      XCTAssertEqual(res.body.remainingStoredCardsCount, 0)
    case let .failure(problem):
      XCTFail("Expected deletePaymentSource to succeed, got: \(problem)")
    }
  }

  func testCreatePaymentIntent_BoundaryRejections_ReturnsRFC9457InvalidParams() {
    let controller = MockService().makeAXPaymentsController()
    let invalidPayload = CreatePaymentIntentRequestSchema(
      projectId: "55",
      backingId: "66",
      checkoutId: "77",
      amountInCents: 0
    )

    guard case let .failure(problem) = controller.handleCreatePaymentIntent(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected Poka-Yoke rejection")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(
      Set(problem.invalidParams.map(\.name)),
      ["projectId", "backingId", "checkoutId", "amountInCents"]
    )
  }

  func testDeletePaymentSource_InvalidGraphID_RejectedWithSuggestedAction() {
    let controller = MockService().makeAXPaymentsController()
    let invalidPayload = DeletePaymentSourceRequestSchema(paymentSourceId: "4242")

    guard case let .failure(problem) = controller.handleDeletePaymentSource(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected invalid paymentSourceId to fail")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "paymentSourceId")
    XCTAssertTrue(problem.suggestedAction.contains("PaymentSource-"))
  }

  func testLegacyPaymentPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(CreatePaymentIntentInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(PaymentSourceDeleteInput.axDeprecationDescriptor.deprecated)
  }
}

