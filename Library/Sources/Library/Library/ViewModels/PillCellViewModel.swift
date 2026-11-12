import Foundation
import Prelude
import ReactiveSwift
import UIKit

/// Typed display configuration payload for a pill collection-view cell.
public struct PillCellData: Equatable, Sendable {
  /// Pill title text.
  public let text: String
  /// Foreground text color.
  public let textColor: UIColor
  /// Pill background fill color.
  public let backgroundColor: UIColor

  /// Creates a typed `PillCellData` contract.
  public init(text: String, textColor: UIColor, backgroundColor: UIColor) {
    self.text = text
    self.textColor = textColor
    self.backgroundColor = backgroundColor
  }
}

/// Input actions for `PillCellViewModel`.
public protocol PillCellViewModelInputs {
  /// Configures the pill cell with display title text.
  func configure(with value: String)
}

/// Output signals for `PillCellViewModel`.
public protocol PillCellViewModelOutputs {
  /// Emits the localized label text to display inside the pill.
  var text: Signal<String, Never> { get }
}

/// Combined inputs/outputs contract for `PillCellViewModel`.
public protocol PillCellViewModelType {
  /// Input receiver.
  var inputs: PillCellViewModelInputs { get }
  /// Signal outputs.
  var outputs: PillCellViewModelOutputs { get }
}

/// View model backing compact pill tag cells.
public final class PillCellViewModel: PillCellViewModelType, PillCellViewModelInputs,
  PillCellViewModelOutputs {
  /// Initializes the pill view model stream.
  public init() {
    self.text = self.configureWithValueProperty.signal.skipNil()
  }

  private let configureWithValueProperty = MutableProperty<String?>(nil)
  /// Sends a new display title string to the cell.
  public func configure(with value: String) {
    self.configureWithValueProperty.value = value
  }

  /// Signal emitting non-nil pill label strings.
  public let text: Signal<String, Never>

  /// Concrete input interface.
  public var inputs: PillCellViewModelInputs { return self }
  /// Concrete output interface.
  public var outputs: PillCellViewModelOutputs { return self }
}
