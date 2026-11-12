import Combine
import KsApi
import SwiftUI

/// A model that SwiftUI can use to display Search Filters modals.
///
/// Also creates `SearchFilterPill`s from the selected filters,
/// for the `SearchFiltersHeaderView`.
///
/// This object is read-only outside of the `Library-iOS` Framework.
/// `SearchFiltersUseCase` owns and updates this object.
public class SearchFilters: ObservableObject {
  /// Available and currently selected project category filter options.
  public struct CategoryOptions {
    /// All selectable root categories.
    public var categories: [KsApi.Category]
    /// Currently active category or subcategory filter.
    public var selectedCategory: SearchFiltersCategory
  }

  /// Available and currently selected result sort order options.
  public struct SortOptions {
    /// Ordered list of sort criteria shown in the sort sheet.
    public let sortOptions: [DiscoveryParams.Sort]
    /// Active sort order.
    public var selectedSort: DiscoveryParams.Sort
  }

  /// Available and currently selected project funding state options.
  public struct ProjectStateOptions {
    /// Supported campaign states (e.g., all, live, successful).
    public let stateOptions: [DiscoveryParams.State]
    /// Active campaign state filter.
    public var selectedProjectState: DiscoveryParams.State
  }

  /// Available and currently selected percentage-funded buckets.
  public struct PercentRaisedOptions {
    /// Preset percentage-raised ranges.
    public let buckets: [DiscoveryParams.PercentRaisedBucket]
    /// Active percentage-raised bucket, or `nil` when unfiltered.
    public var selectedBucket: DiscoveryParams.PercentRaisedBucket?
  }

  /// Suggested, default, and selected geographic location filters.
  public struct LocationOptions {
    /// Default suggested locations shown before search input.
    public var defaultLocations: [Location]
    /// Autocomplete location matches for the user's query.
    public var suggestedLocations: [Location]
    /// Currently selected location filter, or `nil`.
    public var selectedLocation: Location?
  }

  /// Available and currently selected amount-raised filter buckets.
  public struct AmountRaisedOptions {
    /// Preset amount-raised ranges.
    public let buckets: [DiscoveryParams.AmountRaisedBucket]
    /// Active amount-raised bucket, or `nil` when unfiltered.
    public var selectedBucket: DiscoveryParams.AmountRaisedBucket?
  }

  /// Available and currently selected funding-goal buckets.
  public struct GoalOptions {
    /// Preset goal ranges.
    public let buckets: [DiscoveryParams.GoalBucket]
    /// Active funding-goal bucket, or `nil` when unfiltered.
    public var selectedBucket: DiscoveryParams.GoalBucket?
  }

  /// Boolean quick-toggle filter flags ("Show Only").
  public struct ShowOnlyOptions {
    /// Filters to personalized project recommendations.
    public var recommended: Bool
    /// Filters to projects saved/watched by the signed-in user.
    public var savedProjects: Bool
    /// Filters to Kickstarter "Projects We Love" selections.
    public var projectsWeLove: Bool
    /// Filters to projects backed by friends/following.
    public var following: Bool
  }

  /// Current category filter state.
  public private(set) var category: CategoryOptions
  /// Current sort option state.
  public private(set) var sort: SortOptions
  /// Current project state filter options.
  public private(set) var projectState: ProjectStateOptions
  /// Current percent-raised bucket options.
  public private(set) var percentRaised: PercentRaisedOptions
  /// Current geographic location filter options.
  public private(set) var location: LocationOptions
  /// Current amount-raised bucket options.
  public private(set) var amountRaised: AmountRaisedOptions
  /// Current funding goal bucket options.
  public private(set) var goal: GoalOptions
  /// Current boolean toggle options.
  public private(set) var showOnly: ShowOnlyOptions

  /// Rendered filter pills synchronized with current filter selections.
  public fileprivate(set) var pills: [SearchFilterPill]

  /// Combine publisher notifying SwiftUI views before filter properties change.
  public let objectWillChange = ObservableObjectPublisher()

