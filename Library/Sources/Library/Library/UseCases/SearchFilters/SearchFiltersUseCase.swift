import KsApi
import ReactiveSwift
import UIKit

/// Use case managing search filter selections, modals, and observable SwiftUI state.
public final class SearchFiltersUseCase: SearchFiltersUseCaseType, SearchFiltersUseCaseInputs,
  SearchFiltersUseCaseUIOutputs, SearchFiltersUseCaseDataOutputs {
  /// Initializes the search filters use case.
  /// - Parameters:
  ///   - initialSignal: Initial pulse required before default filter and sort values emit.
  ///   - categories: Stream of available filter categories.
  ///   - defaultLocations: Stream of default search locations.
  ///   - suggestedLocations: Stream of query-suggested search locations.
  public init(
    initialSignal: Signal<Void, Never>,
    categories: Signal<[KsApi.Category], Never>,
    defaultLocations: Signal<[KsApi.Location], Never>,
    suggestedLocations: Signal<[KsApi.Location], Never>
  ) {
    self.categoriesProperty <~ categories
    self.defaultLocationsProperty <~ defaultLocations
    self.suggestedLocationsProperty <~ suggestedLocations

    self.selectedSort = self.selectedSortProperty.signal(takeInitialValueWhen: initialSignal)
    self.selectedCategory = self.selectedCategoryProperty.signal(takeInitialValueWhen: initialSignal)
    self.selectedState = self.selectedStateProperty.signal(takeInitialValueWhen: initialSignal)
    self.selectedPercentRaisedBucket = self.selectedPercentRaisedBucketProperty
      .signal(takeInitialValueWhen: initialSignal)
    self.selectedLocation = self.selectedLocationProperty.signal(takeInitialValueWhen: initialSignal)
    self.selectedAmountRaisedBucket = self.selectedAmountRaisedBucketProperty
      .signal(takeInitialValueWhen: initialSignal)
    self.selectedGoalBucket = self.selectedGoalBucketProperty
      .signal(takeInitialValueWhen: initialSignal)

    self.selectedToggles = Signal.combineLatest(
      self.recommendedProperty.signal(takeInitialValueWhen: initialSignal),
      self.savedProjectsProperty.signal(takeInitialValueWhen: initialSignal),
      self.projectsWeLoveProperty.signal(takeInitialValueWhen: initialSignal),
      self.followingProperty.signal(takeInitialValueWhen: initialSignal)
    )
    .map { recommended, saved, pwl, following in
      SearchFilterToggles(
        recommended: recommended,
        savedProjects: saved,
        projectsWeLove: pwl,
        following: following
      )
    }

    self.searchFilters = SearchFilters(
      sort: SearchFilters.SortOptions(
        sortOptions: Self.sortOptions,
        selectedSort: self.selectedSortProperty.value
      ),
      category: SearchFilters.CategoryOptions(
        categories: self.categoriesProperty.value,
        selectedCategory: self.selectedCategoryProperty.value
      ),
      projectState: SearchFilters.ProjectStateOptions(
        stateOptions: Self.stateOptions,
        selectedProjectState: self.selectedStateProperty.value
      ),
      percentRaised: SearchFilters.PercentRaisedOptions(
        buckets: DiscoveryParams.PercentRaisedBucket.allCases
      ),
      location: SearchFilters.LocationOptions(
        defaultLocations: self.defaultLocationsProperty.value,
        suggestedLocations: self.suggestedLocationsProperty.value
      ),
      amountRaised: SearchFilters.AmountRaisedOptions(
        buckets: DiscoveryParams.AmountRaisedBucket.allCases
      ),
      goal: SearchFilters.GoalOptions(buckets: DiscoveryParams.GoalBucket.allCases),
      showOnly: SearchFilters.ShowOnlyOptions(
        recommended: self.recommendedProperty.value,
        savedProjects: self.savedProjectsProperty.value,
        projectsWeLove: self.projectsWeLoveProperty.value,
        following: self.followingProperty.value
      )
    )

    let tappedTogglePill = self.tappedFilterTypeSignal.filter { $0.isToggle }
    let tappedModalPill = self.tappedFilterTypeSignal.filter { !$0.isToggle }

    self.showFilters = tappedModalPill.map { Self.filterModal(toShowForPill: $0) }

    tappedTogglePill.observeValues { [weak self] pill in
      self?.toggleFilter(ofType: pill)
    }

    Signal.combineLatest(
      self.dataOutputs.selectedSort,
      self.dataOutputs.selectedCategory,
      self.dataOutputs.selectedState,
      self.dataOutputs.selectedPercentRaisedBucket,
      self.dataOutputs.selectedLocation,
      self.dataOutputs.selectedAmountRaisedBucket,
      self.dataOutputs.selectedGoalBucket,
      self.dataOutputs.selectedToggles
    )
    .observeForUI()
    .observeValues { [
      weak searchFilters
    ] sort, category, state, percentRaisedBucket, location, amountRaisedBucket, goalBucket, toggles in
      searchFilters?.update(
        withSort: sort,
        category: category,
        projectState: state,
        percentRaisedBucket: percentRaisedBucket,
        location: location,
        amountRaisedBucket: amountRaisedBucket,
        goalBucket: goalBucket,
        toggles: toggles
      )
    }

    self.categoriesProperty.signal.observeForUI()
      .observeValues { [weak searchFilters] in searchFilters?.update(withCategories: $0) }
    self.defaultLocationsProperty.signal.observeForUI()
      .observeValues { [weak searchFilters] in searchFilters?.update(withDefaultSearchLocations: $0) }
    self.suggestedLocationsProperty.signal.observeForUI()
      .observeValues { [weak searchFilters] in searchFilters?.update(withSuggestedLocations: $0) }
  }

  fileprivate let (tappedFilterTypeSignal, tappedFilterTypeObserver) = Signal<
    SearchFilterPill.FilterType,
    Never
  >.pipe()

  /// Notifies the use case that the user tapped a filter pill button.
  public func tappedButton(forFilterType type: SearchFilterPill.FilterType) {
    self.tappedFilterTypeObserver.send(value: type)
  }

  fileprivate let selectedSortProperty = MutableProperty<DiscoveryParams.Sort>(
    SearchFiltersUseCase.defaultSortOption
  )
  fileprivate let selectedCategoryProperty = MutableProperty<SearchFiltersCategory>(.none)
  fileprivate let selectedStateProperty = MutableProperty<DiscoveryParams.State>(
    SearchFiltersUseCase.defaultStateOption
  )
  fileprivate let selectedPercentRaisedBucketProperty =
    MutableProperty<DiscoveryParams.PercentRaisedBucket?>(nil)
  fileprivate let selectedLocationProperty = MutableProperty<Location?>(nil)
  fileprivate let selectedAmountRaisedBucketProperty =
    MutableProperty<DiscoveryParams.AmountRaisedBucket?>(nil)
  fileprivate let selectedGoalBucketProperty = MutableProperty<DiscoveryParams.GoalBucket?>(nil)

  fileprivate let categoriesProperty = MutableProperty<[KsApi.Category]>([])
  fileprivate let defaultLocationsProperty = MutableProperty<[KsApi.Location]>([])
  fileprivate let suggestedLocationsProperty = MutableProperty<[KsApi.Location]>([])

  fileprivate let recommendedProperty = MutableProperty<Bool>(false)
  fileprivate let savedProjectsProperty = MutableProperty<Bool>(false)
  fileprivate let projectsWeLoveProperty = MutableProperty<Bool>(false)
  fileprivate let followingProperty = MutableProperty<Bool>(false)

  internal static let defaultSortOption = DiscoveryParams.Sort.magic
  internal static let defaultStateOption = DiscoveryParams.State.all

  /// Emits the modal type to present when a filter pill is tapped.
  public let showFilters: Signal<SearchFilterModalType, Never>

  /// Selected sort stream.
  public let selectedSort: Signal<DiscoveryParams.Sort, Never>
  /// Selected category stream.
  public let selectedCategory: Signal<SearchFiltersCategory, Never>
  /// Selected project state stream.
  public let selectedState: Signal<DiscoveryParams.State, Never>
  /// Selected percent raised bucket stream.
  public let selectedPercentRaisedBucket: Signal<DiscoveryParams.PercentRaisedBucket?, Never>
  /// Selected location stream.
  public let selectedLocation: Signal<Location?, Never>
  /// Selected amount raised bucket stream.
  public let selectedAmountRaisedBucket: Signal<DiscoveryParams.AmountRaisedBucket?, Never>
  /// Selected funding goal bucket stream.
  public let selectedGoalBucket: Signal<DiscoveryParams.GoalBucket?, Never>
  /// Selected "Show Only" toggles stream.
  public let selectedToggles: Signal<SearchFilterToggles, Never>

  /// Observable filter model bound to the SwiftUI search filters header and modals.
  public private(set) var searchFilters: SearchFilters

  /// Resets all non-default filters and sort options when the search query is cleared.
  public func clearedQueryText() {
    self.resetFilters(for: .allFilters)
    self.resetFilters(for: .sort)
  }

  /// Resets filters belonging to the specified modal scope.
  public func resetFilters(for modal: SearchFilterModalType) {
    switch modal {
    case .allFilters:
      // Sort isn't a filter, so it's not included here.
      self.selectedCategoryProperty.value = .none
      self.selectedStateProperty.value = SearchFiltersUseCase.defaultStateOption
      self.selectedPercentRaisedBucketProperty.value = nil
      self.selectedLocationProperty.value = nil
      self.selectedAmountRaisedBucketProperty.value = nil
      self.selectedGoalBucketProperty.value = nil
      self.followingProperty.value = false
      self.recommendedProperty.value = false
      self.projectsWeLoveProperty.value = false
      self.savedProjectsProperty.value = false
    case .category:
      self.selectedCategoryProperty.value = .none
    case .sort:
      self.selectedSortProperty.value = SearchFiltersUseCase.defaultSortOption
    case .percentRaised:
      self.selectedPercentRaisedBucketProperty.value = nil
    case .location:
      self.selectedLocationProperty.value = nil
    case .amountRaised:
      self.selectedAmountRaisedBucketProperty.value = nil
    case .goal:
      self.selectedGoalBucketProperty.value = nil
    }
  }

  /// Applies a discrete filter or sort selection event.
  public func selectedFilter(_ event: SearchFilterEvent) {
    switch event {
    case let .sort(sort): self.selectedSortProperty.value = sort
    case let .category(selectedCategory): self.selectedCategoryProperty.value = selectedCategory
    case let .projectState(state): self.selectedStateProperty.value = state
    case let .percentRaised(bucket): self.selectedPercentRaisedBucketProperty.value = bucket
    case let .amountRaised(bucket): self.selectedAmountRaisedBucketProperty.value = bucket
    case let .goal(bucket): self.selectedGoalBucketProperty.value = bucket
    case let .location(location): self.selectedLocationProperty.value = location
    case let .recommended(showRecommended): self.recommendedProperty.value = showRecommended
    case let .savedProjects(showSavedProjects): self.savedProjectsProperty.value = showSavedProjects
    case let .projectsWeLove(showProjectsWeLove): self.projectsWeLoveProperty.value = showProjectsWeLove
    case let .following(showFollowing): self.followingProperty.value = showFollowing
    }
  }

  internal func toggleFilter(ofType type: SearchFilterPill.FilterType) {
    switch type {
    case .projectsWeLove: self.selectedFilter(.projectsWeLove(!self.projectsWeLoveProperty.value))
    case .saved: self.selectedFilter(.savedProjects(!self.savedProjectsProperty.value))
    case .following: self.selectedFilter(.following(!self.followingProperty.value))
    case .recommended: self.selectedFilter(.recommended(!self.recommendedProperty.value))
    default:
      assert(false, "Only boolean filter types can be toggled directly from the pill bar header.")
    }
  }

  /// Input interface for this use case.
  public var inputs: SearchFiltersUseCaseInputs { return self }
  /// UI output interface for this use case.
  public var uiOutputs: SearchFiltersUseCaseUIOutputs { return self }
  /// Data output interface for this use case.
  public var dataOutputs: SearchFiltersUseCaseDataOutputs { return self }
}
