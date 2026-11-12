import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// View model managing the discovery navigation bar filter title, dropdown arrow, and favorite category state.
public final class DiscoveryNavigationHeaderViewModel: DiscoveryNavigationHeaderViewModelType,
  DiscoveryNavigationHeaderViewModelInputs, DiscoveryNavigationHeaderViewModelOutputs {
  /// Initializes the discovery navigation header view model.
  public init() {
    let currentParams = Signal.merge(
      self.paramsProperty.signal.skipNil().skipRepeats(),
      self.filtersSelectedRowProperty.signal.skipNil().map { $0.params }
    )

    let paramsAndFiltersAreHidden = Signal.merge(
      currentParams.map { ($0, false) },
      currentParams.takeWhen(self.titleButtonTappedProperty.signal).map { ($0, true) }
    )
    .scan(nil) { data, paramsAndFiltersHidden -> (params: DiscoveryParams, filtersAreHidden: Bool)? in
      let (params, filtersAreHidden) = paramsAndFiltersHidden
      return (
        params: params,
        filtersAreHidden: filtersAreHidden ? !(data?.filtersAreHidden ?? true) : true
      )
    }
    .skipNil()

    let strings = paramsAndFiltersAreHidden.map(first).map(stringsForHeaderTitle)
    let filtersAreHidden = paramsAndFiltersAreHidden.map(second)

    self.animateArrowToDown = filtersAreHidden
    self.dividerIsHidden = strings.map { $0.subcategory == nil }.skipRepeats()
    self.exploreLabelIsHidden = self.filtersSelectedRowProperty.signal.map {
      shouldHideHeaderExploreLabel($0?.params)
    }

    self.debugContainerViewIsHidden = self.viewDidLoadProperty.signal
      .map { DiscoveryNavigationHeaderViewModel.canShowBetaTools(environment: AppEnvironment.current) }
      .negate()

    self.favoriteViewIsHidden = paramsAndFiltersAreHidden.map(first)
      .map { $0.category == nil }
      .mergeWith(self.viewDidLoadProperty.signal.mapConst(true))
      .skipRepeats()

    self.favoriteViewIsDimmed = paramsAndFiltersAreHidden
      .filter { params, _ in params.category != nil }
      .map { _, filtersAreHidden in !filtersAreHidden }
      .skipRepeats()

    self.debugImageViewIsDimmed = self.debugContainerViewIsHidden
      .takePairWhen(filtersAreHidden)
      .filter { debugContainerIsHidden, _ in isFalse(debugContainerIsHidden) }
      .map(second)
      .negate()

    let dismissFiltersSignal = Signal.merge(
      self.filtersSelectedRowProperty.signal.ignoreValues(),
      paramsAndFiltersAreHidden.filter { $0.filtersAreHidden }.skip(first: 1).ignoreValues()
    )

    self.dismissDiscoveryFilters = dismissFiltersSignal
      .ksr_debounce(.milliseconds(400), on: AppEnvironment.current.scheduler)

    self.notifyDelegateFilterSelectedParams = currentParams.skip(first: 1)

    self.primaryLabelFont = paramsAndFiltersAreHidden
      .map { params, filtersAreHidden in (params.category?.isRoot ?? true) && filtersAreHidden }

    self.primaryLabelOpacityAnimated = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst((0.0, false)),
      paramsAndFiltersAreHidden
        .map(first)
        .map { ($0.category?.isRoot == .some(false) ? 0.6 : 1.0, true) }
    )

    self.primaryLabelText = strings.map { $0.filter }
    self.secondaryLabelIsHidden = strings.map { $0.subcategory == nil }.skipRepeats()
    self.secondaryLabelText = strings.map { $0.subcategory ?? "" }

    self.arrowOpacityAnimated = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst((0.0, false)),
      self.secondaryLabelText.signal.mapConst((1.0, true)).take(first: 1)
    )

    let rowForFilters = Signal.merge(
      self.paramsProperty.signal.skipNil().map { SelectableRow(isSelected: true, params: $0) },
      self.filtersSelectedRowProperty.signal.skipNil()
    )

    self.showDiscoveryFilters = rowForFilters
      .takeWhen(paramsAndFiltersAreHidden.filter { !$0.filtersAreHidden })

    self.titleButtonAccessibilityHint = self.animateArrowToDown
      .map { $0 ? Strings.Opens_filters() : Strings.Closes_filters() }

    self.titleButtonAccessibilityLabel = paramsAndFiltersAreHidden
      .map(first)
      .map(accessibilityLabelForHeaderTitleButton)

    let categoryIdOnParamsUpdated = currentParams.map { $0.category?.intID }.skipNil()

    let categoryIdOnFavoriteTap = categoryIdOnParamsUpdated
      .takeWhen(self.favoriteButtonTappedProperty.signal)
      .on(value: { toggleStoredFavoriteCategory(withId: $0) })

    self.updateFavoriteButton = Signal.merge(
      categoryIdOnParamsUpdated.map { ($0, false) },
      categoryIdOnFavoriteTap.map { ($0, true) }
    )
    .map { id, animated in (selected: isFavoriteCategoryStored(withId: id), animated: animated) }

    self.favoriteButtonAccessibilityLabel = self.updateFavoriteButton
      .map {
        $0.selected
          ? Strings.discovery_favorite_categories_buttons_unfavorite_a11y_label()
          : Strings.discovery_favorite_categories_buttons_favorite_a11y_label()
      }

    self.showFavoriteOnboardingAlert = strings
      .map { Strings.category_name_saved(category_name: $0.subcategory ?? $0.filter) }
      .takeWhen(self.favoriteButtonTappedProperty.signal)
      .filter { _ in
        !AppEnvironment.current.ubiquitousStore.hasSeenFavoriteCategoryAlert ||
          !AppEnvironment.current.userDefaults.hasSeenFavoriteCategoryAlert
      }
      .on(value: { _ in
        AppEnvironment.current.ubiquitousStore.hasSeenFavoriteCategoryAlert = true
        AppEnvironment.current.userDefaults.hasSeenFavoriteCategoryAlert = true
      })
  }

  fileprivate let paramsProperty = MutableProperty<DiscoveryParams?>(nil)
  /// Configures the header with the active `DiscoveryParams`.
  public func configureWith(params: DiscoveryParams) { self.paramsProperty.value = params }

  fileprivate let favoriteButtonTappedProperty = MutableProperty(())
  /// Toggles favorite state for the active category.
  public func favoriteButtonTapped() { self.favoriteButtonTappedProperty.value = () }

  fileprivate let filtersSelectedRowProperty = MutableProperty<SelectableRow?>(nil)
  /// Applies a selected filter row from the discovery filters sheet.
  public func filtersSelected(row: SelectableRow) { self.filtersSelectedRowProperty.value = row }

  fileprivate let titleButtonTappedProperty = MutableProperty(())
  /// Toggles presentation of the discovery filters menu.
  public func titleButtonTapped() { self.titleButtonTappedProperty.value = () }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals `viewDidLoad()` lifecycle readiness.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  private static func canShowBetaTools(environment: Environment) -> Bool {
    return environment.mainBundle.isAlpha || environment.mainBundle.isBeta || environment.mainBundle.isDebug
  }

  /// Emits whether the header arrow should animate downward.
  public let animateArrowToDown: Signal<Bool, Never>
  /// Emits arrow opacity and whether to animate the change.
  public let arrowOpacityAnimated: Signal<(CGFloat, Bool), Never>
  /// Emits whether the debug tools button container is hidden.
  public let debugContainerViewIsHidden: Signal<Bool, Never>
  /// Emits whether the debug tools icon is dimmed.
  public let debugImageViewIsDimmed: Signal<Bool, Never>
  /// Emits when the discovery filters drawer should dismiss.
  public let dismissDiscoveryFilters: Signal<(), Never>
  /// Emits whether the category/subcategory divider is hidden.
  public let dividerIsHidden: Signal<Bool, Never>
  /// Emits whether the Explore prefix label is hidden.
  public let exploreLabelIsHidden: Signal<Bool, Never>
  /// Emits the accessibility label for the favorite category button.
  public let favoriteButtonAccessibilityLabel: Signal<String, Never>
  /// Emits whether the favorite button should appear dimmed.
  public let favoriteViewIsDimmed: Signal<Bool, Never>
  /// Emits whether the favorite button container is hidden.
  public let favoriteViewIsHidden: Signal<Bool, Never>
  /// Emits selected discovery params back to the parent delegate.
  public let notifyDelegateFilterSelectedParams: Signal<DiscoveryParams, Never>
  /// Emits whether the primary title label uses bold font styling.
  public let primaryLabelFont: Signal<Bool, Never>
  /// Emits primary label opacity and animation flag.
  public let primaryLabelOpacityAnimated: Signal<(CGFloat, Bool), Never>
  /// Emits text for the primary filter label.
  public let primaryLabelText: Signal<String, Never>
  /// Emits whether the secondary subcategory label is hidden.
  public let secondaryLabelIsHidden: Signal<Bool, Never>
  /// Emits text for the secondary subcategory label.
  public let secondaryLabelText: Signal<String, Never>
  /// Emits the row used to present the discovery filters sheet.
  public let showDiscoveryFilters: Signal<SelectableRow, Never>
  /// Emits category name for the first-time favorite onboarding alert.
  public let showFavoriteOnboardingAlert: Signal<String, Never>
  /// Emits the accessibility hint for the header title button.
  public let titleButtonAccessibilityHint: Signal<String, Never>
  /// Emits the accessibility label for the header title button.
  public let titleButtonAccessibilityLabel: Signal<String, Never>
  /// Emits favorite button selected and animation state.
  public let updateFavoriteButton: Signal<(selected: Bool, animated: Bool), Never>

  /// Input interface for this view model.
  public var inputs: DiscoveryNavigationHeaderViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: DiscoveryNavigationHeaderViewModelOutputs { return self }
}
