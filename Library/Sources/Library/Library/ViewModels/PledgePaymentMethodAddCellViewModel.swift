import Foundation
import ReactiveSwift

/// Input actions for `PledgePaymentMethodAddCellViewModel`.
public protocol PledgePaymentMethodAddCellViewModelInputs {
  /// Used to configure the cell with a loading state.
  func configureWith(value: Bool)
}

/// Output signals for `PledgePaymentMethodAddCellViewModel`.
public protocol PledgePaymentMethodAddCellViewModelOutputs {
  /// Emits whether the add-payment-method cell should show an active loading spinner.
  var showLoading: Signal<Bool, Never> { get }
}

/// Combined inputs/outputs contract for `PledgePaymentMethodAddCellViewModel`.
public protocol PledgePaymentMethodAddCellViewModelType {
  /// Input receiver.
  var inputs: PledgePaymentMethodAddCellViewModelInputs { get }
  /// Output signals.
  var outputs: PledgePaymentMethodAddCellViewModelOutputs { get }
}

/// View model managing loading indicator state on the Add Payment Method cell.
public final class PledgePaymentMethodAddCellViewModel: PledgePaymentMethodAddCellViewModelType,
  PledgePaymentMethodAddCellViewModelInputs, PledgePaymentMethodAddCellViewModelOutputs {
  /// Initializes loading-state signal forwarding.
  public init() {
    self.showLoading = self.configData.signal
  }

  /// Emits `true` when Stripe card sheet preparation is in progress.
  public let showLoading: Signal<Bool, Never>

  fileprivate let configData = MutableProperty<Bool>(false)
  /// Updates whether the loading spinner should be displayed.
  public func configureWith(value: Bool) {
    self.configData.value = value
  }

  /// Concrete input interface.
  public var inputs: PledgePaymentMethodAddCellViewModelInputs { return self }
  /// Concrete output interface.
  public var outputs: PledgePaymentMethodAddCellViewModelOutputs { return self }
}
