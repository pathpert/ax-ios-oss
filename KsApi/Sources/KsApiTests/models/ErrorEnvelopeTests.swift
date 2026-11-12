@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `ErrorEnvelopeTests` behavior and contracts.
class ErrorEnvelopeTests: XCTestCase {
  func testJsonDecodingWithFullData() {
    let env: ErrorEnvelope = try! ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "access_token_invalid",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
    ])
    XCTAssertNotNil(env)
  }

  func testJsonDecodingWithBadKsrCode() {
    let env: ErrorEnvelope = try! ErrorEnvelope.decodeJSONDictionary([
      "error_messages": ["hello"],
      "ksr_code": "doesnt_exist",
      "http_code": 401,
      "exception": [
        "backtrace": ["hello"],
        "message": "hello"
      ]
    ])
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.ksrCode)
  }

  func testJsonDecodingWithNonStandardError() {
    let env: ErrorEnvelope = try! ErrorEnvelope.decodeJSONDictionary([
      "status": 406,
      "data": [
        "errors": [
          "amount": [
            "Bad amount"
          ]
        ]
      ]
    ])
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.ksrCode)
    XCTAssertEqual(["Bad amount"], env.errorMessages)
    XCTAssertEqual(406, env.httpCode)
  }

  func testJsonDecodingWithNonStandardErrorBackerReward() {
    let env: ErrorEnvelope = try! ErrorEnvelope.decodeJSONDictionary([
      "status": 406,
      "data": [
        "errors": [
          "backer_reward": [
            "Bad amount"
          ]
        ]
      ]
    ])
    XCTAssertNotNil(env)
    XCTAssertEqual(ErrorEnvelope.KsrCode.UnknownCode, env.ksrCode)
    XCTAssertEqual(["Bad amount"], env.errorMessages)
    XCTAssertEqual(406, env.httpCode)
  }

  func testAXRemediationFieldsAndProblemDetailsConversion() {
    let tfaEnvelope = ErrorEnvelope(
      errorMessages: ["Two-factor authentication code is required."],
      ksrCode: .TfaRequired,
      httpCode: 403,
      exception: nil
    )
    XCTAssertTrue(tfaEnvelope.isRetriable)
    XCTAssertTrue(tfaEnvelope.suggestedAction.contains("2FA"))

    let problem = tfaEnvelope.toAXProblemDetails(operation: "oauth_authorizations")
    XCTAssertEqual(problem.status, 403)
    XCTAssertTrue(problem.type.contains("oauth_authorizations"))
    XCTAssertTrue(problem.isRetriable)
    XCTAssertEqual(problem.suggestedAction, tfaEnvelope.suggestedAction)
    XCTAssertEqual(problem.invalidParams.count, 1)

    let validationEnvelope = ErrorEnvelope.validateCheckoutError(["Reward is no longer available"])
    XCTAssertFalse(validationEnvelope.isRetriable)
    XCTAssertTrue(validationEnvelope.suggestedAction.contains("CheckoutController"))
  }
}
