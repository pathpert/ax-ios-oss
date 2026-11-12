import Foundation
import KsApi
import Library
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Adapter for SceneDelegateViewModel & AppEnvironment

/// Legacy bridge abstracting home-screen shortcut routing and email verification link calls.
public protocol AppLifecycleLegacyBridgeProtocol {
  /// Maps a home-screen shortcut item into a deterministic scene navigation contract.
  func routeShortcut(_ item: ShortcutItem) -> Result<SceneShortcutNavigationContract, AXProblemDetails>
  /// Verifies an email universal link token against the backend API.
  func verifyEmailLink(url: URL, token: String) -> Result<EmailVerificationSceneContract, AXProblemDetails>
}

/// Strangler-fig adapter bridging `AppLifecycleLegacyBridgeProtocol` to `ServiceType`.
public final class LegacyAppLifecycleAdapter: AppLifecycleLegacyBridgeProtocol {
  private let apiService: ServiceType

  /// Creates an adapter backed by the provided `ServiceType`.
  public init(apiService: ServiceType = AppEnvironment.current.apiService) {
    self.apiService = apiService
  }

  /// Maps the supplied shortcut item to its destination tab and filter contract.
  public func routeShortcut(_ item: ShortcutItem) -> Result<SceneShortcutNavigationContract, AXProblemDetails> {
    switch item {
    case .projectsWeLove:
      return .success(SceneShortcutNavigationContract(
        shortcutType: item.typeString,
        destinationTab: "discovery",
        staffPicksFilter: true,
        recommendedFilter: false
      ))
    case .recommendedForYou:
      return .success(SceneShortcutNavigationContract(
        shortcutType: item.typeString,
        destinationTab: "discovery",
        staffPicksFilter: false,
        recommendedFilter: true
      ))
    case .search:
      return .success(SceneShortcutNavigationContract(
        shortcutType: item.typeString,
        destinationTab: "search",
        staffPicksFilter: false,
        recommendedFilter: false
      ))
    }
  }

  /// Executes the legacy `verifyEmail(withToken:)` RPC and translates errors into `AXProblemDetails`.
  public func verifyEmailLink(url: URL, token: String) -> Result<EmailVerificationSceneContract, AXProblemDetails> {
    guard let result = self.apiService.verifyEmail(withToken: token).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on verifyEmail"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "verifyEmailLink"
      ))
    }

    switch result {
    case let .success(envelope):
      return .success(EmailVerificationSceneContract(
        verifiedURL: url.absoluteString,
        message: envelope.message,
        isVerified: true,
        idempotencyReplayed: false
      ))
    case let .failure(error):
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(error, operation: "verifyEmailLink"))
    }
  }
}

// MARK: - Rule 2 & Rule 5: App Lifecycle Module Service

/// Domain service orchestrating scene shortcut routing and idempotent email link verification.
public final class AppLifecycleModuleService {
  private let bridge: AppLifecycleLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int
  private var verificationStore: [IdempotencyKey: (VerifyEmailSceneLinkRequestSchema, EmailVerificationSceneContract)] = [:]

  /// Initializes the service with a bridge and machine-tempo rate limit quota.
  public init(
    bridge: AppLifecycleLegacyBridgeProtocol = LegacyAppLifecycleAdapter(),
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Validates a home-screen shortcut request and returns the routing contract.
  public func triggerShortcut(
    schema: TriggerHomeScreenShortcutRequestSchema
  ) -> Result<AXServiceResponse<SceneShortcutNavigationContract>, AXProblemDetails> {
    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { item in
      self.bridge.routeShortcut(item).map { contract in
        AXServiceResponse(
          value: contract,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Verifies an email universal link while enforcing idempotency and rate limits.
  public func verifyEmailSceneLink(
    schema: VerifyEmailSceneLinkRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<EmailVerificationSceneContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.verificationStore[idempotencyKey] {
      guard savedSchema == schema else {
        return .failure(AXProblemDetails(
          type: "https://docs.kickstarter.com/errors/idempotency-key-conflict",
          title: "Idempotency Key Reused With Different Payload",
          status: 409,
          detail: "Idempotency-Key '\(idempotencyKey.rawValue)' was already used for a different email verification link.",
          suggestedAction: "Generate a fresh UUID v4 Idempotency-Key for distinct verification links.",
          isRetriable: false
        ))
      }
      let replayed = EmailVerificationSceneContract(
        verifiedURL: contract.verifiedURL,
        message: contract.message,
        isVerified: contract.isVerified,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { url, token in
      self.bridge.verifyEmailLink(url: url, token: token).map { contract in
        self.verificationStore[idempotencyKey] = (schema, contract)
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
        detail: "Machine-tempo rate limit exceeded on app_lifecycle module.",
        suggestedAction: "Wait 15 seconds before dispatching additional scene lifecycle actions.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

