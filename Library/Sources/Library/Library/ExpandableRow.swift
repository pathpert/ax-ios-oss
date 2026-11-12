import KsApi
import Prelude

/// Discovery filter drawer group model tracking expansion state, filter parameters, and nested rows.
public struct ExpandableRow {
  /// Whether the nested `selectableRows` section is currently expanded in the filter UI.
  public let isExpanded: Bool
  /// Top-level `DiscoveryParams` represented by this filter group.
  public let params: DiscoveryParams
  /// Selectable child filter rows revealed when `isExpanded` is `true`.
  public let selectableRows: [SelectableRow]

  /// Optics namespace providing functional lenses for `ExpandableRow` fields.
  public enum lens {
    /// Lens focusing on `ExpandableRow.isExpanded`.
    public static let isExpanded = Lens<ExpandableRow, Bool>(
      view: { $0.isExpanded },
      set: { ExpandableRow(isExpanded: $0, params: $1.params, selectableRows: $1.selectableRows) }
    )

    /// Lens focusing on `ExpandableRow.params`.
    public static let params = Lens<ExpandableRow, DiscoveryParams>(
      view: { $0.params },
      set: { ExpandableRow(isExpanded: $1.isExpanded, params: $0, selectableRows: $1.selectableRows) }
    )

    /// Lens focusing on `ExpandableRow.selectableRows`.
    public static let selectableRows = Lens<ExpandableRow, [SelectableRow]>(
      view: { $0.selectableRows },
      set: { ExpandableRow(isExpanded: $1.isExpanded, params: $1.params, selectableRows: $0) }
    )
  }
}

public extension Lens where Whole == ExpandableRow, Part == DiscoveryParams {
  /// Composed lens focusing on the `social` filter flag inside `ExpandableRow.params`.
  var social: Lens<ExpandableRow, Bool?> {
    return ExpandableRow.lens.params .. DiscoveryParams.lens.social
  }

  /// Composed lens focusing on the `staffPicks` filter flag inside `ExpandableRow.params`.
  var staffPicks: Lens<ExpandableRow, Bool?> {
    return ExpandableRow.lens.params .. DiscoveryParams.lens.staffPicks
  }

  /// Composed lens focusing on the `starred` filter flag inside `ExpandableRow.params`.
  var starred: Lens<ExpandableRow, Bool?> {
    return ExpandableRow.lens.params .. DiscoveryParams.lens.starred
  }

  /// Composed lens focusing on the `category` selection inside `ExpandableRow.params`.
  var category: Lens<ExpandableRow, KsApi.Category?> {
    return ExpandableRow.lens.params .. DiscoveryParams.lens.category
  }
}

extension ExpandableRow: Equatable {}
/// Compares two expandable rows across expansion state, params, and child rows.
public func == (lhs: ExpandableRow, rhs: ExpandableRow) -> Bool {
  return lhs.isExpanded == rhs.isExpanded &&
    lhs.params == rhs.params &&
    lhs.selectableRows == rhs.selectableRows
}
