import Foundation
/// Lightweight representation of a root Kickstarter project category nested inside `Category`.
///
/// Format: Base64-encoded GraphQL ID (`id`) or numeric string converted via `categoryType`.
/// Negative Constraint: Do not pass `ParentCategory` directly to endpoints expecting a full `Category` with subcategories; convert using `categoryType`.
public struct ParentCategory: Swift.Codable {
  /// Unlocalized English analytics category identifier.
  public let analyticsName: String?
  /// GraphQL global category identifier (Base64 encoded `"Category-<intID>"`).
  public let id: String
  /// Localized display name of the parent category.
  public let name: String

  /// Converts this parent reference into a `Category` value.
  public var categoryType: Category {
    return Category(analyticsName: self.analyticsName, id: self.id, name: self.name)
  }
}

private let unrecognizedCategoryId: Int = -1

/// Kickstarter project category or subcategory taxonomy node.
///
/// Format: GraphQL global `id` decodes to numeric `intID` via `decompose(id:)`.
/// Negative Constraint: Do not compare categories by `name` (localized); compare using `Equatable` (`id`) or `intID`.
public struct Category: Swift.Codable {
  /// Numeric server identifier for the Games root category (`12`).
  public static let gamesId: Int = 12
  /// Unlocalized English analytics category name (`nil` if omitted in summary fragments).
  public var analyticsName: String?
  /// Base64-encoded GraphQL category identifier.
  public var id: String
  /// Localized display name of the category.
  public var name: String
  internal let _parent: ParentCategory?
  /// Parent category GraphQL ID when `self` is a subcategory; `nil` for root categories.
  public var parentId: String?
  /// Paginated child subcategories connection when fetched via category queries.
  public var subcategories: SubcategoryConnection?
  /// Total number of live/discoverable projects in this category, if provided.
  public var totalProjectCount: Int?

  /// Creates a `Category` model value.
  public init(
    analyticsName: String?,
    id: String,
    name: String,
    parentCategory: ParentCategory? = nil,
    parentId: String? = nil,
    subcategories: SubcategoryConnection? = nil,
    totalProjectCount: Int? = nil
  ) {
    self.analyticsName = analyticsName
    self.id = id
    self.name = name
    self.parentId = parentId
    self._parent = parentCategory
    self.subcategories = subcategories
    self.totalProjectCount = totalProjectCount
  }

  /// Decoded numeric v1 category ID extracted from Base64 GraphQL `id`, or `nil` if malformed.
  public var intID: Int? {
    return decompose(id: self.id)
  }

  /// Formats a numeric string ID into a GraphQL category ID prefix (`"Category-<id>"`).
  /// - Negative Constraint: Workaround for v1 numeric category IDs; do not use where a real Base64 global ID is already present.
  public static func decode(id: String) -> String {
    return "Category-\(id)"
  }

  /// Parent `Category` derived from `_parent`, or `nil` if this is a root category.
  public var parent: Category? {
    return self._parent?.categoryType
  }

  /// Connection wrapper containing child subcategories for a root category.
  public struct SubcategoryConnection: Swift.Codable {
    /// Total number of child subcategories under this root category.
    public let totalCount: Int
    /// Child `Category` values belonging to this root category.
    public let nodes: [Category]
  }

  /// `true` when `parentId == nil` (indicating a top-level root category).
  public var isRoot: Bool {
    return self.parentId == nil
  }

  /// Returns the parent category if present, or returns self if we know for a fact that self is a
  /// root category.
  public var root: Category? {
    if let parent = self._parent {
      return parent.categoryType
    } else if self.parentId == nil {
      return self
    }
    return nil
  }

  /// Returns the id of the root category.
  public var rootId: Int? {
    if let parentId = self.parentId {
      return decompose(id: parentId)
    }
    return self.root?.intID
  }
}

extension Category {
  private enum CodingKeys: String, CodingKey {
    case analyticsName, id, name, parentId, _parent = "parentCategory", subcategories, totalProjectCount
  }

  /// Decodes a `ParentCategory` from a GraphQL JSON payload.
  ///
  /// Format: Standard `Decodable` initializer; falls back to `nil` for optional metadata fields (`parentId`, `subcategories`, `totalProjectCount`).
  /// Negative Constraint: Do not construct manually in production; decode from `Category` GraphQL responses.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.analyticsName = try values.decodeIfPresent(String.self, forKey: .analyticsName)
    self.id = try values.decode(String.self, forKey: .id)
    self.name = try values.decode(String.self, forKey: .name)
    self.parentId = try? values.decode(String.self, forKey: .parentId)
    self._parent = try? values.decode(ParentCategory.self, forKey: ._parent)
    self.subcategories = try? values.decode(SubcategoryConnection.self, forKey: .subcategories)
    self.totalProjectCount = try? values.decode(Int.self, forKey: .totalProjectCount)
  }
}

extension ParentCategory: Hashable {
  /// Hashes the parent category using its numeric `categoryType.intID`, falling back to `unrecognizedCategoryId`.
  ///
  /// Negative Constraint: Do not rely on `hash(into:)` stability across processes; only used for in-memory sets and diffing.
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.categoryType.intID ?? unrecognizedCategoryId)
  }
}

extension ParentCategory: Equatable {
  /// Compares two `ParentCategory` instances for equality based on their encoded GraphQL `id`.
  public static func == (lhs: ParentCategory, rhs: ParentCategory) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Category: Comparable {}
/// Orders `Category` values alphabetically by root category name, placing root categories before their own subcategories.
///
/// Negative Constraint: Do not use for localized display sorting in UI lists without verifying parent ordering semantics.
public func < (lhs: Category, rhs: Category) -> Bool {
  if lhs.id == rhs.id {
    return false
  }

  if lhs.isRoot, lhs.id == rhs.parent?.id {
    return true
  }

  if !lhs.isRoot, lhs.parent?.id == rhs.id {
    return false
  }

  if let lhsRootName = lhs.parent?.name, let rhsRootName = rhs.parent?.name {
    return lhsRootName < rhsRootName
  }

  return lhs.parent == nil
}

extension Category: Equatable {
  /// Compares two `Category` instances for equality by their GraphQL `id`.
  public static func == (lhs: Category, rhs: Category) -> Bool {
    return lhs.id == rhs.id
  }
}

extension Category: Hashable {
  /// Hashes the category using its integer `intID` (or `unrecognizedCategoryId` when non-numeric).
  public func hash(into hasher: inout Hasher) {
    hasher.combine(self.intID ?? unrecognizedCategoryId)
  }
}

extension Category: CustomStringConvertible, CustomDebugStringConvertible {
  /// Human-readable summary of the category (`GraphCategory(id: ..., name: ...)`).
  public var description: String {
    return "GraphCategory(id: \(self.id), name: \(self.name))"
  }

  /// Debug description mirroring `description`.
  public var debugDescription: String {
    return self.description
  }
}
