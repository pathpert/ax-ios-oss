@testable import Kickstarter_Framework
import XCTest

/// Unit tests covering `CreatePasswordViewControllerTests` behavior and contracts.
final class CreatePasswordViewControllerTests: XCTestCase {
  func testViewDidLoadAddsChildTableViewController() {
    let vc = CreatePasswordViewController.instantiate()
    _ = vc.view

    XCTAssertTrue(vc.children.first is CreatePasswordTableViewController)
  }
}
