import KsApi
import Prelude
import ReactiveSwift

/// View model managing category hierarchy expansion and filter row selection in the discovery drawer.
public final class DiscoveryFiltersViewModel: DiscoveryFiltersViewModelType,
  DiscoveryFiltersViewModelInputs, DiscoveryFiltersViewModelOutputs {
  /// Creates a new `DiscoveryFiltersViewModel`.
  public init() {
    let initialTopFilters = self.viewDidLoadProperty.signal
      .take(first: 1)
      .map { _ in discoveryTopFilters(forUser: AppEnvironment.current.currentUser) }

    let initialSelectedRow = Signal.combineLatest(
      self.initialSelectedRowProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .take(first: 1)
    .map(first)

    let topRows = Signal.combineLatest(
      initialTopFilters,
      initialSelectedRow
    )
    .map { params, selectedRow -> [SelectableRow] in
      params.map { p in SelectableRow(isSelected: p == selectedRow.params, params: p) }
    }

    self.categoriesUseCase = FetchCategoriesUseCase(initialSignal: self.viewDidLoadProperty.signal)

    let categoryId = self.initialSelectedRowProperty.signal.skipNil()
      .map { $0.params.category?.rootId }

    self.loadTopRows = Signal.combineLatest(topRows, categoryId)
      .map { (rows: $0, categoryId: $1) }

    let selectedRowWithCategories = Signal.combineLatest(
      initialSelectedRow,
      self.categoriesUseCase.categories
    )

    let favoriteRows = selectedRowWithCategories
      .map(discoveryFavoriteRows(selectedRow:categories:))
      .skipNil()

    self.loadFavoriteRows = Signal.combineLatest(favoriteRows, categoryId)
      .map { (rows: $0, categoryId: $1) }

    let selectedRowId = Signal.merge(
      categoryId,
      self.tappedExpandableRowProperty.signal.skipNil().map { $0.params.category?.rootId }
    )

    let initialRows = selectedRowWithCategories
      .map(discoveryExpandableRows(selectedRow:categories:))

    let expandingRows = Signal.combineLatest(
      self.tappedExpandableRowProperty.signal.skipNil(),
      initialRows
    )
    .map(toggleDiscoveryRowExpansion(row:in:))

    let initialCatRowsAndIdAndSelectedRowId = Signal.combineLatest(categoryId, selectedRowId)
      .takePairWhen(initialRows)

    let expandedCatRowsAndIdAndSelectedRowId = Signal.combineLatest(categoryId, selectedRowId)
      .takePairWhen(expandingRows)

    self.loadCategoryRows = Signal.merge(
      initialCatRowsAndIdAndSelectedRowId,
      expandedCatRowsAndIdAndSelectedRowId
    )
    .map { (rows: $1, categoryId: $0.0, selectedRowId: $0.1) }

    self.notifyDelegateOfSelectedRow = self.tappedSelectableRowProperty.signal.skipNil()

    self.shouldAnimateSelectableCellProperty <~ Signal.merge(
      self.tappedExpandableRowProperty.signal.mapConst(true),

      self.tappedExpandableRowProperty.signal
        .ksr_delay(.milliseconds(300), on: AppEnvironment.current.scheduler)
        .mapConst(false)
    )

    self.animateInView = self.viewDidAppearProperty.signal

    self.notifyDelegateOfSelectedRow
      .observeValues {
        AppEnvironment.current.ksrAnalytics.trackDiscoveryModalSelectedFilter(
          params: $0.params,
          typeContext: discoveryTypeContext(from: $0.params),
          locationContext: .discoverOverlay
        )
      }
  }

  fileprivate let initialSelectedRowProperty = MutableProperty<SelectableRow?>(nil)
  /// Supplies the currently selected row when the filters modal appears.
  public func configureWith(selectedRow: SelectableRow) {
    self.initialSelectedRowProperty.value = selectedRow
  }

  fileprivate let tappedExpandableRowProperty = MutableProperty<ExpandableRow?>(nil)
  /// Handles user tap to expand or collapse a root category row.
  public func tapped(expandableRow: ExpandableRow) {
    self.tappedExpandableRowProperty.value = expandableRow
  }

  fileprivate let tappedSelectableRowProperty = MutableProperty<SelectableRow?>(nil)
  /// Handles user selection of a filter row.
  public func tapped(selectableRow: SelectableRow) {
    self.tappedSelectableRowProperty.value = selectableRow
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the filters view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewDidAppearProperty = MutableProperty(())
  /// Notifies the view model that the filters view appeared.
  public func viewDidAppear() {
    self.viewDidAppearProperty.value = ()
  }

  fileprivate let shouldAnimateSelectableCellProperty = MutableProperty(false)
  /// Whether filter cells should animate transitions when displayed.
  public var shouldAnimateSelectableCell: Bool {
    return self.shouldAnimateSelectableCellProperty.value
  }

  /// Emits when the drawer should run its entrance animation.
  public let animateInView: Signal<(), Never>
  /// Emits whether the categories loading indicator is visible.
  public var loadingIndicatorIsVisible: Signal<Bool, Never> {
    self.categoriesUseCase.loadingIndicatorIsVisible
  }

  /// Emits expandable category rows along with selected category IDs.
  public let loadCategoryRows: Signal<
    (rows: [ExpandableRow], categoryId: Int?, selectedRowId: Int?),
    Never
  >
  /// Emits favorite category rows and the active category ID.
  public let loadFavoriteRows: Signal<(rows: [SelectableRow], categoryId: Int?), Never>
  /// Emits top-level discovery filter rows and the active category ID.
  public let loadTopRows: Signal<(rows: [SelectableRow], categoryId: Int?), Never>
  /// Emits the selected filter row to notify the delegate.
  public let notifyDelegateOfSelectedRow: Signal<SelectableRow, Never>

  private let categoriesUseCase: FetchCategoriesUseCase

  /// Input receiver (`self`).
  public var inputs: DiscoveryFiltersViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: DiscoveryFiltersViewModelOutputs { return self }
}
