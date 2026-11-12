import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `AccountModuleSpec` behavior and contracts.
final class AccountModuleSpec: XCTestCase {
  private let validKey = "aa0e8400-e29b-41d4-a716-446655440000"

  func testChangeEmail_HappyPath_NormalizesEmailAndReplaysIdempotently() {
    let controller = MockService(changeEmailResult: .success(EmptyResponseEnvelope()))
      .makeAXAccountController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = ChangeEmailRequestSchema(
      newEmail: "  Agent.Builder@Kickstarter.COM ",
      currentPassword: "correct-horse-battery"
    )

    let first = controller.handleChangeEmail(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 200)
    XCTAssertEqual(try? first.get().body.updatedValue, "agent.builder@kickstarter.com")
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleChangeEmail(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testChangePassword_BoundaryValidation_RejectsWeakOrMismatchedPasswords() {
    let controller = MockService(changePasswordResult: .success(EmptyResponseEnvelope()))
      .makeAXAccountController()

    let invalidPayload = ChangePasswordRequestSchema(
      currentPassword: "short",
      newPassword: "short",
      newPasswordConfirmation: "different"
    )

    guard case let .failure(problem) = controller.handleChangePassword(
      payload: invalidPayload,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected weak/mismatched password to fail Poka-Yoke validation")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(
      Set(problem.invalidParams.map(\.name)),
      ["currentPassword", "newPassword", "newPasswordConfirmation"]
    )
  }

  func testChangeCurrency_HappyPath_AndUnsupportedCurrencyRejection() {
    let controller = MockService(changeCurrencyResult: .success(EmptyResponseEnvelope()))
      .makeAXAccountController()

    let validResult = controller.handleChangeCurrency(
      payload: ChangeCurrencyRequestSchema(chosenCurrency: "JPY"),
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? validResult.get().body.updatedValue, "JPY")

    let invalidResult = controller.handleChangeCurrency(
      payload: ChangeCurrencyRequestSchema(chosenCurrency: "$USD"),
      headers: ["Idempotency-Key": "bb0e8400-e29b-41d4-a716-446655440000"]
    )
    guard case let .failure(problem) = invalidResult else {
      return XCTFail("Expected currency symbol '$USD' to be rejected")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "chosenCurrency")
    XCTAssertTrue(problem.suggestedAction.contains("USD"))
  }

  func testLegacyAccountPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(ChangeEmailInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(ChangePasswordInput.axDeprecationDescriptor.deprecated)
    XCTAssertTrue(ChangeCurrencyInput.axDeprecationDescriptor.deprecated)
  }
}

