import Foundation

// MARK: - Rule 2 & Rule 5: Feature Gates Controller

/// Envelope returned by `FeatureGatesController` endpoints with HTTP status, headers, and body or problem details.
public struct AXExperimentControllerResponse<T: Codable & Equatable & Sendable>: Equatable, Sendable {
  /// HTTP status code representing the outcome.
  public let statusCode: Int
  /// Response HTTP headers (including rate-limit metadata when available).
  public let headers: [String: String]
  /// Decoded response payload on success.
  public let body: T?
  /// Structured RFC 9457 problem details on failure.
  public let problem: AXExperimentProblemDetails?
}

/// Controller exposing feature gate evaluation and experiment reload endpoints.
public final class FeatureGatesController {
  private let service: FeatureGatesModuleService
  private static let uuidV4Regex =
    #"^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-4[0-9a-fA-F]{3}-[89abAB][0-9a-fA-F]{3}-[0-9a-fA-F]{12}$"#

  /// Initializes the controller with a `FeatureGatesModuleService`.
  public init(service: FeatureGatesModuleService) {
    self.service = service
  }

  /// Handles a feature gate evaluation request and maps the result to an HTTP-style response.
  public func handleEvaluateGate(
    request: EvaluateFeatureGateRequestSchema
  ) -> AXExperimentControllerResponse<FeatureGateEvaluationContract> {
    switch self.service.evaluateGate(schema: request) {
    case let .success((contract, rateHeaders)):
      return AXExperimentControllerResponse(
        statusCode: 200,
        headers: rateHeaders.httpHeaders,
        body: contract,
        problem: nil
      )
    case let .failure(problem):
      return AXExperimentControllerResponse(
        statusCode: problem.status,
        headers: problem.rateLimitHeaders?.httpHeaders ?? [:],
        body: nil,
        problem: problem
      )
    }
  }

  /// Validates the `Idempotency-Key` header and triggers an experiment user reload.
  public func handleReloadUser(
    headers: [String: String],
    request: ReloadExperimentUserRequestSchema
  ) -> AXExperimentControllerResponse<ExperimentUserReloadContract> {
    guard
      let rawKey = headers.first(where: { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame })?.value
        .trimmingCharacters(in: .whitespacesAndNewlines),
      !rawKey.isEmpty,
      rawKey.range(of: Self.uuidV4Regex, options: .regularExpression) != nil
    else {
      let problem = AXExperimentProblemDetails(
        type: "https://docs.kickstarter.com/errors/missing-or-invalid-idempotency-key",
        title: "Missing or Invalid Idempotency-Key Header",
        status: 400,
        detail: "Mutating endpoint POST /ax/v1/experiments/reload requires a valid UUID v4 Idempotency-Key header.",
        suggestedAction: "Generate a UUID v4 string and pass it in the 'Idempotency-Key' request header.",
        isRetriable: false,
        invalidParams: [AXExperimentInvalidParam(name: "Idempotency-Key", reason: "Must be a valid UUID v4.")]
      )
      return AXExperimentControllerResponse(statusCode: 400, headers: [:], body: nil, problem: problem)
    }

    switch self.service.reloadUser(schema: request, idempotencyKey: rawKey) {
    case let .success((contract, rateHeaders)):
      return AXExperimentControllerResponse(
        statusCode: contract.idempotencyReplayed ? 200 : 201,
        headers: rateHeaders.httpHeaders,
        body: contract,
        problem: nil
      )
    case let .failure(problem):
      return AXExperimentControllerResponse(
        statusCode: problem.status,
        headers: problem.rateLimitHeaders?.httpHeaders ?? [:],
        body: nil,
        problem: problem
      )
    }
  }
}

