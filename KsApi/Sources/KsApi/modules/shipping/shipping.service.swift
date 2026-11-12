import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Reward Shipping Rules & Surveys

/// Isolates legacy `ServiceType` shipping rules and survey response lookups behind `AXProblemDetails`.
public protocol ShippingLegacyBridgeProtocol {
  /// Fetches shipping rules configured for a reward on a project.
  func fetchRewardShippingRules(projectId: Int, rewardId: Int) -> Result<ShippingRulesEnvelope, AXProblemDetails>
  /// Fetches a backer's survey response by ID.
  func fetchSurveyResponse(surveyResponseId: Int) -> Result<SurveyResponse, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating shipping and survey queries to `ServiceType`.
public final class LegacyShippingServiceAdapter: ShippingLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Fetches reward shipping rules synchronously and translates legacy errors.
  public func fetchRewardShippingRules(
    projectId: Int,
    rewardId: Int
  ) -> Result<ShippingRulesEnvelope, AXProblemDetails> {
    guard let result = self.legacyService.fetchRewardShippingRules(projectId: projectId, rewardId: rewardId).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on fetchRewardShippingRules"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "fetchRewardShippingRules"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "fetchRewardShippingRules") }
  }

  /// Fetches a backer survey response synchronously and translates legacy errors.
  public func fetchSurveyResponse(
    surveyResponseId: Int
  ) -> Result<SurveyResponse, AXProblemDetails> {
    guard let result = self.legacyService.fetchSurveyResponse(surveyResponseId: surveyResponseId).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on fetchSurveyResponse"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "fetchSurveyResponse"
      ))
    }
    return result.mapError { LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "fetchSurveyResponse") }
  }
}

// MARK: - Rule 2 & Rule 5: Shipping Module Service

/// Rate-limited service orchestrating reward shipping-rule lookups and survey status checks.
///
/// Negative Constraint: Exhausting `rateLimitMax` returns HTTP 429; legacy floating costs are rounded to integer cents.
public final class ShippingModuleService {
  private let bridge: ShippingLegacyBridgeProtocol
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Creates a `ShippingModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: ShippingLegacyBridgeProtocol,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil
  ) {
    self.init(
      bridge: LegacyShippingServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota
    )
  }

  /// Fetches shipping rules for a reward while enforcing rate-limit quota.
  public func fetchShippingRules(
    schema: FetchShippingRulesRequestSchema
  ) -> Result<AXServiceResponse<ShippingRulesContract>, AXProblemDetails> {
    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { projectId, rewardId in
      self.bridge.fetchRewardShippingRules(projectId: projectId, rewardId: rewardId).map { envelope in
        // Rule 3: Convert legacy floating-point ShippingRule.cost into integer cents!
        let items = envelope.shippingRules.map { rule in
          ShippingRuleItemContract(
            ruleId: rule.id,
            locationId: rule.location.id,
            locationDisplayableName: rule.location.displayableName,
            countryCode: rule.location.country,
            costInCents: Int((rule.cost * 100.0).rounded())
          )
        }
        return AXServiceResponse(
          value: ShippingRulesContract(projectId: projectId, rewardId: rewardId, rules: items),
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Fetches survey response metadata while enforcing rate-limit quota.
  public func fetchSurveyResponse(
    schema: FetchSurveyResponseRequestSchema
  ) -> Result<AXServiceResponse<SurveyResponseContract>, AXProblemDetails> {
    if let err = self.consumeQuota() { return .failure(err) }

    return schema.validate().flatMap { surveyId in
      self.bridge.fetchSurveyResponse(surveyResponseId: surveyId).map { response in
        let contract = SurveyResponseContract(
          surveyResponseId: response.id,
          webSurveyURL: response.urls.web.survey,
          isAnswered: response.answeredAt != nil
        )
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
        detail: "Machine-tempo rate limit exceeded on shipping module.",
        suggestedAction: "Wait 15 seconds before querying shipping rules or surveys again.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: 15)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

