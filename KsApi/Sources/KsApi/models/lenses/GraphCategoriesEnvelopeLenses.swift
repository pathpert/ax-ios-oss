import Prelude

extension RootCategoriesEnvelope {
  /// Functional optics namespace for `RootCategoriesEnvelope`.
  public enum lens {
    /// Lens focusing on `rootCategories` array.
    public static let categories = Lens<RootCategoriesEnvelope, [Category]>(
      view: { $0.rootCategories },
      set: { part, _ in RootCategoriesEnvelope(rootCategories: part) }
    )
  }
}
