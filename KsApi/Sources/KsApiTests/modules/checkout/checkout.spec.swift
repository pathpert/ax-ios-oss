import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `CheckoutModuleSpec` behavior and contracts.
final class CheckoutModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-42".utf8).base64EncodedString()
  private let validRewardId = Data("Reward-99".utf8).base64EncodedString()
  private let validLocationId = Data("Location-7".utf8).base64EncodedString()
  private let validBackingId = Data("Backing-1".utf8).base64EncodedString()
  private let validIdempotencyKey = "550e8400-e29b-41d4-a716-446655440000"

  // MARK: - 1. Happy Path & Strangler Fig Adapter Verification (Rules 1, 2, 7)

  func testCreateCheckout_HappyPath_ViaStranglerFigAdapter() {
    let envelope = CreateCheckoutEnvelope(
      checkout: .init(
        id: "2026",
        paymentUrl: "https://www.kickstarter.com/checkouts/2026/payments",
        backingId: self.validBackingId
      )
    )
    let mockService = MockService(createCheckoutResult: .success(envelope))
    var recordedEvents: [AXMutationEvent] = []
    let controller = mockService.makeAXCheckoutController(
      rateLimitMax: 10,
      initialRemainingQuota: 10,
      onMutationHook: { recordedEvents.append($0) }
    )

    let payload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 2550,
      rewardIds: [self.validRewardId],
      locationId: self.validLocationId,
      refParam: "ax_agent_test"
    )

    let result = controller.handleCreateCheckout(
      payload: payload,
      headers: ["Idempotency-Key": self.validIdempotencyKey]
    )

    switch result {
    case let .success(response):
      XCTAssertEqual(response.statusCode, 201)
      XCTAssertEqual(response.body.checkoutId, "2026")
      XCTAssertEqual(response.body.backingId, self.validBackingId)
      XCTAssertEqual(response.body.amountInCents, 2550)
      XCTAssertFalse(response.body.idempotencyReplayed)
      XCTAssertEqual(response.headers["X-RateLimit-Limit"], "10")
      XCTAssertEqual(response.headers["X-RateLimit-Remaining"], "9")
      XCTAssertEqual(response.headers["Idempotency-Key"], self.validIdempotencyKey)
    case let .failure(problem):
      XCTFail("Expected checkout creation to succeed, got problem: \(problem)")
    }

    XCTAssertEqual(recordedEvents.count, 1)
    XCTAssertEqual(recordedEvents.first?.statusCode, 201)
    XCTAssertEqual(recordedEvents.first?.succeeded, true)
  }

  func testCancelBacking_HappyPath_ViaStranglerFigAdapter() {
    let mockService = MockService(cancelBackingResult: .success(EmptyResponseEnvelope()))
    let controller = mockService.makeAXCheckoutController()

    let result = controller.handleCancelBacking(
      payload: CancelBackingRequestSchema(backingId: self.validBackingId),
      headers: ["idempotency-key": self.validIdempotencyKey]
    )

    switch result {
    case let .success(response):
      XCTAssertEqual(response.statusCode, 200)
      XCTAssertTrue(response.body)
      XCTAssertEqual(response.headers["Idempotency-Key"], self.validIdempotencyKey)
    case let .failure(problem):
      XCTFail("Expected cancelBacking to succeed, got: \(problem)")
    }
  }

  // MARK: - 2. Poka-Yoke Boundary Validation & Schema Descriptors (Rule 3)

  func testSchemaDescriptors_EnforceMeaningFormatAndNegativeConstraints() {
    let descriptors = CreateCheckoutRequestSchema.fieldDescriptors
    XCTAssertEqual(descriptors.count, 4)

    for (name, descriptor) in descriptors {
      XCTAssertFalse(descriptor.meaning.isEmpty, "Field \(name) must have business meaning")
      XCTAssertFalse(descriptor.expectedFormat.isEmpty, "Field \(name) must have expected format")
      XCTAssertFalse(descriptor.negativeConstraints.isEmpty, "Field \(name) must have Negative Constraints")
      XCTAssertTrue(descriptor.negativeConstraints.allSatisfy { $0.hasPrefix("Do not") })
    }
  }

  func testCreateCheckout_BoundaryRejection_ReturnsDetailedInvalidParams() {
    let controller = MockService().makeAXCheckoutController()
    let invalidPayload = CreateCheckoutRequestSchema(
      projectId: "42",
      amountInCents: 50,
      rewardIds: [],
      locationId: "US-NY"
    )

    let result = controller.handleCreateCheckout(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validIdempotencyKey]
    )

    switch result {
    case .success:
      XCTFail("Expected Poka-Yoke boundary validation to reject invalid payload")
    case let .failure(problem):
      XCTAssertEqual(problem.status, 400)
      XCTAssertEqual(problem.title, "Invalid Parameter")
      XCTAssertEqual(problem.type, "https://docs.kickstarter.com/errors/invalid-parameter")
      XCTAssertFalse(problem.isRetriable)
      XCTAssertTrue(problem.suggestedAction.contains("integer cents >= 100"))
      XCTAssertEqual(Set(problem.invalidParams.map(\.name)), ["projectId", "amountInCents", "rewardIds", "locationId"])
    }
  }

  // MARK: - 3. In-Band Actionable Errors & RFC 9457 JSON Serialization (Rule 4)

  func testRFC9457ProblemDetails_JSONSerializationAndUpstreamTranslation() throws {
    let legacyError = ErrorEnvelope(
      errorMessages: ["Pledge amount is below minimum for selected reward"],
      ksrCode: .ValidateCheckoutError,
      httpCode: 200,
      exception: nil
    )
    let controller = MockService(createCheckoutResult: .failure(legacyError)).makeAXCheckoutController()
    let payload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 1000,
      rewardIds: [self.validRewardId]
    )

    guard case let .failure(problem) = controller.handleCreateCheckout(
      payload: payload,
      headers: ["Idempotency-Key": self.validIdempotencyKey]
    ) else {
      return XCTFail("Expected failure from upstream ErrorEnvelope")
    }

    XCTAssertEqual(problem.status, 422)
    XCTAssertEqual(problem.type, "https://docs.kickstarter.com/errors/checkout-validation-failed")
    XCTAssertFalse(problem.isRetriable)
    XCTAssertFalse(problem.suggestedAction.isEmpty)

    let jsonData = try JSONEncoder().encode(problem)
    let decodedJSON = try JSONDecoder().decode([String: AnyDecodableValue].self, from: jsonData)
    XCTAssertEqual(decodedJSON["type"], .string("https://docs.kickstarter.com/errors/checkout-validation-failed"))
    XCTAssertEqual(decodedJSON["title"], .string("Checkout Validation Failed"))
    XCTAssertEqual(decodedJSON["status"], .int(422))
    XCTAssertEqual(decodedJSON["is_retriable"], .bool(false))
    XCTAssertNotNil(decodedJSON["suggested_action"])
    XCTAssertNotNil(decodedJSON["invalid_params"])
  }

  // MARK: - 4. Machine-Tempo Safety: Idempotency & Rate Limits (Rule 5)

  func testIdempotency_MissingOrMalformedHeader_RejectedWithActionableError() {
    let controller = MockService().makeAXCheckoutController()
    let payload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 1500,
      rewardIds: [self.validRewardId]
    )

    if case let .failure(problem) = controller.handleCreateCheckout(payload: payload, headers: [:]) {
      XCTAssertEqual(problem.status, 400)
      XCTAssertEqual(problem.type, "https://docs.kickstarter.com/errors/missing-idempotency-key")
      XCTAssertTrue(problem.isRetriable)
      XCTAssertEqual(problem.invalidParams.first?.name, "Idempotency-Key")
    } else {
      XCTFail("Expected missing Idempotency-Key to fail")
    }

    if case let .failure(problem) = controller.handleCreateCheckout(
      payload: payload,
      headers: ["Idempotency-Key": "not-a-uuid-123"]
    ) {
      XCTAssertEqual(problem.status, 400)
      XCTAssertEqual(problem.type, "https://docs.kickstarter.com/errors/invalid-idempotency-key")
      XCTAssertFalse(problem.isRetriable)
    } else {
      XCTFail("Expected malformed Idempotency-Key to fail")
    }
  }

  func testIdempotency_ReplayAndConflictDetection() {
    let envelope = CreateCheckoutEnvelope(
      checkout: .init(id: "3001", paymentUrl: "https://ksr.com/pay", backingId: self.validBackingId)
    )
    let controller = MockService(createCheckoutResult: .success(envelope))
      .makeAXCheckoutController(rateLimitMax: 5, initialRemainingQuota: 5)
    let payload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 2000,
      rewardIds: [self.validRewardId]
    )

    let first = controller.handleCreateCheckout(payload: payload, headers: ["Idempotency-Key": self.validIdempotencyKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)
    XCTAssertEqual(try? first.get().headers["X-RateLimit-Remaining"], "4")

    let replay = controller.handleCreateCheckout(payload: payload, headers: ["Idempotency-Key": self.validIdempotencyKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")

    let mutatedPayload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 5000,
      rewardIds: [self.validRewardId]
    )
    if case let .failure(problem) = controller.handleCreateCheckout(
      payload: mutatedPayload,
      headers: ["Idempotency-Key": self.validIdempotencyKey]
    ) {
      XCTAssertEqual(problem.status, 409)
      XCTAssertEqual(problem.type, "https://docs.kickstarter.com/errors/idempotency-conflict")
      XCTAssertFalse(problem.isRetriable)
    } else {
      XCTFail("Expected 409 Conflict when reusing Idempotency-Key with different payload")
    }
  }

  func testRateLimitExceeded_Returns429WithRetryAfterSignal() {
    let controller = MockService().makeAXCheckoutController(
      rateLimitMax: 10,
      initialRemainingQuota: 0,
      retryAfterSeconds: 45
    )
    let payload = CreateCheckoutRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 2000,
      rewardIds: [self.validRewardId]
    )

    if case let .failure(problem) = controller.handleCreateCheckout(
      payload: payload,
      headers: ["Idempotency-Key": self.validIdempotencyKey]
    ) {
      XCTAssertEqual(problem.status, 429)
      XCTAssertTrue(problem.isRetriable)
      XCTAssertEqual(problem.rateLimitHeaders?.httpHeaders["X-RateLimit-Limit"], "10")
      XCTAssertEqual(problem.rateLimitHeaders?.httpHeaders["X-RateLimit-Remaining"], "0")
      XCTAssertEqual(problem.rateLimitHeaders?.httpHeaders["Retry-After"], "45")
      XCTAssertTrue(problem.suggestedAction.contains("45 seconds"))
    } else {
      XCTFail("Expected 429 Rate Limit Exceeded")
    }
  }

  // MARK: - 5. Loud Deprecation Metadata Verification (Rule 6)

  func testLegacyPrimitives_ExposeExplicitDeprecationMetadata() {
    XCTAssertTrue(CreateCheckoutInput.axDeprecationDescriptor.deprecated)
    XCTAssertEqual(
      CreateCheckoutInput.axDeprecationDescriptor.replacementPrimitive,
      "CreateCheckoutRequestSchema via CheckoutController.handleCreateCheckout(payload:headers:)"
    )
    XCTAssertTrue(CancelBackingInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(CheckoutController.legacyCreateCheckoutEndpoint.deprecated)
  }
}

private enum AnyDecodableValue: Decodable, Equatable {
  case string(String), int(Int), bool(Bool), other

  init(from decoder: Decoder) throws {
    let container = try decoder.singleValueContainer()
    if let s = try? container.decode(String.self) { self = .string(s) }
    else if let i = try? container.decode(Int.self) { self = .int(i) }
    else if let b = try? container.decode(Bool.self) { self = .bool(b) }
    else { self = .other }
  }
}
