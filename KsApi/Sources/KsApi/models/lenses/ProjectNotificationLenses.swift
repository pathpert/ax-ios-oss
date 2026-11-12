import Prelude

extension ProjectNotification {
  /// Functional optics namespace for immutable `ProjectNotification` updates.
  public enum lens {
    /// Lens focusing on email notification preference.
    public static let email = Lens<ProjectNotification, Bool>(
      view: { $0.email },
      set: { ProjectNotification(email: $0, id: $1.id, mobile: $1.mobile, project: $1.project) }
    )

    /// Lens focusing on `ProjectNotification.id`.
    public static let id = Lens<ProjectNotification, Int>(
      view: { $0.id },
      set: { ProjectNotification(email: $1.email, id: $0, mobile: $1.mobile, project: $1.project) }
    )

    /// Lens focusing on mobile push notification preference.
    public static let mobile = Lens<ProjectNotification, Bool>(
      view: { $0.mobile },
      set: { ProjectNotification(email: $1.email, id: $1.id, mobile: $0, project: $1.project) }
    )

    /// Lens focusing on the nested `ProjectNotification.Project` summary.
    public static let project = Lens<ProjectNotification, ProjectNotification.Project>(
      view: { $0.project },
      set: { ProjectNotification(email: $1.email, id: $1.id, mobile: $1.mobile, project: $0) }
    )
  }
}

extension Lens where Whole == ProjectNotification, Part == ProjectNotification.Project {
  /// Composed lens focusing on the notification project's `id`.
  public var id: Lens<ProjectNotification, Int> {
    return ProjectNotification.lens.project .. ProjectNotification.Project.lens.id
  }

  /// Composed lens focusing on the notification project's `name`.
  public var name: Lens<ProjectNotification, String> {
    return ProjectNotification.lens.project .. ProjectNotification.Project.lens.name
  }
}
