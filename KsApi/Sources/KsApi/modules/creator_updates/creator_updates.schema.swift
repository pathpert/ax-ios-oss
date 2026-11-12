import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Creator Updates & Draft Publishing

/// Poka-Yoke request schema for updating a creator's project update draft.
///
/// - Negative constraint: `draftId` and `projectId` must be `> 0`; `title` is `1...120` chars and `body` is `1...20,000` chars without `<script` tags.
public struct UpdateCreatorDraftRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the creator `UpdateDraft`.
  public let draftId: Int
  /// Positive integer identifier of the owning Project.
  public let projectId: Int
  /// Update headline (`1...120` trimmed characters).
  public let title: String
  /// Update body content (`1...20,000` trimmed characters without `<script`).
  public let body: String
  /// Whether publishing makes the update visible to the general public rather than backers only.
  public let isPublic: Bool

  /// Field-level descriptors and negative constraints for `UpdateCreatorDraftRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "draftId": .describe(
      field: "draftId",
      meaning: "Positive integer identifier of the creator UpdateDraft.",
      format: "Positive integer > 0",
      negativeConstraints: ["Do not pass 0 or negative integers."]
    ),
    "projectId": .describe(
      field: "projectId",
      meaning: "Positive integer identifier of the Project owning the update draft.",
      format: "Positive integer > 0",
      negativeConstraints: ["Do not pass 0 or negative integers."]
    ),
    "title": .describe(
      field: "title",
      meaning: "Headline title of the creator project update.",
      format: "Non-empty trimmed UTF-8 string between 1 and 120 characters",
      negativeConstraints: [
        "Do not pass empty or whitespace-only titles.",
        "Do not exceed 120 characters."
      ]
    ),
    "body": .describe(
      field: "body",
      meaning: "Main body content of the creator project update.",
      format: "Non-empty trimmed UTF-8 string between 1 and 20,000 characters",
      negativeConstraints: [
        "Do not pass empty or whitespace-only body strings.",
        "Do not pass '<script' HTML injection tags."
      ]
    )
  ]

  /// Creates an `UpdateCreatorDraftRequestSchema` payload.
  public init(draftId: Int, projectId: Int, title: String, body: String, isPublic: Bool) {
    self.draftId = draftId
    self.projectId = projectId
    self.title = title
    self.body = body
    self.isPublic = isPublic
  }

  /// Validates positive identifiers, length bounds, and HTML injection safety.
  public func validate() -> Result<ValidatedUpdateDraftContract, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.draftId <= 0 {
      violations.append(AXInvalidParam(name: "draftId", reason: "Must be a positive integer > 0."))
    }
    if self.projectId <= 0 {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be a positive integer > 0."))
    }
    let trimmedTitle = self.title.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedTitle.isEmpty || trimmedTitle.count > 120 {
      violations.append(AXInvalidParam(name: "title", reason: "Trimmed title must be 1..120 characters."))
    }
    let trimmedBody = self.body.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedBody.isEmpty || trimmedBody.count > 20_000 {
      violations.append(AXInvalidParam(name: "body", reason: "Trimmed body must be 1..20,000 characters."))
    } else if trimmedBody.lowercased().contains("<script") {
      violations.append(AXInvalidParam(name: "body", reason: "Body must not contain '<script' tags."))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "UpdateCreatorDraft request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide positive draftId/projectId, a title <= 120 chars, and a clean body <= 20,000 chars.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    return .success(ValidatedUpdateDraftContract(
      draftId: self.draftId,
      projectId: self.projectId,
      sanitizedTitle: trimmedTitle,
      sanitizedBody: trimmedBody,
      isPublic: self.isPublic
    ))
  }
}

/// Validated and sanitized creator draft update payload produced by `UpdateCreatorDraftRequestSchema.validate()`.
public struct ValidatedUpdateDraftContract: Equatable, Sendable {
  /// Positive integer `UpdateDraft` identifier.
  public let draftId: Int
  /// Positive integer `Project` identifier.
  public let projectId: Int
  /// Trimmed headline string.
  public let sanitizedTitle: String
  /// Trimmed body string free of `<script` tags.
  public let sanitizedBody: String
  /// Visibility flag (`true` = public, `false` = backers only).
  public let isPublic: Bool
}

/// Poka-Yoke request schema for publishing a creator's project update draft.
///
/// - Negative constraint: Both `draftId` and `projectId` must be positive (`> 0`).
public struct PublishCreatorDraftRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the draft to publish.
  public let draftId: Int
  /// Positive integer identifier of the owning project.
  public let projectId: Int

  /// Field-level descriptors and negative constraints for `PublishCreatorDraftRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "draftId": .describe(
      field: "draftId",
      meaning: "Positive integer ID of the UpdateDraft to publish.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative integers.",
        "Do not use for batch publishing."
      ]
    ),
    "projectId": .describe(
      field: "projectId",
      meaning: "Positive integer ID of the Project owning the draft.",
      format: "Positive integer > 0",
      negativeConstraints: ["Do not pass 0 or negative integers."]
    )
  ]

  /// Creates a `PublishCreatorDraftRequestSchema` payload.
  public init(draftId: Int, projectId: Int) {
    self.draftId = draftId
    self.projectId = projectId
  }

  /// Validates that `draftId` and `projectId` are positive integers (`> 0`).
  public func validate() -> Result<PublishCreatorDraftRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []
    if self.draftId <= 0 {
      violations.append(AXInvalidParam(name: "draftId", reason: "Must be > 0."))
    }
    if self.projectId <= 0 {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be > 0."))
    }
    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "PublishCreatorDraft request failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide positive integer values (> 0) for both draftId and projectId.",
        isRetriable: false,
        invalidParams: violations
      ))
    }
    return .success(self)
  }
}

/// Idempotent receipt emitted after updating or publishing a creator update.
public struct CreatorUpdateDraftContract: Codable, Equatable, Sendable {
  /// Server-assigned numeric identifier of the draft or published update.
  public let updateId: Int
  /// Identifier of the owning project.
  public let projectId: Int
  /// Persisted update headline.
  public let title: String
  /// Public visibility status of the update.
  public let isPublic: Bool
  /// `true` when returned from the idempotency store without re-executing the mutation.
  public let idempotencyReplayed: Bool

  /// Creates a `CreatorUpdateDraftContract`.
  public init(
    updateId: Int,
    projectId: Int,
    title: String,
    isPublic: Bool,
    idempotencyReplayed: Bool = false
  ) {
    self.updateId = updateId
    self.projectId = projectId
    self.title = title
    self.isPublic = isPublic
    self.idempotencyReplayed = idempotencyReplayed
  }
}

