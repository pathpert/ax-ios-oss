import KsApi
@testable import Library
import XCTest

/// Unit tests covering `LocalStorageModuleSpec` behavior and contracts.
final class LocalStorageModuleSpec: XCTestCase {
  func testUpdateFavoriteCategoriesAndKeychain_HappyPathAndReplay() {
    let store = MockKeyValueStore()
    let adapter = LegacyLocalStorageAdapter(keyValueStore: store, useInMemoryKeychainForTesting: true)
    let service = LocalStorageModuleService(bridge: adapter, rateLimitMax: 10)
    let controller = LocalStorageController(service: service)

    let catHeaders = ["Idempotency-Key": "c3c3c3c3-1111-4222-8333-444444444444"]
    let catReq = UpdateFavoriteCategoriesRequestSchema(categoryIds: [1, 12, 16])

    let firstResp = try? controller.handleUpdateFavoriteCategories(headers: catHeaders, request: catReq).get()
    XCTAssertEqual(firstResp?.statusCode, 201)
    XCTAssertEqual(firstResp?.body.categoryIds, [1, 12, 16])
    XCTAssertEqual(store.favoriteCategoryIds, [1, 12, 16])

    let replayResp = try? controller.handleUpdateFavoriteCategories(headers: catHeaders, request: catReq).get()
    XCTAssertEqual(replayResp?.statusCode, 200)
    XCTAssertEqual(replayResp?.body.idempotencyReplayed, true)

    let keyHeaders = ["Idempotency-Key": "c3c3c3c3-2222-4222-8333-555555555555"]
    let keyReq = StoreKeychainCredentialRequestSchema(accountName: "ksr_oauth_user_42", secretToken: "oauth_sec_987654321")
    let keyResp = try? controller.handleStoreKeychainCredential(headers: keyHeaders, request: keyReq).get()
    XCTAssertEqual(keyResp?.statusCode, 201)
    XCTAssertEqual(keyResp?.body.storedInSecureEnclave, true)
  }

  func testLocalStorage_BoundaryRejections() {
    let store = MockKeyValueStore()
    let adapter = LegacyLocalStorageAdapter(keyValueStore: store, useInMemoryKeychainForTesting: true)
    let controller = LocalStorageController(service: LocalStorageModuleService(bridge: adapter))

    let dupResp = controller.handleUpdateFavoriteCategories(
      headers: ["Idempotency-Key": "c3c3c3c3-3333-4222-8333-666666666666"],
      request: UpdateFavoriteCategoriesRequestSchema(categoryIds: [5, 5, 0])
    )
    guard case let .failure(dupProblem) = dupResp else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(dupProblem.status, 400)
    XCTAssertEqual(dupProblem.invalidParams.count, 2)

    let shortTokenResp = controller.handleStoreKeychainCredential(
      headers: ["Idempotency-Key": "c3c3c3c3-4444-4222-8333-777777777777"],
      request: StoreKeychainCredentialRequestSchema(accountName: "a", secretToken: "123")
    )
    guard case let .failure(tokenProblem) = shortTokenResp else {
      return XCTFail("Expected failure")
    }
    XCTAssertEqual(tokenProblem.status, 400)
    XCTAssertEqual(tokenProblem.invalidParams.count, 2)
  }
}
