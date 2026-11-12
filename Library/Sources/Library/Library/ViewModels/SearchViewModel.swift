import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveSwift

/// View model managing GraphQL project search, filter state, pagination, empty states, and analytics.
public final class SearchViewModel: SearchViewModelType, SearchViewModelInputs, SearchViewModelOutputs {
  /// Initializes the search view model and wires categories, locations, filters, pagination, and tracking.
  public init() {
    self.categoriesUseCase = FetchCategoriesUseCase(initialSignal: self.viewDidLoadProperty.signal)
    self.locationsUseCase = FetchLocationsUseCase(initialSignal: self.viewDidLoadProperty.signal)
    self.searchFiltersUseCase = SearchFiltersUseCase(
      initialSignal: self.viewDidLoadProperty.signal,
      categories: self.categoriesUseCase.dataOutputs.categories,
      defaultLocations: self.locationsUseCase.dataOutputs.defaultLocations,
      suggestedLocations: self.locationsUseCase.dataOutputs.suggestedLocations
    )

    let viewWillAppearNotAnimated = self.viewWillAppearAnimatedProperty.signal.filter(isTrue).ignoreValues()
    let queryText = Signal.merge(
      self.searchTextChangedProperty.signal,
      viewWillAppearNotAnimated.mapConst("").take(first: 1)
    )

    let queryParams: Signal<DiscoveryParams, Never> = Signal.combineLatest(
      queryText,
      self.searchFiltersUseCase.dataOutputs.selectedSort,
      self.searchFiltersUseCase.dataOutputs.selectedCategory,
      self.searchFiltersUseCase.dataOutputs.selectedState,
      self.searchFiltersUseCase.dataOutputs.selectedPercentRaisedBucket,
      self.searchFiltersUseCase.dataOutputs.selectedLocation,
      self.searchFiltersUseCase.dataOutputs.selectedAmountRaisedBucket,
      self.searchFiltersUseCase.dataOutputs.selectedGoalBucket,
      self.searchFiltersUseCase.dataOutputs.selectedToggles
    )
    .map { query, sort, category, state, percentRaised, location, amountRaised, goal, toggles in
      DiscoveryParams.withQuery(
        query,
        sort: sort,
        category: category.category,
        state: state,
        percentRaised: percentRaised,
        location: location,
        amountRaised: amountRaised,
        goal: goal,
        toggles: toggles
      )
    }

    let clears = queryParams.mapConst([SearchResult]())
    let requestFirstPageWith: Signal<DiscoveryParams, Never> = queryParams
    let isCloseToBottom = self.willDisplayProjectProperty.signal.skipNil()
      .map { row, total in row >= total - 3 }
      .skipRepeats()
      .filter(isTrue)
      .ignoreValues()

    var firstRequest = true
    let requestFromOptionsWithDebounce: (DiscoveryParams)
      -> SignalProducer<GraphAPI.SearchQuery.Data, ErrorEnvelope> = { params in
        SignalProducer<(), ErrorEnvelope>(value: ())
          .switchMap {
            let query = GraphAPI.SearchQuery.from(discoveryParams: params)
            let request = AppEnvironment.current.apiService.fetch(query: query)
            let debounce = firstRequest ? DispatchTimeInterval.seconds(0) : AppEnvironment.current
              .debounceInterval
            if firstRequest { firstRequest = false }
            return request.ksr_debounce(debounce, on: AppEnvironment.current.scheduler)
          }
      }

    let statsProperty = MutableProperty<Int>(0)
    let optionsProperty = MutableProperty<DiscoveryParams?>(nil)
    optionsProperty <~ requestFirstPageWith

    let (paginatedProjects, isLoading, page, _) = paginate(
      requestFirstPageWith: requestFirstPageWith,
      requestNextPageWhen: isCloseToBottom,
      clearOnNewRequest: false,
      skipRepeats: false,
      valuesFromEnvelope: { [statsProperty] (data: GraphAPI.SearchQuery.Data) -> [SearchResult] in
        statsProperty.value = data.projects?.totalCount ?? 0
        return data.projects?.nodes?.compact() ?? []
      },
      cursorFromEnvelope: { data in
        guard let pageInfo = data.projects?.pageInfo else { return nil }
        return pageInfo.hasNextPage ? pageInfo.endCursor : nil
      },
      requestFromParams: requestFromOptionsWithDebounce,
      requestFromCursor: { [optionsProperty] (maybeCursor: String?) -> SignalProducer<
        GraphAPI.SearchQuery.Data,
        ErrorEnvelope
      > in
        guard let options = optionsProperty.value, let cursor = maybeCursor else {
          return SignalProducer.empty
        }
        let query = GraphAPI.SearchQuery.from(discoveryParams: options, withCursor: cursor)
        return AppEnvironment.current.apiService.fetch(query: query)
      }
    )

    let stats = statsProperty.signal
    self.searchLoaderIndicatorIsAnimating = isLoading

    let searchResults: Signal<[SearchResult], Never> = Signal.merge(clears, paginatedProjects)
      .skipRepeats(==)

    let isProjectsTitleVisible = Signal.combineLatest(queryText, searchResults)
      .map { query, projects in query.isEmpty && !projects.isEmpty }
      .skipRepeats()

    self.projects = searchResults.map { nodes in
      nodes.compactMap { ProjectCardProperties($0.fragments.projectCardFragment) }
    }

    let shouldShowEmptyState = Signal.combineLatest(paginatedProjects, isLoading)
      .map { projects, isLoading in isLoading ? false : projects.isEmpty }
      .skipRepeats()

    self.showEmptyState = requestFirstPageWith.takePairWhen(shouldShowEmptyState)
    self.reachabilityProperty <~ Reachability.signalProducer
    self.showVideoFeedBanner = Signal.merge(
      self.viewWillAppearAnimatedProperty.signal.ignoreValues(),
      self.reachabilityProperty.signal.ignoreValues()
    )
    .map { featureVideoFeedEnabled() && Reachability.current != .none }
    .skipRepeats()

    self.goToProject = makeSearchNavigationAndTracking(
      searchResults: searchResults,
      paginatedProjects: paginatedProjects,
      isLoading: isLoading,
      page: page,
      stats: stats,
      queryText: queryText,
      queryParams: queryParams,
      requestFirstPageWith: requestFirstPageWith,
      viewWillAppearNotAnimated: viewWillAppearNotAnimated,
      tappedProjectIndex: self.tappedProjectIndexSignal
    )

    let emptyResultsOnFirstAppearance = viewWillAppearNotAnimated
      .take(first: 1)
      .mapConst(SearchResults(isProjectsTitleVisible: false, count: 0, projects: []))

    self.searchResults = Signal.combineLatest(isProjectsTitleVisible, stats, self.projects)
      .map { isTitleVisible, resultCount, projects in
        SearchResults(
          isProjectsTitleVisible: isTitleVisible,
          count: resultCount,
          projects: projects.map { $0.projectCellModel }
        )
      }
      .merge(with: emptyResultsOnFirstAppearance)
  }

