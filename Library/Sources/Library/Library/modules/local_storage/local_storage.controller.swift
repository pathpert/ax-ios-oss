import Foundation
import KsApi

// MARK: - Rule 2 & Rule 5: Local Storage Controller

/// AX boundary controller validating `Idempotency-Key` headers and delegating local storage writes.
/// - Negative Constraint: Do not bypass `LocalStorageController` to mutate Keychain or `KeyValueStoreType` directly from views.
public final class LocalStorageController {
  /// AX endpoint metadata for persisting favorite discovery category IDs.
  public static let updateCategoriesEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/library/storage/favorite-categories",
    summary: "Persists validated favorite category IDs into KeyValueStoreType with Idempotency-Key protection.",
    requiresIdempotencyKey: true
  )

  /// AX endpoint metadata for persisting credentials into Keychain.
  public static let storeKeychainEndpoint = AXEndpointDescriptor(
    method: "PUT",
    path: "/ax/v1/library/storage/keychain",
    summary: "Persists a validated credential into Keychain with RFC 9457 error translation.",
    requiresIdempotencyKey: true
  )

  private let service: LocalStorageModuleService

  /// Creates a local-storage AX boundary controller backed by `service`.
  public init(service: LocalStorageModuleService) {
    self.service = service
  }

  /// Validates the `Idempotency-Key` header and persists updated favorite categories.
  public func handleUpdateFavoriteCategories(
    headers: [String: String],
    request: UpdateFavoriteCategoriesRequestSchema
  ) -> Result<AXControllerResponse<FavoriteCategoriesContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.updateFavoriteCategories(schema: request, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }

  /// Validates the `Idempotency-Key` header and stores a credential in Keychain.
  public func handleStoreKeychainCredential(
    headers: [String: String],
    request: StoreKeychainCredentialRequestSchema
  ) -> Result<AXControllerResponse<KeychainCredentialContract>, AXProblemDetails> {
    let rawKey = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    return IdempotencyKey.validate(rawKey).flatMap { key in
      self.service.storeCredential(schema: request, idempotencyKey: key).map { resp in
        AXControllerResponse(
          statusCode: resp.value.idempotencyReplayed ? 200 : 201,
          headers: resp.rateLimitHeaders.httpHeaders,
          body: resp.value
        )
      }
    }
  }
}
