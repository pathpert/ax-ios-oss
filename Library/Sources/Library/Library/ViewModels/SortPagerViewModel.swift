import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `SortPagerViewModel`.
public protocol SortPagerViewModelInputs {
  /// Call with the sorts that the view was configured with.
  func configureWith(sorts: [DiscoveryParams.Sort])

  /// Call when the view controller's didRotateFromInterfaceOrientation method is called.
  func didRotateFromInterfaceOrientation()

  /// Call when a sort is selected from outside this view.
  func select(sort: DiscoveryParams.Sort)

  /// Call when a sort button is tapped.
  func sortButtonTapped(index: Int)

  /// Call when to update the sort style.
  func updateStyle(categoryId: Int?)

  /// Call when the view controller's willRotateToInterfaceOrientation method is called.
  func willRotateToInterfaceOrientation()

  /// Call when the view controller's viewDidAppear method is called.
  func viewDidAppear()

  /// Call when view controller's viewWillAppear method is called.
  func viewWillAppear()
}

/// Outputs exposed by `SortPagerViewModel`.
public protocol SortPagerViewModelOutputs {
  /// Emits a list of sorts that should be used to create sort buttons.
  var createSortButtons: Signal<[DiscoveryParams.Sort], Never> { get }

  /// Emits a bool whether the indicator view should be hidden, used for rotation.
  var indicatorViewIsHidden: Signal<Bool, Never> { get }

  /// Emits a sort that should be passed on to the view's delegate.
  var notifyDelegateOfSelectedSort: Signal<DiscoveryParams.Sort, Never> { get }

  /// Emits an index to pin the indicator view to a particular button view and whether to animate it.
  var pinSelectedIndicatorToPage: Signal<(Int, Bool), Never> { get }

  /// Emits an index of the selected button to update all button selected states.
  var setSelectedButton: Signal<Int, Never> { get }

  /// Emits a category id to update style on sort change (e.g. filter selection).
  var updateSortStyle: Signal<
    (categoryId: Int?, sorts: [DiscoveryParams.Sort], animated: Bool),
    Never
  > { get }
}

/// Combined inputs and outputs interface for `SortPagerViewModel`.
public protocol SortPagerViewModelType {
  /// The view model's inputs.
  var inputs: SortPagerViewModelInputs { get }
  /// The view model's outputs.
  var outputs: SortPagerViewModelOutputs { get }
}

