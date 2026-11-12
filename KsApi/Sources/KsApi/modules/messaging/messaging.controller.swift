import Foundation

// MARK: - Rule 2, Rule 5 & Rule 6: Messaging Controller & Deprecation Guardrails

/// Agent-native REST controller for sending validated plain-text messages to project creators or threads.
///
/// Negative Constraint: Requires an `Idempotency-Key` header; do not call legacy `ServiceType.sendMessage(body:toSubject:)` directly.
public final class MessagingController {
  /// Endpoint metadata for `POST /ax/v1/messages`.
  public static let sendMessageEndpoint = AXEndpointDescriptor(
    method: "POST",
    path: "/ax/v1/messages",
    summary: "Sends a validated plain-text message to a project or thread with Idempotency-Key safety.",
    requiresIdempotencyKey: true,
    deprecated: false
  )

  private let service: MessagingModuleService
  private let onMutationHook: ((AXMutationEvent) -> Void)?

  /// Creates a `MessagingController` backed by `service` and an optional audit hook.
  public init(
    service: MessagingModuleService,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) {
    self.service = service
    self.onMutationHook = onMutationHook
  }

  /// Handles `POST /ax/v1/messages` with plain-text validation and `Idempotency-Key` replay safety.
  public func handleSendMessage(
    payload: SendMessageRequestSchema,
    headers: [String: String]
  ) -> Result<AXControllerResponse<SentMessageContract>, AXProblemDetails> {
    let rawHeader = headers.first { $0.key.caseInsensitiveCompare("Idempotency-Key") == .orderedSame }?.value
    switch IdempotencyKey.validate(rawHeader) {
    case let .failure(problem):
      self.onMutationHook?(AXMutationEvent(
        endpoint: Self.sendMessageEndpoint.path,
        idempotencyKey: rawHeader ?? "",
        statusCode: problem.status,
        succeeded: false
      ))
      return .failure(problem)
    case let .success(key):
      switch self.service.sendMessage(schema: payload, idempotencyKey: key) {
      case let .failure(problem):
        self.onMutationHook?(AXMutationEvent(
          endpoint: Self.sendMessageEndpoint.path,
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
          endpoint: Self.sendMessageEndpoint.path,
          idempotencyKey: key.rawValue,
          statusCode: status,
          succeeded: true
        ))
        return .success(AXControllerResponse(statusCode: status, headers: responseHeaders, body: res.value))
      }
    }
  }
}

extension MessageSubject {
  /// Deprecation descriptor redirecting callers to `SendMessageRequestSchema`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "MessageSubject",
    meaning: "Legacy REST v1 message target enum lacking Idempotency-Key and body sanitization guardrails.",
    format: "Legacy enum (Deprecated)",
    negativeConstraints: ["Do not route new agent workflows directly through ServiceType.sendMessage(body:toSubject:)."],
    deprecated: true,
    replacementPrimitive: "SendMessageRequestSchema via MessagingController.handleSendMessage(payload:headers:)"
  )
}

extension ServiceType {
  /// Strangler Fig entry point returning an agent-native `MessagingController` backed by `self`.
  public func makeAXMessagingController(
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60,
    onMutationHook: ((AXMutationEvent) -> Void)? = nil
  ) -> MessagingController {
    let service = MessagingModuleService(
      legacyService: self,
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
    return MessagingController(service: service, onMutationHook: onMutationHook)
  }
}

