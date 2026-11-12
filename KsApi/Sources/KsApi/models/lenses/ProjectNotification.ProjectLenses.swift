import Prelude

extension ProjectNotification.Project {
  /// Functional optics namespace for `ProjectNotification.Project`.
  public enum lens {
    /// Lens focusing on notification project `id`.
    public static let id = Lens<ProjectNotification.Project, Int>(
      view: { $0.id },
      set: { ProjectNotification.Project(id: $0, name: $1.name) }
    )

    /// Lens focusing on notification project `name`.
    public static let name = Lens<ProjectNotification.Project, String>(
      view: { $0.name },
      set: { ProjectNotification.Project(id: $1.id, name: $0) }
    )
  }
}
