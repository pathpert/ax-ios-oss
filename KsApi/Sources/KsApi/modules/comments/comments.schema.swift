import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Comments & User Moderation

/// Poka-Yoke request schema for posting a comment or reply on a project or update.
///
/// - Negative constraint: `body` must be trimmed non-empty text (`1...2000` chars) without `<script` tags; `commentableId` must be a Base64 GraphID.
public struct PostCommentRequestSchema: Codable, Equatable, Sendable {
  /// Base64 GraphQL ID of the Project (`"Project-<id>"`) or Update (`"FreeformPost-<id>"`).
  public let commentableId: String
  /// Plain-text comment body (`1...2,000` characters).
  public let body: String
  /// Optional Base64 GraphQL ID of the parent Comment (`"Comment-<id>"`) when replying.
  public let parentId: String?

  /// Field-level descriptors and negative constraints for `PostCommentRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "commentableId": .describe(
      field: "commentableId",
      meaning: "Base64-encoded GraphQL ID of the Project or Update being commented on.",
      format: "Base64 string decoding to 'Project-<numeric_id>' or 'FreeformPost-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer project or update IDs.",
        "Do not pass project slugs."
      ]
    ),
    "body": .describe(
      field: "body",
      meaning: "Plain-text comment body.",
      format: "Non-empty trimmed UTF-8 string between 1 and 2,000 characters",
      negativeConstraints: [
        "Do not pass empty or whitespace-only strings.",
        "Do not pass raw <script> tags or executable HTML payloads.",
        "Do not exceed 2,000 characters."
      ]
    ),
    "parentId": .describe(
      field: "parentId",
      meaning: "Optional Base64-encoded GraphQL ID of the parent Comment when posting a reply.",
      format: "Base64 string decoding to 'Comment-<numeric_id>' or nil",
      negativeConstraints: [
        "Do not pass raw integer comment IDs.",
        "Do not pass the project ID as parentId."
      ]
    )
  ]

  /// Creates a `PostCommentRequestSchema` payload.
  public init(commentableId: String, body: String, parentId: String? = nil) {
    self.commentableId = commentableId
    self.body = body
    self.parentId = parentId
  }

  /// Validates target GraphID prefixes, body length/HTML safety, and optional reply parent ID.
  public func validate() -> Result<ValidatedPostCommentContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    let validCommentable = CreateCheckoutRequestSchema.isValidGraphID(self.commentableId, expectedPrefix: "Project-")
      || CreateCheckoutRequestSchema.isValidGraphID(self.commentableId, expectedPrefix: "FreeformPost-")
    if !validCommentable {
      violations.append(AXInvalidParam(
        name: "commentableId",
        reason: "Must be Base64 'Project-<id>' or 'FreeformPost-<id>'."
      ))
    }

    let trimmed = self.body.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmed.isEmpty || trimmed.count > 2000 {
      violations.append(AXInvalidParam(
        name: "body",
        reason: "Trimmed comment body must be between 1 and 2,000 characters."
      ))
    } else if trimmed.lowercased().contains("<script") {
      violations.append(AXInvalidParam(
        name: "body",
        reason: "Comment body must not contain '<script' HTML injection tags."
      ))
    }

    if let parent = self.parentId,
       !CreateCheckoutRequestSchema.isValidGraphID(parent, expectedPrefix: "Comment-") {
      violations.append(AXInvalidParam(
        name: "parentId",
        reason: "When present, parentId must be Base64 'Comment-<id>'."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "PostComment request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a Base64 'Project-<id>' or 'FreeformPost-<id>', a non-empty plain-text body <= 2000 chars, and optional Base64 'Comment-<id>' parentId.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedPostCommentContract(
      commentableId: self.commentableId,
      sanitizedBody: trimmed,
      parentId: self.parentId
    ))
  }
}

/// Validated and sanitized comment contract produced by `PostCommentRequestSchema.validate()`.
public struct ValidatedPostCommentContract: Equatable, Sendable {
  /// Validated GraphQL target ID (`"Project-<id>"` or `"FreeformPost-<id>"`).
  public let commentableId: String
  /// Trimmed plain-text comment body.
  public let sanitizedBody: String
  /// Optional validated parent comment ID (`"Comment-<id>"`).
  public let parentId: String?
}

/// Poka-Yoke request schema for blocking another Kickstarter user.
///
/// - Negative constraint: Pass a Base64 `"User-<id>"` GraphQL ID, never raw integer IDs or handles.
public struct BlockUserRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL ID of the User to block (`"User-<id>"`).
  public let blockUserId: String

  /// Field-level descriptors and negative constraints for `BlockUserRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "blockUserId": .describe(
      field: "blockUserId",
      meaning: "Base64-encoded GraphQL ID of the User to block.",
      format: "Base64 string decoding to 'User-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer user IDs or usernames.",
        "Do not use for batch user blocking."
      ]
    )
  ]

  /// Creates a `BlockUserRequestSchema` payload.
  public init(blockUserId: String) {
    self.blockUserId = blockUserId
  }

  /// Validates that `blockUserId` decodes to `"User-<numeric_id>"`.
  public func validate() -> Result<String, AXProblemDetails> {
    guard CreateCheckoutRequestSchema.isValidGraphID(self.blockUserId, expectedPrefix: "User-") else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "blockUserId '\(self.blockUserId)' is not a valid Base64 'User-<id>' GraphID.",
        suggestedAction: "Encode 'User-<numeric_id>' in Base64 format before calling the block user endpoint.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "blockUserId", reason: "Must be Base64 'User-<id>'.")]
      ))
    }
    return .success(self.blockUserId)
  }
}

/// Idempotent comment creation contract returned after posting a comment or reply.
public struct CommentMutationContract: Codable, Equatable, Sendable {
  /// Server-assigned comment GraphQL ID.
  public let commentId: String
  /// Identifier of the comment author.
  public let authorId: String
  /// Persisted comment body text.
  public let body: String
  /// Parent comment ID when the posted comment is a reply.
  public let parentId: String?
  /// `true` when posted as a threaded reply.
  public let isReply: Bool
  /// `true` when returned from the idempotency store without re-posting.
  public let idempotencyReplayed: Bool

  /// Creates a `CommentMutationContract`.
  public init(
    commentId: String,
    authorId: String,
    body: String,
    parentId: String?,
    isReply: Bool,
    idempotencyReplayed: Bool = false
  ) {
    self.commentId = commentId
    self.authorId = authorId
    self.body = body
    self.parentId = parentId
    self.isReply = isReply
    self.idempotencyReplayed = idempotencyReplayed
  }
}

