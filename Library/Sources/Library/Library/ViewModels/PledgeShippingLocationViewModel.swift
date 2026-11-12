import Foundation
import GraphAPI
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Input data for configuring `PledgeShippingLocationViewModel`.
public struct PledgeShippingLocationViewData {
  /// Project ID
  let pid: Int
  /// Initial selected location
  let selectedLocationId: Int?
  /// Whether or not the project has any rewards that require shipping.
  let hasShippableRewards: Bool

  /// Creates shipping location view data derived from the project's rewards and existing backing.
  public init(withProject project: Project) {
    self.pid = project.id
    self.selectedLocationId = project.personalization.backing?.locationId

    guard project.rewards.count > 0 else {
      assert(
        false,
        "Project has no rewards attached, so we don't know whether or not to show the shipping location."
      )

      self.hasShippableRewards = true
      return
    }

    // TODO: Clean up when a Project field for this is added (MBL-3150)
    self.hasShippableRewards = project.rewards
      .contains(where: { $0.shipping.enabled })
  }
}

/// Inputs accepted by `PledgeShippingLocationViewModel`.
public protocol PledgeShippingLocationViewModelInputs {
  /// Configures the view model with project shipping metadata.
  func configureWith(data: PledgeShippingLocationViewData)
  /// Opens the shipping location picker when the selector button is tapped.
  func shippingLocationButtonTapped()
  /// Dismisses the shipping location picker without saving changes.
  func shippingLocationCancelButtonTapped()
  /// Applies a newly selected shipping `Location` rule.
  func shippingLocationUpdated(to rule: Location)
  /// Signals that the shipping location view has loaded.
  func viewDidLoad()
}

