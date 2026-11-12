import Prelude

extension Item {
  /// Functional optics namespace for `Item`.
  public enum lens {
    /// Lens focusing on optional item `description`.
    public static let description = Lens<Item, String?>(
      view: { $0.description },
      set: { .init(
        description: $0, id: $1.id, name: $1.name,
        projectId: $1.projectId
      ) }
    )

    /// Lens focusing on item `id`.
    public static let id = Lens<Item, Int>(
      view: { $0.id },
      set: { .init(
        description: $1.description, id: $0, name: $1.name,
        projectId: $1.projectId
      ) }
    )

    /// Lens focusing on item `name`.
    public static let name = Lens<Item, String>(
      view: { $0.name },
      set: { .init(
        description: $1.description, id: $1.id, name: $0,
        projectId: $1.projectId
      ) }
    )

    /// Lens focusing on owning `projectId`.
    public static let projectId = Lens<Item, Int>(
      view: { $0.projectId },
      set: { .init(
        description: $1.description, id: $1.id, name: $1.name,
        projectId: $0
      ) }
    )
  }
}