/// View model managing the Discovery sort tab bar buttons, indicator positioning, and styling.
public final class SortPagerViewModel: SortPagerViewModelType, SortPagerViewModelInputs,
  SortPagerViewModelOutputs {
  /// Creates a new `SortPagerViewModel` and binds sort selection and indicator animation signals.
  public init() {
    let sorts: Signal<[DiscoveryParams.Sort], Never> = Signal.combineLatest(
      self.sortsProperty.signal.skipNil(),
      self.viewWillAppearProperty.signal
    )
    .map(first)

    self.createSortButtons = sorts.take(first: 1)

    self.updateSortStyle = Signal.merge(
      sorts.map { ($0, nil, false) }.take(first: 1),
      sorts.takePairWhen(self.updateStyleProperty.signal).map { ($0, $1, true) }
    )
    .map { sorts, id, animated in (categoryId: id, sorts: sorts, animated: animated) }

    let selectedPage: Signal<(Int, Int), Never> = Signal.combineLatest(
      sorts,
      self.selectSortProperty.signal.skipNil()
    )
    .map { arg -> (Int, Int) in
      let (sorts, sort) = arg
      return (sorts.firstIndex(of: sort) ?? 0, sorts.count)
    }

    let pageIndex: Signal<Int, Never> = sorts.mapConst(0)

    self.setSelectedButton = Signal.merge(
      pageIndex.take(first: 1),
      self.sortButtonTappedIndexProperty.signal.skipNil(),
      selectedPage.map { index, _ in index }
    )
    .skipRepeats(==)

    let selectedPageOnRotate = Signal.merge(pageIndex, selectedPage.map(first))
      .takeWhen(self.didRotateProperty.signal)

    self.pinSelectedIndicatorToPage = Signal.merge(
      pageIndex
        .takeWhen(self.viewDidAppearProperty.signal)
        .take(first: 1)
        .map { ($0, false) },
      selectedPage
        .map { page, _ in (page, true) }
        .skipRepeats(==),
      selectedPageOnRotate
        .map { ($0, false) }
    )

    self.notifyDelegateOfSelectedSort = Signal.combineLatest(
      sorts.take(first: 1),
      self.sortButtonTappedIndexProperty.signal.skipNil()
    )
    .map { sorts, sortIndex in sorts[sortIndex] }

    self.indicatorViewIsHidden = Signal.merge(
      self.viewWillAppearProperty.signal
        .take(first: 1)
        .mapConst(true),
      self.viewDidAppearProperty.signal
        .take(first: 1)
        .mapConst(false)
        .ksr_debounce(.milliseconds(100), on: AppEnvironment.current.scheduler),
      self.willRotateProperty.signal.mapConst(true),
      self.didRotateProperty.signal
        .mapConst(false)
        .ksr_debounce(.milliseconds(100), on: AppEnvironment.current.scheduler)
    )
  }

  fileprivate let didRotateProperty = MutableProperty(())
  /// Re-pins the selection indicator after an interface orientation change.
  public func didRotateFromInterfaceOrientation() {
    self.didRotateProperty.value = ()
  }

  fileprivate let sortsProperty = MutableProperty<[DiscoveryParams.Sort]?>(nil)
  /// Configures the pager with the ordered list of available sorts.
  public func configureWith(sorts: [DiscoveryParams.Sort]) {
    self.sortsProperty.value = sorts
  }

  fileprivate let selectSortProperty = MutableProperty<DiscoveryParams.Sort?>(nil)
  /// Selects a sort tab programmatically when synced with page swiping.
  public func select(sort: DiscoveryParams.Sort) {
    self.selectSortProperty.value = sort
  }

  fileprivate let sortButtonTappedIndexProperty = MutableProperty<Int?>(nil)
  /// Handles a tap on the sort button at `index`.
  public func sortButtonTapped(index: Int) {
    self.sortButtonTappedIndexProperty.value = index
  }

  fileprivate let updateStyleProperty = MutableProperty<Int?>(nil)
  /// Updates sort tab styling for the selected category ID (or `nil`).
  public func updateStyle(categoryId: Int?) {
    self.updateStyleProperty.value = categoryId
  }

  fileprivate let willRotateProperty = MutableProperty(())
  /// Hides the selection indicator right before an interface rotation begins.
  public func willRotateToInterfaceOrientation() {
    self.willRotateProperty.value = ()
  }

  fileprivate let viewDidAppearProperty = MutableProperty(())
  /// Signals that the sort pager view appeared.
  public func viewDidAppear() {
    self.viewDidAppearProperty.value = ()
  }

  fileprivate let viewWillAppearProperty = MutableProperty(())
  /// Signals that the sort pager view will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  /// Emits the sorts used to instantiate sort tab buttons.
  public let createSortButtons: Signal<[DiscoveryParams.Sort], Never>
  /// Emits whether the sliding selection indicator view should be hidden.
  public var indicatorViewIsHidden: Signal<Bool, Never>
  /// Emits the sort selected by tapping a tab button.
  public let notifyDelegateOfSelectedSort: Signal<DiscoveryParams.Sort, Never>
  /// Emits the button index and animation flag to reposition the indicator view.
  public let pinSelectedIndicatorToPage: Signal<(Int, Bool), Never>
  /// Emits the selected tab index to update button selection styling.
  public let setSelectedButton: Signal<Int, Never>
  /// Emits updated category styling context for the sort tabs.
  public let updateSortStyle: Signal<
    (categoryId: Int?, sorts: [DiscoveryParams.Sort], animated: Bool),
    Never
  >

  /// The inputs interface for this view model.
  public var inputs: SortPagerViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: SortPagerViewModelOutputs { return self }
}
