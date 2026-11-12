import Prelude

extension User.Avatar {
  /// Functional optics namespace for `User.Avatar`.
  public enum lens {
    /// Lens focusing on `large` avatar URL string.
    public static let large = Lens<User.Avatar, String?>(
      view: { $0.large },
      set: { User.Avatar(large: $0, medium: $1.medium, small: $1.small) }
    )

    /// Lens focusing on `medium` avatar URL string.
    public static let medium = Lens<User.Avatar, String>(
      view: { $0.medium },
      set: { User.Avatar(large: $1.large, medium: $0, small: $1.small) }
    )

    /// Lens focusing on `small` avatar URL string.
    public static let small = Lens<User.Avatar, String>(
      view: { $0.small },
      set: { User.Avatar(large: $1.large, medium: $1.medium, small: $0) }
    )
  }
}
