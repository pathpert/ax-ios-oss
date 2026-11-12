import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveSwift

/// Builds `goToProject` navigation output and attaches search view & result-click analytics.
func makeSearchNavigationAndTracking(
  searchResults: Signal<[SearchResult], Never>,
  paginatedProjects: Signal<[SearchResult], Never>,
  isLoading: Signal<Bool, Never>,
  page: Signal<Int, Never>,
  stats: Signal<Int, Never>,
  queryText: Signal<String, Never>,
  queryParams: Signal<DiscoveryParams, Never>,
  requestFirstPageWith: Signal<DiscoveryParams, Never>,
  viewWillAppearNotAnimated: Signal<Void, Never>,
  tappedProjectIndex: Signal<Int, Never>
) -> Signal<(ProjectPageParam, RefTag), Never> {
  let goToProject = Signal.combineLatest(searchResults, queryText)
    .takePairWhen(tappedProjectIndex)
    .map { ($0.0, $0.1, $1) }
    .map { projects, query, index -> (ProjectPageParam, RefTag)? in
      guard index >= 0, index < projects.count else {
        assert(false, "Tapped card out of bounds.")
        return nil
      }

      let project = projects[index]
      let graphQLID = project.fragments.backerDashboardProjectCellFragment.projectId

      guard let _ = decompose(id: graphQLID),
            let cardProperties = ProjectCardProperties(project.fragments.projectCardFragment)
      else {
        return nil
      }

      return (
        cardProperties.projectPageParam,
        searchResultRefTag(query: query, projects: projects, project: project)
      )
    }
    .skipNil()

  let viewWillAppearSearchResultsCount = Signal.merge(
    stats,
    viewWillAppearNotAnimated.mapConst(0).take(first: 1)
  )

  Signal.combineLatest(queryText, queryParams, viewWillAppearSearchResultsCount)
    .takeWhen(viewWillAppearNotAnimated)
    .observeValues { query, params, searchResultsCount in
      let results = query.isEmpty ? 0 : searchResultsCount
      AppEnvironment.current.ksrAnalytics.trackProjectSearchView(params: params, results: results)
    }

  let hasResults = Signal.combineLatest(paginatedProjects, isLoading)
    .filter(second >>> isFalse)
    .map(first)
    .map { !$0.isEmpty }

  let firstPageResults = Signal.zip(hasResults, page)
    .filter { _, currentPage in currentPage == 1 }
    .map(first)

  let newQuerySearchResultsCount = Signal.merge(
    viewWillAppearSearchResultsCount.filter { $0 == 0 },
    viewWillAppearSearchResultsCount.takeWhen(firstPageResults)
  )

  Signal.combineLatest(queryText, requestFirstPageWith)
    .takePairWhen(newQuerySearchResultsCount)
    .map(unpack)
    .filter { query, _, _ in !query.isEmpty }
    .observeValues { _, params, statsCount in
      AppEnvironment.current.ksrAnalytics.trackProjectSearchView(params: params, results: statsCount)
    }

  Signal.combineLatest(requestFirstPageWith, searchResults)
    .takePairWhen(tappedProjectIndex)
    .map { ($0.0, $0.1, $1) }
    .observeValues { params, results, index in
      guard index >= 0, index < results.count else {
        assert(false, "Tapped card out of bounds.")
        return
      }

      let projectAnalytics = results[index].fragments.projectAnalyticsFragment
      AppEnvironment.current.ksrAnalytics.trackProjectCardClicked(
        page: .search,
        project: projectAnalytics,
        typeContext: .results,
        location: .searchResults,
        params: params
      )
    }

  return goToProject
}

/// Calculates a ref tag from the search query, displayed projects, and tapped project.
func searchResultRefTag(query: String, projects: [SearchResult], project: SearchResult) -> RefTag {
  if project == projects.first, query.isEmpty {
    return RefTag.searchPopularFeatured
  } else if project == projects.first, !query.isEmpty {
    return RefTag.searchFeatured
  } else if query.isEmpty {
    return RefTag.searchPopular
  } else {
    return RefTag.search
  }
}

