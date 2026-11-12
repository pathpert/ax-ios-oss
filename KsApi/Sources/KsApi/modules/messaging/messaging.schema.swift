import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Creator & Backer Messaging

/// Poka-Yoke request schema for sending a direct message to a creator or existing thread.
///
/// - Negative constraint: `targetNumericId` must be `> 0`; `body` must be plain text (`1...5,000` chars) without `<script` tags.
public struct SendMessageRequestSchema: Codable, Equatable, Sendable {
  /// Recipient container kind resolved against `MessageSubject`.
  public enum TargetKind: String, Codable, Equatable, Sendable {
    /// Initiates or continues messaging with the creator of a Project.
    case project
    /// Replies inside an existing conversation thread.
    case messageThread
  }

  /// Target resource kind (`.project` or `.messageThread`).
  public let targetKind: TargetKind
  /// Positive integer identifier of the target Project or MessageThread.
  public let targetNumericId: Int
  /// Display label for the recipient project or thread subject.
  public let targetName: String
  /// Plain-text message content (`1...5,000` trimmed characters).
  public let body: String

  /// Field-level descriptors and negative constraints for `SendMessageRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "targetNumericId": .describe(
      field: "targetNumericId",
      meaning: "Positive integer identifier of the target Project or MessageThread.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative integers.",
        "Do not use for mass/broadcast messaging across multiple threads."
      ]
    ),
    "body": .describe(
      field: "body",
      meaning: "Plain-text message body sent to the creator or backer.",
      format: "Non-empty trimmed UTF-8 string between 1 and 5,000 characters",
      negativeConstraints: [
        "Do not pass empty or whitespace-only strings.",
        "Do not pass '<script' HTML injection payloads.",
        "Do not exceed 5,000 characters."
      ]
    )
  ]

  /// Creates a `SendMessageRequestSchema` payload.
  public init(targetKind: TargetKind, targetNumericId: Int, targetName: String, body: String) {
    self.targetKind = targetKind
    self.targetNumericId = targetNumericId
    self.targetName = targetName
    self.body = body
  }

  /// Validates positive `targetNumericId` and message body length/HTML boundaries.
  public func validate() -> Result<ValidatedSendMessageContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.targetNumericId <= 0 {
      violations.append(AXInvalidParam(
        name: "targetNumericId",
        reason: "Must be a positive integer > 0."
      ))
    }
    let trimmedBody = self.body.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedBody.isEmpty || trimmedBody.count > 5000 {
      violations.append(AXInvalidParam(
        name: "body",
        reason: "Trimmed message body must be between 1 and 5,000 characters."
      ))
    } else if trimmedBody.lowercased().contains("<script") {
      violations.append(AXInvalidParam(
        name: "body",
        reason: "Message body must not contain '<script' tags."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "SendMessage request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a positive targetNumericId > 0 and a plain-text message body between 1 and 5,000 characters.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedSendMessageContract(
      targetKind: self.targetKind,
      targetNumericId: self.targetNumericId,
      targetName: self.targetName,
      sanitizedBody: trimmedBody
    ))
  }
}

/// Validated and sanitized direct-message payload emitted by `SendMessageRequestSchema.validate()`.
public struct ValidatedSendMessageContract: Equatable, Sendable {
  /// Target resource kind.
  public let targetKind: SendMessageRequestSchema.TargetKind
  /// Positive target identifier (`> 0`).
  public let targetNumericId: Int
  /// Recipient project or thread display name.
  public let targetName: String
  /// Trimmed plain-text message body free of `<script` tags.
  public let sanitizedBody: String
}

/// Idempotent contract emitted after delivering a direct message.
public struct SentMessageContract: Codable, Equatable, Sendable {
  /// Server-assigned numeric message ID.
  public let messageId: Int
  /// Delivered plain-text message body.
  public let body: String
  /// Numeric user ID of the sender.
  public let senderId: Int
  /// Numeric user ID of the recipient.
  public let recipientId: Int
  /// `true` when replayed from the idempotency cache without re-sending.
  public let idempotencyReplayed: Bool

  /// Creates a `SentMessageContract`.
  public init(
    messageId: Int,
    body: String,
    senderId: Int,
    recipientId: Int,
    idempotencyReplayed: Bool = false
  ) {
    self.messageId = messageId
    self.body = body
    self.senderId = senderId
    self.recipientId = recipientId
    self.idempotencyReplayed = idempotencyReplayed
  }
}

