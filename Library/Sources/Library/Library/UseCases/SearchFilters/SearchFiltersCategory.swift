import KsApi

/// Selected category filter state supporting no selection, root category, or root + subcategory.
/// - Negative Constraint: Equality compares canonical `Category.id` values rather than full model payloads.
public enum SearchFiltersCategory: Equatable {
  case none
  case rootCategory(KsApi.Category)
  case subcategory(rootCategory: KsApi.Category, subcategory: KsApi.Category)

  /// Display name of the most specific selected category, or `nil` when `.none`.
  public var name: String? {
    return self.category?.name
  }

  /// Most specific selected `KsApi.Category`, or `nil` when `.none`.
  public var category: KsApi.Category? {
    switch self {
    case .none:
      return nil
    case let .rootCategory(rootCategory):
      return rootCategory
    case let .subcategory(_, subcategory):
      return subcategory
    }
  }

  /// Returns `true` if `category` matches the selected root category.
  public func isRootCategorySelected(_ category: KsApi.Category) -> Bool {
    switch self {
    case .none:
      return false
    case let .rootCategory(root):
      return root.id == category.id
    case let .subcategory(root, _):
      return root.id == category.id
    }
  }

  /// Returns `true` if `category` matches the selected subcategory.
  public func isSubcategorySelected(_ category: KsApi.Category) -> Bool {
    switch self {
    case .none:
      return false
    case .rootCategory:
      return false
    case let .subcategory(_, subcategory):
      return subcategory.id == category.id
    }
  }

  /// Returns `true` when a subcategory filter is currently active.
  public func hasSubcategory() -> Bool {
    switch self {
    case .none:
      return false
    case .rootCategory:
      return false
    case .subcategory:
      return true
    }
  }
}

/// Compares two `SearchFiltersCategory` selections by category identifier.
public func == (lhs: SearchFiltersCategory, rhs: SearchFiltersCategory) -> Bool {
  switch (lhs, rhs) {
  case (.none, .none):
    return true

  case let (.rootCategory(leftCategory), .rootCategory(rightCategory)):
    return leftCategory.id == rightCategory.id

  case let (
    .subcategory(leftRootCategory, leftSubcategory),
    .subcategory(rightRootCategory, rightSubcategory)
  ):
    return leftRootCategory.id == rightRootCategory.id &&
      leftSubcategory.id == rightSubcategory.id

  default:
    return false
  }
}
