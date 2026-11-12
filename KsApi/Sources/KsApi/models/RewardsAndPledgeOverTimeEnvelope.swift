import Foundation
import ReactiveSwift

/// GraphQL envelope bundling a project's rewards with its Pledge-Over-Time eligibility and plan copy.
public struct RewardsAndPledgeOverTimeEnvelope {
  /// Rewards configured on the project.
  public let rewards: [Reward]
  /// Whether Pledge-Over-Time installment billing is enabled for this project.
  public let isPledgeOverTimeAllowed: Bool
  /// Explanation copy describing installment collection timing and rules.
  public let pledgeOverTimeCollectionPlanChargeExplanation: String?
  /// Short label summarizing the number of installment payments (e.g., `"Charged as 4 payments"`).
  public let pledgeOverTimeCollectionPlanChargedAsNPayments: String?
  /// Short marketing pitch for Pledge-Over-Time.
  public let pledgeOverTimeCollectionPlanShortPitch: String?
  /// Localized explanation of the minimum pledge threshold required for Pledge-Over-Time.
  public let pledgeOverTimeMinimumExplanation: String?
}

extension RewardsAndPledgeOverTimeEnvelope: Decodable {}
