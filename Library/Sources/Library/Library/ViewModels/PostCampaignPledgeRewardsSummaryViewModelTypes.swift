import KsApi
import ReactiveSwift

/// Row item variants displayed in the post-campaign rewards summary list.
public enum PostCampaignRewardsSummaryItem {
  /// Header row containing estimated delivery summary.
  case header(PledgeSummaryRewardCellData)
  /// Line item row for a selected reward, add-on, shipping, or bonus contribution.
  case reward(PledgeSummaryRewardCellData)

  /// Underlying cell data associated with either header or reward rows.
  public var data: PledgeSummaryRewardCellData {
    switch self {
    case let .header(data): return data
    case let .reward(data): return data
    }
  }

  /// Whether this item represents the section header row.
  public var isHeader: Bool {
    switch self {
    case .header: return true
    case .reward: return false
    }
  }

  /// Whether this item represents a reward/line-item row.
  public var isReward: Bool {
    switch self {
    case .header: return false
    case .reward: return true
    }
  }
}

/// Configuration payload describing rewards and pricing options for a post-campaign pledge summary.
public struct PostCampaignRewardsSummaryViewData {
  let rewards: [Reward]
  let selectedQuantities: SelectedRewardQuantities
  let currencyCode: String
  let omitCurrencyCode: Bool
  let shipping: PledgeShippingSummaryViewData?
  let useLatePledgeCosts: Bool
}

/// Inputs accepted by `PostCampaignPledgeRewardsSummaryViewModel`.
public protocol PostCampaignPledgeRewardsSummaryViewModelInputs {
  /// Configures the summary with selected reward quantities, optional bonus support, and pledge totals.
  func configureWith(
    rewardsData: PostCampaignRewardsSummaryViewData,
    bonusAmount: Double?,
    pledgeData: PledgeSummaryViewData
  )
  /// Signals that the summary view has loaded.
  func viewDidLoad()
}

/// Outputs emitted by `PostCampaignPledgeRewardsSummaryViewModel`.
public protocol PostCampaignPledgeRewardsSummaryViewModelOutputs {
  /// Emits total pledge summary data to configure the footer total view.
  var configurePledgeTotalViewWithData: Signal<PledgeSummaryViewData, Never> { get }
  /// Emits header and reward cell data items for the summary table.
  var loadRewardsIntoDataSource: Signal<
    (headerData: PledgeSummaryRewardCellData?, rewards: [PledgeSummaryRewardCellData]),
    Never
  > { get }
}

/// Interface combining inputs and outputs for `PostCampaignPledgeRewardsSummaryViewModel`.
public protocol PostCampaignPledgeRewardsSummaryViewModelType {
  /// Input receiver for post-campaign rewards summary events.
  var inputs: PostCampaignPledgeRewardsSummaryViewModelInputs { get }
  /// Output signals configuring the summary header, rewards, and total view.
  var outputs: PostCampaignPledgeRewardsSummaryViewModelOutputs { get }
}

