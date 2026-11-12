import Foundation

// MARK: - Rule 3: Poka-Yoke Schemas for Project Notifications & Unseen Activity (KsApi)

/// Poka-Yoke request schema for updating email and push notification toggles on a backed project.
///
/// - Negative constraint: `notificationId` and `projectId` must be `> 0` and `projectName` must be `1...200` trimmed characters.
public struct UpdateProjectNotificationRequestSchema: Codable, Equatable, Sendable {
  /// Positive integer identifier of the `ProjectNotification` record.
  public let notificationId: Int
  /// Positive integer identifier of the backed project.
  public let projectId: Int
  /// Display name of the backed project (`1...200` characters).
  public let projectName: String
  /// Whether email notifications should be enabled.
  public let emailEnabled: Bool
  /// Whether mobile push notifications should be enabled.
  public let mobileEnabled: Bool

  /// Field-level descriptors and negative constraints for `UpdateProjectNotificationRequestSchema`.
  public static let fieldDescriptors: [String: AXFieldDescriptor] = [
    "notificationId": .describe(
      field: "notificationId",
      meaning: "Positive integer identifier of the ProjectNotification subscription record.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative notification IDs."
      ]
    ),
    "projectId": .describe(
      field: "projectId",
      meaning: "Positive integer identifier of the backed project.",
      format: "Positive integer > 0",
      negativeConstraints: [
        "Do not pass 0 or negative project IDs."
      ]
    ),
    "projectName": .describe(
      field: "projectName",
      meaning: "Non-empty display name of the backed project.",
      format: "Non-empty trimmed string (1-200 chars)",
      negativeConstraints: [
        "Do not pass empty or whitespace-only project names."
      ]
    )
  ]

  /// Creates an `UpdateProjectNotificationRequestSchema` payload.
  public init(
    notificationId: Int,
    projectId: Int,
    projectName: String,
    emailEnabled: Bool,
    mobileEnabled: Bool
  ) {
    self.notificationId = notificationId
    self.projectId = projectId
    self.projectName = projectName
    self.emailEnabled = emailEnabled
    self.mobileEnabled = mobileEnabled
  }

  /// Validates identifier and project name boundaries, constructing a domain `ProjectNotification`.
  public func validate() -> Result<ProjectNotification, AXProblemDetails> {
    var violations: [AXInvalidParam] = []

    if self.notificationId <= 0 {
      violations.append(AXInvalidParam(name: "notificationId", reason: "Must be a positive integer > 0."))
    }

    if self.projectId <= 0 {
      violations.append(AXInvalidParam(name: "projectId", reason: "Must be a positive integer > 0."))
    }

    let trimmedName = self.projectName.trimmingCharacters(in: .whitespacesAndNewlines)
    if trimmedName.isEmpty || trimmedName.count > 200 {
      violations.append(AXInvalidParam(
        name: "projectName",
        reason: "Must be a non-empty string between 1 and 200 characters."
      ))
    }

    guard violations.isEmpty else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Invalid Project Notification Payload",
        status: 400,
        detail: "Project notification update failed Poka-Yoke boundary validation.",
        suggestedAction: "Provide positive notificationId (> 0), projectId (> 0), and a non-empty projectName.",
        isRetriable: false,
        invalidParams: violations
      ))
    }

    let notification = ProjectNotification(
      email: self.emailEnabled,
      id: self.notificationId,
      mobile: self.mobileEnabled,
      project: ProjectNotification.Project(id: self.projectId, name: trimmedName)
    )
    return .success(notification)
  }
}

/// Poka-Yoke request schema requiring explicit confirmation before clearing the unseen activity badge.
public struct ClearUnseenActivityRequestSchema: Codable, Equatable, Sendable {
  /// Confirmation guard; must be `true` to reset the user's unseen activity indicator.
  public let confirmClearUnseenCount: Bool

  /// Creates a `ClearUnseenActivityRequestSchema` payload.
  public init(confirmClearUnseenCount: Bool = true) {
    self.confirmClearUnseenCount = confirmClearUnseenCount
  }

  /// Validates explicit confirmation (`confirmClearUnseenCount == true`).
  public func validate() -> Result<EmptyInput, AXProblemDetails> {
    guard self.confirmClearUnseenCount else {
      return .failure(AXProblemDetails(
        type: "https://docs.kickstarter.com/errors/invalid-parameter",
        title: "Unconfirmed Unseen Activity Clear",
        status: 400,
        detail: "confirmClearUnseenCount must be true to reset the user's unseen activity indicator.",
        suggestedAction: "Set confirmClearUnseenCount=true when calling POST /ax/v1/notifications/clear-unseen.",
        isRetriable: false,
        invalidParams: [AXInvalidParam(name: "confirmClearUnseenCount", reason: "Must be true.")]
      ))
    }
    return .success(EmptyInput())
  }
}

/// Idempotent contract emitted after persisting project notification preferences.
public struct ProjectNotificationContract: Codable, Equatable, Sendable {
  /// Notification subscription identifier.
  public let notificationId: Int
  /// Project identifier associated with the notification setting.
  public let projectId: Int
  /// Resulting email notification enabled state.
  public let emailEnabled: Bool
  /// Resulting mobile push notification enabled state.
  public let mobileEnabled: Bool
  /// `true` when served from the idempotency cache.
  public let idempotencyReplayed: Bool
}

/// Idempotent contract emitted after clearing the user's unseen activity badge counter.
public struct ClearUnseenActivityContract: Codable, Equatable, Sendable {
  /// Remaining unseen activity indicator count (`0` after reset).
  public let activityIndicatorCount: Int
  /// `true` when served from the idempotency cache.
  public let idempotencyReplayed: Bool
}

