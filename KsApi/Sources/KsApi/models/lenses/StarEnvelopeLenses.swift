import Prelude

extension StarEnvelope {
  /// Functional optics namespace for `StarEnvelope`.
  public enum lens {
    /// Lens focusing on the viewer `user` returned after watching/starring.
    public static let user = Lens<StarEnvelope, User>(
      view: { $0.user },
      set: { StarEnvelope(user: $0, project: $1.project) }
    )

    /// Lens focusing on the updated `project`.
    public static let project = Lens<StarEnvelope, Project>(
      view: { $0.project },
      set: { StarEnvelope(user: $1.user, project: $0) }
    )
  }
}
