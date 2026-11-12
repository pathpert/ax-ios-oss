import Foundation
import UIKit

/// Model representing one filter pill button displayed in `SearchFiltersHeaderView`.
/// - Negative Constraint: Each `FilterType` must appear at most once in the header bar because `id` derives from `filterType.rawValue`.
public struct SearchFilterPill: Identifiable {
  /// Stable identifier derived from `filterType.rawValue`.
  public var id: Int {
    return self.filterType.rawValue
  }

  /// Whether the pill is visually highlighted as an active filter.
  public let isHighlighted: Bool
  /// Semantic filter dimension represented by this pill.
  public let filterType: FilterType
  /// Visual presentation style (icon, dropdown label, toggle, or toggle with icon).
  public let buttonType: ButtonType
  /// Badge count displayed alongside aggregated filter pills (`0` when unbadged).
  public let count: Int

  /// Which filter the pill represents.
  /// Only one pill of each type will be shown, since this powers the id of the pill.
  public enum FilterType: Int {
    case allFilters
    case category
    case sort
    case projectState
    case percentRaised
    case location
    case amountRaised
    case goal
    case projectsWeLove
    case saved
    case following
    case recommended

    /// If `true`, this pill is a boolean value that can be toggled directly from the search header.
    /// Tapping on this pill doesn't open a modal.
    var isToggle: Bool {
      switch self {
      case .projectsWeLove:
        true
      case .saved:
        true
      case .following:
        true
      case .recommended:
        true
      default:
        false
      }
    }
  }

  /// How the pill should be rendered.
  public enum ButtonType {
    case image(UIImage)
    case dropdown(String)
    case toggle(String)
    case toggleWithImage(String, UIImage)
  }

  /// Initializes a search filter pill display model.
  public init(
    isHighlighted: Bool,
    filterType: SearchFilterPill.FilterType,
    buttonType: ButtonType,
    count: Int = 0
  ) {
    self.isHighlighted = isHighlighted
    self.filterType = filterType
    self.buttonType = buttonType
    self.count = count
  }
}
