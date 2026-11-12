import Experimentation
import ExperimentationTestHelpers
import XCTest

final class FeatureGatesModuleSpec: XCTestCase {
  // MARK: - 1. Happy Path + Replay Protection

  func testEvaluateGateAndReloadUser_HappyPath() {
    let mockClient = MockStatsigWrapper()
    mockClient.features[.videoFeed] = true

    let service = FeatureGatesModuleService(legacyClient: mockClient, rateLimitMax: 10)
    let controller = FeatureGatesController(service: service)

    let evalResponse = controller.handleEvaluateGate(
      request: EvaluateFeatureGateRequestSchema(gateKey: "video_feed")
    )
    XCTAssertEqual(evalResponse.statusCode, 200)
    XCTAssertEqual(evalResponse.body?.isEnabled, true)
    XCTAssertEqual(evalResponse.body?.description, "Video Feed")
    XCTAssertEqual(evalResponse.headers["X-RateLimit-Remaining"], "9")

    let reloadHeaders = ["Idempotency-Key": "b2b2b2b2-3333-4444-8555-666666666666"]
    let reloadReq = ReloadExperimentUserRequestSchema(ksrUserId: 42, segmentAnonymousId: "anon-device-001")
    let firstReload = controller.handleReloadUser(headers: reloadHeaders, request: reloadReq)
    XCTAssertEqual(firstReload.statusCode, 201)
    XCTAssertEqual(firstReload.body?.idempotencyReplayed, false)

    let secondReload = controller.handleReloadUser(headers: reloadHeaders, request: reloadReq)
    XCTAssertEqual(secondReload.statusCode, 200)
    XCTAssertEqual(secondReload.body?.idempotencyReplayed, true)
  }

  // MARK: - 2. Boundary Rejections & Uninitialized Nil Gate Protection (Rule 3 & Rule 4)

  func testEvaluateGate_RejectsUnknownGateAndUninitializedNilState() {
    let mockClient = MockStatsigWrapper()
    let service = FeatureGatesModuleService(legacyClient: mockClient)
    let controller = FeatureGatesController(service: service)

    let invalidKeyResp = controller.handleEvaluateGate(
      request: EvaluateFeatureGateRequestSchema(gateKey: "unknown_flag")
    )
    XCTAssertEqual(invalidKeyResp.statusCode, 400)
    XCTAssertEqual(invalidKeyResp.problem?.invalidParams.first?.name, "gateKey")

    // video_feed is not set in mockClient.features -> returns nil -> translated to 503 Problem Details!
    let uninitializedResp = controller.handleEvaluateGate(
      request: EvaluateFeatureGateRequestSchema(gateKey: "video_feed")
    )
    XCTAssertEqual(uninitializedResp.statusCode, 503)
    XCTAssertEqual(uninitializedResp.problem?.isRetriable, true)
    XCTAssertTrue(uninitializedResp.problem?.suggestedAction.contains("POST /ax/v1/experiments/reload") == true)
  }

  // MARK: - 3. Reload Boundary Validation & Rate Limit Backoff

  func testReloadUser_RejectsInvalidIdentityAndEnforcesRateLimit() {
    let mockClient = MockStatsigWrapper()
    let service = FeatureGatesModuleService(
      legacyClient: mockClient,
      rateLimitMax: 1,
      initialRemainingQuota: 0,
      retryAfterSeconds: 30
    )
    let controller = FeatureGatesController(service: service)

    let rateLimited = controller.handleReloadUser(
      headers: ["Idempotency-Key": "b2b2b2b2-3333-4444-8555-777777777777"],
      request: ReloadExperimentUserRequestSchema(ksrUserId: 10, segmentAnonymousId: nil)
    )
    XCTAssertEqual(rateLimited.statusCode, 429)
    XCTAssertEqual(rateLimited.headers["Retry-After"], "30")
  }
}

