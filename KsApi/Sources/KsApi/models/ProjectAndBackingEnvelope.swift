import Foundation
import GraphAPI
import ReactiveSwift

/// Paired GraphQL response envelope containing a `Project` and its associated `Backing`.
public struct ProjectAndBackingEnvelope: Equatable, Decodable {
  /// Decoded project model with its backing attached.
  public var project: Project
  /// Decoded backing model including add-ons and payment increments.
  public var backing: Backing
}

// MARK: - GraphQL Adapters

extension ProjectAndBackingEnvelope {
  static func envelopeProducer(
    from data: GraphAPI.FetchBackingQuery.Data
  ) -> SignalProducer<ProjectAndBackingEnvelope, ErrorEnvelope> {
    let addOns = data.backing?.addOns?.nodes?
      .compactMap { $0 }
      .compactMap { node -> Reward? in
        let rewardFragment = node.fragments.rewardFragment
        let itemFragment = node.fragments.rewardItemsFragment
        let imageFragment = node.fragments.rewardImageFragment

        return Reward.reward(
          from: rewardFragment,
          rewardItems: RewardsItem.rewardItemsData(from: itemFragment),
          rewardImage: Reward.Image.rewardPhoto(from: imageFragment)
        )
      }

    var paymentIncrements: [PledgePaymentIncrement] = []

    if let backingIncrements = data.backing?.paymentIncrements {
      paymentIncrements = backingIncrements
        .compactMap {
          PledgePaymentIncrement(withGraphQLFragment: $0.fragments.paymentIncrementFragment)
        }
    }

    guard
      let backingFragment = data.backing?.fragments.backingFragment,
      let projectFragment = data.backing?.project?.fragments.projectFragment,
      let backing = Backing.backing(
        from: backingFragment,
        addOns: addOns,
        paymentIncrements: paymentIncrements
      ),
      let project = Project.project(
        from: projectFragment,
        flagging: nil,
        backing: backing,
        extendedProjectProperties: nil,
        video: nil
      )
    else {
      return SignalProducer(error: .couldNotParseJSON)
    }

    return SignalProducer(value: ProjectAndBackingEnvelope(project: project, backing: backing))
  }
}
