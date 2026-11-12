import Foundation
import GraphAPI
import KsApi
import ReactiveSwift

/// Typealias for search card display properties.
public typealias SearchResultCard = ProjectCardProperties
/// GraphQL project node emitted by search queries.
public typealias SearchResult = GraphAPI.SearchQuery.Data.Projects.Node

/// Value object driving the search results collection/table view data source.
public struct SearchResults {
  /// Whether the "Popular projects" header title should be displayed above results.
  public let isProjectsTitleVisible: Bool
  /// Total matching project count reported by the search query.
  public let count: Int
  /// Mapped cell view models for matching search results.
  public let projects: [BackerDashboardProjectCellViewModel.ProjectCellModel]

  /// Creates a search results snapshot.
  public init(
    isProjectsTitleVisible: Bool,
    count: Int,
    projects: [BackerDashboardProjectCellViewModel.ProjectCellModel]
  ) {
    self.isProjectsTitleVisible = isProjectsTitleVisible
    self.count = count
    self.projects = projects
  }
}

/// Input events handled by `SearchViewModel`.
public protocol SearchViewModelInputs {
  /// Call when the user enters a new search term.
  func searchTextChanged(_ searchText: String)

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view will appear.
  func viewWillAppear(animated: Bool)

  /// Call when a project is tapped.
  func tapped(projectAtIndex index: Int)

  /// Call this when the user taps on a button to show one of the sort options.
  func tappedButton(forFilterType type: SearchFilterPill.FilterType)

  /// Call this when the user updates a sort or filter option
  func selectedFilter(_ event: SearchFilterEvent)

  /// Call this when the user types a location query string in the location filter
  func searchedForLocations(_ query: String)

  /// Call this when the user taps reset on a filter modal
  func resetFilters(for: SearchFilterModalType)

  /**
   Call from the controller's `tableView:willDisplayCell:forRowAtIndexPath` method.

   - parameter row:       The 0-based index of the row displaying.
   - parameter totalRows: The total number of rows in the table view.
   */
  func willDisplayProjectAtRow(_ row: Int, outOf totalProjects: Int)
}

/// Output signals and filter model exposed by `SearchViewModel`.
public protocol SearchViewModelOutputs {
  /// Emits a project ID  and ref tag when the project page should be opened.
  var goToProject: Signal<(ProjectPageParam, RefTag), Never> { get }

  /// Used to power the datasource. Emits projects, whether or not to show the "Popular" title, and the results count. May emit an array of empty projects if the page was cleared and new results are loading.
  var searchResults: Signal<SearchResults, Never> { get }

  /// Emits when loading indicator should be hidden.
  var searchLoaderIndicatorIsAnimating: Signal<Bool, Never> { get }

  /// Emits true when no search results should be shown, and false otherwise.
  var showEmptyState: Signal<(DiscoveryParams, Bool), Never> { get }

  /// Sends a model object which can be used to display all filter options, and a type describing which filters to display.
  var showFilters: Signal<SearchFilterModalType, Never> { get }

  /// Emits to show the video feed banner
  var showVideoFeedBanner: Signal<Bool, Never> { get }

  /// An @ObservableObject model which SwiftUI can use to display the search filters modals and header.
  /// Owned and automatically updated by the `SearchFiltersUseCase`.
  var searchFilters: SearchFilters { get }
}

/// View model interface powering project search, filters, pagination, and tracking.
public protocol SearchViewModelType {
  /// Input receiver for search text, filter selection, and scrolling events.
  var inputs: SearchViewModelInputs { get }
  /// Output signals bound by `SearchViewController`.
  var outputs: SearchViewModelOutputs { get }
}
