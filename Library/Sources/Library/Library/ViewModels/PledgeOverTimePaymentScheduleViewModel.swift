import Foundation
import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Inputs accepted by `PledgeOverTimePaymentScheduleViewModel`.
public protocol PledgeOverTimePaymentScheduleViewModelInputs {
  /// Configures the schedule view model with pledge payment increments.
  func configure(with increments: [PledgePaymentIncrement])
  /// Toggles the expanded/collapsed display state of the payment schedule.
  func collapseToggle()
  /// Signals that the payment schedule view has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `PledgeOverTimePaymentScheduleViewModel`.
public protocol PledgeOverTimePaymentScheduleViewModelOutputs {
  /// Emits whether the payment schedule list is currently collapsed.
  var collapsed: Signal<Bool, Never> { get }
  /// Emits formatted payment schedule items derived from the configured increments.
  var paymentScheduleItems: Signal<[PLOTPaymentScheduleItem], Never> { get }
}

/// Interface combining inputs and outputs for `PledgeOverTimePaymentScheduleViewModel`.
public protocol PledgeOverTimePaymentScheduleViewModelType {
  /// Input receiver for schedule configuration and collapse toggles.
  var inputs: PledgeOverTimePaymentScheduleViewModelInputs { get }
  /// Output signals driving collapse state and payment schedule rows.
  var outputs: PledgeOverTimePaymentScheduleViewModelOutputs { get }
}

/// View model formatting Pledge Over Time (PLOT) payment increments and collapse state.
public struct PledgeOverTimePaymentScheduleViewModel: PledgeOverTimePaymentScheduleViewModelType,
  PledgeOverTimePaymentScheduleViewModelInputs, PledgeOverTimePaymentScheduleViewModelOutputs {
  /// Initializes the payment schedule view model.
  public init() {
    let configureWith = Signal.combineLatest(
      self.configureWithProperty.signal,
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let initialCollapsed = Signal.combineLatest(
      self.collapsedProperty.signal,
      self.viewDidLoadProperty.signal
    )
    .map(first)

    self.collapsed = initialCollapsed

    self.paymentScheduleItems = configureWith
      .map { increments in
        increments.map { increment in
          PLOTPaymentScheduleItem(with: increment)
        }
      }
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the payment schedule view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let configureWithProperty = MutableProperty<[PledgePaymentIncrement]>([])
  /// Configures the view model with pledge payment increments.
  public func configure(with increments: [PledgePaymentIncrement]) {
    self.configureWithProperty.value = increments
  }

  private let collapsedProperty = MutableProperty<Bool>(true)
  /// Toggles whether the schedule details are collapsed or expanded.
  public func collapseToggle() {
    self.collapsedProperty.value = !self.collapsedProperty.value
  }

  /// Emits the current collapsed state.
  public var collapsed: Signal<Bool, Never>
  /// Emits formatted payment schedule items.
  public var paymentScheduleItems: Signal<[PLOTPaymentScheduleItem], Never>

  /// Returns `self` as `PledgeOverTimePaymentScheduleViewModelInputs`.
  public var inputs: PledgeOverTimePaymentScheduleViewModelInputs { self }
  /// Returns `self` as `PledgeOverTimePaymentScheduleViewModelOutputs`.
  public var outputs: PledgeOverTimePaymentScheduleViewModelOutputs { self }
}

// MARK: - PLOTPaymentScheduleItem

/// Display model representing a single installment row in a Pledge Over Time schedule.
public struct PLOTPaymentScheduleItem: Equatable {
  /// Formatted scheduled collection date string.
  public var dateString: String
  /// Localized status badge label text.
  public var stateLabel: String
  /// Visual badge style corresponding to the increment state.
  public var badgeStyle: BadgeStyle
  /// Formatted installment amount in the project's native currency.
  public var amountString: String

  init(with increment: PledgePaymentIncrement) {
    self.dateString = Format.date(
      secondsInUTC: increment.scheduledCollection,
      dateStyle: .medium,
      timeStyle: .none
    )

    self.amountString = getAmountString(from: increment)
    self.stateLabel = getStateLabelText(from: increment)
    self.badgeStyle = getBadgeStyle(from: increment)
  }
}

private func getAmountString(from increment: PledgePaymentIncrement) -> String {
  // Only display the adjusted amount if a partial refund was issued.
  // If the payment increment was fully refunded, display the full payment increment amount.
  if case let .partialRefund(refundedAmount) = increment.refundStatus {
    return refundedAmount.amountFormattedInProjectNativeCurrency
  }

  return increment.amount.amountFormattedInProjectNativeCurrency
}

private func getStateLabelText(from increment: PledgePaymentIncrement) -> String {
  guard let badge = increment.badge else {
    assert(false, "Missing badge when it should have been fetched.")
    return ""
  }

  return badge.copy
}

private func getBadgeStyle(from increment: PledgePaymentIncrement) -> BadgeStyle {
  guard let badge = increment.badge else {
    assert(false, "Missing badge when it should have been fetched.")
    return .neutral
  }

  switch badge.variant {
  case .purple:
    return .custom(
      foregroundColor: Colors.PLOT.Badge.Text.purple.uiColor(),
      backgroundColor: Colors.PLOT.Badge.Background.purple.uiColor()
    )
  case .green:
    return .custom(
      foregroundColor: Colors.PLOT.Badge.Text.green.uiColor(),
      backgroundColor: Colors.PLOT.Badge.Background.green.uiColor()
    )
  case .red:
    // TODO: This variant isn't implemented on the backend; I believe it's a bug and should actually be danger.
    fallthrough
  case .danger:
    return BadgeStyle.custom(
      foregroundColor: Colors.PLOT.Badge.Text.danger.uiColor(),
      backgroundColor: Colors.PLOT.Badge.Background.danger.uiColor()
    )
  case .gray:
    return .custom(
      foregroundColor: Colors.PLOT.Badge.Text.gray.uiColor(),
      backgroundColor: Colors.PLOT.Badge.Background.gray.uiColor()
    )
  }
}
