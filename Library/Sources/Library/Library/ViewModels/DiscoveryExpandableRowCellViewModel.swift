import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `DiscoveryExpandableRowCellViewModel`.
public protocol DiscoveryExpandableRowCellInputs {
  /// Configures the expandable category row with its row state and active category ID.
  func configureWith(row: ExpandableRow, categoryId: Int?)
  /// Signals that the expandable cell is about to appear.
  func willDisplay()
}

/// Outputs emitted by `DiscoveryExpandableRowCellViewModel`.
public protocol DiscoveryExpandableRowCellOutputs {
  /// Emits the VoiceOver accessibility hint describing expand/collapse behavior.
  var cellAccessibilityHint: Signal<String, Never> { get }
  /// Emits the VoiceOver accessibility label including category name and live count.
  var cellAccessibilityLabel: Signal<String, Never> { get }
  /// Emits `(row, categoryId)` styling context for the expandable header cell.
  var expandCategoryStyle: Signal<(ExpandableRow, Int?), Never> { get }
  /// Emits whether the category row is currently expanded.
  var filterIsExpanded: Signal<Bool, Never> { get }
  /// Emits the localized category filter title text.
  var filterTitleLabelText: Signal<String, Never> { get }
  /// Emits the alpha transparency applied to the live projects count label.
  var projectsCountLabelAlpha: Signal<CGFloat, Never> { get }
  /// Emits whether the live projects count label is hidden.
  var projectsCountLabelHidden: Signal<Bool, Never> { get }
  /// Emits the formatted count of live projects in the category.
  var projectsCountLabelText: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `DiscoveryExpandableRowCellViewModel`.
public protocol DiscoveryExpandableRowCellViewModelType {
  /// Input receiver for expandable row configuration and display lifecycle.
  var inputs: DiscoveryExpandableRowCellInputs { get }
  /// Output signals styling the expandable category header cell.
  var outputs: DiscoveryExpandableRowCellOutputs { get }
}

/// View model formatting expandable parent category filter headers in Discovery.
public final class DiscoveryExpandableRowCellViewModel: DiscoveryExpandableRowCellViewModelType,
  DiscoveryExpandableRowCellInputs, DiscoveryExpandableRowCellOutputs {
  /// Initializes the discovery expandable row cell view model.
  public init() {
    let expandableRowAndCategoryId = self.expandableRowAndCategoryIdProperty.signal.skipNil()
      .takeWhen(self.willDisplayProperty.signal)

    let expandableRow = expandableRowAndCategoryId.map(first)

    self.expandCategoryStyle = expandableRowAndCategoryId

    self.filterTitleLabelText = expandableRow
      .map { $0.params.category?.name ?? "" }

    self.filterIsExpanded = expandableRow
      .map { $0.isExpanded }

    self.cellAccessibilityHint = expandableRow
      .map { $0.isExpanded ? Strings.Collapses_subcategories() : Strings.Expands_subcategories() }

    self.cellAccessibilityLabel = expandableRow
      .map {
        Strings.Filter_name_project_count_live_projects(
          filter_name: $0.params.category?.name ?? "",
          project_count: $0.params.category?.totalProjectCount ?? 0
        )
      }

    self.projectsCountLabelText = expandableRow
      .map { Format.wholeNumber($0.params.category?.totalProjectCount ?? 0) }

    self.projectsCountLabelHidden = expandableRow
      .map { $0.params.category?.totalProjectCount == .some(0) }

    self.projectsCountLabelAlpha = expandableRowAndCategoryId
      .map { expandableRow, categoryId in categoryId == nil || expandableRow.isExpanded ? 1.0 : 0.4 }
  }

  fileprivate let expandableRowAndCategoryIdProperty = MutableProperty<(ExpandableRow, Int?)?>(nil)
  /// Configures the cell with an `ExpandableRow` model and selected category ID.
  public func configureWith(row: ExpandableRow, categoryId: Int?) {
    self.expandableRowAndCategoryIdProperty.value = (row, categoryId)
  }

  fileprivate let willDisplayProperty = MutableProperty(())
  /// Signals that the expandable cell is about to be rendered.
  public func willDisplay() {
    self.willDisplayProperty.value = ()
  }

  /// Emits the VoiceOver accessibility hint.
  public let cellAccessibilityHint: Signal<String, Never>
  /// Emits the VoiceOver accessibility label.
  public let cellAccessibilityLabel: Signal<String, Never>
  /// Emits row and category ID values used to apply visual styling.
  public let expandCategoryStyle: Signal<(ExpandableRow, Int?), Never>
  /// Emits whether subcategories are expanded.
  public let filterIsExpanded: Signal<Bool, Never>
  /// Emits the category filter display name.
  public let filterTitleLabelText: Signal<String, Never>
  /// Emits the alpha opacity for the live project count label.
  public let projectsCountLabelAlpha: Signal<CGFloat, Never>
  /// Emits whether the live project count label is hidden.
  public let projectsCountLabelHidden: Signal<Bool, Never>
  /// Emits the formatted count string of live projects.
  public let projectsCountLabelText: Signal<String, Never>

  /// Returns `self` as `DiscoveryExpandableRowCellInputs`.
  public var inputs: DiscoveryExpandableRowCellInputs { return self }
  /// Returns `self` as `DiscoveryExpandableRowCellOutputs`.
  public var outputs: DiscoveryExpandableRowCellOutputs { return self }
}
