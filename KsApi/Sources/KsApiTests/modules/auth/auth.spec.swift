import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `AuthModuleSpec` behavior and contracts.
final class AuthModuleSpec: XCTestCase {
  private let validKey = "ff0e8400-e29b-41d4-a716-446655440000"

  func testSignInWithApple_HappyPath_AndIdempotentReplay() {
    let envelope = SignInWithAppleEnvelope(
      signInWithApple: .init(apiAccessToken: "ksr_oauth_token_123", user: .init(uid: "usr_42"))
    )
    let controller = MockService(signInWithAppleResult: .success(envelope))
      .makeAXAuthController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = SignInWithAppleRequestSchema(
      iosAppBundleId: "com.kickstarter.kickstarter",
      authCode: "c9876543210abcdef",
      firstName: "Ada",
      lastName: "Lovelace"
    )

    let first = controller.handleSignInWithApple(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().body.userUid, "usr_42")
    XCTAssertEqual(try? first.get().body.idempotencyReplayed, false)

    let replay = controller.handleSignInWithApple(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().statusCode, 200)
    XCTAssertEqual(try? replay.get().body.idempotencyReplayed, true)
  }

  func testVerifyEmail_HappyPath_AndRejectsFullURLInTokenField() {
    let envelope = EmailVerificationResponseEnvelope(message: "Email verified")
    let controller = MockService(verifyEmailResult: .success(envelope)).makeAXAuthController()

    let validResult = controller.handleVerifyEmail(
      payload: VerifyEmailRequestSchema(emailAccessToken: "tok_verify_1234567890abcdef"),
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? validResult.get().body, "Email verified")

    let urlTokenResult = controller.handleVerifyEmail(
      payload: VerifyEmailRequestSchema(emailAccessToken: "https://kickstarter.com/verify?token=1234567890"),
      headers: ["Idempotency-Key": "110e8400-e29b-41d4-a716-446655440000"]
    )
    guard case let .failure(problem) = urlTokenResult else {
      return XCTFail("Expected full URL in emailAccessToken to be rejected")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "emailAccessToken")
  }

  func testLegacyAuthPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(SignInWithAppleInput.axDeprecationDescriptor.deprecated)
  }
}

