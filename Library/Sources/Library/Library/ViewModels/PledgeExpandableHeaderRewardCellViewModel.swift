import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Categorizes a row rendered inside the expandable pledge rewards summary header.
public enum PledgeSummaryRewardCellDataType {
  /// Collapsible summary header row.
  case header
  /// Individual reward tier line item.
  case reward
  /// Shipping fee line item.
  case shipping
  /// Bonus support amount line item.
  case bonusSupport
}

/// Display model for a single row inside `PledgeExpandableRewardsHeaderViewController`.
public struct PledgeSummaryRewardCellData: Hashable {
  /// Stable identity for diffable data sources.
  public let id = UUID()
  /// Row category used to select cell styling.
  public let type: PledgeSummaryRewardCellDataType?
  /// Optional section header attributed text.
  public let headerText: NSAttributedString?
  /// Whether `headerText` should be displayed.
  public let showHeader: Bool
  /// Primary title or description text for the row.
  public let text: String
  /// Formatted currency amount attributed string.
  public let amount: NSAttributedString
}

/// Inputs accepted by `PledgeExpandableHeaderRewardCellViewModel`.
public protocol PledgeExpandableHeaderRewardCellViewModelInputs {
  /// Configures the cell with its summary row data.
  func configure(with data: PledgeSummaryRewardCellData)
}

/// Outputs exposed by `PledgeExpandableHeaderRewardCellViewModel`.
public protocol PledgeExpandableHeaderRewardCellViewModelOutputs {
  /// Emits the formatted currency amount string for the trailing label.
  var amountAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits optional section header text when `showHeader` is `true`.
  var headerLabelText: Signal<NSAttributedString?, Never> { get }
  /// Emits the primary row title text.
  var labelText: Signal<String, Never> { get }
  /// Emits the cell row type for layout styling.
  var type: Signal<PledgeSummaryRewardCellDataType, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeExpandableHeaderRewardCellViewModel`.
public protocol PledgeExpandableHeaderRewardCellViewModelType {
  /// The view model's inputs.
  var inputs: PledgeExpandableHeaderRewardCellViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeExpandableHeaderRewardCellViewModelOutputs { get }
}

/// View model for an individual row inside the expandable pledge rewards summary section.
public final class PledgeExpandableHeaderRewardCellViewModel: PledgeExpandableHeaderRewardCellViewModelType,
  PledgeExpandableHeaderRewardCellViewModelInputs, PledgeExpandableHeaderRewardCellViewModelOutputs {
  /// Creates a new `PledgeExpandableHeaderRewardCellViewModel`.
  public init() {
    let data = self.configureWithDataProperty.signal.skipNil()
    let showHeader = data.map(\.showHeader)

    self.amountAttributedText = data.map(\.amount)
    self.headerLabelText = Signal.combineLatest(data, showHeader)
      .map { data, showHeader in
        showHeader == true ? data.headerText : nil
      }
    self.labelText = data.map(\.text)

    self.type = data.map(\.type).skipNil()
  }

  private let configureWithDataProperty = MutableProperty<PledgeSummaryRewardCellData?>(nil)
  /// Configures the cell with display data.
  public func configure(with data: PledgeSummaryRewardCellData) {
    self.configureWithDataProperty.value = data
  }

  /// Emits the trailing formatted amount text.
  public let amountAttributedText: Signal<NSAttributedString, Never>
  /// Emits optional header text above the row.
  public let headerLabelText: Signal<NSAttributedString?, Never>
  /// Emits the leading row description text.
  public let labelText: Signal<String, Never>
  /// Emits the row category type.
  public let type: Signal<PledgeSummaryRewardCellDataType, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgeExpandableHeaderRewardCellViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgeExpandableHeaderRewardCellViewModelOutputs { return self }
}
