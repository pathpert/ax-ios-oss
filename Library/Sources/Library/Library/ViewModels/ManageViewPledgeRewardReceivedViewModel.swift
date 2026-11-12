import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Input data for configuring `ManageViewPledgeRewardReceivedViewModel`.
public struct ManageViewPledgeRewardReceivedViewData: Equatable {
  /// The backed project.
  public let project: Project
  /// Whether the backer has marked the reward as received.
  public let backerCompleted: Bool
  /// Estimated delivery timestamp in seconds since 1970.
  public let estimatedDeliveryOn: TimeInterval
  /// Current status of the backing.
  public let backingState: Backing.Status
  /// Formatted estimated shipping cost string, if available.
  public let estimatedShipping: String?
  /// Whether the pledge disclaimer view should be hidden.
  public let pledgeDisclaimerViewHidden: Bool
}

/// Inputs for `ManageViewPledgeRewardReceivedViewModel`.
public protocol ManageViewPledgeRewardReceivedViewModelInputs {
  /// Configures the view model with pledge and reward delivery data.
  func configureWith(_ data: ManageViewPledgeRewardReceivedViewData)
  /// Called when the user toggles the reward-received switch.
  func rewardReceivedToggleTapped(isOn: Bool)
  /// Called when the view loads.
  func viewDidLoad()
}

/// Outputs for `ManageViewPledgeRewardReceivedViewModel`.
public protocol ManageViewPledgeRewardReceivedViewModelOutputs {
  /// Emits the container corner radius.
  var cornerRadius: Signal<CGFloat, Never> { get }
  /// Emits the attributed estimated delivery date label text.
  var estimatedDeliveryDateLabelAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits the attributed estimated shipping cost text.
  var estimatedShippingAttributedText: Signal<NSAttributedString, Never> { get }
  /// Emits whether the estimated shipping label should be hidden.
  var estimatedShippingHidden: Signal<Bool, Never> { get }
  /// Emits the container layout margins.
  var layoutMargins: Signal<UIEdgeInsets, Never> { get }
  /// Emits the horizontal margin width.
  var marginWidth: Signal<CGFloat, Never> { get }
  /// Emits whether the pledge disclaimer view should be hidden.
  var pledgeDisclaimerViewHidden: Signal<Bool, Never> { get }
  /// Emits whether the reward-received toggle is currently on.
  var rewardReceived: Signal<Bool, Never> { get }
  /// Emits whether the reward-received toggle row should be hidden.
  var rewardReceivedHidden: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs contract for managing the reward-received section.
public protocol ManageViewPledgeRewardReceivedViewModelType {
  /// The inputs interface.
  var inputs: ManageViewPledgeRewardReceivedViewModelInputs { get }
  /// The outputs interface.
  var outputs: ManageViewPledgeRewardReceivedViewModelOutputs { get }
}

/// View model for displaying estimated delivery, shipping, and reward-received status in pledge management.
public class ManageViewPledgeRewardReceivedViewModel:
  ManageViewPledgeRewardReceivedViewModelType,
  ManageViewPledgeRewardReceivedViewModelInputs,
  ManageViewPledgeRewardReceivedViewModelOutputs {
  /// Creates a new reward-received view model.
  public init() {
    let data = Signal.combineLatest(
      self.configureWithDataProperty.signal,
      self.viewDidLoadSignal
    )
    .map(first)
    .skipNil()

    let project = data.map(\.project)

    let backer = project
      .map { _ in AppEnvironment.current.currentUser }
      .skipNil()

    let rewardReceivedEvent = Signal.combineLatest(
      project,
      backer
    )
    .takePairWhen(self.rewardReceivedToggleTappedProperty.signal)
    .map(unpack)
    .switchMap { project, backer, received in
      AppEnvironment.current.apiService.backingUpdate(
        forProject: project, forUser: backer, received: received
      )
      .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
      .materialize()
    }

    let markedReceivedBacking = rewardReceivedEvent.values()

    let initialRewardReceived = data
      .map(\.backerCompleted)

    let updatedRewardReceived = markedReceivedBacking
      .map { $0.backerCompleted.coalesceWith(false) }

    self.rewardReceived = Signal.merge(
      initialRewardReceived,
      updatedRewardReceived
    )

    self.estimatedDeliveryDateLabelAttributedText = data.map(\.estimatedDeliveryOn)
      .map(estimatedDeliveryAttributedText)

    self.estimatedShippingAttributedText = data.map(\.estimatedShipping).skipNil()
      .map(formatEstimatedShipping)

    self.estimatedShippingHidden = data.map(\.estimatedShipping)
      .map { $0 == nil }

    self.rewardReceivedHidden = data.map(\.backingState).map { state in state != .collected }
    self.cornerRadius = self.rewardReceivedHidden.map { $0 ? 0 : Styles.grid(2) }
    self.layoutMargins = self.rewardReceivedHidden.map { $0 ? .zero : .init(all: Styles.gridHalf(5)) }
    self.marginWidth = self.rewardReceivedHidden.map { $0 ? 0 : 1 }

    self.pledgeDisclaimerViewHidden = data.map(\.pledgeDisclaimerViewHidden)

    // MARK: Analytics

    self.rewardReceivedToggleTappedProperty.signal.withLatestFrom(project)
      .observeValues { rewardReceived, project in
        AppEnvironment.current.ksrAnalytics.trackRewardReceivedToggled(
          toggleOn: rewardReceived,
          project: project,
          context: .managePledgeScreen
        )
      }
  }

  private let configureWithDataProperty = MutableProperty<ManageViewPledgeRewardReceivedViewData?>(nil)
  /// Configures the view model with the given pledge reward-received data.
  public func configureWith(_ data: ManageViewPledgeRewardReceivedViewData) {
    self.configureWithDataProperty.value = data
  }

  private let rewardReceivedToggleTappedProperty = MutableProperty<Bool>(false)
  /// Updates the reward-received status when the user toggles the switch.
  public func rewardReceivedToggleTapped(isOn: Bool) {
    self.rewardReceivedToggleTappedProperty.value = isOn
  }

  private let (viewDidLoadSignal, viewDidLoadObserver) = Signal<(), Never>.pipe()
  /// Signals that the associated view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadObserver.send(value: ())
  }

