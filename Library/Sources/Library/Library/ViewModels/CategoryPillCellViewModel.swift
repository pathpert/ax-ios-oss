import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Input payload configuring a category selection pill cell.
public struct CategoryPillCellValue: Equatable {
  /// Localized display title rendered inside the pill button.
  public let name: String
  /// Category represented by this pill.
  public let category: KsApi.Category
  /// Grid index path used to route selection callbacks back to the collection view delegate.
  public let indexPath: IndexPath?

  /// Creates a `CategoryPillCellValue`.
  public init(name: String, category: KsApi.Category, indexPath: IndexPath?) {
    self.name = name
    self.category = category
    self.indexPath = indexPath
  }
}

/// Inputs accepted by `CategoryPillCellViewModel`.
public protocol CategoryPillCellViewModelInputs {
  /// Configures the pill cell with display title, category, and index path.
  func configure(with value: CategoryPillCellValue)
  /// Signals that the category pill cell was tapped.
  func pillCellTapped()
  /// Sets whether the pill is currently highlighted as selected.
  func setIsSelected(selected: Bool)
}

/// Outputs emitted by `CategoryPillCellViewModel`.
public protocol CategoryPillCellViewModelOutputs {
  /// Emits the category pill button title text.
  var buttonTitle: Signal<String, Never> { get }
  /// Emits the deduplicated selection state of the pill.
  var isSelected: Signal<Bool, Never> { get }
  /// Emits `(indexPath, category)` to notify the delegate on tap.
  var notifyDelegatePillCellTapped: Signal<(IndexPath, KsApi.Category), Never> { get }
}

/// Interface combining inputs and outputs for `CategoryPillCellViewModel`.
public protocol CategoryPillCellViewModelType {
  /// Input receiver for pill configuration and selection updates.
  var inputs: CategoryPillCellViewModelInputs { get }
  /// Output signals formatting pill label, state, and tap events.
  var outputs: CategoryPillCellViewModelOutputs { get }
}

/// View model managing display text and selection state for a category selection pill.
public final class CategoryPillCellViewModel: CategoryPillCellViewModelType,
  CategoryPillCellViewModelInputs, CategoryPillCellViewModelOutputs {
  /// Initializes the category pill cell view model.
  public init() {
    self.notifyDelegatePillCellTapped = self.configureWithValueProperty.signal
      .skipNil()
      .takeWhen(self.pillCellTappedProperty.signal)
      .compactMap { value in
        guard let index = value.indexPath else {
          return nil
        }

        return (index, value.category)
      }

    self.isSelected = self.isSelectedProperty.signal.skipRepeats()

    self.buttonTitle = self.configureWithValueProperty.signal.skipNil()
      .map(\.name)
  }

  private let configureWithValueProperty = MutableProperty<CategoryPillCellValue?>(nil)
  /// Configures the cell with `CategoryPillCellValue`.
  public func configure(with value: CategoryPillCellValue) {
    self.configureWithValueProperty.value = value
  }

  private let pillCellTappedProperty = MutableProperty(())
  /// Signals that the user tapped the pill cell.
  public func pillCellTapped() {
    self.pillCellTappedProperty.value = ()
  }

  private let isSelectedProperty = MutableProperty<Bool>(false)
  /// Updates whether this pill is selected.
  public func setIsSelected(selected: Bool) {
    self.isSelectedProperty.value = selected
  }

  /// Emits the localized category title for the pill button.
  public let buttonTitle: Signal<String, Never>
  /// Emits selection state changes.
  public let isSelected: Signal<Bool, Never>
  /// Emits index path and category when tapped.
  public let notifyDelegatePillCellTapped: Signal<(IndexPath, KsApi.Category), Never>

  /// Returns `self` as `CategoryPillCellViewModelInputs`.
  public var inputs: CategoryPillCellViewModelInputs { return self }
  /// Returns `self` as `CategoryPillCellViewModelOutputs`.
  public var outputs: CategoryPillCellViewModelOutputs { return self }
}
