import KsApi
import ReactiveSwift
import UIKit

/// Inputs accepted by `BackingCellViewModel`.
public protocol BackingCellViewModelInputs {
  /// Configures the backing cell with a `Backing`, its `Project`, and whether it was opened from a backing view.
  func configureWith(backing: Backing, project: Project, isFromBacking: Bool)
}

/// Outputs emitted by `BackingCellViewModel`.
public protocol BackingCellViewModelOutputs {
  /// Emits a boolean whether the backing info button is hidden or not.
  var backingInfoButtonIsHidden: Signal<Bool, Never> { get }

  /// Emits formatted pledged amount copy.
  var pledged: Signal<String, Never> { get }
  /// Emits the backed reward description text.
  var reward: Signal<String, Never> { get }
  /// Emits formatted estimated reward delivery date copy.
  var delivery: Signal<String, Never> { get }
  /// Emits horizontal/vertical stack alignment adapted for VoiceOver.
  var rootStackViewAlignment: Signal<UIStackView.Alignment, Never> { get }
}

/// Interface combining inputs and outputs for `BackingCellViewModel`.
public protocol BackingCellViewModelType {
  /// Input receiver for backing summary cell configuration.
  var inputs: BackingCellViewModelInputs { get }
  /// Output signals formatting pledged amount, reward copy, delivery date, and alignment.
  var outputs: BackingCellViewModelOutputs { get }
}

/// View model formatting summary details of a user's pledge inside message threads.
public final class BackingCellViewModel: BackingCellViewModelType, BackingCellViewModelInputs,
  BackingCellViewModelOutputs {
  /// Initializes the backing cell view model.
  public init() {
    let backingAndProjectAndIsFromBacking = self.backingAndProjectAndIsFromBackingProperty.signal.skipNil()
    let backing = backingAndProjectAndIsFromBacking.map { $0.0 }

    self.backingInfoButtonIsHidden = backingAndProjectAndIsFromBacking
      .map { _, _, isFromBacking in isFromBacking }

    self.pledged = backingAndProjectAndIsFromBacking.map { backing, project, _ in
      Strings.backing_info_pledged_backing_amount(
        backing_amount: Format.currency(backing.amount, currencyCode: project.statsCurrency)
      )
    }

    self.reward = backing.map { $0.reward?.description ?? "" }

    self.delivery = backing.map { backing in
      backing.reward?.estimatedDeliveryOn.map {
        Strings.backing_info_estimated_delivery_date(
          delivery_date: Format.date(
            secondsInUTC: $0,
            template: DateFormatter.monthYear,
            timeZone: UTCTimeZone
          )
        )
      }
    }
    .map { $0 ?? "" }

    self.rootStackViewAlignment = backingAndProjectAndIsFromBacking
      .map { _, _, _ in AppEnvironment.current.isVoiceOverRunning() ? .fill : .leading }
  }

  fileprivate let backingAndProjectAndIsFromBackingProperty = MutableProperty<(Backing, Project, Bool)?>(nil)
  /// Configures the cell with the `Backing`, associated `Project`, and origin flag.
  public func configureWith(backing: Backing, project: Project, isFromBacking: Bool) {
    self.backingAndProjectAndIsFromBackingProperty.value = (backing, project, isFromBacking)
  }

  /// Emits whether the backing info button is hidden.
  public let backingInfoButtonIsHidden: Signal<Bool, Never>
  /// Emits formatted pledged amount copy.
  public let pledged: Signal<String, Never>
  /// Emits the reward summary text.
  public let reward: Signal<String, Never>
  /// Emits formatted estimated delivery date text.
  public let delivery: Signal<String, Never>
  /// Emits stack alignment adjusted for VoiceOver readability.
  public let rootStackViewAlignment: Signal<UIStackView.Alignment, Never>

  /// Returns `self` as `BackingCellViewModelInputs`.
  public var inputs: BackingCellViewModelInputs { return self }
  /// Returns `self` as `BackingCellViewModelOutputs`.
  public var outputs: BackingCellViewModelOutputs { return self }
}
