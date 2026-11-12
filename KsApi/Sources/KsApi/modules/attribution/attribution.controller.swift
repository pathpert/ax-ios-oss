import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Attribution Controller & Deprecation Guardrails

/// Agent-native REST controller handling validated third-party attribution events and APNs push token registration.
///
/// Negative Constraint: Requires a valid `Idempotency-Key` header; do not pass floating-point dollar amounts via legacy `TriggerThirdPartyEventInput`.
public final class AttributionController {
  /// Endpoint metadata for `POST /ax/v1/attribution/events`.
  public static let triggerEventEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/attribution/events",
    summary: "Dispatches a validated third-party attribution event using integer cents and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `POST /ax/v1/notifications/push-tokens`.
  public static let registerPushTokenEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/notifications/push-tokens",
    summary: "Registers a validated hex APNs push token with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: AttributionModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates an `AttributionController` backed by `service` and an optional audit hook.
  public init(
    service: AttributionModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/attribution/events` using integer-cent amounts and `Idempotency-Key` validation.
  public func handleTriggerThirdPartyEvent(
    payload: TriggerThirdPartyEventRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<Bool>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.triggerEventEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.triggerThirdPartyEvent(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.triggerEventEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.triggerEventEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 201,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 201, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `POST /ax/v1/notifications/push-tokens` after validating `Idempotency-Key` and hex token format.
  public func handleRegisterPushToken(
    payload: RegisterPushTokenRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<String>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.registerPushTokenEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.registerPushToken(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.registerPushTokenEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.registerPushTokenEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: 200, headers: responseHeaders, body: res.value))
      }
    }
  }

  private static func extractIdempotencyHeader(from headers: [String: String]) -> String? {
    headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
  }
}

extension TriggerThirdPartyEventInput {
  /// Deprecation descriptor redirecting callers to `TriggerThirdPartyEventRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "TriggerThirdPartyEventInput",
    meaning: "Legacy GraphQL input using floating-point Double currency (pledgeAmount/shipping) and untyped dictionary serialization.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows through TriggerThirdPartyEventInput.",
      "Do not pass floating-point Double currency."
    ],
    deprecated: true,
    replacementPrimitive: "TriggerThirdPartyEventRequestSchema via AttributionController.handleTriggerThirdPartyEvent(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `AttributionController` backed by `self`.
  public func makeAXAttributionController(
    rateLimitMax: Int = 100,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 15,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> AttributionController {
    let service = AttributionModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return AttributionController(service: service, onMutationHook: onMutationHook)
  }
}

