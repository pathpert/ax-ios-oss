import Foundation

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Experimentation (StatsigClientType)

/// Legacy bridge abstracting feature gate lookups and user reloads from `StatsigClientType`.
public protocol FeatureGatesLegacyBridgeProtocol {
  /// Evaluates the current state of the specified Statsig feature gate.
  func evaluateGate(feature: StatsigFeature) -> Result<Bool, AXExperimentProblemDetails>
  /// Reloads experiment and feature gate assignments for the provided user context.
  func reloadUser(_ user: StatsigClientUser) -> Result<Void, AXExperimentProblemDetails>
}

/// Strangler-fig adapter bridging `FeatureGatesLegacyBridgeProtocol` to `StatsigClientType`.
public final class LegacyFeatureGatesAdapter: FeatureGatesLegacyBridgeProtocol {
  private let legacyClient: StatsigClientType

  /// Creates an adapter wrapping the supplied legacy `StatsigClientType`.
  public init(legacyClient: StatsigClientType) {
    self.legacyClient = legacyClient
  }

  /// Evaluates the feature gate, surfacing uninitialized client states as a 503 problem detail.
  public func evaluateGate(feature: StatsigFeature) -> Result<Bool, AXExperimentProblemDetails> {
    // Rule 4: Never swallow uninitialized nil states or silently fallback to false.
    guard let isEnabled = self.legacyClient.checkGate(for: feature) else {
      return .failure(AXExperimentProblemDetails(
        type: "https://docs.kickstarter.com/errors/experiment-client-uninitialized",
        title: "Experimentation Client Uninitialized or Gate Missing",
        status: 503,
        detail: "StatsigClientType returned nil for feature gate '\(feature.rawValue)' (\(feature.description)).",
        suggestedAction: "Ensure StatsigClient is initialized or reloaded via POST /ax/v1/experiments/reload before evaluating feature gates.",
        isRetriable: true
      ))
    }
    return .success(isEnabled)
  }

  /// Reloads experiment assignments for the specified user.
  public func reloadUser(_ user: StatsigClientUser) -> Result<Void, AXExperimentProblemDetails> {
    self.legacyClient.reload(withUser: user)
    return .success(())
  }
}

// MARK: - Rule 2 & Rule 5: Feature Gates Module Service

/// Domain service evaluating feature gates and reloading experiment user context with rate limiting and idempotency.
public final class FeatureGatesModuleService {
  private let bridge: FeatureGatesLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var reloadStore: [String: (ReloadExperimentUserRequestSchema, ExperimentUserReloadContract)] = [:]

  /// Creates a service with a custom bridge, rate limit cap, and retry window.
  public init(
    bridge: FeatureGatesLegacyBridgeProtocol,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a `StatsigClientType` in `LegacyFeatureGatesAdapter`.
  public convenience init(
    legacyClient: StatsigClientType,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30
  ) {
    self.init(
      bridge: LegacyFeatureGatesAdapter(legacyClient: legacyClient),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Validates the request schema, enforces rate limiting, and evaluates the target feature gate.
  public func evaluateGate(
    schema: EvaluateFeatureGateRequestSchema
  ) -> Result<(FeatureGateEvaluationContract, AXExperimentRateLimitHeaders), AXExperimentProblemDetails> {
    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { feature in
      self.bridge.evaluateGate(feature: feature).map { isEnabled in
        let contract = FeatureGateEvaluationContract(
          gateKey: feature.rawValue,
          description: feature.description,
          isEnabled: isEnabled
        )
        return (contract, AXExperimentRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota))
      }
    }
  }

  /// Reloads experiment assignments for a user, enforcing UUID idempotency and rate limits.
  public func reloadUser(
    schema: ReloadExperimentUserRequestSchema,
    idempotencyKey: String
  ) -> Result<(ExperimentUserReloadContract, AXExperimentRateLimitHeaders), AXExperimentProblemDetails> {
    let normalizedKey = idempotencyKey.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
    if let (savedSchema, contract) = self.reloadStore[normalizedKey] {
      guard savedSchema == schema else {
        return .failure(AXExperimentProblemDetails(
          type: "https://docs.kickstarter.com/errors/idempotency-key-conflict",
          title: "Idempotency Key Reused With Different Payload",
          status: 409,
          detail: "Idempotency-Key '\(normalizedKey)' was already used for a different experiment reload payload.",
          suggestedAction: "Generate a fresh UUID v4 Idempotency-Key for distinct user reload operations.",
          isRetriable: false
        ))
      }
      let replayed = ExperimentUserReloadContract(
        ksrUserId: contract.ksrUserId,
        segmentAnonymousId: contract.segmentAnonymousId,
        reloaded: true,
        idempotencyReplayed: true
      )
      return .success((replayed, AXExperimentRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)))
    }

    if let rateLimitError = self.consumeRateLimitBudget() { return .failure(rateLimitError) }

    return schema.validate().flatMap { clientUser in
      self.bridge.reloadUser(clientUser).map { _ in
        let contract = ExperimentUserReloadContract(
          ksrUserId: clientUser.ksrUserId,
          segmentAnonymousId: clientUser.segmentAnonymousId,
          reloaded: true,
          idempotencyReplayed: false
        )
        self.reloadStore[normalizedKey] = (schema, contract)
        return (contract, AXExperimentRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota))
      }
    }
  }

  private func consumeRateLimitBudget() -> AXExperimentProblemDetails? {
    guard self.remainingQuota > 0 else {
      let headers = AXExperimentRateLimitHeaders(
        limit: self.rateLimitMax,
        remaining: 0,
        retryAfterSeconds: self.retryAfterSeconds
      )
      return AXExperimentProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) requests per window exceeded on feature_gates module.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as indicated by Retry-After before retrying.",
        isRetriable: true,
        rateLimitHeaders: headers
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

