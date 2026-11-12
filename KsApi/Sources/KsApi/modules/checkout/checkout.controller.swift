import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Checkout Controller, Endpoint Metadata & Mutation Hooks

/// Machine-readable endpoint descriptor exposed in the AX capability registry.
public struct AXEndpointDescriptor: Codable, Equatable, Sendable {
  /// HTTP verb (`"GET"`, `"POST"`, `"PUT"`, `"DELETE"`).
  public let method: String
  /// Normalized controller route path (e.g., `"/ax/v1/checkout/sessions"`).
  public let path: String
  /// Concise description of endpoint purpose and safety guarantees.
  public let summary: String
  /// Whether callers must supply an `Idempotency-Key` header.
  public let requiresIdempotencyKey: Bool
  /// Whether this endpoint is legacy/deprecated and should be avoided by agents.
  public let deprecated: Bool
  /// Preferred replacement endpoint or schema name when `deprecated` is `true`.
  public let replacementPrimitive: String?

  /// Creates an `AXEndpointDescriptor`.
  public init(
    method: String,
    path: String,
    summary: String,
    requiresIdempotencyKey: Bool,
    deprecated: Bool = false,
    replacementPrimitive: String? = nil
  ) {
    self.method = method
    self.path = path
    self.summary = summary
    self.requiresIdempotencyKey = requiresIdempotencyKey
    self.deprecated = deprecated
    self.replacementPrimitive = replacementPrimitive
  }
}

/// Standardized HTTP-like response envelope returned by AX controllers.
public struct AXControllerResponse<Body: Codable & Equatable>: Equatable {
  /// HTTP status code (e.g., `200`, `201`).
  public let statusCode: Int
  /// Response headers including rate-limit metadata and `Idempotency-Key`.
  public let headers: [String: String]
  /// Strongly typed response body contract.
  public let body: Body

  /// Creates an `AXControllerResponse`.
  public init(statusCode: Int, headers: [String: String], body: Body) {
    self.statusCode = statusCode
    self.headers = headers
    self.body = body
  }
}

/// Audit event emitted after every AX controller mutation attempt.
public struct AXMutationEvent: Equatable, Sendable {
  /// Controller endpoint path invoked.
  public let endpoint: String
  /// Supplied `Idempotency-Key` header value (empty string when missing).
  public let idempotencyKey: String
  /// Resulting status code (HTTP status or RFC 9457 error status).
  public let statusCode: Int
  /// Whether the mutation completed without error.
  public let succeeded: Bool
}

/// Agent-native REST controller handling checkout session creation and backing cancellation.
///
/// Negative Constraint: Always pass an `Idempotency-Key` header; do not route agents through `CreateCheckoutInput` or `CancelBackingInput`.
public final class CheckoutController {
  /// Endpoint metadata for `POST /ax/v1/checkout/sessions`.
  public static let createCheckoutEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/checkout/sessions",
    summary: "Creates a validated Kickstarter checkout session using integer cents and Base64 GraphIDs.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Endpoint metadata for `DELETE /ax/v1/checkout/backings`.
  public static let cancelBackingEndpoint = AXEndpointDescriptor(
    method: "DELETE",
    path: "/ax/v1/checkout/backings",
    summary: "Cancels an active backing with idempotency protection.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  /// Deprecated legacy endpoint metadata redirecting callers to `handleCreateCheckout(payload:headers:)`.
  public static let legacyCreateCheckoutEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/graphql#createCheckout",
    summary: "Legacy string-amount checkout mutation.",
    requiresIdempotencyKey: false,
    deprecated: true,
    replacementPrimitive: "CheckoutController.handleCreateCheckout(payload:headers:)"
  )

