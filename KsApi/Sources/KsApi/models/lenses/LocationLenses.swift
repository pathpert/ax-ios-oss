import Prelude

extension Location {
  /// Functional optics namespace for `Location`.
  public enum lens {
    /// Lens focusing on ISO `country` code.
    public static let country = Lens<Location, String>(
      view: { $0.country },
      set: { Location(
        country: $0, displayableName: $1.displayableName, id: $1.id,
        localizedName: $1.localizedName, name: $1.name
      ) }
    )

    /// Lens focusing on `displayableName`.
    public static let displayableName = Lens<Location, String>(
      view: { $0.displayableName },
      set: { Location(
        country: $1.country, displayableName: $0, id: $1.id, localizedName: $1.localizedName,
        name: $1.name
      ) }
    )

    /// Lens focusing on location `id`.
    public static let id = Lens<Location, Int>(
      view: { $0.id },
      set: { Location(
        country: $1.country, displayableName: $1.displayableName, id: $0,
        localizedName: $1.localizedName, name: $1.name
      ) }
    )

    /// Lens focusing on `localizedName`.
    public static let localizedName = Lens<Location, String>(
      view: { $0.localizedName },
      set: { Location(
        country: $1.country, displayableName: $1.displayableName, id: $1.id,
        localizedName: $0, name: $1.name
      ) }
    )

    /// Lens focusing on `name`.
    public static let name = Lens<Location, String>(
      view: { $0.name },
      set: { Location(
        country: $1.country, displayableName: $1.displayableName, id: $1.id,
        localizedName: $1.localizedName, name: $0
      ) }
    )
  }
}
