import Foundation
import ReactiveSwift

// MARK: - Rule 1: Strangler Fig Legacy Adapter for Comments & Moderation

/// Isolates legacy `ServiceType` comment posting and user-blocking calls behind `AXProblemDetails`.
public protocol CommentsLegacyBridgeProtocol {
  /// Publishes a top-level comment or reply on a project/update thread.
  func postComment(contract: ValidatedPostCommentContract) -> Result<Comment, AXProblemDetails>
  /// Blocks a user account for moderation/safety.
  func blockUser(userId: String) -> Result<EmptyResponseEnvelope, AXProblemDetails>
}

/// Default Strangler Fig adapter delegating comment and moderation calls to `ServiceType`.
public final class LegacyCommentsServiceAdapter: CommentsLegacyBridgeProtocol {
  private let legacyService: ServiceType

  /// Creates an adapter backed by the given `ServiceType`.
  public init(legacyService: ServiceType) {
    self.legacyService = legacyService
  }

  /// Posts a comment synchronously and translates legacy errors.
  public func postComment(contract: ValidatedPostCommentContract) -> Result<Comment, AXProblemDetails> {
    let input = PostCommentInput(
      body: contract.sanitizedBody,
      commentableId: contract.commentableId,
      parentId: contract.parentId
    )
    guard let result = self.legacyService.postComment(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on postComment"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "postComment"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "postComment")
    }
  }

  /// Blocks a user synchronously and translates legacy errors.
  /// Blocks a user idempotently while enforcing rate-limit quota.
  public func blockUser(userId: String) -> Result<EmptyResponseEnvelope, AXProblemDetails> {
    let input = BlockUserInput(blockUserId: userId)
    guard let result = self.legacyService.blockUser(input: input).single() else {
      return .failure(LegacyCheckoutServiceAdapter.translateLegacyError(
        ErrorEnvelope(errorMessages: ["Empty signal on blockUser"], ksrCode: .UnknownCode, httpCode: 502, exception: nil),
        operation: "blockUser"
      ))
    }
    return result.mapError {
      LegacyCheckoutServiceAdapter.translateLegacyError($0, operation: "blockUser")
    }
  }
}

// MARK: - Rule 2 & Rule 5: Comments Module Service (Idempotency + Rate Limit Guardrails)

/// Rate-limited, idempotent service orchestrating comment posting and user blocking.
///
/// Negative Constraint: Reusing an `IdempotencyKey` with a modified comment or target fails with HTTP 409 conflict.
public final class CommentsModuleService {
  private struct CachedCommentEntry {
    let fingerprint: PostCommentRequestSchema
    let contract: CommentMutationContract
  }

  private let bridge: CommentsLegacyBridgeProtocol
  private let rateLimitMax: Int
  private let retryAfterSeconds: Int
  private var remainingQuota: Int
  private var commentStore: [IdempotencyKey: CachedCommentEntry] = [:]
  private var blockStore: [IdempotencyKey: String] = [:]

  /// Creates a `CommentsModuleService` with explicit bridge and rate-limit configuration.
  public init(
    bridge: CommentsLegacyBridgeProtocol,
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
      bridge: LegacyCommentsServiceAdapter(legacyService: legacyService),
      rateLimitMax: rateLimitMax,
      initialRemainingQuota: initialRemainingQuota,
      retryAfterSeconds: retryAfterSeconds
    )
  }

  /// Posts a comment or reply idempotently while enforcing rate-limit quota.
  public func postComment(
    schema: PostCommentRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<CommentMutationContract>, AXProblemDetails> {
    if let existing = self.commentStore[idempotencyKey] {
      guard existing.fingerprint == schema else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      let replayed = CommentMutationContract(
        commentId: existing.contract.commentId,
        authorId: existing.contract.authorId,
        body: existing.contract.body,
        parentId: existing.contract.parentId,
        isReply: existing.contract.isReply,
        idempotencyReplayed: true
      )
      return .success(AXServiceResponse(
        value: replayed,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() {
      return .failure(rateLimitError)
    }

    return schema.validate().flatMap { validated in
      self.bridge.postComment(contract: validated).map { comment in
        let output = CommentMutationContract(
          commentId: comment.id,
          authorId: comment.author.id,
          body: comment.body,
          parentId: comment.parentId,
          isReply: comment.isReply,
          idempotencyReplayed: false
        )
        self.commentStore[idempotencyKey] = CachedCommentEntry(fingerprint: schema, contract: output)
        return AXServiceResponse(
          value: output,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  /// Blocks a user idempotently while enforcing rate-limit quota.
  public func blockUser(
    schema: BlockUserRequestSchema,
    idempotencyKey: IdempotencyKey
  ) -> Result<AXServiceResponse<Bool>, AXProblemDetails> {
    if let existingUserId = self.blockStore[idempotencyKey] {
      guard existingUserId == schema.blockUserId else {
        return .failure(Self.idempotencyConflict(key: idempotencyKey))
      }
      return .success(AXServiceResponse(
        value: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
      ))
    }

    if let rateLimitError = self.consumeRateLimitBudget() {
      return .failure(rateLimitError)
    }

    return schema.validate().flatMap { validatedUserId in
      self.bridge.blockUser(userId: validatedUserId).map { _ in
        self.blockStore[idempotencyKey] = validatedUserId
        return AXServiceResponse(
          value: true,
          rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: self.remainingQuota)
        )
      }
    }
  }

  private static func idempotencyConflict(key: IdempotencyKey) -> AXProblemDetails {
    AXProblemDetails(
      type: "https://docs.kickstarter.com/errors/idempotency-conflict",
      title: "Idempotency-Key Payload Conflict",
      status: 409,
      detail: "Idempotency-Key '\(key.rawValue)' was already used with a different comment or block payload.",
      suggestedAction: "Generate a fresh UUID v4 'Idempotency-Key' for each distinct comment or user block operation.",
      isRetriable: false,
      invalidParams: [AXInvalidParam(name: "Idempotency-Key", reason: "Key already bound to a different payload.")]
    )
  }

  private func consumeRateLimitBudget() -> AXProblemDetails? {
    guard self.remainingQuota > 0 else {
      return AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/rate-limit-exceeded",
        title: "Rate Limit Exceeded",
        status: 429,
        detail: "Machine-tempo rate limit of \(self.rateLimitMax) comment/moderation mutations exceeded.",
        suggestedAction: "Wait \(self.retryAfterSeconds) seconds as specified by 'Retry-After' before retrying.",
        isRetriable: true,
        rateLimitHeaders: AXRateLimitHeaders(limit: self.rateLimitMax, remaining: 0, retryAfterSeconds: self.retryAfterSeconds)
      )
    }
    self.remainingQuota -= 1
    return nil
  }
}

