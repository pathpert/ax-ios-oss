import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `AttributionModuleSpec` behavior and contracts.
final class AttributionModuleSpec: XCTestCase {
  private let validProjectId = Data("Project-888".utf8).base64EncodedString()
  private let validDeviceId = "123e4567-e89b-12d3-a456-426614174000"
  private let validKey = "220e8400-e29b-41d4-a716-446655440000"
  private let validHexPushToken = String(repeating: "a1b2c3d4", count: 8) // 64 hex chars

  func testTriggerThirdPartyEvent_HappyPath_ConvertsCentsAndEnforcesIdempotency() {
    let controller = MockService(triggerThirdPartyEventResult: .success(EmptyResponseEnvelope()))
      .makeAXAttributionController(rateLimitMax: 5, initialRemainingQuota: 5)

    let payload = TriggerThirdPartyEventRequestSchema(
      deviceId: self.validDeviceId,
      eventName: "pledge_initiated",
      projectId: self.validProjectId,
      pledgeAmountInCents: 3500,
      shippingAmountInCents: 500
    )

    let first = controller.handleTriggerThirdPartyEvent(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? first.get().statusCode, 201)
    XCTAssertEqual(try? first.get().headers["X-RateLimit-Remaining"], "4")

    let replay = controller.handleTriggerThirdPartyEvent(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replay.get().headers["X-RateLimit-Remaining"], "4")
  }

  func testRegisterPushToken_HappyPath_AndRejectsBracketedNSDataDescription() {
    let controller = MockService().makeAXAttributionController()

    let validResult = controller.handleRegisterPushToken(
      payload: RegisterPushTokenRequestSchema(apnsHexToken: self.validHexPushToken),
      headers: ["Idempotency-Key": self.validKey]
    )
    XCTAssertEqual(try? validResult.get().statusCode, 200)
    XCTAssertEqual(try? validResult.get().body, self.validHexPushToken)

    let bracketedResult = controller.handleRegisterPushToken(
      payload: RegisterPushTokenRequestSchema(apnsHexToken: "<deadbeef 12345678>"),
      headers: ["Idempotency-Key": "330e8400-e29b-41d4-a716-446655440000"]
    )
    guard case let .failure(problem) = bracketedResult else {
      return XCTFail("Expected bracketed NSData token description to be rejected")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "apnsHexToken")
  }

  func testLegacyAttributionPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(TriggerThirdPartyEventInput.axDeprecationDescriptor.deprecated)
  }
}