  /// Total count of active non-sort filters applied to search results.
  public var filterCount: Int {
    // Note that sort is a special case and is not included in
    // reset or the filter count functionality.
    [
      self.hasCategory,
      self.hasProjectState,
      self.hasPercentRaised,
      self.hasLocation,
      self.hasAmountRaised,
      self.hasGoal,
      self.showOnly.following,
      self.showOnly.projectsWeLove,
      self.showOnly.recommended,
      self.showOnly.savedProjects
    ]
    .count(where: { $0 == true })
  }

  /// Returns `true` when at least one search filter is active (`filterCount > 0`).
  public var hasFilters: Bool {
    self.filterCount > 0
  }

  var hasCategory: Bool {
    switch self.category.selectedCategory {
    case .none:
      return false
    case .rootCategory:
      return true
    case .subcategory:
      return true
    }
  }

  var hasProjectState: Bool {
    return self.projectState.selectedProjectState != SearchFiltersUseCase.defaultStateOption
  }

  var hasSort: Bool {
    return self.sort.selectedSort != SearchFiltersUseCase.defaultSortOption
  }

  var hasPercentRaised: Bool {
    return self.percentRaised.selectedBucket != nil
  }

  var hasLocation: Bool {
    return self.location.selectedLocation != nil
  }

  var hasAmountRaised: Bool {
    return self.amountRaised.selectedBucket != nil
  }

  var hasGoal: Bool {
    return self.goal.selectedBucket != nil
  }

  init(
    sort: SortOptions,
    category: CategoryOptions,
    projectState: ProjectStateOptions,
    percentRaised: PercentRaisedOptions,
    location: LocationOptions,
    amountRaised: AmountRaisedOptions,
    goal: GoalOptions,
    showOnly: ShowOnlyOptions
  ) {
    self.sort = sort
    self.category = category
    self.projectState = projectState
    self.percentRaised = percentRaised
    self.location = location
    self.amountRaised = amountRaised
    self.goal = goal
    self.showOnly = showOnly

    self.pills = []
    self.updatePills()
  }

  func update(
    withSort sort: DiscoveryParams.Sort,
    category: SearchFiltersCategory,
    projectState: DiscoveryParams.State,
    percentRaisedBucket: DiscoveryParams.PercentRaisedBucket?,
    location: Location?,
    amountRaisedBucket: DiscoveryParams.AmountRaisedBucket?,
    goalBucket: DiscoveryParams.GoalBucket?,
    toggles: SearchFilterToggles
  ) {
    self.objectWillChange.send()

    self.sort.selectedSort = sort
    self.category.selectedCategory = category
    self.projectState.selectedProjectState = projectState
    self.percentRaised.selectedBucket = percentRaisedBucket
    self.location.selectedLocation = location
    self.amountRaised.selectedBucket = amountRaisedBucket
    self.goal.selectedBucket = goalBucket
    self.showOnly.recommended = toggles.recommended
    self.showOnly.savedProjects = toggles.savedProjects
    self.showOnly.projectsWeLove = toggles.projectsWeLove
    self.showOnly.following = toggles.following

    self.updatePills()
  }

  func update(
    withCategories categories: [KsApi.Category]
  ) {
    self.objectWillChange.send()
    self.category.categories = categories
  }

  func update(
    withDefaultSearchLocations locations: [Location]
  ) {
    self.objectWillChange.send()
    self.location.defaultLocations = locations
  }

  func update(
    withSuggestedLocations locations: [Location]
  ) {
    self.objectWillChange.send()
    self.location.suggestedLocations = locations
  }

  /// Returns `true` when the specific filter modal category `type` currently has an active selection.
  public func has(filter type: SearchFilterModalType) -> Bool {
    switch type {
    case .allFilters:
      return self.hasFilters
    case .category:
      return self.hasCategory
    case .sort:
      return self.hasSort
    case .percentRaised:
      return self.hasPercentRaised
    case .location:
      return self.hasLocation
    case .amountRaised:
      return self.hasAmountRaised
    case .goal:
      return self.hasGoal
    }
  }

  /// Determines whether the selected filter modal currently has an active selection that can be reset.
  public func canReset(filter type: SearchFilterModalType) -> Bool {
    return self.has(filter: type)
  }

  private func updatePills() {
    self.pills = self.buildFilterPills()
  }
}
