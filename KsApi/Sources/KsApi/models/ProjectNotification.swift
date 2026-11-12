import Foundation

/// @deprecated Legacy project notification mutation payload.
/// Route all new callers to `UpdateProjectNotificationRequestSchema` and `NotificationsController.updateProjectNotificationEndpoint` in `KsApi/modules/notifications`.
public struct ProjectNotification {
  /// Agent Experience deprecation metadata directing callers to `NotificationsController`.
  public static let axDeprecationDescriptor = AXFieldDescriptor.describe(
    field: "ProjectNotification",
    meaning: "Legacy project notification mutation model lacking boundary validation and Idempotency-Key safety.",
    format: "Legacy REST model (Deprecated)",
    negativeConstraints: ["Do not invoke ServiceType.updateProjectNotification(_:) directly in automated agent workflows."],
    deprecated: true,
    replacementPrimitive: "UpdateProjectNotificationRequestSchema via NotificationsController.handleUpdateNotification(payload:headers:)"
  )
  /// Whether email notifications are enabled for updates to `project`.
  public let email: Bool
  /// Unique numeric identifier for this project notification subscription.
  public let id: Int
  /// Whether mobile push notifications are enabled for updates to `project`.
  public let mobile: Bool
  /// Minimal project reference associated with this notification setting.
  public let project: Project

  /// Lightweight project summary embedded in `ProjectNotification`.
  public struct Project {
    /// Numeric project identifier.
    public let id: Int
    /// Display title of the project.
    public let name: String
  }
}

extension ProjectNotification: Decodable {}

extension ProjectNotification.Project: Decodable {}

extension ProjectNotification: Equatable {}

/// Compares two `ProjectNotification` instances by their unique `id`.
public func == (lhs: ProjectNotification, rhs: ProjectNotification) -> Bool {
  return lhs.id == rhs.id
}

extension ProjectNotification.Project: Equatable {}

/// Compares two `ProjectNotification.Project` summaries by their `id`.
public func == (lhs: ProjectNotification.Project, rhs: ProjectNotification.Project) -> Bool {
  return lhs.id == rhs.id
}
