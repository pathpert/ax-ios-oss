import KDS
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift
import UIKit

/// View model coordinating stepper/text-field pledge amount input, decimal rounding, and max-pledge validation.
public final class PledgeAmountViewModel: PledgeAmountViewModelType,
  PledgeAmountViewModelInputs, PledgeAmountViewModelOutputs {
  /// Creates a new `PledgeAmountViewModel`.
  public init() {
    let configData = self.projectAndRewardProperty.signal
      .skipNil()

    let project = configData
      .map(first)

    let reward = configData
      .map(second)

    let currentAmount = configData
      .map(third)

    let minAndMax = Signal.combineLatest(
      project,
      reward
    )
    .map { project, reward -> (Double, Double) in
      let (min, max) = minAndMaxPledgeAmount(forProject: project, reward: reward)

      // Minimum amount for regular rewards is zero as this is the "bonus support" amount.
      return (reward.isNoReward ? min : 0, max)
    }

    let minValue = minAndMax
      .map(first)

    let unavailableAmount = Signal.merge(
      self.projectAndRewardProperty.signal.mapConst(0)
        .take(until: self.unavailableAmountChangedProperty.signal.ignoreValues()),
      self.unavailableAmountChangedProperty.signal
    )

    let maxValue = minAndMax
      .map(second)
      .combineLatest(with: unavailableAmount)
      .map(-)

    let textFieldInputValue = self.textFieldDidEndEditingProperty.signal
      .skipNil()
      .map(Double.init)
      .skipNil()
      .map { rounded($0, places: 2) }

    let initialValue = Signal.combineLatest(
      project,
      currentAmount,
      minValue
    )
    .map(initialPledgeAmount)

    let stepperValue = Signal.merge(
      initialValue,
      textFieldInputValue,
      self.stepperValueProperty.signal
    )

    self.textFieldValue = stepperValue
      .map { value in
        // Adds trailing zeros if the rounded number has non-zero remainder
        // Removes trailing zeros and the decimal point otherwise
        // Example:
        //  25 => 25
        //  25. => 25
        //  25.0  => 25
        //  25.00 => 25
        //  25.1 => 25.10
        //  25.10 = 25.10
        let numberOfDecimalPlaces = value.truncatingRemainder(dividingBy: 1) == 0 ? 0 : 2
        return String(format: "%.\(numberOfDecimalPlaces)f", value)
      }

    self.currency = project
      .map {
        currencySymbol(forCurrencyCode: $0.stats.projectCurrency).trimmed()
      }

    let textFieldValue = self.textFieldValueProperty.signal
      .map { $0.coalesceWith("") }
      .map(Double.init)
      .map { $0.coalesceWith(0) }

    let updatedValue = Signal.combineLatest(
      minValue,
      maxValue,
      Signal.merge(
        stepperValue,
        textFieldValue.signal
      )
    )

    self.stepperMinValue = updatedValue
      .map { ($0.0, $0.2) }
      .map(min)

    self.stepperMaxValue = minValue.mapConst(PledgeAmountStepperConstants.max)

    let stepperValueChanged = Signal.combineLatest(
      self.stepperMinValue.signal,
      self.stepperMaxValue.signal,
      self.stepperValueProperty.signal
    )

    self.generateSelectionFeedback = stepperValueChanged
      .filter { min, max, value in min < value && value < max }
      .ignoreValues()

    self.generateNotificationWarningFeedback = stepperValueChanged
      .filter { min, max, value in
        value <= min || max <= value
      }
      .ignoreValues()

    self.notifyDelegateAmountUpdated = updatedValue
      .map { min, max, value in
        PledgeAmountData(
          amount: rounded(value, places: 2),
          min: min,
          max: max,
          isValid: min <= value && value <= max
        )
      }

    self.maxPledgeAmountErrorLabelIsHidden = updatedValue
      .map { _, max, value in value <= max }

    let isValueValid = self.notifyDelegateAmountUpdated
      .map(\.isValid)
      .skipRepeats()

    self.maxPledgeAmountErrorLabelText = updatedValue
      .map(second)
      .combineLatest(with: project)
      .map { max, project in
        let maxPledge = Format.currency(max, currencyCode: project.statsCurrency, omitCurrencyCode: false)

        return Strings.Enter_an_amount_less_than_max_pledge(max_pledge: maxPledge)
      }
      .skipRepeats()

    self.doneButtonIsEnabled = isValueValid

    let textColor = isValueValid
      .map { $0 ? LegacyColors.ksr_create_700.uiColor() : LegacyColors.ksr_alert.uiColor() }

    self.labelTextColor = textColor

    self.stepperValue = self.notifyDelegateAmountUpdated.map(\.amount).skipRepeats()

    self.textFieldIsFirstResponder = self.doneButtonTappedProperty.signal
      .mapConst(false)

    self.textFieldTextColor = textColor
      .wrapInOptional()

    self.plusSignLabelHidden = reward.map(\.isNoReward)
    self.subTitleLabelHidden = reward.map(\.isNoReward)
    self.titleLabelText = reward.map(\.isNoReward).map {
      $0 ? Strings.Your_pledge_amount() : Strings.Bonus_support()
    }
  }

  private let projectAndRewardProperty = MutableProperty<PledgeAmountViewConfigData?>(nil)
  /// Configures the stepper and text field with `data`.
  public func configureWith(data: PledgeAmountViewConfigData) {
    self.projectAndRewardProperty.value = data
  }

  private let doneButtonTappedProperty = MutableProperty(())
  /// Dismisses focus when Done is tapped.
  public func doneButtonTapped() {
    self.doneButtonTappedProperty.value = ()
  }

  private let stepperValueProperty = MutableProperty<Double>(0)
  /// Updates amount from stepper interaction.
  public func stepperValueChanged(_ value: Double) {
    self.stepperValueProperty.value = value
  }

  private let textFieldDidEndEditingProperty = MutableProperty<String?>(nil)
  /// Normalizes and rounds text field input after editing completes.
  public func textFieldDidEndEditing(_ value: String?) {
    self.textFieldDidEndEditingProperty.value = value
  }

  private let textFieldValueProperty = MutableProperty<String?>(nil)
  /// Evaluates validation as the user types in the text field.
  public func textFieldValueChanged(_ value: String?) {
    self.textFieldValueProperty.value = value
  }

  private let unavailableAmountChangedProperty = MutableProperty<Double>(0)
  /// Adjusts remaining maximum allowed pledge amount when other items reserve budget.
  public func unavailableAmountChanged(to amount: Double) {
    self.unavailableAmountChangedProperty.value = amount
  }

  /// Emits trimmed currency symbol displayed beside the amount field.
  public let currency: Signal<String, Never>
  /// Emits whether the keyboard accessory Done button is enabled.
  public let doneButtonIsEnabled: Signal<Bool, Never>
  /// Emits when haptic selection feedback should trigger inside bounds.
  public let generateSelectionFeedback: Signal<Void, Never>
  /// Emits when warning haptic feedback should trigger at min/max bounds.
  public let generateNotificationWarningFeedback: Signal<Void, Never>
  /// Emits foreground color reflecting valid vs out-of-range amount state.
  public let labelTextColor: Signal<UIColor, Never>
  /// Emits whether the max-pledge exceeded error label is hidden.
  public let maxPledgeAmountErrorLabelIsHidden: Signal<Bool, Never>
  /// Emits localized maximum pledge limit error copy.
  public let maxPledgeAmountErrorLabelText: Signal<String, Never>
  /// Emits validated `PledgeAmountData` updates to the parent checkout coordinator.
  public let notifyDelegateAmountUpdated: Signal<PledgeAmountData, Never>
  /// Emits whether the leading `+` prefix label for bonus support is hidden.
  public let plusSignLabelHidden: Signal<Bool, Never>
  /// Emits maximum stepper value.
  public let stepperMaxValue: Signal<Double, Never>
  /// Emits minimum stepper value.
  public let stepperMinValue: Signal<Double, Never>
  /// Emits synchronized stepper numeric value.
  public let stepperValue: Signal<Double, Never>
  /// Emits whether the "Additional bonus support" subtitle label is hidden.
  public let subTitleLabelHidden: Signal<Bool, Never>
  /// Emits optional validation foreground color for the text field.
  public let textFieldTextColor: Signal<UIColor?, Never>
  /// Emits whether the amount text field should remain first responder.
  public let textFieldIsFirstResponder: Signal<Bool, Never>
  /// Emits formatted numeric string (`0` or `2` decimal places) shown in the text field.
  public let textFieldValue: Signal<String, Never>
  /// Emits localized section header (`"Your pledge amount"` vs `"Bonus support"`).
  public let titleLabelText: Signal<String, Never>

  /// Inputs receiver (`self`).
  public var inputs: PledgeAmountViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: PledgeAmountViewModelOutputs { return self }
}

// MARK: - Functions

private func initialPledgeAmount(
  from _: Project,
  currentAmount: Double,
  minValue: Double
) -> Double {
  return max(currentAmount, minValue)
}

/*
 A helper that assists in rounding a Double to a given number of decimal places
 NB: Do not use this for rounding elsewhere.
 */
private func rounded(_ value: Double, places: Int) -> Double {
  let divisor = pow(10.0, Double(places))
  return (value * divisor).rounded() / divisor
}
