import KDS
import XCTest

final class DesignTokensModuleSpec: XCTestCase {
  func testResolveSpacingAndSemanticColor_HappyPath() {
    let controller = DesignTokensController(service: DesignTokensModuleService(rateLimitMax: 10))

    let spacingResp = controller.handleResolveSpacing(
      request: ResolveSpacingTokenRequestSchema(unitIndex: 4)
    )
    XCTAssertEqual(spacingResp.statusCode, 200)
    XCTAssertEqual(spacingResp.body?.tokenIdentifier, "Spacing.unit_04")
    XCTAssertEqual(spacingResp.body?.points, 16.0)
    XCTAssertEqual(spacingResp.headers["X-RateLimit-Remaining"], "9")

    let colorResp = controller.handleResolveSemanticColor(
      request: ResolveSemanticColorRequestSchema(tokenName: "text/primary", opacityPercent: 85)
    )
    XCTAssertEqual(colorResp.statusCode, 200)
    XCTAssertEqual(colorResp.body?.tokenName, "text/primary")
    XCTAssertEqual(colorResp.body?.opacityPercent, 85)
  }

  func testResolveTokens_BoundaryRejectionsAndRFC9457Errors() {
    let controller = DesignTokensController()

    let badSpacing = controller.handleResolveSpacing(
      request: ResolveSpacingTokenRequestSchema(unitIndex: 13)
    )
    XCTAssertEqual(badSpacing.statusCode, 400)
    XCTAssertEqual(badSpacing.problem?.invalidParams.first?.name, "unitIndex")

    let badColor = controller.handleResolveSemanticColor(
      request: ResolveSemanticColorRequestSchema(tokenName: "#FF0000", opacityPercent: 0)
    )
    XCTAssertEqual(badColor.statusCode, 400)
    XCTAssertEqual(badColor.problem?.invalidParams.count, 2)
  }
}

