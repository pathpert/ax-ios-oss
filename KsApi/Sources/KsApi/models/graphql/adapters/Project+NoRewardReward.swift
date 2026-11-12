import GraphAPI
import Prelude

extension Reward {
  /// Synthesizes a local no-reward tier from `NoRewardRewardFragment` because GraphQL omits v1's implicit no-reward entry.
  /// See PR #1616 for original context.
  public static func noRewardReward(from fragment: GraphAPI.NoRewardRewardFragment) -> Reward {
    let projectMinimumPledgeAmount: Int = fragment.minPledge
    let currentUsersCurrencyFXRate: Double = fragment.fxRate

    let convertedMinimumAmount = currentUsersCurrencyFXRate * Double(projectMinimumPledgeAmount)

    let emptyReward = Reward.noReward(
      withMinimum: Double(projectMinimumPledgeAmount),
      convertedMinimum: convertedMinimumAmount
    )

    return emptyReward
  }
}
