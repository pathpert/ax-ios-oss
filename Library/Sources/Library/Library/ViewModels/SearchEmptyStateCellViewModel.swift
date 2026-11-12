import KsApi
import ReactiveSwift

/// Input data summarizing active search query and filter state for the empty state cell.
public struct SearchEmptyStateSearchData {
  /// Optional search text query entered by the user.
  public let query: String?
  /// Whether one or more search filters are currently applied.
  public let hasFilters: Bool

  /// Creates empty state search context with `query` and `hasFilters`.
  public init(query: String?, hasFilters: Bool) {
    self.query = query
    self.hasFilters = hasFilters
  }
}

/// Inputs accepted by `SearchEmptyStateCellViewModel`.
public protocol SearchEmptyStateCellViewModelInputs {
  /// Configures the empty state cell with current search query and filter flags.
  func configureWith(data: SearchEmptyStateSearchData)
}

/// Outputs emitted by `SearchEmptyStateCellViewModel`.
public protocol SearchEmptyStateCellViewModelOutputs {
  /// Emits the headline copy summarizing zero search results.
  var titleText: Signal<String, Never> { get }
  /// Emits guidance suggesting query changes or filter adjustments.
  var subtitleText: Signal<String, Never> { get }
  /// Emits whether the "Clear filters" action button should be hidden.
  var hideClearFiltersButton: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `SearchEmptyStateCellViewModel`.
public protocol SearchEmptyStateCellViewModelType {
  /// Input receiver for search empty state configuration.
  var inputs: SearchEmptyStateCellViewModelInputs { get }
  /// Output signals formatting empty state copy and button visibility.
  var outputs: SearchEmptyStateCellViewModelOutputs { get }
}

/// View model formatting empty search result messaging and filter reset controls.
public final class SearchEmptyStateCellViewModel: SearchEmptyStateCellViewModelType,
  SearchEmptyStateCellViewModelInputs, SearchEmptyStateCellViewModelOutputs {
  /// Initializes the search empty state cell view model.
  public init() {
    self.titleText = self.searchDataProperty.signal
      .skipNil()
      .map { searchData in
        if let query = searchData.query, query.count > 0 {
          return Strings.No_results_for(query: query)
        }
        return Strings.No_results()
      }

    self.subtitleText = self.searchDataProperty.signal
      .skipNil()
      .map { searchData in
        if searchData.hasFilters && searchData.query?.isEmpty == false {
          return Strings.Try_rephrasing_your_search_or_adjusting_the_filters()
        } else if searchData.hasFilters {
          return Strings.Try_adjusting_the_filters()
        }
        return Strings.Try_rephrasing_your_search()
      }

    self.hideClearFiltersButton = self.searchDataProperty.signal
      .skipNil()
      .map { !$0.hasFilters }
  }

  fileprivate let searchDataProperty = MutableProperty<SearchEmptyStateSearchData?>(nil)
  /// Configures the cell with `SearchEmptyStateSearchData`.
  public func configureWith(data: SearchEmptyStateSearchData) {
    self.searchDataProperty.value = data
  }

  /// Emits the localized empty state headline text.
  public let titleText: Signal<String, Never>
  /// Emits the localized empty state suggestion subtitle.
  public let subtitleText: Signal<String, Never>
  /// Emits whether the clear-filters button is hidden.
  public let hideClearFiltersButton: Signal<Bool, Never>

  /// Returns `self` as `SearchEmptyStateCellViewModelInputs`.
  public var inputs: SearchEmptyStateCellViewModelInputs { return self }
  /// Returns `self` as `SearchEmptyStateCellViewModelOutputs`.
  public var outputs: SearchEmptyStateCellViewModelOutputs { return self }
}
