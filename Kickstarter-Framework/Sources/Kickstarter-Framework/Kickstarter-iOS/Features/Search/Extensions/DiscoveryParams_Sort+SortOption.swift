import KsApi
import Library

extension DiscoveryParams.Sort: @retroactive Identifiable {}
// Implements SortOption so DiscoveryParams.Sort can be used in a SortView.
extension DiscoveryParams.Sort: SortOption {
  /// Unique identifier backed by the sort option's raw API string.
  /// - Negative Constraint: Do not parse as a localized display label; use `name` for UI copy.
  public var id: String {
    return self.rawValue
  }

  /// Localized human-readable title displayed in search sort pickers.
  public var name: String {
    switch self {
    case .endingSoon:
      return Strings.discovery_sort_types_end_date()
    case .magic:
      return Strings.Recommended()
    case .newest:
      return Strings.discovery_sort_types_newest()
    case .popular:
      return Strings.discovery_sort_types_popularity()
    case .most_funded:
      return Strings.discovery_sort_types_most_funded()
    case .most_backed:
      return Strings.discovery_sort_types_most_backed()
    }
  }
}
