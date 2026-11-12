import KsApi
import Prelude
import ReactiveSwift

protocol SettingsAccountPickerCellViewModelInputs {
  func configure(with cellValue: SettingsCellValue)
  func didSelectCurrency(currency: Currency)
}

protocol SettingsAccountPickerCellViewModelOutputs {
  var notifyCurrencyPickerCellRemoved: Signal<Bool, Never> { get }
  var updateCurrencyDetailText: Signal<String, Never> { get }
}

protocol SettingsAccountPickerCellViewModelType {
  var inputs: SettingsAccountPickerCellViewModelInputs { get }
  var outputs: SettingsAccountPickerCellViewModelOutputs { get }
}

final class SettingsAccountPickerCellViewModel: SettingsAccountPickerCellViewModelOutputs,
  SettingsAccountPickerCellViewModelInputs, SettingsAccountPickerCellViewModelType {
  /// Initializes bindings for currency picker selection in account settings.
  public init() {
    self.notifyCurrencyPickerCellRemoved = self.selectedCurrencyProperty.signal.mapConst(true)

    self.updateCurrencyDetailText = self.selectedCurrencyProperty.signal.skipNil()
      .map { $0.descriptionText }
  }

  fileprivate let selectedCurrencyProperty = MutableProperty<Currency?>(nil)
  /// Records the user's selected `Currency` and notifies the picker row to dismiss.
  public func didSelectCurrency(currency: Currency) {
    self.selectedCurrencyProperty.value = currency
  }

  fileprivate let cellTypeProperty = MutableProperty<SettingsAccountCellType?>(nil)
  func configure(with cellValue: SettingsCellValue) {
    self.cellTypeProperty.value = cellValue.cellType as? SettingsAccountCellType
  }

  /// Emits `true` when the currency picker cell should collapse after a selection.
  public let notifyCurrencyPickerCellRemoved: Signal<Bool, Never>
  /// Emits formatted display copy for the newly selected `Currency`.
  public let updateCurrencyDetailText: Signal<String, Never>

  var inputs: SettingsAccountPickerCellViewModelInputs { return self }
  var outputs: SettingsAccountPickerCellViewModelOutputs { return self }
}
