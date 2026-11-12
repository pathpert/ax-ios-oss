import Foundation

// MARK: - Rule 1 & Rule 2: GraphAPI Scalars Module Service

/// Domain service enforcing format validation and rate limits for GraphAPI custom scalars.
public final class GraphScalarsModuleService {
  private let rateLimitMax: Int
  private var remainingQuota: Int

  /// Initializes the scalar validation service with a configurable request quota.
  public init(rateLimitMax: Int = 120, initialRemainingQuota: Int? = nil) {
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
  }

  /// Consumes rate-limit budget and validates custom scalar fields.
  public func validateScalars(
    schema: ValidateGraphScalarsRequestSchema
  ) -> Result<(ValidatedGraphScalarsContract, [String: String]), AXGraphScalarProblemDetails> {
    guard self.remainingQuota > 0 else {
      return .failure(AXGraphScalarProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit exceeded on GraphAPI scalars module.",
        suggestedAction: "Wait 15 seconds before validating more GraphQL scalars.",
        isRetriable: true,
        invalidParams: []
      ))
    }
    self.remainingQuota -= 1

    let headers = [
      "X-RateLimit-Limit": "\(self.rateLimitMax)",
      "X-RateLimit-Remaining": "\(self.remainingQuota)"
    ]
    return schema.validate().map { ($0, headers) }
  }
}

