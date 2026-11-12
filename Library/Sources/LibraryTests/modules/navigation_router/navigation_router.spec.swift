import KsApi
@testable import Library
import XCTest

/// Unit tests covering `NavigationRouterModuleSpec` behavior and contracts.
final class NavigationRouterModuleSpec: XCTestCase {
  func testResolveRoute_HappyPath() {
    let controller = NavigationRouterController(service: NavigationRouterModuleService(rateLimitMax: 10))

    let projectResp = try? controller.handleResolveRoute(
      request: ResolveDeepLinkRequestSchema(
        urlString: "https://www.kickstarter.com/projects/creator/cool-gadget",
        requireDeepLinkWhitelist: true
      )
    ).get()
    XCTAssertEqual(projectResp?.statusCode, 200)
    XCTAssertEqual(projectResp?.body.routeCategory, "project")
    XCTAssertEqual(projectResp?.body.requiresAuthentication, false)

    let messageResp = try? controller.handleResolveRoute(
      request: ResolveDeepLinkRequestSchema(
        urlString: "https://www.kickstarter.com/messages/9876",
        requireDeepLinkWhitelist: true
      )
    ).get()
    XCTAssertEqual(messageResp?.statusCode, 200)
    XCTAssertEqual(messageResp?.body.routeCategory, "messages")
    XCTAssertEqual(messageResp?.body.requiresAuthentication, true)
  }

  func testResolveRoute_RejectsUntrustedDomainAndUnmatchedPath() {
    let controller = NavigationRouterController()

    let phishingResp = controller.handleResolveRoute(
      request: ResolveDeepLinkRequestSchema(urlString: "https://evil-phishing.example.com/projects/a/b")
    )
    guard case let .failure(phishingProblem) = phishingResp else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(phishingProblem.status, 400)
    XCTAssertEqual(phishingProblem.invalidParams.first?.name, "urlString")

    let unmatchedResp = controller.handleResolveRoute(
      request: ResolveDeepLinkRequestSchema(urlString: "https://www.kickstarter.com/non-existent-route/123/xyz")
    )
    guard case let .failure(unmatchedProblem) = unmatchedResp else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(unmatchedProblem.status, 404)
    XCTAssertEqual(unmatchedProblem.title, "Unmatched Navigation Route")
  }
}
