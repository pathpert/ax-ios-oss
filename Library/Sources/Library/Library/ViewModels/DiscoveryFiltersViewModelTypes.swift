import KsApi
import Prelude
import ReactiveSwift

/// Input methods accepted by `DiscoveryFiltersViewModel`.
public protocol DiscoveryFiltersViewModelInputs {
  /// Call with the row that is selected when the filters appear and array of loaded categories.
  func configureWith(selectedRow: SelectableRow)

  /// Call when an expandable row is tapped.
  func tapped(expandableRow: ExpandableRow)

  /// Call when a selectable row is tapped.
  func tapped(selectableRow: SelectableRow)

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view did appear.
  func viewDidAppear()
}

/// Output signals and properties exposed by `DiscoveryFiltersViewModel`.
public protocol DiscoveryFiltersViewModelOutputs {
  /// Emits when to animate in the view.
  var animateInView: Signal<(), Never> { get }

  /// Emits whether the categories are loading for the activity indicator view.
  var loadingIndicatorIsVisible: Signal<Bool, Never> { get }

  /**
   Emits an array of expandable rows to put into the categories section of filters,
   a category id to set row styles, and an optional category id for setting scrollTo position.
   **/
  var loadCategoryRows: Signal<
    (rows: [ExpandableRow], categoryId: Int?, selectedRowId: Int?),
    Never
  > { get }

  /// Emits an array of selectable rows for the favorites section and category id to set row styles.
  var loadFavoriteRows: Signal<(rows: [SelectableRow], categoryId: Int?), Never> { get }

  /// Emits an array of selectable rows to put into the top filters section and category id to set row styles.
  var loadTopRows: Signal<(rows: [SelectableRow], categoryId: Int?), Never> { get }

  /// Emits a selectable row when the delegate should be notified of the selection.
  var notifyDelegateOfSelectedRow: Signal<SelectableRow, Never> { get }

  /// A bool that determines whether a cell should be animated when it is displayed.
  var shouldAnimateSelectableCell: Bool { get }
}

/// Interface combining inputs and outputs for `DiscoveryFiltersViewModel`.
public protocol DiscoveryFiltersViewModelType {
  /// Input receiver for filter events.
  var inputs: DiscoveryFiltersViewModelInputs { get }
  /// Output signals observed by the filters drawer UI.
  var outputs: DiscoveryFiltersViewModelOutputs { get }
}

// MARK: - Helpers

/**
 Converts an array of categories into a grouped array of expandable rows,
 then finds the expandable row that contains the given selectable row, and expands it.

 - parameter selectedRow: An optional selected row to search for.

 - parameter categories: A full array of categories.

 - returns: An array of expandable rows with one row expanded.
 */
internal func discoveryExpandableRows(
  selectedRow: SelectableRow,
  categories: [KsApi.Category]
) -> [ExpandableRow] {
  let expandableRows = categories.filter { (category: KsApi.Category) in category.isRoot }
    .sorted { (lhs: KsApi.Category, _) in lhs.isRoot }
    .map { (rootCategory: KsApi.Category) in
      ExpandableRow(
        isExpanded: false,
        params: .defaults |> DiscoveryParams.lens.category .~ rootCategory,
        selectableRows: ([rootCategory] + (rootCategory.subcategories?.nodes ?? []))
          .sorted()
          .compactMap { (node: KsApi.Category) in
            SelectableRow(
              isSelected: node == selectedRow.params.category,
              params: .defaults
                |> DiscoveryParams.lens.category .~ node
            )
          }
      )
    }
    .sorted { (lhs: ExpandableRow, rhs: ExpandableRow) in
      guard let lhsCategory = lhs.params.category, let rhsCategory = rhs.params.category else {
        return lhs.params.category == nil
      }
      return lhsCategory < rhsCategory
    }

  return expandableRows.map { expandableRow in
    expandableRow
      |> ExpandableRow.lens.isExpanded .~
      expandableRow.selectableRows.lazy.map { $0.params }.contains(selectedRow.params)
      |> ExpandableRow.lens.selectableRows .~
      expandableRow.selectableRows.sorted { lhs, rhs in
        guard let lhsName = lhs.params.category?.name, let rhsName = rhs.params.category?.name,
              lhs.params.category?.isRoot == rhs.params.category?.isRoot else {
          return (lhs.params.category?.isRoot ?? false) && !(rhs.params.category?.isRoot ?? false)
        }
        return lhsName < rhsName
      }
  }
}

/**
 Toggles the expansion of the row provided.

 - parameter rowToToggle:    The row to toggle expansion.
 - parameter expandableRows: A full array of expandable rows.

 - returns: A new array of expandable rows with the provided row's expansion toggled.
 */
internal func toggleDiscoveryRowExpansion(
  row rowToToggle: ExpandableRow,
  in expandableRows: [ExpandableRow]
) -> [ExpandableRow] {
  return expandableRows
    .map { expandableRow in
      expandableRow
        |> ExpandableRow.lens.isExpanded .~ (
          expandableRow.params == rowToToggle.params &&
            !rowToToggle.isExpanded
        )
    }
}

internal func discoveryTopFilters(forUser user: User?) -> [DiscoveryParams] {
  var filters: [DiscoveryParams] = []

  filters.append(.defaults |> DiscoveryParams.lens.includePOTD .~ true)
  filters.append(.defaults |> DiscoveryParams.lens.staffPicks .~ true)

  guard user != nil else {
    return filters
  }

  filters.append(.defaults |> DiscoveryParams.lens.starred .~ true)

  if user?.optedOutOfRecommendations != true {
    filters.append(
      .defaults
        |> DiscoveryParams.lens.recommended .~ true
        |> DiscoveryParams.lens.backed .~ false
    )
  }

  filters.append(.defaults |> DiscoveryParams.lens.social .~ true)

  return filters
}

internal func discoveryFavoriteRows(
  selectedRow: SelectableRow,
  categories: [KsApi.Category]
) -> [SelectableRow]? {
  let subcategories = categories
    .filter { $0.isRoot }
    .flatMap { category in [category] + (category.subcategories?.nodes ?? []) }

  let faves: [SelectableRow] = subcategories
    .compactMap { subcategory in
      guard let id = subcategory.intID else {
        return nil
      }
      if AppEnvironment.current.ubiquitousStore.favoriteCategoryIds.contains(id) ||
        AppEnvironment.current.userDefaults.favoriteCategoryIds.contains(id) {
        return SelectableRow(
          isSelected: subcategory == selectedRow.params.category,
          params: .defaults |> DiscoveryParams.lens.category .~ subcategory
        )
      } else {
        return nil
      }
    }
  return faves.isEmpty ? nil : faves
}

internal func discoveryTypeContext(
  from discoveryParams: DiscoveryParams
) -> KSRAnalytics.TypeContext {
  if discoveryParams.staffPicks == true {
    return .pwl
  } else if discoveryParams.starred == true {
    return .watched
  } else if discoveryParams.social == true {
    return .social
  } else if let category = discoveryParams.category {
    return category.parent == nil ? .categoryName : .subcategoryName
  } else if discoveryParams.recommended == true {
    return .recommended
  } else {
    return .allProjects
  }
}

