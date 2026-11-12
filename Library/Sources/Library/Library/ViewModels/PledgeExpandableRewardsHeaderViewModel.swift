import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// Section items displayed in the expandable pledge summary rewards header.
public enum PledgeExpandableRewardsHeaderItem {
  /// Summary header row showing total estimated delivery date and total pledge amount.
  case header(PledgeSummaryRewardCellData)
  /// Individual reward tier row shown when expanded.
  case reward(PledgeSummaryRewardCellData)

  /// The cell configuration payload associated with this item.
  public var data: PledgeSummaryRewardCellData {
    switch self {
    case let .header(data): return data
    case let .reward(data): return data
    }
  }

  /// `true` when this item is the summary `.header` row.
  public var isHeader: Bool {
    switch self {
    case .header: return true
    case .reward: return false
    }
  }

  /// `true` when this item is an individual `.reward` row.
  public var isReward: Bool {
    switch self {
    case .header: return false
    case .reward: return true
    }
  }
}

/// Input data required to configure `PledgeExpandableRewardsHeaderViewModel`.
public struct PledgeExpandableRewardsHeaderViewData {
  /// Selected rewards included in the pledge.
  public let rewards: [Reward]
  /// Mapping of reward ID to selected quantity.
  public let selectedQuantities: SelectedRewardQuantities
  /// ISO currency code for formatting reward totals.
  public let currencyCode: String
  /// Whether to omit the US currency code prefix when formatting amounts.
  public let omitCurrencyCode: Bool
}

/// Inputs accepted by `PledgeExpandableRewardsHeaderViewModel`.
public protocol PledgeExpandableRewardsHeaderViewModelInputs {
  /// Configures the header with the selected rewards and formatting preferences.
  func configure(with data: PledgeExpandableRewardsHeaderViewData)
  /// Toggles the expanded/collapsed state of individual reward rows.
  func expandButtonTapped()
  /// Signals that the header view has loaded.
  func viewDidLoad()
}

/// Outputs exposed by `PledgeExpandableRewardsHeaderViewModel`.
public protocol PledgeExpandableRewardsHeaderViewModelOutputs {
  /// Emits ordered header and reward items to populate the summary table.
  var loadRewardsIntoDataSource: Signal<[PledgeExpandableRewardsHeaderItem], Never> { get }
  /// Emits the updated expanded (`true`) or collapsed (`false`) state.
  var expandRewards: Signal<Bool, Never> { get }
}

/// Combined inputs and outputs interface for `PledgeExpandableRewardsHeaderViewModel`.
public protocol PledgeExpandableRewardsHeaderViewModelType {
  /// The view model's inputs.
  var inputs: PledgeExpandableRewardsHeaderViewModelInputs { get }
  /// The view model's outputs.
  var outputs: PledgeExpandableRewardsHeaderViewModelOutputs { get }
}

