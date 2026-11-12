@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `NotificationsModuleSpec` behavior and contracts.
final class NotificationsModuleSpec: XCTestCase {
  func testUpdateNotificationAndClearUnseen_HappyPathAndReplay() {
    let mockService = MockService(
      clearUserUnseenActivityResult: .success(ClearUserUnseenActivityEnvelope(activityIndicatorCount: 0)),
      updateProjectNotificationResponse: ProjectNotification.template
    )
    let controller = NotificationsController(
      service: NotificationsModuleService(legacyService: mockService, rateLimitMax: 10)
    )

    let headers = ["Idempotency-Key": "f6f6f6f6-1111-4222-8333-444444444444"]
    let updateReq = UpdateProjectNotificationRequestSchema(
      notificationId: 10,
      projectId: 99,
      projectName: "Modular Synth",
      emailEnabled: true,
      mobileEnabled: false
    )

    let firstResp = try? controller.handleUpdateNotification(payload: updateReq, headers: headers).get()
    XCTAssertEqual(firstResp?.statusCode, 201)
    XCTAssertEqual(firstResp?.body.idempotencyReplayed, false)

    let replayResp = try? controller.handleUpdateNotification(payload: updateReq, headers: headers).get()
    XCTAssertEqual(replayResp?.statusCode, 200)
    XCTAssertEqual(replayResp?.body.idempotencyReplayed, true)

    let clearHeaders = ["Idempotency-Key": "f6f6f6f6-2222-4222-8333-555555555555"]
    let clearResp = try? controller.handleClearUnseenActivity(
      payload: ClearUnseenActivityRequestSchema(confirmClearUnseenCount: true),
      headers: clearHeaders
    ).get()
    XCTAssertEqual(clearResp?.statusCode, 201)
    XCTAssertEqual(clearResp?.body.activityIndicatorCount, 0)
  }

  func testNotifications_BoundaryRejections() {
    let controller = NotificationsController(
      service: NotificationsModuleService(legacyService: MockService())
    )

    let badUpdate = controller.handleUpdateNotification(
      payload: UpdateProjectNotificationRequestSchema(
        notificationId: 0,
        projectId: -1,
        projectName: "   ",
        emailEnabled: true,
        mobileEnabled: true
      ),
      headers: ["Idempotency-Key": "f6f6f6f6-3333-4222-8333-666666666666"]
    )
    guard case let .failure(problem) = badUpdate else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.count, 3)
  }
}
