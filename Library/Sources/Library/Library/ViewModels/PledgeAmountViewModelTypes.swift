import KsApi
import ReactiveSwift
import UIKit

/// Configuration tuple passed to `PledgeAmountViewModel` with project bounds, reward tier, and current pledge amount.
public typealias PledgeAmountViewConfigData = (
  project: Project,
  reward: Reward,
  currentAmount: Double
)

/// Upper-bound constants governing the pledge amount stepper control.
public enum PledgeAmountStepperConstants {
  static let max: Double = 1_000_000_000
}

/// Inputs accepted by `PledgeAmountViewModel`.
public protocol PledgeAmountViewModelInputs {
  /// Configures the stepper and text field with project, reward, and initial amount.
  func configureWith(data: PledgeAmountViewConfigData)
  /// Notifies the view model that the keyboard toolbar Done button was tapped.
  func doneButtonTapped()
  /// Notifies the view model when the user steps the pledge amount control.
  func stepperValueChanged(_ value: Double)
  /// Parses and rounds the typed amount once text field editing ends.
  func textFieldDidEndEditing(_ value: String?)
  /// Updates live validation as the user edits the pledge amount text field.
  func textFieldValueChanged(_ value: String?)
  /// Subtracts `amount` reserved by add-ons or shipping from maximum allowed bonus support.
  func unavailableAmountChanged(to amount: Double)
}

/// Reactive outputs emitted by `PledgeAmountViewModel`.
public protocol PledgeAmountViewModelOutputs {
  /// Emits trimmed currency symbol displayed beside the amount field.
  var currency: Signal<String, Never> { get }
  /// Emits whether the keyboard accessory Done button is enabled.
  var doneButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits when haptic selection feedback should trigger inside bounds.
  var generateSelectionFeedback: Signal<Void, Never> { get }
  /// Emits when warning haptic feedback should trigger at min/max bounds.
  var generateNotificationWarningFeedback: Signal<Void, Never> { get }
  /// Emits foreground color reflecting valid vs out-of-range amount state.
  var labelTextColor: Signal<UIColor, Never> { get }
  /// Emits whether the max-pledge exceeded error label is hidden.
  var maxPledgeAmountErrorLabelIsHidden: Signal<Bool, Never> { get }
  /// Emits localized maximum pledge limit error copy.
  var maxPledgeAmountErrorLabelText: Signal<String, Never> { get }
  /// Emits whether the leading `+` prefix label for bonus support is hidden.
  var plusSignLabelHidden: Signal<Bool, Never> { get }
  /// Emits validated `PledgeAmountData` updates to the parent checkout coordinator.
  var notifyDelegateAmountUpdated: Signal<PledgeAmountData, Never> { get }
  /// Emits maximum stepper value.
  var stepperMaxValue: Signal<Double, Never> { get }
  /// Emits minimum stepper value.
  var stepperMinValue: Signal<Double, Never> { get }
  /// Emits synchronized stepper numeric value.
  var stepperValue: Signal<Double, Never> { get }
  /// Emits whether the "Additional bonus support" subtitle label is hidden.
  var subTitleLabelHidden: Signal<Bool, Never> { get }
  /// Emits whether the amount text field should remain first responder.
  var textFieldIsFirstResponder: Signal<Bool, Never> { get }
  /// Emits optional validation foreground color for the text field.
  var textFieldTextColor: Signal<UIColor?, Never> { get }
  /// Emits formatted numeric string (`0` or `2` decimal places) shown in the text field.
  var textFieldValue: Signal<String, Never> { get }
  /// Emits localized section header (`"Your pledge amount"` vs `"Bonus support"`).
  var titleLabelText: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for pledge and bonus amount editing.
public protocol PledgeAmountViewModelType {
  /// Input receiver.
  var inputs: PledgeAmountViewModelInputs { get }
  /// Output signal provider.
  var outputs: PledgeAmountViewModelOutputs { get }
}

