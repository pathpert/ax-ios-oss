import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// Coordinates the Discovery screen's sort tabs, filter parameters, and paged project lists.
public final class DiscoveryViewModel: DiscoveryViewModelType, DiscoveryViewModelInputs,
  DiscoveryViewModelOutputs {
  internal static func initialParams() -> DiscoveryParams {
    guard AppEnvironment.current.currentUser?.optedOutOfRecommendations == .some(false) else {
      return DiscoveryParams.defaults
        |> DiscoveryParams.lens.includePOTD .~ true
    }

    return DiscoveryParams.recommendedDefaults
  }

  /// Creates a new `DiscoveryViewModel` and binds sort-tab and filter coordination signals.
  public init() {
    let remoteConfigReadyOrContinue = Signal.merge(
      self.remoteConfigClientConfiguredProperty.signal,
      self.viewDidLoadProperty.signal.ignoreValues(),
      self.remoteConfigClientConfigurationFailedProperty.signal
    ).take(first: 1)

    let sorts: [DiscoveryParams.Sort] = [.magic, .popular, .newest, .endingSoon]

    let configureWithSorts = remoteConfigReadyOrContinue.mapConst(sorts)

    self.configurePagerDataSource = configureWithSorts
    self.configureSortPager = configureWithSorts

    let initialParams = Signal.merge(
      self.viewWillAppearProperty.signal.take(first: 1).ignoreValues(),
      self.didChangeRecommendationsSettingProperty.signal
        .takeWhen(self.viewWillAppearProperty.signal)
    )
    .map(DiscoveryViewModel.initialParams)
    .skipRepeats()

    let currentParams = Signal.merge(
      initialParams,
      self.filterWithParamsProperty.signal.skipNil()
    )
    .skipRepeats()

    let dataSourceConfiguredAndCurrentParams = Signal.combineLatest(
      configureWithSorts.ksr_debounce(.nanoseconds(0), on: AppEnvironment.current.scheduler),
      currentParams
    )
    .map(second)

    self.configureNavigationHeader = dataSourceConfiguredAndCurrentParams
    self.loadFilterIntoDataSource = dataSourceConfiguredAndCurrentParams

    let swipeToSort = self.willTransitionToPageProperty.signal
      .takeWhen(self.pageTransitionCompletedProperty.signal.filter(isTrue))
      .map { sorts[$0] }

    let prevSortedPage = Signal.merge(
      swipeToSort,
      self.sortPagerSelectedSortProperty.signal.skipNil()
    )
    .combinePrevious(.magic)
    .map(first)

    self.selectSortPage = Signal
      .merge(
        swipeToSort,
        self.sortPagerSelectedSortProperty.signal.skipNil(),
        currentParams.map { $0.sort }.skipNil()
      )
      .skipRepeats()

    self.navigateToSort = Signal
      .merge(
        swipeToSort.map { (sort: $0, ignore: true) },
        self.sortPagerSelectedSortProperty.signal.skipNil().map { (sort: $0, ignore: false) },
        currentParams.map { $0.sort }.skipNil().map { (sort: $0, ignore: false) }
      )
      .skipRepeats(==)
      .combinePrevious((sort: .magic, ignore: true))
      .filter { _, next in !next.ignore }
      .map { previous, next in
        let lhs = sorts.firstIndex(of: next.sort) ?? -1
        let rhs = sorts.firstIndex(of: previous.sort) ?? 9_999
        return (next.sort, lhs < rhs ? .reverse : .forward)
      }

    self.updateSortPagerStyle = self.filterWithParamsProperty.signal.skipNil()
      .map { $0.category?.intID }
      .skipRepeats(==)

    self.sortsAreEnabled = self.setSortsEnabledProperty.signal.skipNil()

    let currentSortedPage = Signal.merge(
      self.sortPagerSelectedSortProperty.signal.skipNil().skipRepeats(==),
      swipeToSort
    )

    Signal.combineLatest(
      currentParams,
      currentSortedPage,
      prevSortedPage
    )
    .filter { $0.1.rawValue != $0.2.rawValue }
    .observeValues { currentParams, currentSortedPage, prevSortedPage in
      AppEnvironment
        .current
        .ksrAnalytics
        .trackDiscoverySelectedSort(
          prevSort: prevSortedPage,
          params: currentParams,
          discoverySortContext: self.getDiscoverySortTypeContext(from: currentSortedPage)
        )
    }
  }

  /// convert DiscoveryParams.Sort to TypeContext.DiscoverySortContext
  private func getDiscoverySortTypeContext(
    from sort: DiscoveryParams.Sort
  ) -> KSRAnalytics.TypeContext.DiscoverySortContext {
    switch sort {
    case .endingSoon: return .endingSoon
    case .magic: return .magic
    case .newest: return .newest
    case .popular: return .popular
    default:
      assert(
        false,
        "The other sort types were added for GraphQL compatibility, and should never come up in V1 Discover."
      )
      return .magic
    }
  }

  fileprivate let didChangeRecommendationsSettingProperty = MutableProperty(())
  /// Refreshes discovery parameters when the user toggles their recommendations privacy setting.
  public func didChangeRecommendationsSetting() {
    self.didChangeRecommendationsSettingProperty.value = ()
  }

  fileprivate let filterWithParamsProperty = MutableProperty<DiscoveryParams?>(nil)
  /// Applies newly selected discovery filter parameters.
  public func filter(withParams params: DiscoveryParams) {
    self.filterWithParamsProperty.value = params
  }

  fileprivate let remoteConfigClientConfiguredProperty = MutableProperty(())
  /// Signals that Remote Config has finished configuring.
  public func remoteConfigClientConfigured() {
    self.remoteConfigClientConfiguredProperty.value = ()
  }

  fileprivate let remoteConfigClientConfigurationFailedProperty = MutableProperty(())
  /// Signals that Remote Config failed to configure so discovery can proceed with defaults.
  public func remoteConfigClientConfigurationFailed() {
    self.remoteConfigClientConfigurationFailedProperty.value = ()
  }

  fileprivate let pageTransitionCompletedProperty = MutableProperty(false)
  /// Notifies the view model that a page transition animation completed.
  public func pageTransition(completed: Bool) {
    self.pageTransitionCompletedProperty.value = completed
  }

  fileprivate let sortPagerSelectedSortProperty = MutableProperty<DiscoveryParams.Sort?>(nil)
  /// Switches discovery to the selected sort tab.
  public func sortPagerSelected(sort: DiscoveryParams.Sort) {
    self.sortPagerSelectedSortProperty.value = sort
  }

  fileprivate let setSortsEnabledProperty = MutableProperty<Bool?>(nil)
  /// Enables or disables sort tab interaction.
  public func setSortsEnabled(_ enabled: Bool) {
    self.setSortsEnabledProperty.value = enabled
  }

  fileprivate let willTransitionToPageProperty = MutableProperty<Int>(0)
  /// Records the target page index before a page view controller transition begins.
  public func willTransition(toPage nextPage: Int) {
    self.willTransitionToPageProperty.value = nextPage
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the discovery view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let viewWillAppearProperty = MutableProperty<Bool?>(nil)
  /// Signals that the discovery view will appear.
  public func viewWillAppear(animated: Bool) {
    self.viewWillAppearProperty.value = animated
  }

  /// Emits discovery parameters used to configure the navigation header.
  public let configureNavigationHeader: Signal<DiscoveryParams, Never>
  /// Emits the ordered list of sorts for the page view data source.
  public let configurePagerDataSource: Signal<[DiscoveryParams.Sort], Never>
  /// Emits the ordered list of sorts for the sort pager bar.
  public let configureSortPager: Signal<[DiscoveryParams.Sort], Never>
  /// Emits active filter parameters to load into each discovery page.
  public let loadFilterIntoDataSource: Signal<DiscoveryParams, Never>
  /// Emits the sort and swipe direction when programmatically navigating between sort pages.
  public let navigateToSort: Signal<(DiscoveryParams.Sort, UIPageViewController.NavigationDirection), Never>
  /// Emits the active sort to highlight in the sort pager bar.
  public let selectSortPage: Signal<DiscoveryParams.Sort, Never>
  /// Emits whether the sort tabs should be interactive.
  public let sortsAreEnabled: Signal<Bool, Never>
  /// Emits the selected category ID (or `nil`) to style the sort pager bar.
  public let updateSortPagerStyle: Signal<Int?, Never>

  /// The inputs interface for this view model.
  public var inputs: DiscoveryViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: DiscoveryViewModelOutputs { return self }
}
