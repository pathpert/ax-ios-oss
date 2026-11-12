import Foundation
import KsApi

// MARK: - Rule 1: Strangler Fig Legacy Adapter for KeyValueStoreType & Keychain

/// Legacy storage adapter protocol bridging typed `local_storage` operations to `KeyValueStoreType` and `Keychain`.
public protocol LocalStorageLegacyBridgeProtocol {
  /// Persists selected favorite category integer IDs to `KeyValueStoreType`.
  func saveFavoriteCategories(_ categoryIds: [Int]) -> Result<[Int], AXProblemDetails>
  /// Stores a sensitive credential in Keychain (or test in-memory enclave).
  func storeCredential(account: String, secret: String) -> Result<Void, AXProblemDetails>
  /// Retrieves a stored credential from Keychain, failing with `404` `AXProblemDetails` if absent.
  func fetchCredential(account: String) -> Result<String, AXProblemDetails>
}

/// Strangler Fig adapter delegating `local_storage` writes to `KeyValueStoreType` and `Keychain`.
///
/// Negative Constraint: Set `useInMemoryKeychainForTesting: true` only in tests; production calls must touch the real Keychain.
public final class LegacyLocalStorageAdapter: LocalStorageLegacyBridgeProtocol {
  private let keyValueStore: KeyValueStoreType
  private var inMemorySecureEnclaveFallback: [String: String]?

  /// Creates the adapter backed by `keyValueStore` and optional in-memory test enclave.
  public init(keyValueStore: KeyValueStoreType, useInMemoryKeychainForTesting: Bool = false) {
    self.keyValueStore = keyValueStore
    self.inMemorySecureEnclaveFallback = useInMemoryKeychainForTesting ? [:] : nil
  }

  /// Persists favorite category IDs and returns the saved list.
  public func saveFavoriteCategories(_ categoryIds: [Int]) -> Result<[Int], AXProblemDetails> {
    self.keyValueStore.favoriteCategoryIds = categoryIds
    return .success(self.keyValueStore.favoriteCategoryIds)
  }

  /// Stores `secret` under `account` in Keychain (or test enclave), returning typed `AXProblemDetails` on error.
  /// Validates and stores a Keychain credential with idempotency deduplication and rate limiting.
  public func storeCredential(account: String, secret: String) -> Result<Void, AXProblemDetails> {
    if self.inMemorySecureEnclaveFallback != nil {
      self.inMemorySecureEnclaveFallback?[account] = secret
      return .success(())
    }
    do {
      try Keychain.storePassword(secret, forAccount: account)
      return .success(())
    } catch let error as KeychainError {
      return .failure(Self.translateKeychainError(error, account: account))
    } catch {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/keychain-failure",
        title: "Keychain Storage Failure",
        status: 500,
        detail: error.localizedDescription,
        suggestedAction: "Verify Keychain entitlements and device lock state before retrying.",
        isRetriable: true
      ))
    }
  }

  /// Fetches the credential stored for `account` from Keychain or returns a `404` problem detail when missing.
  public func fetchCredential(account: String) -> Result<String, AXProblemDetails> {
    if let enclave = self.inMemorySecureEnclaveFallback {
      guard let secret = enclave[account] else {
        return .failure(Self.notFoundProblem(account: account))
      }
      return .success(secret)
    }
    do {
      // Rule 4: Never swallow missing credentials as silent nil or false!
      guard let secret = try Keychain.fetchPassword(forAccount: account) else {
        return .failure(Self.notFoundProblem(account: account))
      }
      return .success(secret)
    } catch let error as KeychainError {
      return .failure(Self.translateKeychainError(error, account: account))
    } catch {
      return .failure(Self.notFoundProblem(account: account))
    }
  }

  private static func notFoundProblem(account: String) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/keychain-credential-not-found",
      title: "Keychain Credential Not Found",
      status: 404,
      detail: "No credential exists in Keychain for account '\(account)'.",
      suggestedAction: "Store a credential first via PUT /ax/v1/library/storage/keychain or re-authenticate the user.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "accountName", reason: "Account '\(account)' not found in Keychain.")]
    )
  }

  private static func translateKeychainError(_ error: KeychainError, account: String) -> AXProblemDetails {
    let nsErr = error.nsError
    return AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/keychain-osstatus-error",
      title: "Keychain OSStatus Error",
      status: 500,
      detail: "Keychain operation for account '\(account)' failed with code \(nsErr.code): \(nsErr.localizedDescription).",
      suggestedAction: "Ensure the iOS simulator or device has Keychain sharing entitlements unlocked.",
      isRetriable: false
    )
  }
}

// MARK: - Rule 2 & Rule 5: Local Storage Module Service

/// Rate-limited, idempotent service layer implementing `local_storage` module capabilities.
///
/// Negative Constraint: Always pass unique UUIDv4 `IdempotencyKey` per distinct mutation payload; reusing a key with different inputs fails with `409 Conflict`.
public final class LocalStorageModuleService {
  private let bridge: LocalStorageLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int
  private var categoriesStore: [IdempotencyKey: (UpdateFavoriteCategoriesRequestSchema, FavoriteCategoriesContract)] = [:]
  private var keychainStore: [IdempotencyKey: (StoreKeychainCredentialRequestSchema, KeychainCredentialContract)] = [:]

  /// Creates the service with a storage bridge and configurable request rate limit.
  public init(
    bridge: LocalStorageLegacyBridgeProtocol,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Validates and persists favorite categories with idempotency deduplication and rate limiting.
  public func updateFavoriteCategories(
    schema: UpdateFavoriteCategoriesRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<FavoriteCategoriesContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.categoriesStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = FavoriteCategoriesContract(categoryIds: contract.categoryIds, idempotencyReplayed: true)
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { ids in
      self.bridge.saveFavoriteCategories(ids).map { saved in
        let contract = FavoriteCategoriesContract(categoryIds: saved, idempotencyReplayed: false)
        self.categoriesStore[idempotencyKey] = (schema, contract)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Validates and stores a Keychain credential with idempotency deduplication and rate limiting.
  public func storeCredential(
    schema: StoreKeychainCredentialRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<KeychainCredentialContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.keychainStore[idempotencyKey] {
      guard savedSchema == schema else { return .failure(Self.idempotencyConflict(key: idempotencyKey)) }
      let replayed = KeychainCredentialContract(
        accountName: contract.accountName,
        storedInSecureEnclave: true,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { account, secret in
      self.bridge.storeCredential(account: account, secret: secret).map { _ in
        let contract = KeychainCredentialContract(
          accountName: account,
          storedInSecureEnclave: true,
          idempotencyReplayed: false
        )
        self.keychainStore[idempotencyKey] = (schema, contract)
        return AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private func consumeQuota() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit exceeded on local_storage module.",
        suggestedAction: "Wait 30 seconds before writing to local storage again.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 30)
      )
    }
    self.remainingQuota -= 1
    return nil
  }

  private static func idempotencyConflict(key: IdempotencyKey) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/idempotency-key-conflict",
      title: "Idempotency Key Reused With Different Payload",
      status: 409,
      detail: "Idempotency-Key '\(key.rawValue)' was already used for a different local storage mutation.",
      suggestedAction: "Generate a new UUID v4 Idempotency-Key for each distinct local storage mutation.",
      isRetriable: false
    )
  }
}