/// View model managing the collapsible rewards breakdown header in pledge confirmation.
public final class PledgeExpandableRewardsHeaderViewModel: PledgeExpandableRewardsHeaderViewModelType,
  PledgeExpandableRewardsHeaderViewModelInputs, PledgeExpandableRewardsHeaderViewModelOutputs {
  /// Creates a new `PledgeExpandableRewardsHeaderViewModel`.
  public init() {
    let data = Signal.combineLatest(
      self.configureWithRewardsProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let rewards = data.map(\.rewards)
    let selectedQuantities = data.map(\.selectedQuantities)

    let latestRewardDeliveryDate = rewards.map { rewards in
      rewards
        .compactMap { $0.estimatedDeliveryOn }
        .reduce(0) { accum, value in max(accum, value) }
    }

    self.expandRewards = self.expandButtonTappedProperty.signal
      .scan(false) { current, _ in !current }

    let estimatedDeliveryString = latestRewardDeliveryDate.map { date -> String? in
      guard date > 0 else { return nil }

      let dateString = Format.date(
        secondsInUTC: date,
        template: DateFormatter.monthYear,
        timeZone: UTCTimeZone
      )

      return Strings.backing_info_estimated_delivery_date(delivery_date: dateString)
    }
    .skipNil()

    let total: Signal<Double, Never> = Signal.combineLatest(
      rewards,
      selectedQuantities
    )
    .map { rewards, selectedQuantities in
      rewards.reduce(0.0) { total, reward in
        let totalForReward = reward.minimum
          .multiplyingCurrency(Double(selectedQuantities[reward.id] ?? 0))

        return total.addingCurrency(totalForReward)
      }
    }

    self.loadRewardsIntoDataSource = Signal.zip(
      data,
      selectedQuantities,
      estimatedDeliveryString,
      total
    )
    .map(items)
  }

  private let configureWithRewardsProperty = MutableProperty<PledgeExpandableRewardsHeaderViewData?>(nil)
  /// Configures the expandable rewards header with selected rewards and formatting details.
  public func configure(with data: PledgeExpandableRewardsHeaderViewData) {
    self.configureWithRewardsProperty.value = data
  }

  private let expandButtonTappedProperty = MutableProperty(())
  /// Toggles whether individual rewards are expanded below the header row.
  public func expandButtonTapped() {
    self.expandButtonTappedProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the header view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits ordered header and reward items to render in the table data source.
  public let loadRewardsIntoDataSource: Signal<[PledgeExpandableRewardsHeaderItem], Never>
  /// Emits the current expanded state (`true` when expanded).
  public let expandRewards: Signal<Bool, Never>

  /// The inputs interface for this view model.
  public var inputs: PledgeExpandableRewardsHeaderViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: PledgeExpandableRewardsHeaderViewModelOutputs { return self }
}

// MARK: - Functions

private func items(
  with data: PledgeExpandableRewardsHeaderViewData,
  selectedQuantities: SelectedRewardQuantities,
  estimatedDeliveryString: String,
  total: Double
) -> [PledgeExpandableRewardsHeaderItem] {
  guard let totalAmountAttributedText = attributedHeaderCurrency(
    with: data.currencyCode, amount: total, omitUSCurrencyCode: data.omitCurrencyCode
  ) else { return [] }

  let headerItem = PledgeExpandableRewardsHeaderItem.header(.init(
    type: .header,
    headerText: nil,
    showHeader: true,
    text: estimatedDeliveryString,
    amount: totalAmountAttributedText
  ))

  let rewardItems = data.rewards.compactMap { reward -> PledgeExpandableRewardsHeaderItem? in
    guard let title = reward.title else { return nil }

    let quantity = selectedQuantities[reward.id] ?? 0
    let itemString = quantity > 1 ? "\(Format.wholeNumber(quantity)) x \(title)" : title

    let amount = quantity > 1 ? reward.minimum * Double(quantity) : reward.minimum
    let amountAttributedText = attributedRewardCurrency(
      with: data.currencyCode, amount: amount, omitUSCurrencyCode: data.omitCurrencyCode
    )

    return PledgeExpandableRewardsHeaderItem.reward(.init(
      type: .reward,
      headerText: nil,
      showHeader: true,
      text: itemString,
      amount: amountAttributedText
    ))
  }

  return [headerItem] + rewardItems
}

private func attributedHeaderCurrency(
  with currencyCode: String,
  amount: Double,
  omitUSCurrencyCode: Bool
) -> NSAttributedString? {
  let defaultAttributes = checkoutCurrencyDefaultAttributes()
    .withAllValuesFrom([.foregroundColor: LegacyColors.ksr_support_400.uiColor()])
  let superscriptAttributes = checkoutCurrencySuperscriptAttributes()
  guard
    let attributedCurrency = Format.attributedCurrency(
      amount,
      currencyCode: currencyCode,
      omitCurrencyCode: omitUSCurrencyCode,
      defaultAttributes: defaultAttributes,
      superscriptAttributes: superscriptAttributes,
      maximumFractionDigits: 0,
      minimumFractionDigits: 0
    ) else { return nil }

  return attributedCurrency
}

private func attributedRewardCurrency(
  with currencyCode: String,
  amount: Double,
  omitUSCurrencyCode: Bool
) -> NSAttributedString {
  let currencyString = Format.currency(
    amount,
    currencyCode: currencyCode,
    omitCurrencyCode: omitUSCurrencyCode,
    maximumFractionDigits: 0,
    minimumFractionDigits: 0
  )

  return NSAttributedString(
    string: currencyString,
    attributes: [
      .foregroundColor: LegacyColors.ksr_support_400.uiColor(),
      .font: UIFont.ksr_subhead().bolded
    ]
  )
}
