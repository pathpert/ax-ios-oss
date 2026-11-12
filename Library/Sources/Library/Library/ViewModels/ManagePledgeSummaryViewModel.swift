import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Summary payload configuring the pledge breakdown card inside Manage Pledge.
public struct ManagePledgeSummaryViewData: Equatable {
  /// Numeric identifier of the backing user.
  public let backerId: Int
  /// Display name of the backing user.
  public let backerName: String
  /// 1-based sequence number of the backer on this project.
  public let backerSequence: Int
  /// Current settlement status of the backing.
  public let backingState: Backing.Status
  /// Optional bonus pledge amount added beyond reward minimum.
  public let bonusAmount: Double?
  /// `true` if the signed-in user created the project.
  public let currentUserIsCreatorOfProject: Bool
  /// `true` if the backing is a pledge without a reward tier.
  public let isNoReward: Bool
  /// Displayable shipping destination name, if applicable.
  public let locationName: String?
  /// `true` when amounts require currency conversion display.
  public let needsConversion: Bool
  /// `true` to suppress trailing `"US"` on USD currency labels.
  public let omitUSCurrencyCode: Bool
  /// Total pledge amount in project currency units.
  public let pledgeAmount: Double
  /// Unix timestamp (UTC seconds) when the backing was created.
  public let pledgedOn: TimeInterval
  /// ISO 4217 currency code of the project.
  public let currencyCode: String
  /// Campaign deadline timestamp (UTC seconds).
  public let projectDeadline: TimeInterval
  /// Lifecycle state of the project.
  public let projectState: Project.State
  /// Base reward minimum amount in project currency units.
  public let rewardMinimum: Double
  /// Controls visibility of the creator reward-received toggle section.
  public let rewardReceivedViewControllerViewIsHidden: Bool
  /// Configuration payload for the reward-received view controller.
  public let rewardReceivedWithData: ManageViewPledgeRewardReceivedViewData
  /// Shipping cost in project currency units, if any.
  public let shippingAmount: Double?
  /// `true` when shipping cost row should remain hidden.
  public let shippingAmountHidden: Bool
  /// `true` if the selected base reward is local pickup only.
  public let rewardIsLocalPickup: Bool
  /// Scheduled Plot installment increments when using Pledge Over Time.
  public let paymentIncrements: [PledgePaymentIncrement]?
  // Temporary property
  /// Optional backing project reference used for status copy.
  public let project: Project?
}

/// Inputs accepted by `ManagePledgeSummaryViewModel`.
public protocol ManagePledgeSummaryViewModelInputs {
  /// Supplies the summary data model for the managed backing.
  func configureWith(_ data: ManagePledgeSummaryViewData)
  /// Notifies the view model that the summary view has loaded.
  func viewDidLoad()
}

/// Reactive outputs emitted by `ManagePledgeSummaryViewModel`.
public protocol ManagePledgeSummaryViewModelOutputs {
  /// Emits `(avatarURL, placeholderImageName)` for the backer avatar.
  var backerImageURLAndPlaceholderImageName: Signal<(URL, String), Never> { get }
  /// Emits whether the backer name label should be hidden.
  var backerNameLabelHidden: Signal<Bool, Never> { get }
  /// Emits the authenticated backer display name.
  var backerNameText: Signal<String, Never> { get }
  /// Emits the localized `"Backer #N"` sequence label text.
  var backerNumberText: Signal<String, Never> { get }
  /// Emits the localized `"As of <date>"` pledge date text.
  var backingDateText: Signal<String, Never> { get }
  /// Emits whether the circular avatar view should be hidden.
  var circleAvatarViewHidden: Signal<Bool, Never> { get }
  /// Emits formatted data for `PledgeAmountSummaryViewController`.
  var configurePledgeAmountSummaryViewWithData: Signal<PledgeAmountSummaryViewData, Never> { get }
  /// Emits status pill data for `PledgeStatusLabelView`.
  var configurePledgeStatusLabelViewWithProject: Signal<PledgeStatusLabelViewData, Never> { get }
  /// Emits configuration for the reward-received confirmation view.
  var configureRewardReceivedWithData: Signal<ManageViewPledgeRewardReceivedViewData, Never> { get }
  /// Emits whether the reward-received confirmation section is hidden.
  var rewardReceivedViewControllerViewIsHidden: Signal<Bool, Never> { get }
  /// Emits attributed total pledge currency text.
  var totalAmountText: Signal<NSAttributedString, Never> { get }
}

/// Combined inputs/outputs interface for managing pledge summary state.
public protocol ManagePledgeSummaryViewModelType {
  /// Input receiver.
  var inputs: ManagePledgeSummaryViewModelInputs { get }
  /// Output signal provider.
  var outputs: ManagePledgeSummaryViewModelOutputs { get }
}

