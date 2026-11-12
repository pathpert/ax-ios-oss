

/// Response envelope returned after watching (starring) or unwatching a project.
public struct StarEnvelope {
  /// Updated current viewer record.
  public let user: User
  /// Updated project reflecting the viewer's new watch state.
  public let project: Project
}

extension StarEnvelope: Decodable {}
