import Foundation
@preconcurrency import GraphAPI

// MARK: - Rule 3: Poka-Yoke Schemas for Project Watch & Content Flagging

/// Poka-Yoke request schema for watching or unwatching a Kickstarter project.
///
/// - Negative constraint: Pass a Base64 `"Project-<id>"` GraphQL ID, never raw integer IDs or slugs.
public struct WatchProjectRequestSchema: Codable, Equatable, Sendable {
  /// Base64-encoded GraphQL Global ID of the Project (`"Project-<id>"`).
  public let projectId: String
  /// Optional analytics surface identifier (`1...64` chars, no URL schemes).
  public let trackingContext: String?

  /// Field-level descriptors and negative constraints for `WatchProjectRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "projectId": .describe(
      field: "projectId",
      meaning: "Base64-encoded GraphQL Global ID of the Project to watch or unwatch.",
      format: "Base64 string decoding to 'Project-<numeric_id>'",
      negativeConstraints: [
        "Do not pass raw integer project IDs or slugs.",
        "Do not use for batch watch/unwatch operations."
      ]
    ),
    "trackingContext": .describe(
      field: "trackingContext",
      meaning: "Optional analytics surface identifier where the watch action originated.",
      format: "Non-empty alphanumeric/underscore string <= 64 chars or nil",
      negativeConstraints: ["Do not pass full URLs or JSON blobs as trackingContext."]
    )
  ]

  /// Creates a `WatchProjectRequestSchema` payload.
  public init(projectId: String, trackingContext: String? = nil) {
    self.projectId = projectId
    self.trackingContext = trackingContext
  }

  /// Validates GraphID prefix and optional tracking context constraints.
  public func validate() -> Result<WatchProjectRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if !CreateCheckoutRequestSchema.isValidGraphID(self.projectId, expectedPrefix: "Project-") {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be Base64 'Project-<id>'."))
    }
    if let ctx = self.trackingContext,
       ctx.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty || ctx.count > 64 || ctx.contains("://") {
      violations.append(AXInvalidParam(
        name: "trackingContext",
        reason: "When present, must be a concise surface identifier (1..64 chars) without URL schemes."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "WatchProject request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a Base64-encoded 'Project-<id>' and an optional concise trackingContext <= 64 characters.",
        isRetriable: false,
        invalidParams: violations
      ))
    }
    return .success(self)
  }
}

/// Poka-Yoke request schema for reporting/flagging abusive content on Kickstarter.
///
/// - Negative constraint: `contentId` must decode to `"Project-<id>"`, `"Comment-<id>"`, or `"FreeformPost-<id>"`.
public struct CreateFlaggingRequestSchema: Equatable, Sendable {
  /// Base64-encoded GraphQL ID of the flagged resource.
  public let contentId: String
  /// Typed moderation violation category.
  public let kind: GraphAPI.NonDeprecatedFlaggingKind
  /// Optional reporter rationale (`1...1,000` non-whitespace characters when present).
  public let details: String?

  /// Field-level descriptors and negative constraints for `CreateFlaggingRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "contentId": .describe(
      field: "contentId",
      meaning: "Base64-encoded GraphQL ID of the Project, Comment, or Backing being flagged.",
      format: "Base64 string decoding to 'Project-<id>', 'Comment-<id>', or 'FreeformPost-<id>'",
      negativeConstraints: [
        "Do not pass raw integer IDs.",
        "Do not use for batch flagging."
      ]
    ),
    "details": .describe(
      field: "details",
      meaning: "Optional human-readable explanation of why the content violates guidelines.",
      format: "Plain-text string between 1 and 1,000 characters or nil",
      negativeConstraints: [
        "Do not pass empty whitespace-only strings when details is provided.",
        "Do not exceed 1,000 characters."
      ]
    )
  ]

  /// Creates a `CreateFlaggingRequestSchema` payload.
  public init(contentId: String, kind: GraphAPI.NonDeprecatedFlaggingKind, details: String? = nil) {
    self.contentId = contentId
    self.kind = kind
    self.details = details
  }

  /// Validates `contentId` GraphID prefix and optional `details` length.
  public func validate() -> Result<CreateFlaggingRequestSchema, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    let validTarget = CreateCheckoutRequestSchema.isValidGraphID(self.contentId, expectedPrefix: "Project-")
      || CreateCheckoutRequestSchema.isValidGraphID(self.contentId, expectedPrefix: "Comment-")
      || CreateCheckoutRequestSchema.isValidGraphID(self.contentId, expectedPrefix: "FreeformPost-")

    if !validTarget {
      violations.append(AXInvalidParam(
        name: "contentId",
        reason: "Must be Base64 'Project-<id>', 'Comment-<id>', or 'FreeformPost-<id>'."
      ))
    }

    if let rawDetails = self.details {
      let trimmed = rawDetails.trimmingCharacters(in: .whitespacesAndNewlines)
      if trimmed.isEmpty || trimmed.count > 1000 {
        violations.append(AXInvalidParam(
          name: "details",
          reason: "When present, details must be 1..1,000 non-whitespace characters."
        ))
      }
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Parameter",
        status: 400,
        detail: "CreateFlagging request failed Poka-Yoke boundary validation (\(violations.count) violation(s)).",
        suggestedAction: "Provide a valid Base64 contentId ('Project-<id>', 'Comment-<id>', or 'FreeformPost-<id>') and optional details <= 1,000 characters.",
        isRetriable: false,
        invalidParams: violations
      ))
    }
    return .success(self)
  }
}

/// Idempotent result contract emitted after watching or unwatching a project.
public struct ProjectWatchContract: Codable, Equatable, Sendable {
  /// Base64 GraphQL identifier of the target project.
  public let projectId: String
  /// Resulting watch state (`true` = watching, `false` = unwatched).
  public let isWatched: Bool
  /// Updated total watcher count reported by the server.
  public let watchesCount: Int
  /// `true` when returned from the idempotency store without re-running the mutation.
  public let idempotencyReplayed: Bool

  /// Creates a `ProjectWatchContract`.
  public init(
    projectId: String,
    isWatched: Bool,
    watchesCount: Int,
    idempotencyReplayed: Bool = false
  ) {
    self.projectId = projectId
    self.isWatched = isWatched
    self.watchesCount = watchesCount
    self.idempotencyReplayed = idempotencyReplayed
  }
}

