import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Payments Controller & Deprecation Guardrails

/// Agent-native REST controller handling Stripe PaymentIntent creation and payment source deletion.
///
/// Negative Constraint: Requires an `Idempotency-Key` header and integer-cent amounts; do not use legacy string-dollar `CreatePaymentIntentInput` or `PaymentSourceDeleteInput`.
public final class PaymentsController {
  /// Endpoint metadata for `POST /ax/v1/payments/intents`.
  public static let createPaymentIntentEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/payments/intents",
    summary: "Creates a Stripe PaymentIntent using integer cents, Base64 GraphIDs, and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `DELETE /ax/v1/payments/sources`.
  public static let deletePaymentSourceEndpoint = AXEndpointDescriptor(
    method: "DELETE",
    path: "/ax/v1/payments/sources",
    summary: "Deletes a stored payment method with Base64 GraphID validation and Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: PaymentsModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `PaymentsController` backed by `service` and an optional audit hook.
  public init(
    service: PaymentsModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/payments/intents` with integer-cent and `Idempotency-Key` validation.
  public func handleCreatePaymentIntent(
    payload: CreatePaymentIntentRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<PaymentIntentContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.createPaymentIntentEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.createPaymentIntent(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createPaymentIntentEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        let status = res.value.idempotencyReplayed ? 200 : 201
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createPaymentIntentEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }

  /// Handles `DELETE /ax/v1/payments/sources` with Base64 GraphID and `Idempotency-Key` validation.
  public func handleDeletePaymentSource(
    payload: DeletePaymentSourceRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<DeletedPaymentSourceContract>, AXProblemDetails> {
    let rawHeader = Self.extractIdempotencyHeader(from: headers)
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.deletePaymentSourceEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.deletePaymentSource(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.deletePaymentSourceEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)
      case let .success(res):
        var responseHeaders = res.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = key.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.deletePaymentSourceEndpoint.path,
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

// MARK: - Rule 6: Loud Deprecation Metadata for Legacy Payment Inputs

extension CreatePaymentIntentInput {
  /// Deprecation descriptor redirecting callers to `CreatePaymentIntentRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "CreatePaymentIntentInput",
    meaning: "Legacy GraphQL input using floating-point string amountDollars and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows through CreatePaymentIntentInput.",
      "Do not pass floating-point dollar strings."
    ],
    deprecated: true,
    replacementPrimitive: "CreatePaymentIntentRequestSchema via PaymentsController.handleCreatePaymentIntent(payload:headers:)"
  )
}

extension PaymentSourceDeleteInput {
  /// Deprecation descriptor redirecting callers to `DeletePaymentSourceRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "PaymentSourceDeleteInput",
    meaning: "Legacy GraphQL input using untyped dictionary serialization and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows through PaymentSourceDeleteInput."],
    deprecated: true,
    replacementPrimitive: "DeletePaymentSourceRequestSchema via PaymentsController.handleDeletePaymentSource(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `PaymentsController` backed by `self`.
  public func makeAXPaymentsController(
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> PaymentsController {
    let service = PaymentsModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return PaymentsController(service: service, onMutationHook: onMutationHook)
  }
}