  private let service: CheckoutModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `CheckoutController` backed by `service` and an optional audit hook.
  public init(
    service: CheckoutModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/checkout/sessions` with mandatory `Idempotency-Key` validation and RFC 9457 error responses.
  public func handleCreateCheckout(
    payload: CreateCheckoutRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<CheckoutSessionContract>, AXProblemDetails> {
    let rawIdempotencyHeader = Self.extractIdempotencyHeader(from: headers)

    switch IdempotencyKey.validate(rawIdempotencyHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.createCheckoutEndpoint.path,
        idempotencyKey: rawIdempotencyHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)

    case let .success(idempotencyKey):
      switch self.service.createCheckout(schema: payload, idempotencyKey: idempotencyKey) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createCheckoutEndpoint.path,
          idempotencyKey: idempotencyKey.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)

      case let .success(serviceResponse):
        var responseHeaders = serviceResponse.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = idempotencyKey.rawValue
        let statusCode = serviceResponse.value.idempotencyReplayed ? 200 : 201
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.createCheckoutEndpoint.path,
          idempotencyKey: idempotencyKey.rawValue,
          statusCode: statusCode,
          succeeded: true
        ))
        return .success(AXControllerResponse(
          statusCode: statusCode,
          headers: responseHeaders,
          body: serviceResponse.value
        ))
      }
    }
  }

  /// Handles `DELETE /ax/v1/checkout/backings` with mandatory `Idempotency-Key` validation and RFC 9457 error responses.
  public func handleCancelBacking(
    payload: CancelBackingRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<Bool>, AXProblemDetails> {
    let rawIdempotencyHeader = Self.extractIdempotencyHeader(from: headers)

    switch IdempotencyKey.validate(rawIdempotencyHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.cancelBackingEndpoint.path,
        idempotencyKey: rawIdempotencyHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)

    case let .success(idempotencyKey):
      switch self.service.cancelBacking(schema: payload, idempotencyKey: idempotencyKey) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.cancelBackingEndpoint.path,
          idempotencyKey: idempotencyKey.rawValue,
          statusCode: problem.status,
          succeeded: false
        ))
        return .failure(problem)

      case let .success(serviceResponse):
        var responseHeaders = serviceResponse.rateLimitHeaders.httpHeaders
        responseHeaders["Idempotency-Key"] = idempotencyKey.rawValue
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.cancelBackingEndpoint.path,
          idempotencyKey: idempotencyKey.rawValue,
          statusCode: 200,
          succeeded: true
        ))
        return .success(AXControllerResponse(
          statusCode: 200,
          headers: responseHeaders,
          body: serviceResponse.value
        ))
      }
    }
  }

  private static func extractIdempotencyHeader(from headers: [String: String]) -> String? {
    for (key, value) in headers where key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame {
      return value
    }
    return nil
  }
}

// MARK: - Rule 6: Loud Deprecation Metadata on Legacy Checkout & Backing Primitives

extension CreateCheckoutInput {
  /// Explicit deprecation schema descriptor guiding automated callers to the AX Checkout primitive.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "CreateCheckoutInput",
    meaning: "Legacy GraphQL input using optional floating-point string amount and lacking Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows through CreateCheckoutInput.",
      "Do not pass untyped string amounts."
    ],
    deprecated: true,
    replacementPrimitive: "CreateCheckoutRequestSchema via CheckoutController.handleCreateCheckout(payload:headers:)"
  )
}

extension CancelBackingInput {
  /// Explicit deprecation schema descriptor guiding automated callers to the AX CancelBacking primitive.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "CancelBackingInput",
    meaning: "Legacy GraphQL input lacking boundary GraphID validation and Idempotency-Key enforcement.",
    format: "Legacy struct (Deprecated)",
    negativeConstraints: [
      "Do not route new agent workflows through CancelBackingInput."
    ],
    deprecated: true,
    replacementPrimitive: "CancelBackingRequestSchema via CheckoutController.handleCancelBacking(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an Agent-Native `CheckoutController` backed by `self`.
  public func makeAXCheckoutController(
    rateLimitMax: Int = 60,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 30,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> CheckoutController {
    let moduleService = CheckoutModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return CheckoutController(service: moduleService, onMutationHook: onMutationHook)
  }
}
