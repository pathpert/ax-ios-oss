import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input actions supported by `DiscoveryNavigationHeaderViewModel`.
public protocol DiscoveryNavigationHeaderViewModelInputs {
  /// Call to configure with Discovery params.
  func configureWith(params: DiscoveryParams)
  /// Call when favorite category button is tapped.
  func favoriteButtonTapped()
  /// Call when params have been selected from the filters menu.
  func filtersSelected(row: SelectableRow)
  /// Call when title button is tapped.
  func titleButtonTapped()
  /// Call when the view controller view loads.
  func viewDidLoad()
}

/// UI and navigation outputs emitted by `DiscoveryNavigationHeaderViewModel`.
public protocol DiscoveryNavigationHeaderViewModelOutputs {
  /// Emits to animate arrow image down or up.
  var animateArrowToDown: Signal<Bool, Never> { get }
  /// Emits opacity for arrow and whether to animate the change, used for launch transition.
  var arrowOpacityAnimated: Signal<(CGFloat, Bool), Never> { get }
  /// Emits when debug container view should be shown/hidden, depending if build is Beta/Debug or Release.
  var debugContainerViewIsHidden: Signal<Bool, Never> { get }
  /// Emits when the debug image view should dim.
  var debugImageViewIsDimmed: Signal<Bool, Never> { get }
  /// Emits whether divider label is hidden.
  var dividerIsHidden: Signal<Bool, Never> { get }
  /// Emits when the filters view controller should be dismissed.
  var dismissDiscoveryFilters: Signal<(), Never> { get }
  /// Emits when the Explore label should be shown/hidden after filter is selected.
  var exploreLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits a11y label for favorite button.
  var favoriteButtonAccessibilityLabel: Signal<String, Never> { get }
  /// Emits when favorite button should be enabled, e.g. when filters is closed.
  var favoriteViewIsDimmed: Signal<Bool, Never> { get }
  /// Emits whether the favorite container view is hidden.
  var favoriteViewIsHidden: Signal<Bool, Never> { get }
  /// Emits params for Discovery view controller when filter selected.
  var notifyDelegateFilterSelectedParams: Signal<DiscoveryParams, Never> { get }
  /// Emits to set the font for primary label and whether it should be bolded or not.
  var primaryLabelFont: Signal<Bool, Never> { get }
  /// Emits an opacity for primary label and whether to animate the change.
  var primaryLabelOpacityAnimated: Signal<(CGFloat, Bool), Never> { get }
  /// Emits text for filter label.
  var primaryLabelText: Signal<String, Never> { get }
  /// Emits to show/hide subcategory label.
  var secondaryLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits text for subcategory label.
  var secondaryLabelText: Signal<String, Never> { get }
  /// Emits when discovery filters view controller should be presented.
  var showDiscoveryFilters: Signal<SelectableRow, Never> { get }
  /// Emits to show an onboarding alert for first time tapping the favorite button with the category name.
  var showFavoriteOnboardingAlert: Signal<String, Never> { get }
  /// Emits a11y hint for title button.
  var titleButtonAccessibilityHint: Signal<String, Never> { get }
  /// Emits a11y label for title button.
  var titleButtonAccessibilityLabel: Signal<String, Never> { get }
  /// Emits to update heart to selected or not, with animation or not.
  var updateFavoriteButton: Signal<(selected: Bool, animated: Bool), Never> { get }
}

/// View model interface for the discovery navigation header bar.
public protocol DiscoveryNavigationHeaderViewModelType {
  /// Input interface for the discovery navigation header view model.
  var inputs: DiscoveryNavigationHeaderViewModelInputs { get }
  /// Output interface for the discovery navigation header view model.
  var outputs: DiscoveryNavigationHeaderViewModelOutputs { get }
}

internal func shouldHideHeaderExploreLabel(_ params: DiscoveryParams?) -> Bool {
  guard let params = params else { return true }

  return stringsForHeaderTitle(params: params).0 != Strings.All_Projects()
}

internal func stringsForHeaderTitle(params: DiscoveryParams) -> (filter: String, subcategory: String?) {
  let filterText: String
  var subcategoryText: String?

  if params.staffPicks == true {
    filterText = Strings.Projects_We_Love()
  } else if params.starred == true {
    filterText = Strings.Saved()
  } else if params.social == true {
    filterText = Strings.Following()
  } else if let category = params.category {
    filterText = category.isRoot ? headerCategoryString(forCategoryId: category.id) : category.root?.name ?? ""
    subcategoryText = category.isRoot ? nil : category.name
  } else if params.recommended == true {
    filterText = Strings.Recommended_For_You()
  } else {
    filterText = Strings.All_Projects()
  }
  return (filter: filterText, subcategory: subcategoryText)
}

internal func accessibilityLabelForHeaderTitleButton(params: DiscoveryParams) -> String {
  if params.staffPicks == true {
    return Strings.Filter_by_projects_we_love()
  } else if params.starred == true {
    return Strings.Filter_by_saved_projects()
  } else if params.social == true {
    return Strings.Filter_by_projects_backed_by_friends()
  } else if let category = params.category {
    return category.isRoot
      ? Strings.Filter_by_category_name(category_name: category.name)
      : Strings.Filter_by_subcategory_name_in_category_name(
        subcategory_name: category.name,
        category_name: category.root?.name ?? ""
      )
  } else if params.recommended == true {
    return Strings.Filter_by_projects_recommended_for_you()
  } else {
    return Strings.Filter_by_all_projects()
  }
}

private func headerCategoryString(forCategoryId id: String) -> String {
  return RootCategory(categoryId: id).allProjectsString()
}

internal func isFavoriteCategoryStored(withId id: Int) -> Bool {
  return AppEnvironment.current.ubiquitousStore.favoriteCategoryIds.firstIndex(of: id) != nil ||
    AppEnvironment.current.userDefaults.favoriteCategoryIds.firstIndex(of: id) != nil
}

internal func toggleStoredFavoriteCategory(withId id: Int) {
  if let index = AppEnvironment.current.ubiquitousStore.favoriteCategoryIds.firstIndex(of: id) {
    AppEnvironment.current.ubiquitousStore.favoriteCategoryIds.remove(at: index)
  } else {
    AppEnvironment.current.ubiquitousStore.favoriteCategoryIds.append(id)
  }

  if let index = AppEnvironment.current.userDefaults.favoriteCategoryIds.firstIndex(of: id) {
    AppEnvironment.current.userDefaults.favoriteCategoryIds.remove(at: index)
  } else {
    AppEnvironment.current.userDefaults.favoriteCategoryIds.append(id)
  }
}

