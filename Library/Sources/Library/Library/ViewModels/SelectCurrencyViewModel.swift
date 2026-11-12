import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Display model pairing a `Currency` option with its current selection state.
public struct SelectedCurrencyData: Equatable {
  /// The currency represented by the row.
  public let currency: Currency
  /// Whether this currency is currently selected.
  public let selected: Bool
}

/// Inputs accepted by `SelectCurrencyViewModel`.
public protocol SelectCurrencyViewModelInputs {
  /// Configures the view model with the user's currently saved currency.
  func configure(with selectedCurrency: Currency)
  /// Called when the user taps a currency row at the specified index.
  func didSelectCurrency(atIndex index: Int)
  /// Called when the user taps Save to persist the chosen currency.
  func saveButtonTapped()
  /// Signals that the view has loaded.
  func viewDidLoad()
}

/// Outputs exposed by `SelectCurrencyViewModel`.
public protocol SelectCurrencyViewModelOutputs {
  /// Emits whether the loading indicator should be visible.
  var activityIndicatorShouldShow: Signal<Bool, Never> { get }
  /// Emits the previously selected row index to deselect.
  var deselectCellAtIndex: Signal<Int, Never> { get }
  /// Emits when the currency change request completes successfully.
  var didUpdateCurrency: Signal<(), Never> { get }
  /// Emits the ordered currency row data and whether this is the initial load.
  var reloadDataWithCurrencies: Signal<([SelectedCurrencyData], Bool), Never> { get }
  /// Emits whether the Save button should be enabled.
  var saveButtonIsEnabled: Signal<Bool, Never> { get }
  /// Emits the newly selected row index to highlight.
  var selectCellAtIndex: Signal<Int, Never> { get }
  /// Emits an error message if updating the currency fails.
  var updateCurrencyDidFailWithError: Signal<String, Never> { get }
  /// Emits when the currency update mutation succeeds.
  var updateCurrencyDidSucceed: Signal<Void, Never> { get }
}

/// Combined inputs and outputs interface for `SelectCurrencyViewModel`.
public protocol SelectCurrencyViewModelType {
  /// The view model's inputs.
  var inputs: SelectCurrencyViewModelInputs { get }
  /// The view model's outputs.
  var outputs: SelectCurrencyViewModelOutputs { get }
}

