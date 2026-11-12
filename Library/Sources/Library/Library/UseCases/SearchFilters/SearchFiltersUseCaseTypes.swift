import GraphAPI
import KsApi
import ReactiveSwift
import UIKit

/// Coordinate interface exposing inputs, UI outputs, and data outputs for search filtering.
public protocol SearchFiltersUseCaseType {
  /// Input actions triggered by the user interface.
  var inputs: SearchFiltersUseCaseInputs { get }
  /// UI outputs driving filter modals and observable filter state.
  var uiOutputs: SearchFiltersUseCaseUIOutputs { get }
  /// Data outputs emitting selected filter and sort values.
  var dataOutputs: SearchFiltersUseCaseDataOutputs { get }
}

/// Input actions supported by `SearchFiltersUseCase`.
public protocol SearchFiltersUseCaseInputs {
  /// Call this when the user taps on a button to show one of the sort options.
  func tappedButton(forFilterType: SearchFilterPill.FilterType)
  /// Call this when the clears their query and the sort options should reset.
  func clearedQueryText()
  /// Call this when the user updates a sort or filter option
  func selectedFilter(_ event: SearchFilterEvent)
  /// Call this when the user taps reset on a filter modal
  func resetFilters(for: SearchFilterModalType)
}

/// UI-facing outputs produced by `SearchFiltersUseCase`.
public protocol SearchFiltersUseCaseUIOutputs {
  /// Sends a model object which can be used to display all filter options, and a type describing which filters to display.
  var showFilters: Signal<SearchFilterModalType, Never> { get }

  /// An @ObservableObject model which SwiftUI can use to display the search filters modals and header.
  /// Owned and automatically updated by this `SearchFiltersUseCase`.
  var searchFilters: SearchFilters { get }
}

/// Selected filter value streams emitted by `SearchFiltersUseCase`.
public protocol SearchFiltersUseCaseDataOutputs {
  /// The currently selected sort option. Defaults to `.popular`. Default value only sent after `initialSignal` occurs.
  var selectedSort: Signal<DiscoveryParams.Sort, Never> { get }
  /// The currently selected category. Defaults to nil. Default value only sent after `initialSignal` occurs.
  var selectedCategory: Signal<SearchFiltersCategory, Never> { get }
  /// The currently selected project state. Defaults to `.all`. Default value only sent after `initialSignal` occurs.
  var selectedState: Signal<DiscoveryParams.State, Never> { get }
  /// The currently selected percent raised bucket. Defaults to `nil`. Default value only sent after `initialSignal` occurs.
  var selectedPercentRaisedBucket: Signal<DiscoveryParams.PercentRaisedBucket?, Never> { get }
  /// The currently selected filter location. Defaults to `nil`. Default value only sent after `initialSignal` occurs.
  var selectedLocation: Signal<Location?, Never> { get }
  /// The currently selected amount raised bucket. Defaults to `nil`. Default value only sent after `initialSignal` occurs.
  var selectedAmountRaisedBucket: Signal<DiscoveryParams.AmountRaisedBucket?, Never> { get }
  /// The currently selected goal bucket. Defaults to `nil`. Default value only sent after `initialSignal` occurs.
  var selectedGoalBucket: Signal<DiscoveryParams.GoalBucket?, Never> { get }
  /// The currently selected 'Show Only' toggles. All toggles default to `false`. Default value only sent after `initialSignal` occurs.
  var selectedToggles: Signal<SearchFilterToggles, Never> { get }
}

/// Modal destinations presented when selecting a search filter pill.
public enum SearchFilterModalType: Hashable, CaseIterable {
  /// Full filter sheet showing all filter sections.
  case allFilters
  /// Category picker modal.
  case category
  /// Sort order picker modal.
  case sort
  /// Percent raised bucket picker modal.
  case percentRaised
  /// Location picker modal.
  case location
  /// Amount raised bucket picker modal.
  case amountRaised
  /// Funding goal bucket picker modal.
  case goal
}

/// Discrete filter or sort update events sent to `SearchFiltersUseCaseInputs`.
public enum SearchFilterEvent {
  /// Updates the active sort order.
  case sort(DiscoveryParams.Sort)
  /// Updates the active category selection.
  case category(SearchFiltersCategory)
  /// Updates the project state filter.
  case projectState(DiscoveryParams.State)
  /// Updates the percent raised bucket filter.
  case percentRaised(DiscoveryParams.PercentRaisedBucket)
  /// Updates the amount raised bucket filter.
  case amountRaised(DiscoveryParams.AmountRaisedBucket)
  /// Updates the funding goal bucket filter.
  case goal(DiscoveryParams.GoalBucket)
  /// Updates the location filter.
  case location(Location?)
  /// Toggles the recommended projects filter.
  case recommended(Bool)
  /// Toggles the saved projects filter.
  case savedProjects(Bool)
  /// Toggles the Projects We Love filter.
  case projectsWeLove(Bool)
  /// Toggles the following creators filter.
  case following(Bool)
}

/// Boolean toggle states for the "Show Only" search filter section.
public struct SearchFilterToggles {
  /// Whether to filter to recommended projects.
  public var recommended: Bool
  /// Whether to filter to saved projects.
  public var savedProjects: Bool
  /// Whether to filter to Projects We Love.
  public var projectsWeLove: Bool
  /// Whether to filter to projects from followed creators.
  public var following: Bool
}

internal extension SearchFiltersUseCase {
  static let sortOptions: [DiscoveryParams.Sort] = [
    .magic, // aka Recommended
    .popular,
    .newest,
    .endingSoon,
    .most_funded,
    .most_backed
  ]

  static let stateOptions: [DiscoveryParams.State] = [
    .all,
    .live,
    .late_pledge,
    .upcoming,
    .successful
  ]

  static func filterModal(toShowForPill pill: SearchFilterPill.FilterType) -> SearchFilterModalType {
    switch pill {
    case .allFilters, .projectState, .projectsWeLove, .saved, .following, .recommended:
      return .allFilters
    case .category:
      return .category
    case .sort:
      return .sort
    case .percentRaised:
      return .percentRaised
    case .location:
      return .location
    case .amountRaised:
      return .amountRaised
    case .goal:
      return .goal
    }
  }
}

private extension GraphAPI.LocationsByTermQuery.Data.Locations {}

