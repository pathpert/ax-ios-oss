import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit

/// View model formatting rewards, shipping, and bonus line items for post-campaign pledges.
public final class PostCampaignPledgeRewardsSummaryViewModel: PostCampaignPledgeRewardsSummaryViewModelType,
  PostCampaignPledgeRewardsSummaryViewModelInputs, PostCampaignPledgeRewardsSummaryViewModelOutputs {
  /// Initializes the post-campaign pledge rewards summary view model.
  public init() {
    let data = Signal.combineLatest(
      self.configureWithDataProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let rewardData = data.map { $0.0 }
    let rewards = data.map(\.0.rewards)
    let selectedQuantities = data.map(\.0.selectedQuantities)
    let useLatePledgeCosts = data.map(\.0.useLatePledgeCosts)
    let bonusAmount = data.map(\.1)

    let latestRewardDeliveryDate = rewards.map { rewards in
      rewards
        .compactMap { $0.estimatedDeliveryOn }
        .reduce(0) { accum, value in max(accum, value) }
    }

    let estimatedDeliveryString = latestRewardDeliveryDate.map { date -> String? in
      guard date > 0 else { return nil }

      let dateString = Format.date(
        secondsInUTC: date,
        template: DateFormatter.monthYear,
        timeZone: UTCTimeZone
      )

      return Strings.backing_info_estimated_delivery_date(delivery_date: dateString)
    }

    let total: Signal<Double, Never> = Signal.combineLatest(
      rewards,
      selectedQuantities,
      useLatePledgeCosts
    )
    .map { rewards, selectedQuantities, isLatePledge in
      rewards.reduce(0.0) { total, reward in
        let totalForReward = isLatePledge ? reward.latePledgeAmount : reward.pledgeAmount
          .multiplyingCurrency(Double(selectedQuantities[reward.id] ?? 0))

        return total.addingCurrency(totalForReward)
      }
    }

    self.loadRewardsIntoDataSource = Signal.zip(
      rewardData,
      selectedQuantities,
      estimatedDeliveryString,
      bonusAmount,
      total
    )
    .map(items)
    .map { data in
      /// Decipher header vs reward objects from the `[PostCampaignRewardsSummaryItem]` data object.
      let header = data.compactMap { item -> PledgeSummaryRewardCellData? in
        guard case let .header(data) = item else { return nil }
        return data
      }

      let allRewards = data.compactMap { item -> PledgeSummaryRewardCellData? in
        guard case let .reward(data) = item else { return nil }
        return data
      }

      return (header.first, allRewards)
    }

    self.configurePledgeTotalViewWithData = data.map { data in
      let (_, _, pledgeSummaryData) = data
      return pledgeSummaryData
    }
  }

  private let configureWithDataProperty =
    MutableProperty<(PostCampaignRewardsSummaryViewData, Double?, PledgeSummaryViewData)?>(nil)
  /// Configures the view model with rewards, optional bonus amount, and summary pricing data.
  public func configureWith(
    rewardsData: PostCampaignRewardsSummaryViewData,
    bonusAmount: Double?,
    pledgeData: PledgeSummaryViewData
  ) {
    self.configureWithDataProperty.value = (rewardsData, bonusAmount, pledgeData)
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Signals that the summary view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits total pledge summary data to configure the footer total view.
  public let configurePledgeTotalViewWithData: Signal<PledgeSummaryViewData, Never>
  /// Emits header and reward row data items for the data source.
  public let loadRewardsIntoDataSource: Signal<
    (headerData: PledgeSummaryRewardCellData?, rewards: [PledgeSummaryRewardCellData]),
    Never
  >

  /// Returns `self` as `PostCampaignPledgeRewardsSummaryViewModelInputs`.
  public var inputs: PostCampaignPledgeRewardsSummaryViewModelInputs { return self }
  /// Returns `self` as `PostCampaignPledgeRewardsSummaryViewModelOutputs`.
  public var outputs: PostCampaignPledgeRewardsSummaryViewModelOutputs { return self }
}

// MARK: - Functions

private func items(
  with data: PostCampaignRewardsSummaryViewData,
  selectedQuantities: SelectedRewardQuantities,
  estimatedDeliveryString: String?,
  bonusAmount: Double?,
  total _: Double
) -> [PostCampaignRewardsSummaryItem] {
  // MARK: Header

  let headerItem = PostCampaignRewardsSummaryItem.header(.init(
    type: .header,
    headerText: nil,
    showHeader: false,
    text: estimatedDeliveryString ?? "",
    amount: NSAttributedString(string: "")
  ))

  // MARK: Rewards

  let rewardItems = data.rewards.compactMap { reward -> PostCampaignRewardsSummaryItem? in
    guard reward.isNoReward == false, let title = reward.title else { return nil }

    let quantity = selectedQuantities[reward.id] ?? 0
    let itemString = quantity > 1 ? "\(Format.wholeNumber(quantity)) x \(title)" : title

    let itemCost = data.useLatePledgeCosts ? reward.latePledgeAmount : reward.pledgeAmount
    let amount = quantity > 1 ? itemCost * Double(quantity) : itemCost
    let amountAttributedText = attributedRewardCurrency(
      with: data.currencyCode, amount: amount, omitUSCurrencyCode: data.omitCurrencyCode
    )

    return PostCampaignRewardsSummaryItem.reward(.init(
      type: .reward,
      headerText: nil,
      showHeader: false,
      text: itemString,
      amount: amountAttributedText
    ))
  }
  var items = [headerItem] + rewardItems

  // MARK: Shipping

  if let shipping = data.shipping, shipping.total > 0 {
    let shippingAmountAttributedText = attributedRewardCurrency(
      with: data.currencyCode, amount: shipping.total, omitUSCurrencyCode: data.omitCurrencyCode
    )

    let shippingItem = PostCampaignRewardsSummaryItem.reward(.init(
      type: .shipping,
      headerText: nil,
      showHeader: false,
      text: Strings.Shipping_to_country(country: shipping.locationName),
      amount: shippingAmountAttributedText
    ))

    items.append(shippingItem)
  }

  // MARK: Bonus

  if let bonus = bonusAmount, bonus > 0, rewardItems.isEmpty == false {
    let bonusAmountAttributedText = attributedRewardCurrency(
      with: data.currencyCode, amount: bonus, omitUSCurrencyCode: data.omitCurrencyCode
    )

    let bonusItem = PostCampaignRewardsSummaryItem.reward(.init(
      type: .bonusSupport,
      headerText: nil,
      showHeader: false,
      text: Strings.Bonus_support(),
      amount: bonusAmountAttributedText
    ))

    items.append(bonusItem)
  }

  return items
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
