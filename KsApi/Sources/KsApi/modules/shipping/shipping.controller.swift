import Foundation

// MARK: - Rule 2: Shipping Controller

/// Agent-native REST controller serving normalized shipping rules (`costInCents`) and survey responses.
public final class ShippingController {
  /// Endpoint metadata for `GET /ax/v1/shipping/rules`.
  public static let fetchShippingRulesEndpoint = AXEndpointDescriptor(
    method: "GET",
    path: "/ax/v1/shipping/rules",
    summary: "Fetches reward shipping rules and normalizes legacy floating-point costs into integer costInCents.",
    requiresIdempotencyKey: false,
    deprecated: false
  )

  /// Endpoint metadata for `GET /ax/v1/surveys/responses`.
  public static let fetchSurveyResponseEndpoint = AXEndpointDescriptor(
    method: "GET",
    path: "/ax/v1/surveys/responses",
    summary: "Fetches a backer survey response contract.",
    requiresIdempotencyKey: false,
    deprecated: false
  )

  private let service: ShippingModuleService

  /// Creates a `ShippingController` backed by `service`.
  public init(service: ShippingModuleService) {
    self.service = service
  }

  /// Handles `GET /ax/v1/shipping/rules` and returns integer-cent shipping rule contracts.
  public func handleFetchShippingRules(
    query: FetchShippingRulesRequestSchema
  ) -> Result<AXControllerResponse<ShippingRulesContract>, AXProblemDetails> {
    self.service.fetchShippingRules(schema: query).map { resp in
      AXControllerResponse(
        statusCode: 200,
        headers: resp.rateLimitHeaders.httpHeaders,
        body: resp.value
      )
    }
  }

  /// Handles `GET /ax/v1/surveys/responses` and returns a `SurveyResponseContract`.
  public func handleFetchSurveyResponse(
    query: FetchSurveyResponseRequestSchema
  ) -> Result<AXControllerResponse<SurveyResponseContract>, AXProblemDetails> {
    self.service.fetchSurveyResponse(schema: query).map { resp in
      AXControllerResponse(
        statusCode: 200,
        headers: resp.rateLimitHeaders.httpHeaders,
        body: resp.value
      )
    }
  }
}
