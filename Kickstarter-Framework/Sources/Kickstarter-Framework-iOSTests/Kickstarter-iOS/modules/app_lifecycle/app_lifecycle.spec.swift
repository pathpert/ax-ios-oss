@testable import Kickstarter_Framework
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `AppLifecycleModuleSpec` behavior and contracts.
final class AppLifecycleModuleSpec: XCTestCase {
  func testTriggerShortcutAndVerifyEmailLink_HappyPath() {
    let mockApi = MockService(
      verifyEmailResult: .success(EmailVerificationResponseEnvelope(message: "Email verified!"))
    )
    let adapter = LegacyAppLifecycleAdapter(apiService: mockApi)
    let service = AppLifecycleModuleService(bridge: adapter, rateLimitMax: 10)
    let controller = AppLifecycleController(service: service)

    let shortcutResp = try? controller.handleTriggerShortcut(
      request: TriggerHomeScreenShortcutRequestSchema(shortcutType: "projects_we_love")
    ).get()
    XCTAssertEqual(shortcutResp?.statusCode, 200)
    XCTAssertEqual(shortcutResp?.body.destinationTab, "discovery")
    XCTAssertEqual(shortcutResp?.body.staffPicksFilter, true)

    let headers = ["Idempotency-Key": "e5e5e5e5-1111-4222-8333-444444444444"]
    let verifyReq = VerifyEmailSceneLinkRequestSchema(
      verificationURLString: "https://www.kickstarter.com/profile/verify_email?at=valid_token_12345"
    )
    let verifyResp = try? controller.handleVerifyEmailSceneLink(headers: headers, request: verifyReq).get()
    XCTAssertEqual(verifyResp?.statusCode, 201)
    XCTAssertEqual(verifyResp?.body.isVerified, true)
    XCTAssertEqual(verifyResp?.body.message, "Email verified!")

    let replayResp = try? controller.handleVerifyEmailSceneLink(headers: headers, request: verifyReq).get()
    XCTAssertEqual(replayResp?.statusCode, 200)
    XCTAssertEqual(replayResp?.body.idempotencyReplayed, true)
  }

  func testAppLifecycle_BoundaryRejections() {
    let controller = AppLifecycleController(
      service: AppLifecycleModuleService(bridge: LegacyAppLifecycleAdapter(apiService: MockService()))
    )

    let badShortcut = controller.handleTriggerShortcut(
      request: TriggerHomeScreenShortcutRequestSchema(shortcutType: "unknown_shortcut")
    )
    guard case let .failure(shortcutProblem) = badShortcut else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(shortcutProblem.status, 400)
    XCTAssertEqual(shortcutProblem.invalidParams.first?.name, "shortcutType")

    let missingTokenLink = controller.handleVerifyEmailSceneLink(
      headers: ["Idempotency-Key": "e5e5e5e5-2222-4222-8333-555555555555"],
      request: VerifyEmailSceneLinkRequestSchema(
        verificationURLString: "https://www.kickstarter.com/profile/verify_email"
      )
    )
    guard case let .failure(linkProblem) = missingTokenLink else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(linkProblem.status, 400)
    XCTAssertEqual(linkProblem.invalidParams.first?.name, "verificationURLString")
  }
}
