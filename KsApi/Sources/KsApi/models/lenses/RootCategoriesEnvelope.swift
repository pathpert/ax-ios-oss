/// GraphQL response envelope containing top-level root discovery categories.
public struct RootCategoriesEnvelope: Decodable {
  /// Ordered list of root `Category` models.
  public var rootCategories: [Category]
}
