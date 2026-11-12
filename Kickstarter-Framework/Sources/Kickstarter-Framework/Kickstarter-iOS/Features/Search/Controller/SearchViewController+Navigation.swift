import KDS
import KsApi
import Library
import Prelude
import SwiftUI
import UIKit

/// `SearchViewController` extensions declared in `SearchViewController+Navigation.swift`.
extension SearchViewController {
  internal func showSort() {
    let sortViewModel = SortViewModel(
      sortOptions: self.viewModel.outputs.searchFilters.sort.sortOptions,
      selectedSortOption: self.viewModel.outputs.searchFilters.sort.selectedSort
    )

    let sortView = SortView(
      viewModel: sortViewModel,
      onSelectedSort: { [weak self] sortOption in
        self?.viewModel.inputs.selectedFilter(.sort(sortOption))
      },
      onClosed: { [weak self] in
        self?.dismiss(animated: true)
      }
    )

    let hostingController = UIHostingController(rootView: sortView)
    self.present(sheet: hostingController, withHeight: sortView.dynamicHeight())
  }

  internal func showFilters(filterType: SearchFilterModalType) {
    var filterView = FilterRootView(
      filterType: filterType,
      searchFilters: self.viewModel.outputs.searchFilters
    )
    filterView.onFilter = { [weak self] filterEvent in
      self?.viewModel.inputs.selectedFilter(filterEvent)
    }
    filterView.onSearchedForLocations = { [weak self] locationQuery in
      self?.viewModel.inputs.searchedForLocations(locationQuery)
    }
    filterView.onReset = { [weak self] type in
      self?.viewModel.inputs.resetFilters(for: type)
    }
    filterView.onResults = { [weak self] in
      self?.dismiss(animated: true)
    }
    filterView.onClose = { [weak self] in
      self?.dismiss(animated: true)
    }
    let hostingController = UIHostingController(rootView: filterView)
    self.present(hostingController, animated: true)
  }

  internal func goTo(project projectParam: ProjectPageParam, refTag: RefTag) {
    let nav = ProjectPageViewController.navigationController(
      withProjectOrParam: Either.right(projectParam),
      refInfo: RefInfo(refTag)
    )

    self.present(nav, animated: true, completion: nil)
  }
}

extension SearchViewController: TabBarControllerScrollable {}

// MARK: - SearchEmptyStateCellDelegate

extension SearchViewController: SearchEmptyStateCellDelegate {
  func searchEmptyStateCellDidTapRemoveAllFiltersButton(
    _: SearchEmptyStateCell
  ) {
    self.viewModel.inputs.resetFilters(for: .allFilters)
  }
}

// MARK: - VideoFeedBannerCellDelegate

extension SearchViewController: VideoFeedBannerCellDelegate {
  func videoFeedBannerCellDidTapTryItNow(_ cell: VideoFeedBannerCell) {
    self.presentVideoFeed(from: cell)
  }
}

