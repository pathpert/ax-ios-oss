import Foundation
import ReactiveSwift

/// Input actions for `CategoryCollectionViewSectionHeaderViewModel`.
public protocol CategoryCollectionViewSectionHeaderViewModelInputs {
  /// Configures the section header with a category title string.
  func configure(with value: String)
}

/// Output signals for `CategoryCollectionViewSectionHeaderViewModel`.
public protocol CategoryCollectionViewSectionHeaderViewModelOutputs {
  /// Emits localized header label text for the category section.
  var text: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for `CategoryCollectionViewSectionHeaderViewModel`.
public protocol CategoryCollectionViewSectionHeaderViewModelType {
  /// Input receiver.
  var inputs: CategoryCollectionViewSectionHeaderViewModelInputs { get }
  /// Output signals.
  var outputs: CategoryCollectionViewSectionHeaderViewModelOutputs { get }
}

/// View model formatting section header titles in the category collection screen.
public final class CategoryCollectionViewSectionHeaderViewModel:
  CategoryCollectionViewSectionHeaderViewModelType, CategoryCollectionViewSectionHeaderViewModelInputs,
  CategoryCollectionViewSectionHeaderViewModelOutputs {
  /// Initializes section title forwarding stream.
  public init() {
    self.text = self.configureWithValueProperty.signal.skipNil()
  }

  private let configureWithValueProperty = MutableProperty<String?>(nil)
  /// Supplies the section header title string.
  public func configure(with value: String) {
    self.configureWithValueProperty.value = value
  }

  /// Emits non-nil section title strings.
  public let text: Signal<String, Never>

  /// Concrete input interface.
  public var inputs: CategoryCollectionViewSectionHeaderViewModelInputs { return self }
  /// Concrete output interface.
  public var outputs: CategoryCollectionViewSectionHeaderViewModelOutputs { return self }
}
