import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Messaging

/// Isolates legacy `ServiceType` messaging calls behind `AXProblemDetails` errors.
public protocol MessagingLegacyBridgeProtocol {
  /// Sends a validated creator/backer message.
  func sendMessage(contract: ValidatedSendMessageContract) -> Result<Message, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating messaging calls to `ServiceType`.
public final class LegacyMessagingServiceAdapter: MessagingLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Dispatches the validated message synchronously and translates legacy errors.
  public func sendMessage(contract: ValidatedSendMessageContract) -> Result<Message, AXProblemDetails> {
    let subject: MessageSubject = .project(id: contract.targetNumericId, name: contract.targetName)
    guard let result = self.legacyService.sendMessage(body: contract.sanitizedBody, toSubject: subject).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on sendMessage"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "sendMessage"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "sendMessage")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Messaging Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating message delivery.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a different message payload fails with HTTP 409 conflict.
public final class MessagingModuleService {
  private let bridge: MessagingLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var messageStore: [IdempotencyKey: (SendMessageRequestSchema, SentMessageContract)] = [:]

  /// Creates a `MessagingModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: MessagingLegacyBridgeProtocol,
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.bridge = bridge
    self.rateLimitMax = max(1, rateLimitMax)
    self.remainingQuota = initialRemainingQuota ?? max(1, rateLimitMax)
    self.retryAfterSeconds = max(1, retryAfterSeconds)
  }

  /// Convenience initializer wrapping a legacy `ServiceType`.
  public convenience init(
    legacyService: ServiceType,
    rateLimitMax: Int = 30,
    initialRemainingQuota: Int? = nil,
    retryAfterSeconds: Int = 60
  ) {
    self.init(
      bridge: LegacyMessagingServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Sends a message idempotently while enforcing rate-limit quota.
  public func sendMessage(
    schema: SendMessageRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<SentMessageContract>, AXProblemDetails> {
    if let (savedSchema, contract) = self.messageStore[idempotencyKey] {
      guard savedSchema == schema else {
        return .failure(AXProblemDetails(
          type: "https://docs.kickstarter.com/errors/idempotency-conflict",
          title: "Idempotency-Key Payload Conflict",
          status: 409,
          detail: "Idempotency-Key '\(idempotencyKey.rawValue)' was already used with a different message payload.",
          suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each new message.",
          isRetriable: false,
          invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key bound to another message payload.")]
        ))
      }
      let replayed = SentMessageContract(
        messageId: contract.messageId,
        body: contract.body,
        senderId: contract.senderId,
        recipientId: contract.recipientId,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    guard self.remainingQuota > 0 else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) messages exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      ))
    }
    self.remainingQuota -= 1

    return schema.validate().flatMap { validated in
      self.bridge.sendMessage(contract: validated).map { msg in
        let output = SentMessageContract(
          messageId: msg.id,
          body: msg.body,
          senderId: msg.sender.id,
          recipientId: msg.recipient.id,
          idempotencyReplayed: false
        )
        self.messageStore[idempotencyKey] = (schema, output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }
}

