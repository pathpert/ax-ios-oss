import KsApi
import Prelude

/// Selectable discovery filter row pairing `isSelected` state with `DiscoveryParams`.
/// - Negative Constraint: Treat as an immutable value model and update via `SelectableRow.lens`.
public struct SelectableRow {
  /// Whether this filter row is currently selected.
  public let isSelected: Bool
  /// Legacy `DiscoveryParams` query parameters represented by this row.
  public let params: DiscoveryParams

  /// Functional optics namespace for deriving modified `SelectableRow` copies.
  public enum lens {
    /// Lens focusing on `SelectableRow.isSelected`.
    public static let isSelected = Lens<SelectableRow, Bool>(
      view: { $0.isSelected },
      set: { SelectableRow(isSelected: $0, params: $1.params) }
    )

    /// Lens focusing on `SelectableRow.params`.
    public static let params = Lens<SelectableRow, DiscoveryParams>(
      view: { $0.params },
      set: { SelectableRow(isSelected: $1.isSelected, params: $0) }
    )
  }
}

/// Lenses forwarding `SelectableRow.params` filters onto underlying `DiscoveryParams` fields.
public extension Lens where Whole == SelectableRow, Part == DiscoveryParams {
  /// Lens focusing on `DiscoveryParams.social`.
  var social: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.social
  }

  /// Lens focusing on `DiscoveryParams.staffPicks`.
  var staffPicks: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.staffPicks
  }

  /// Lens focusing on `DiscoveryParams.starred`.
  var starred: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.starred
  }

  /// Lens focusing on `DiscoveryParams.category`.
  var category: Lens<SelectableRow, KsApi.Category?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.category
  }

  /// Lens focusing on `DiscoveryParams.includePOTD`.
  var includePOTD: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.includePOTD
  }

  /// Lens focusing on `DiscoveryParams.recommended`.
  var recommended: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.recommended
  }

  /// Lens focusing on `DiscoveryParams.backed`.
  var backed: Lens<SelectableRow, Bool?> {
    return SelectableRow.lens.params .. DiscoveryParams.lens.backed
  }
}

extension SelectableRow: Equatable {}
/// Compares two `SelectableRow` instances by selection state and `DiscoveryParams`.
public func == (lhs: SelectableRow, rhs: SelectableRow) -> Bool {
  return lhs.isSelected == rhs.isSelected && lhs.params == rhs.params
}
