import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Strongly-typed view data configuring the add-on selection continue CTA bar.
///
/// Negative Constraint: `pledgeAmount` is optional and hides the subtotal section when `nil`.
public struct RewardAddOnSelectionContinueCTAViewData: Equatable {
  /// Total count of selected add-ons across all add-on cards.
  public let selectedQuantity: Int
  /// `true` when the selection satisfies pledge and bonus amount rules.
  public let isValid: Bool
  /// `true` while add-on rewards are still being fetched.
  public let isLoading: Bool
  /// Formatted attributed pledge total string, or `nil` to hide the amount subtotal.
  public let pledgeAmount: NSAttributedString?

  /// Creates a typed `RewardAddOnSelectionContinueCTAViewData` contract.
  public init(
    selectedQuantity: Int,
    isValid: Bool,
    isLoading: Bool,
    pledgeAmount: NSAttributedString?
  ) {
    self.selectedQuantity = selectedQuantity
    self.isValid = isValid
    self.isLoading = isLoading
    self.pledgeAmount = pledgeAmount
  }
}

/// Inputs accepted by `RewardAddOnSelectionContinueCTAViewModel`.
public protocol RewardAddOnSelectionContinueCTAViewModelInputs {
  /// Configures the continue CTA bar with current add-on quantity, validity, loading, and subtotal state.
  func configure(with data: RewardAddOnSelectionContinueCTAViewData)
}

/// Outputs emitted by `RewardAddOnSelectionContinueCTAViewModel`.
public protocol RewardAddOnSelectionContinueCTAViewModelOutputs {
  /// Emits whether the Continue button is enabled.
  var buttonEnabled: Signal<Bool, Never> { get }
  /// Emits localized title text reflecting selected add-on count.
  var buttonTitle: Signal<String, Never> { get }
  /// Emits whether loading state indicators are shown.
  var isLoading: Signal<Bool, Never> { get }
  /// Emits whether the pledge subtotal view should be hidden.
  var pledgeAmountHidden: Signal<Bool, Never> { get }
  /// Emits formatted attributed pledge subtotal copy.
  var pledgeAmountText: Signal<NSAttributedString, Never> { get }
}

/// Interface combining inputs and outputs for `RewardAddOnSelectionContinueCTAViewModel`.
public protocol RewardAddOnSelectionContinueCTAViewModelType {
  /// Input receiver for continue CTA state updates.
  var inputs: RewardAddOnSelectionContinueCTAViewModelInputs { get }
  /// Output signals configuring CTA button appearance and subtotal labels.
  var outputs: RewardAddOnSelectionContinueCTAViewModelOutputs { get }
}

/// View model formatting the sticky Continue CTA bar during add-on reward selection.
public final class RewardAddOnSelectionContinueCTAViewModel: RewardAddOnSelectionContinueCTAViewModelType,
  RewardAddOnSelectionContinueCTAViewModelInputs, RewardAddOnSelectionContinueCTAViewModelOutputs {
  /// Initializes the add-on continue CTA view model.
  public init() {
    let selectedQuantity = self.configDataProperty.signal.skipNil().map(\.selectedQuantity)
    let isValid = self.configDataProperty.signal.skipNil().map(\.isValid)
    let isLoading = self.configDataProperty.signal.skipNil().map(\.isLoading)
    let pledgeAmount = self.configDataProperty.signal.skipNil().map(\.pledgeAmount)

    self.pledgeAmountText = pledgeAmount.skipNil()

    self.pledgeAmountHidden = pledgeAmount.map(isNil)

    self.buttonTitle = selectedQuantity.map { quantity in
      if quantity > 0 {
        return Strings.Continue_with_quantity_count_add_ons(quantity_count: quantity)
      }

      return Strings.Continue()
    }

    self.buttonEnabled = isValid

    self.isLoading = Signal.combineLatest(
      isLoading,
      self.buttonTitle
    )
    .map(first)
  }

  private let configDataProperty = MutableProperty<RewardAddOnSelectionContinueCTAViewData?>(nil)
  /// Updates the CTA view model with `RewardAddOnSelectionContinueCTAViewData`.
  public func configure(with data: RewardAddOnSelectionContinueCTAViewData) {
    self.configDataProperty.value = data
  }

  /// Emits whether the Continue CTA button is enabled.
  public let buttonEnabled: Signal<Bool, Never>
  /// Emits formatted Continue button copy with add-on count.
  public let buttonTitle: Signal<String, Never>
  /// Emits whether the CTA is loading.
  public let isLoading: Signal<Bool, Never>
  /// Emits whether the subtotal amount label is hidden.
  public let pledgeAmountHidden: Signal<Bool, Never>
  /// Emits the attributed subtotal amount text.
  public let pledgeAmountText: Signal<NSAttributedString, Never>

  /// Returns `self` as `RewardAddOnSelectionContinueCTAViewModelInputs`.
  public var inputs: RewardAddOnSelectionContinueCTAViewModelInputs { return self }
  /// Returns `self` as `RewardAddOnSelectionContinueCTAViewModelOutputs`.
  public var outputs: RewardAddOnSelectionContinueCTAViewModelOutputs { return self }
}