/// Outputs exposed by `PledgeShippingLocationViewModel`.
public protocol PledgeShippingLocationViewModelOutputs {
  /// Emits whether the location selector stack view is hidden while loading.
  var adaptableStackViewIsHidden: Signal<Bool, Never> { get }
  /// Emits when the shipping locations sheet should be dismissed.
  var dismissShippingLocations: Signal<Void, Never> { get }
  /// Emits all available shipping locations and the currently selected location to present.
  var presentShippingLocations: Signal<([Location], Location), Never> { get }
  /// Emits the active shipping `Location` (or `nil` if unshippable) to the parent delegate.
  var notifyDelegateOfSelectedShippingLocation: Signal<Location?, Never> { get }
  /// Emits whether the shimmer loading placeholder is hidden.
  var shimmerLoadingViewIsHidden: Signal<Bool, Never> { get }
  /// Emits the localized name of the currently selected shipping location.
  var shippingLocationButtonTitle: Signal<String, Never> { get }
  /// Emits an error message when loading shippable locations fails.
  var shippingRulesError: Signal<String, Never> { get }
  /// Emits whether the entire shipping location selector section should be hidden.
  var shippingLocationViewHidden: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeShippingLocationViewModel`.
public protocol PledgeShippingLocationViewModelType {
  /// The view model's inputs.
  var inputs: PledgeShippingLocationViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeShippingLocationViewModelOutputs { get }
}

/// View model managing shippable destination fetching and selection during pledge checkout.
public final class PledgeShippingLocationViewModel: PledgeShippingLocationViewModelType,
  PledgeShippingLocationViewModelInputs,
  PledgeShippingLocationViewModelOutputs {
  /// Creates a new `PledgeShippingLocationViewModel` and binds location loading and selection signals.
  public init() {
    let configData = Signal.combineLatest(
      self.configDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let selectedLocationId = configData
      .map { $0.selectedLocationId }

    // Hide the selector if the project has no shippable rewards.
    self.shippingLocationViewHidden = configData.map { data in
      !data.hasShippableRewards
    }

    let isLoading = MutableProperty(false)

    // TODO: It would make this page a bit faster if we fetched shippableLocationsExpanded earlier.
    // This could be fetched as part of the Project Page fetch, or part of ProjectFragment.
    let locationsQuery = configData
      .on(value: { _ in
        isLoading.value = true
      })
      .switchMap { data in
        shippableLocations(data: data).materialize()
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .on(completed: {
            isLoading.value = false
          })
      }

    let loadedLocations = locationsQuery.values()
    let erroredLocations = locationsQuery.errors()

    self.adaptableStackViewIsHidden = isLoading.signal
    self.shimmerLoadingViewIsHidden = isLoading.signal.negate()

    let initialShippingLocation = Signal.combineLatest(
      loadedLocations,
      selectedLocationId
    )
    .map(determineShippingLocation)

    self.shippingRulesError = erroredLocations
      .mapConst(Strings.We_were_unable_to_load_the_shipping_destinations())

    let selectedShippingLocation = Signal.merge(
      initialShippingLocation,
      self.shippingLocationUpdatedSignal.wrapInOptional()
    )

    self.notifyDelegateOfSelectedShippingLocation = selectedShippingLocation

    self.presentShippingLocations = Signal.combineLatest(
      loadedLocations,
      selectedShippingLocation.skipNil()
    )
    .takeWhen(self.shippingLocationButtonTappedSignal)

    self.shippingLocationButtonTitle = selectedShippingLocation
      .skipNil()
      .map { $0.localizedName }

    self.dismissShippingLocations = Signal.merge(
      self.shippingLocationCancelButtonTappedProperty.signal,
      self.shippingLocationUpdatedSignal.signal
        .ignoreValues()
        .ksr_debounce(.milliseconds(300), on: AppEnvironment.current.scheduler)
    )
  }

  private let configDataProperty = MutableProperty<PledgeShippingLocationViewData?>(nil)
  /// Configures the view model with project shipping requirements.
  public func configureWith(data: PledgeShippingLocationViewData) {
    self.configDataProperty.value = data
  }

  private let (shippingLocationButtonTappedSignal, shippingLocationButtonTappedObserver)
    = Signal<Void, Never>.pipe()
  /// Requests presentation of the shipping location picker.
  public func shippingLocationButtonTapped() {
    self.shippingLocationButtonTappedObserver.send(value: ())
  }

  private let shippingLocationCancelButtonTappedProperty = MutableProperty(())
  /// Dismisses the shipping location picker without changing the selected country.
  public func shippingLocationCancelButtonTapped() {
    self.shippingLocationCancelButtonTappedProperty.value = ()
  }

  private let (shippingLocationUpdatedSignal, shippingLocationUpdatedObserver) = Signal<Location, Never>
    .pipe()
  /// Updates the active shipping destination to the selected `Location`.
  public func shippingLocationUpdated(to location: Location) {
    self.shippingLocationUpdatedObserver.send(value: location)
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the shipping location selector view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits whether the selector stack view is hidden during loading.
  public let adaptableStackViewIsHidden: Signal<Bool, Never>
  /// Emits when the shipping location picker should be dismissed.
  public let dismissShippingLocations: Signal<Void, Never>
  /// Emits available locations and the current selection to display in the picker.
  public let presentShippingLocations: Signal<([Location], Location), Never>
  /// Emits the selected shipping location to the delegate.
  public let notifyDelegateOfSelectedShippingLocation: Signal<Location?, Never>
  /// Emits whether the loading shimmer is hidden.
  public let shimmerLoadingViewIsHidden: Signal<Bool, Never>
  /// Emits the localized shipping location button title.
  public let shippingLocationButtonTitle: Signal<String, Never>
  /// Emits an error message if shipping locations fail to load.
  public let shippingRulesError: Signal<String, Never>
  /// Emits whether the shipping location section is hidden.
  public let shippingLocationViewHidden: Signal<Bool, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgeShippingLocationViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgeShippingLocationViewModelOutputs { return self }
}

// MARK: - Functions

private func determineShippingLocation(
  locations: [Location],
  selectedLocationId: Int?
) -> Location? {
  if let locationId = selectedLocationId,
     let selectedShippingLocation = locations.first(where: { $0.id == locationId }) {
    return selectedShippingLocation
  }

  return defaultShippingLocation(fromLocations: locations)
}

private func shippableLocations(data: PledgeShippingLocationViewData)
  -> SignalProducer<[Location], ErrorEnvelope> {
  if !data.hasShippableRewards {
    return SignalProducer(value: [])
  }

  let query = GraphAPI.ShippableLocationsForProjectQuery(id: data.pid)
  let producer = AppEnvironment.current.apiService.fetch(query: query)
    .map { data in
      let locations = Location.locations(from: data)
      return locations
    }
  return producer
}
