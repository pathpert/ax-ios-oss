import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Pledge Management Controller & Deprecation Guardrails

/// Agent-native REST controller validating post-campaign checkout readiness.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not query `ServiceType.validateCheckout(...)` directly.
public final class PledgeManagementController {
  /// Endpoint metadata for `POST /ax/v1/pledges/validate-checkout`.
  public static let validateCheckoutEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/pledges/validate-checkout",
    summary: "Validates a post-campaign checkout session with Stripe secret format checks and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: PledgeManagementModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `PledgeManagementController` backed by `service` and an optional audit hook.
  public init(
    service: PledgeManagementModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/pledges/validate-checkout` with client-secret format and `Idempotency-Key` checks.
  public func handleValidateCheckout(
    payload: ValidateCheckoutRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<ValidatedCheckoutStatusContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.validateCheckoutEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.validateCheckout(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.validateCheckoutEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.validateCheckoutEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }
}

extension ValidateCheckoutEnvelope {
  /// Deprecation descriptor redirecting callers to `ValidateCheckoutRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ValidateCheckoutEnvelope",
    meaning: "Legacy GraphQL validation envelope lacking input secret format checks and Idempotency-Key guardrails.",
    format: "Legacy struct (Deprecated direct query)",
    negativeConstraints: ["Do not invoke ServiceType.validateCheckout(...) directly in agent workflows."],
    deprecated: true,
    replacementPrimitive: "ValidateCheckoutRequestSchema via PledgeManagementController.handleValidateCheckout(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `PledgeManagementController` backed by `self`.
  public func makeAXPledgeManagementController(
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> PledgeManagementController {
    let service = PledgeManagementModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return PledgeManagementController(service: service, onMutationHook: onMutationHook)
  }
}