/// View model managing currency selection and persistence in Settings.
public final class SelectCurrencyViewModel: SelectCurrencyViewModelType, SelectCurrencyViewModelInputs,
  SelectCurrencyViewModelOutputs {
  /// Creates a new `SelectCurrencyViewModel` and binds selection and save signals.
  public init() {
    let initialChosenCurrency = Signal.combineLatest(
      self.selectedCurrencySignal,
      self.viewDidLoadSignal
    )
    .map(first)

    let orderedCurrencies = initialChosenCurrency
      .map { currencies(orderedBySelected: $0) }

    let didSelectCurrency = orderedCurrencies
      .takePairWhen(self.didSelectCurrencyAtIndexSignal)
      .map { $0[$1] }

    let orderedAndInitial = Signal.combineLatest(orderedCurrencies, initialChosenCurrency)
      .map { ($0, $1) }
      .map(selectedCurrencyData(with:selected:))
      .map { ($0, true) }

    let orderedAndSelected = Signal.combineLatest(orderedCurrencies, didSelectCurrency)
      .map { ($0, $1) }
      .map(selectedCurrencyData(with:selected:))
      .map { ($0, false) }

    self.reloadDataWithCurrencies = Signal.merge(
      orderedAndInitial,
      orderedAndSelected
    )

    let selectedCurrency = Signal.merge(initialChosenCurrency, didSelectCurrency)

    self.selectCellAtIndex = Signal.combineLatest(
      selectedCurrency,
      initialChosenCurrency
    )
    .map { currencies(orderedBySelected: $1).firstIndex(of: $0) }
    .skipNil()

    self.deselectCellAtIndex = self.selectCellAtIndex
      .combinePrevious()
      .map(first)

    let updateCurrencyEvent = didSelectCurrency
      .takeWhen(self.saveButtonTappedSignal.ignoreValues())
      .switchMap { input in
        AppEnvironment.current.apiService
          .changeCurrency(input: ChangeCurrencyInput(chosenCurrency: input.rawValue))
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map { _ in input }
          .materialize()
      }

    self.updateCurrencyDidSucceed = updateCurrencyEvent.values().ignoreValues()

    self.updateCurrencyDidFailWithError = updateCurrencyEvent.errors().map { $0.localizedDescription }

    self.activityIndicatorShouldShow = Signal.merge(
      self.saveButtonTappedSignal.mapConst(true),
      updateCurrencyEvent.filter { $0.isTerminating }.mapConst(false)
    )

    let updatedCurrency = updateCurrencyEvent.values()

    let initialAndSelected = Signal.combineLatest(
      initialChosenCurrency,
      didSelectCurrency
    )

    let updatedAndSelected = Signal.combineLatest(
      updatedCurrency,
      didSelectCurrency
    )

    let currenciesDoNotMatch = Signal.merge(
      initialAndSelected,
      updatedAndSelected
    )
    .map(!=)

    self.saveButtonIsEnabled = Signal.merge(
      self.viewDidLoadSignal.mapConst(false),
      currenciesDoNotMatch
    )

    self.didUpdateCurrency = updateCurrencyEvent.values().ignoreValues()
  }

  private let (selectedCurrencySignal, selectedCurrencyObserver) = Signal<Currency, Never>.pipe()
  /// Configures the view model with the user's current preferred currency.
  public func configure(with selectedCurrency: Currency) {
    self.selectedCurrencyObserver.send(value: selectedCurrency)
  }

  private let (didSelectCurrencyAtIndexSignal, didSelectCurrencyAtIndexObserver)
    = Signal<Int, Never>.pipe()
  /// Selects the currency at the given list index.
  public func didSelectCurrency(atIndex index: Int) {
    self.didSelectCurrencyAtIndexObserver.send(value: index)
  }

  private let (viewDidLoadSignal, viewDidLoadObserver) = Signal<(), Never>.pipe()
  /// Signals that the currency picker view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadObserver.send(value: ())
  }

  private let (saveButtonTappedSignal, saveButtonTappedObserver) = Signal<(), Never>.pipe()
  /// Submits the newly selected currency to the backend.
  public func saveButtonTapped() {
    self.saveButtonTappedObserver.send(value: ())
  }

  /// Emits whether the activity indicator should be shown.
  public let activityIndicatorShouldShow: Signal<Bool, Never>
  /// Emits the index of the row to deselect.
  public let deselectCellAtIndex: Signal<Int, Never>
  /// Emits after the currency update succeeds.
  public let didUpdateCurrency: Signal<(), Never>
  /// Emits the list of currencies with selection state and initial-load flag.
  public let reloadDataWithCurrencies: Signal<([SelectedCurrencyData], Bool), Never>
  /// Emits whether the save action should be enabled.
  public let saveButtonIsEnabled: Signal<Bool, Never>
  /// Emits the index of the newly selected currency row.
  public let selectCellAtIndex: Signal<Int, Never>
  /// Emits a localized error message if saving fails.
  public let updateCurrencyDidFailWithError: Signal<String, Never>
  /// Emits when saving the currency succeeds.
  public let updateCurrencyDidSucceed: Signal<Void, Never>

  /// The inputs interface for this view model.
  public var inputs: SelectCurrencyViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: SelectCurrencyViewModelOutputs { return self }
}

internal func currencies(orderedBySelected selected: Currency) -> [Currency] {
  return Currency.allCases.sorted(by: { cur1, _ in cur1 == selected })
}

internal func selectedCurrencyData(with currencies: [Currency], selected: Currency)
  -> [SelectedCurrencyData] {
  return currencies.map { currency in .init(currency: currency, selected: currency == selected) }
}
