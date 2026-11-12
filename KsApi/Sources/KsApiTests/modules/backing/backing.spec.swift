import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `BackingModuleSpec` behavior and contracts.
final class BackingModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-101".utf8).base64EncodedString()
  private let validRewardId = Data("Reward-202".utf8).base64EncodedString()
  private let validBackingId = Data("Backing-303".utf8).base64EncodedString()
  private let validKey = "770e8400-e29b-41d4-a716-446655440000"

  func testCreateBacking_HappyPath_AndIdempotentReplay() {
    let checkout = Checkout(
      id: "chk_900",
      state: .successful,
      backing: .init(clientSecret: "seti_123_secret_abc", requiresAction: false)
    )
    let envelope = CreateBackingEnvelope(createBacking: .init(checkout: checkout))
    let controller = MockService(createBackingResult: .success(envelope))
      .makeAXBackingController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = CreateBackingRequestSchema(
      projectId: self.validProjectId,
      amountInCents: 5000,
      rewardIds: [self.validRewardId],
      paymentSourceId: "src_card_1"
    )

    let first = controller.handleCreateBacking(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.checkoutId, "chk_900")
    XCTAssertEqual(try? first.get().body.state, "SUCCESSFUL")
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleCreateBacking(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testUpdateBacking_HappyPath_ViaStranglerFigAdapter() {
    let checkout = Checkout(
      id: "chk_901",
      state: .verifying,
      backing: .init(clientSecret: "pi_secret_xyz", requiresAction: true)
    )
    let envelope = UpdateBackingEnvelope(updateBacking: .init(checkout: checkout))
    let controller = MockService(updateBackingResult: .success(envelope)).makeAXBackingController()

    let payload = UpdateBackingRequestSchema(
      backingId: self.validBackingId,
      amountInCents: 7500,
      rewardIds: [self.validRewardId]
    )

    let result = controller.handleUpdateBacking(payload: payload, headers: ["Idempotency-Key": self.validKey])
    switch result {
    case let .success(res):
      XCTAssertEqual(res.statusCode, 200)
      XCTAssertEqual(res.body.checkoutId, "chk_901")
      XCTAssertTrue(res.body.requiresAction)
    case let .failure(problem):
      XCTFail("Expected updateBacking to succeed, got: \(problem)")
    }
  }

  func testCreateBacking_BoundaryRejections_MissingPaymentAndInvalidStripeSecret() {
    let controller = MockService().makeAXBackingController()
    let invalidPayload = CreateBackingRequestSchema(
      projectId: "raw-id",
      amountInCents: 20,
      rewardIds: [],
      paymentSourceId: nil,
      setupIntentClientSecret: "pk_test_not_a_seti_secret"
    )

    let result = controller.handleCreateBacking(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    )
    guard case let .failure(problem) = result else {
      return XCTFail("Expected Poka-Yoke rejection")
    }
    XCTAssertEqual(problem.status, 400)
    let names = Set(problem.invalidParams.map(\.name))
    XCTAssertTrue(names.contains("projectId"))
    XCTAssertTrue(names.contains("amountInCents"))
    XCTAssertTrue(names.contains("setupIntentClientSecret"))
  }

  func testUpdateBacking_EmptyMutableFields_RejectedWithActionableProblemDetails() {
    let controller = MockService().makeAXBackingController()
    let emptyUpdate = UpdateBackingRequestSchema(backingId: self.validBackingId)

    let result = controller.handleUpdateBacking(
      payload: emptyUpdate,
      headers: ["Idempotency-Key": self.validKey]
    )
    guard case let .failure(problem) = result else {
      return XCTFail("Expected empty updateBacking to fail")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "updateFields")
    XCTAssertFalse(problem.suggestedAction.isEmpty)
  }

  func testSchemaAndDeprecationDescriptors_PresentAndComplete() {
    for (_, desc) in CreateBackingRequestSchema.fieldDescriptors {
      XCTAssertFalse(desc.negativeConstraints.isEmpty)
    }
    XCTAssertTrue(CreateBackingInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(UpdateBackingInput.axDeprecationDescriptor.deprecated)
  }
}