/// View model formatting backer metadata, pledge date, and itemized pledge totals for Manage Pledge.
public class ManagePledgeSummaryViewModel: ManagePledgeSummaryViewModelType,
  ManagePledgeSummaryViewModelInputs, ManagePledgeSummaryViewModelOutputs {
  /// Creates a new `ManagePledgeSummaryViewModel`.
  public init() {
    let data = Signal.combineLatest(
      self.dataSignal,
      self.viewDidLoadSignal
    )
    .map(first)

    self.configurePledgeStatusLabelViewWithProject = data.map(pledgeStatusLabelViewData)

    self.configurePledgeAmountSummaryViewWithData = data.map(pledgeAmountSummaryViewData)

    let userAndIsBackingProject = data.map(\.backerId)
      .compactMap { backerId -> (User, Bool)? in
        guard let user = AppEnvironment.current.currentUser else {
          return nil
        }

        return (user, backerId == user.id)
      }

    self.backerNameLabelHidden = userAndIsBackingProject.map(second).negate()
    self.circleAvatarViewHidden = userAndIsBackingProject.map(second).negate()

    self.configureRewardReceivedWithData = data.map(\.rewardReceivedWithData)
    self.rewardReceivedViewControllerViewIsHidden = data.map(\.rewardReceivedViewControllerViewIsHidden)

    let userBackingProject = userAndIsBackingProject
      .filter(second >>> isTrue)
      .map(first)

    self.backerNameText = userBackingProject
      .map(\.name)

    self.backerImageURLAndPlaceholderImageName = userBackingProject
      .map(\.avatar.small)
      .map(URL.init)
      .skipNil()
      .map { ($0, "avatar--placeholder") }

    self.backerNumberText = data.map(\.backerSequence)
      .map { Strings.backer_modal_backer_number(backer_number: Format.wholeNumber($0)) }

    self.backingDateText = data.map(\.pledgedOn)
      .map(formattedPledgeDate)

    self.totalAmountText = data.map { ($0.currencyCode, $0.pledgeAmount, $0.omitUSCurrencyCode) }
      .map { currencyCode, pledgeAmount, omitUSCurrencyCode in
        attributedCurrency(
          with: currencyCode,
          amount: pledgeAmount,
          omitUSCurrencyCode: omitUSCurrencyCode
        )
      }
      .skipNil()
  }

  private let (dataSignal, dataObserver) = Signal<ManagePledgeSummaryViewData, Never>.pipe()
  /// Sends pledge summary data to populate outputs.
  public func configureWith(_ data: ManagePledgeSummaryViewData) {
    self.dataObserver.send(value: data)
  }

  private let (viewDidLoadSignal, viewDidLoadObserver) = Signal<(), Never>.pipe()
  /// Signals that the summary view finished loading.
  public func viewDidLoad() {
    self.viewDidLoadObserver.send(value: ())
  }

  /// Emits `(avatarURL, placeholderImageName)` for the backer avatar.
  public let backerImageURLAndPlaceholderImageName: Signal<(URL, String), Never>
  /// Emits whether the backer name label should be hidden.
  public let backerNameLabelHidden: Signal<Bool, Never>
  /// Emits the authenticated backer display name.
  public let backerNameText: Signal<String, Never>
  /// Emits the localized `"Backer #N"` sequence label text.
  public let backerNumberText: Signal<String, Never>
  /// Emits the localized `"As of <date>"` pledge date text.
  public let backingDateText: Signal<String, Never>
  /// Emits whether the circular avatar view should be hidden.
  public let circleAvatarViewHidden: Signal<Bool, Never>
  /// Emits status pill data for `PledgeStatusLabelView`.
  public let configurePledgeStatusLabelViewWithProject: Signal<PledgeStatusLabelViewData, Never>
  /// Emits formatted data for `PledgeAmountSummaryViewController`.
  public let configurePledgeAmountSummaryViewWithData: Signal<PledgeAmountSummaryViewData, Never>
  /// Emits configuration for the reward-received confirmation view.
  public let configureRewardReceivedWithData: Signal<ManageViewPledgeRewardReceivedViewData, Never>
  /// Emits whether the reward-received confirmation section is hidden.
  public let rewardReceivedViewControllerViewIsHidden: Signal<Bool, Never>
  /// Emits attributed total pledge currency text.
  public let totalAmountText: Signal<NSAttributedString, Never>

  /// Inputs receiver (`self`).
  public var inputs: ManagePledgeSummaryViewModelInputs { return self }
  /// Outputs provider (`self`).
  public var outputs: ManagePledgeSummaryViewModelOutputs { return self }
}

private func formattedPledgeDate(_ timeInterval: TimeInterval) -> String {
  let formattedDate = Format.date(secondsInUTC: timeInterval, dateStyle: .long, timeStyle: .none)
  return Strings.As_of_pledge_date(pledge_date: formattedDate)
}

private func pledgeAmountSummaryViewData(
  with data: ManagePledgeSummaryViewData
) -> PledgeAmountSummaryViewData {
  return .init(
    bonusAmount: data.bonusAmount,
    bonusAmountHidden: false,
    isNoReward: data.isNoReward,
    locationName: data.locationName,
    omitUSCurrencyCode: data.omitUSCurrencyCode,
    currencyCode: data.currencyCode,
    pledgedOn: data.pledgedOn,
    rewardMinimum: data.rewardMinimum,
    shippingAmount: data.shippingAmount,
    shippingAmountHidden: data.shippingAmountHidden,
    rewardIsLocalPickup: data.rewardIsLocalPickup
  )
}

private func pledgeStatusLabelViewData(with data: ManagePledgeSummaryViewData) -> PledgeStatusLabelViewData {
  return PledgeStatusLabelViewData(
    currentUserIsCreatorOfProject: data.currentUserIsCreatorOfProject,
    needsConversion: data.needsConversion,
    pledgeAmount: data.pledgeAmount,
    currencyCode: data.currencyCode,
    projectDeadline: data.projectDeadline,
    projectState: data.projectState,
    backingState: data.backingState,
    paymentIncrements: data.paymentIncrements,
    project: data.project
  )
}

private func attributedCurrency(
  with currencyCode: String,
  amount: Double,
  omitUSCurrencyCode: Bool
) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
    .withAllValuesFrom([.foregroundColor: LegacyColors.ksr_support_700.uiColor()])
  let superscriptAttributes = checkoutCurrencySuperscriptAttributes()
  guard
    let attributedCurrency = Format.attributedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitUSCurrencyCode,
      defaultAttributes: defaultAttributes,
      superscriptAttributes: superscriptAttributes
    ) else { return nil }

  return attributedCurrency
}
