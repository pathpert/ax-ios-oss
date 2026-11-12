import Foundation
import Prelude

extension Category {
  /// Functional lenses for `Category`.
  public enum lens {
    private static func copy(
      _ category: Category,
      analyticsName: String?? = nil,
      id: String? = nil,
      name: String? = nil,
      parentCategory: ParentCategory?? = nil,
      parentId: String?? = nil,
      subcategories: Category.SubcategoryConnection?? = nil,
      totalProjectCount: Int?? = nil
    ) -> Category {
      Category(
        analyticsName: analyticsName ?? category.analyticsName,
        id: id ?? category.id,
        name: name ?? category.name,
        parentCategory: parentCategory ?? category._parent,
        parentId: parentId ?? category.parentId,
        subcategories: subcategories ?? category.subcategories,
        totalProjectCount: totalProjectCount ?? category.totalProjectCount
      )
    }

    /// Lens focusing on the analytics-safe English category slug.
    public static let analyticsName = Lens<Category, String?>(
      view: { $0.analyticsName },
      set: { copy($1, analyticsName: .some($0)) }
    )

    /// Lens focusing on the GraphQL node identifier for the category.
    public static let id = Lens<Category, String>(
      view: { $0.id },
      set: { copy($1, id: $0) }
    )

    /// Lens focusing on the localized display name of the category.
    public static let name = Lens<Category, String>(
      view: { $0.name },
      set: { copy($1, name: $0) }
    )

    /// Lens focusing on the optional parent category reference.
    public static let parent = Lens<Category, ParentCategory?>(
      view: { $0._parent },
      set: { copy($1, parentCategory: .some($0)) }
    )

    /// Lens focusing on the optional parent category identifier string.
    public static let parentId = Lens<Category, String?>(
      view: { $0.parentId },
      set: { copy($1, parentId: .some($0)) }
    )

    /// Lens focusing on nested subcategory connections.
    public static let subcategories = Lens<Category, Category.SubcategoryConnection?>(
      view: { $0.subcategories },
      set: { copy($1, subcategories: .some($0)) }
    )

    /// Lens focusing on total project count in the category.
    public static let totalProjectCount = Lens<Category, Int?>(
      view: { $0.totalProjectCount },
      set: { copy($1, totalProjectCount: .some($0)) }
    )
  }
}