  fileprivate let searchTextChangedProperty = MutableProperty("")
  /// Updates the active search text and resets filters when cleared.
  public func searchTextChanged(_ searchText: String) {
    self.searchTextChangedProperty.value = searchText
    if searchText.isEmpty {
      self.searchFiltersUseCase.inputs.clearedQueryText()
    }
  }

  fileprivate let (tappedProjectIndexSignal, tappedProjectIndexObserver) = Signal<Int, Never>.pipe()
  /// Signals that a project card at the given index was selected.
  public func tapped(projectAtIndex index: Int) { self.tappedProjectIndexObserver.send(value: index) }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the search view finished loading.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  fileprivate let viewWillAppearAnimatedProperty = MutableProperty(false)
  /// Signals that the search view is about to appear.
  public func viewWillAppear(animated: Bool) { self.viewWillAppearAnimatedProperty.value = animated }

  fileprivate let willDisplayProjectProperty = MutableProperty<(row: Int, total: Int)?>(nil)
  /// Reports visible row progress to trigger pagination near the end of results.
  public func willDisplayProjectAtRow(_ row: Int, outOf totalRows: Int) {
    self.willDisplayProjectProperty.value = (row, totalRows)
  }

  /// Signals that the user tapped a filter pill button.
  public func tappedButton(forFilterType type: SearchFilterPill.FilterType) {
    self.searchFiltersUseCase.inputs.tappedButton(forFilterType: type)
  }

  /// Resets filters for the specified modal type.
  public func resetFilters(for type: SearchFilterModalType) {
    self.searchFiltersUseCase.inputs.resetFilters(for: type)
  }

  private let categoriesUseCase: FetchCategoriesUseCase
  private let searchFiltersUseCase: SearchFiltersUseCase
  private let locationsUseCase: FetchLocationsUseCase
  private let reachabilityProperty = MutableProperty(Reachability.current)

  /// Emits project navigation parameters and ref tag when a result card is tapped.
  public let goToProject: Signal<(ProjectPageParam, RefTag), Never>
  /// Emits loaded search project card property models.
  public let projects: Signal<[SearchResultCard], Never>
  /// Emits whether the search loading indicator should animate.
  public let searchLoaderIndicatorIsAnimating: Signal<Bool, Never>
  /// Emits active discovery parameters and visibility flag for the empty search state.
  public let showEmptyState: Signal<(DiscoveryParams, Bool), Never>
  /// Emits whether the video feed banner should be shown.
  public let showVideoFeedBanner: Signal<Bool, Never>
  /// Emits assembled search results driving the list data source.
  public let searchResults: Signal<SearchResults, Never>

  /// Emits filter modal types to present when a filter pill is tapped.
  public var showFilters: Signal<SearchFilterModalType, Never> { self.searchFiltersUseCase.showFilters }
  /// Applies a selected sort or filter event from the filter modal.
  public func selectedFilter(_ event: SearchFilterEvent) { self.searchFiltersUseCase.selectedFilter(event) }
  /// Executes a location autocomplete query inside the location filter modal.
  public func searchedForLocations(_ query: String) { self.locationsUseCase.searchedForLocations(query) }
  /// Observable filter model bound by SwiftUI search filter views.
  public var searchFilters: SearchFilters { self.searchFiltersUseCase.searchFilters }

  /// View model inputs.
  public var inputs: SearchViewModelInputs { return self }
  /// View model outputs.
  public var outputs: SearchViewModelOutputs { return self }
}
