import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `SocialModuleSpec` behavior and contracts.
final class SocialModuleSpec: XCTestCase {
  private let validKey = "150e8400-e29b-41d4-a716-446655440000"

  func testFollowAndUnfollowFriend_HappyPath_AndIdempotentReplay() {
    let controller = MockService().makeAXSocialController(rateLimitMax: 5, initialRemainingQuota: 5)
    let payload = FollowFriendRequestSchema(targetUserId: 42, currentAuthenticatedUserId: 1)

    let firstFollow = controller.handleFollowFriend(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? firstFollow.get().statusCode, 201)
    XCTAssertEqual(try? firstFollow.get().body.isFollowing, true)

    let replayFollow = controller.handleFollowFriend(payload: payload, headers: ["Idempotency-Key": self.validKey])
    XCTAssertEqual(try? replayFollow.get().statusCode, 200)
    XCTAssertEqual(try? replayFollow.get().body.idempotencyReplayed, true)

    let unfollow = controller.handleUnfollowFriend(
      payload: payload,
      headers: ["Idempotency-Key": "160e8400-e29b-41d4-a716-446655440000"]
    )
    XCTAssertEqual(try? unfollow.get().statusCode, 200)
    XCTAssertEqual(try? unfollow.get().body.isFollowing, false)
  }

  func testFollowFriend_SelfFollowForbidden_ReturnsRFC9457Error() {
    let controller = MockService().makeAXSocialController()
    let selfFollow = FollowFriendRequestSchema(targetUserId: 99, currentAuthenticatedUserId: 99)

    guard case let .failure(problem) = controller.handleFollowFriend(
      payload: selfFollow,
      headers: ["Idempotency-Key": self.validKey]
    ) else {
      return XCTFail("Expected self-follow to be rejected")
    }

    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "targetUserId")
  }

  func testLegacySocialPrimitives_ExposeDeprecationMetadata() {
    XCTAssertTrue(FriendStatsEnvelope.axDeprecationDescriptor.deprecated)
  }
}

