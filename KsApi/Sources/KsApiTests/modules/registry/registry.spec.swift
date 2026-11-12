import Foundation
@testable import KsApi
@testable import KsApiTestHelpers
import XCTest

/// Unit tests covering `RegistryModuleSpec` behavior and contracts.
final class RegistryModuleSpec: XCTestCase {
  func testGetCatalog_AllModules_ExposesCompleteAXSurface() {
    let controller = MockService().makeAXRegistryController()
    let result = controller.handleGetCatalog()

    switch result {
    case let .success(res):
      XCTAssertEqual(res.statusCode, 200)
      XCTAssertEqual(res.body.totalModulesCount, 15)
      XCTAssertGreaterThanOrEqual(res.body.totalEndpointsCount, 28)
      for moduleEntry in res.body.modules {
        XCTAssertFalse(moduleEntry.endpoints.isEmpty)
        XCTAssertFalse(moduleEntry.fieldDescriptors.isEmpty)
        XCTAssertFalse(moduleEntry.deprecatedPrimitives.isEmpty)
        XCTAssertTrue(moduleEntry.deprecatedPrimitives.allSatisfy(\.deprecated))
      }
    case let .failure(problem):
      XCTFail("Expected catalog query to succeed, got: \(problem)")
    }
  }

  func testGetCatalog_FilteredByModule_AndUnknownModuleRejection() {
    let controller = MockService().makeAXRegistryController()

    let filtered = controller.handleGetCatalog(
      query: AXCatalogQuerySchema(moduleFilter: "checkout", includeDeprecated: false)
    )
    XCTAssertEqual(try? filtered.get().body.totalModulesCount, 1)
    XCTAssertEqual(try? filtered.get().body.modules.first?.moduleName, "checkout")
    XCTAssertEqual(try? filtered.get().body.modules.first?.deprecatedPrimitives.count, 0)

    let invalid = controller.handleGetCatalog(
      query: AXCatalogQuerySchema(moduleFilter: "non_existent_module")
    )
    guard case let .failure(problem) = invalid else {
      return XCTFail("Expected unknown module filter to fail with RFC 9457 error")
    }
    XCTAssertEqual(problem.status, 400)
    XCTAssertEqual(problem.invalidParams.first?.name, "moduleFilter")
    XCTAssertTrue(problem.suggestedAction.contains("checkout"))
  }
}