  /// Emits the container corner radius.
  public let cornerRadius: Signal<CGFloat, Never>
  /// Emits the attributed estimated delivery date label text.
  public let estimatedDeliveryDateLabelAttributedText: Signal<NSAttributedString, Never>
  /// Emits the attributed estimated shipping cost text.
  public let estimatedShippingAttributedText: Signal<NSAttributedString, Never>
  /// Emits whether the estimated shipping label should be hidden.
  public let estimatedShippingHidden: Signal<Bool, Never>
  /// Emits the container layout margins.
  public let layoutMargins: Signal<UIEdgeInsets, Never>
  /// Emits the horizontal margin width.
  public let marginWidth: Signal<CGFloat, Never>
  /// Emits whether the pledge disclaimer view should be hidden.
  public let pledgeDisclaimerViewHidden: Signal<Bool, Never>
  /// Emits whether the reward-received toggle is currently on.
  public let rewardReceived: Signal<Bool, Never>
  /// Emits whether the reward-received toggle row should be hidden.
  public let rewardReceivedHidden: Signal<Bool, Never>

  /// The inputs interface for this view model.
  public var inputs: ManageViewPledgeRewardReceivedViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: ManageViewPledgeRewardReceivedViewModelOutputs { return self }
}

private func formatEstimatedShipping(with shippingRange: String) -> NSAttributedString {
  // In this UI, the title and value are simply separated by a space.
  let totalString = "\(Strings.Estimated_Shipping()) \(shippingRange)"
  return attributedText(totalString: totalString, valueSubstring: shippingRange)
}

private func estimatedDeliveryAttributedText(with date: TimeInterval) -> NSAttributedString {
  let dateString = Format.date(
    secondsInUTC: date,
    template: DateFormatter.monthYear,
    timeZone: UTCTimeZone
  )
  let string = Strings.backing_info_estimated_delivery_date(delivery_date: dateString)

  return attributedText(totalString: string, valueSubstring: dateString)
}

private func attributedText(totalString: String, valueSubstring: String) -> NSAttributedString {
  let font = UIFont.ksr_subhead()

  let attributedText = NSMutableAttributedString(
    attributedString: totalString
      .attributed(
        with: font,
        foregroundColor: LegacyColors.ksr_support_400.uiColor(),
        attributes: [:],
        bolding: [totalString.replacingOccurrences(of: valueSubstring, with: "")]
      )
  )

  attributedText.setAttributes(
    [
      .font: font,
      .foregroundColor: LegacyColors.ksr_support_700.uiColor()
    ],
    range: (totalString as NSString).range(of: valueSubstring)
  )

  return attributedText
}
