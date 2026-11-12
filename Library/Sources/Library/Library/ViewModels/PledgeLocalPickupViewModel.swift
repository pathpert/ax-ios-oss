import KsApi
import Prelude
import ReactiveSwift

/// View data configuring a local-pickup location summary row in pledge checkout.
public struct PledgeLocalPickupViewData: Equatable {
  /// Localized city/venue display string for pickup.
  public let locationName: String
}

/// Input contract for `PledgeLocalPickupViewModel`.
public protocol PledgeLocalPickupViewModelInputs {
  /// Configures the ViewModel with pickup display data.
  func configure(with data: PledgeLocalPickupViewData)
}

/// Output contract for `PledgeLocalPickupViewModel`.
public protocol PledgeLocalPickupViewModelOutputs {
  /// Emits the formatted pickup location name for the label.
  var locationLabelText: Signal<String, Never> { get }
}

/// Composite ViewModel protocol for local-pickup location summaries.
public protocol PledgeLocalPickupViewModelType {
  /// Input receiver.
  var inputs: PledgeLocalPickupViewModelInputs { get }
  /// Output signal provider.
  var outputs: PledgeLocalPickupViewModelOutputs { get }
}

/// ViewModel driving local-pickup location labels during reward checkout.
public class PledgeLocalPickupViewModel: PledgeLocalPickupViewModelType,
  PledgeLocalPickupViewModelInputs, PledgeLocalPickupViewModelOutputs {
  /// Initializes the ViewModel and maps configured `locationName` updates.
  public init() {
    let configData = self.configureWithDataProperty.signal.skipNil()

    self.locationLabelText = configData.map(\.locationName)
  }

  private let configureWithDataProperty = MutableProperty<PledgeLocalPickupViewData?>(nil)
  /// Binds a new `PledgeLocalPickupViewData` value.
  public func configure(with data: PledgeLocalPickupViewData) {
    self.configureWithDataProperty.value = data
  }

  /// Emits pickup location name strings.
  public let locationLabelText: Signal<String, Never>

  /// Self-conformance to `PledgeLocalPickupViewModelInputs`.
  public var inputs: PledgeLocalPickupViewModelInputs { return self }
  /// Self-conformance to `PledgeLocalPickupViewModelOutputs`.
  public var outputs: PledgeLocalPickupViewModelOutputs { return self }
}
