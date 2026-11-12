import Foundation
import Prelude

extension Backing {
  /// Functional lenses for immutably updating `Backing` fields in view models and test fixtures.
  public enum lens {
    /// Lens focusing on optional add-on rewards selected with this backing.
    public static let addOns = Lens<Backing, [Reward]?>(
      view: { $0.addOns },
      set: { $1.copy(addOns: $0) }
    )

    /// Lens focusing on the total pledge amount in project currency.
    public static let amount = Lens<Backing, Double>(
      view: { $0.amount },
      set: { $1.copy(amount: $0) }
    )

    /// Lens focusing on the optional `User` record for the backer.
    public static let backer = Lens<Backing, User?>(
      view: { $0.backer },
      set: { $1.copy(backer: $0) }
    )

    /// Lens focusing on the numeric backer user identifier.
    public static let backerId = Lens<Backing, Int>(
      view: { $0.backerId },
      set: { $1.copy(backerId: $0) }
    )

    /// Lens focusing on whether the backer has completed the survey/fulfillment check.
    public static let backerCompleted = Lens<Backing, Bool?>(
      view: { $0.backerCompleted },
      set: { $1.copy(backerCompleted: $0) }
    )

    /// Lens focusing on the backing details web/route URL string.
    public static let backingDetailsUrl = Lens<Backing, String>(
      view: { $0.backingDetailsPageRoute },
      set: { $1.copy(backingDetailsPageRoute: $0) }
    )

    /// Lens focusing on the bonus amount pledged above the reward minimum.
    public static let bonusAmount = Lens<Backing, Double>(
      view: { $0.bonusAmount },
      set: { $1.copy(bonusAmount: $0) }
    )

    /// Lens focusing on whether the backing can currently be canceled by the backer.
    public static let cancelable = Lens<Backing, Bool>(
      view: { $0.cancelable },
      set: { $1.copy(cancelable: $0) }
    )

    /// Lens focusing on the unique numeric backing identifier.
    public static let id = Lens<Backing, Int>(
      view: { $0.id },
      set: { $1.copy(id: $0) }
    )

    /// Lens focusing on whether the backing was created during post-campaign late pledging.
    public static let isLatePledge = Lens<Backing, Bool>(
      view: { $0.isLatePledge },
      set: { $1.copy(isLatePledge: $0) }
    )

    /// Lens focusing on the numeric shipping location identifier.
    public static let locationId = Lens<Backing, Int?>(
      view: { $0.locationId },
      set: { $1.copy(locationId: $0) }
    )

    /// Lens focusing on the displayable shipping location name.
    public static let locationName = Lens<Backing, String?>(
      view: { $0.locationName },
      set: { $1.copy(locationName: $0) }
    )

    /// Lens focusing on the optional fulfillment `Order` attached to the backing.
    public static let order = Lens<Backing, Order?>(
      view: { $0.order },
      set: { $1.copy(order: $0) }
    )

    /// Lens focusing on the scheduled pledge-over-time payment increments.
    public static let paymentIncrements = Lens<Backing, [PledgePaymentIncrement]>(
      view: { $0.paymentIncrements },
      set: { $1.copy(paymentIncrements: $0) }
    )

    /// Lens focusing on the stored payment source used for this backing.
    public static let paymentSource = Lens<Backing, Backing.PaymentSource?>(
      view: { $0.paymentSource },
      set: { $1.copy(paymentSource: $0) }
    )

    /// Lens focusing on the UNIX timestamp when the backing was created.
    public static let pledgedAt = Lens<Backing, TimeInterval>(
      view: { $0.pledgedAt },
      set: { $1.copy(pledgedAt: $0) }
    )

    /// Lens focusing on the project's ISO country code string.
    public static let projectCountry = Lens<Backing, String>(
      view: { $0.projectCountry },
      set: { $1.copy(projectCountry: $0) }
    )

    /// Lens focusing on the parent project's numeric identifier.
    public static let projectId = Lens<Backing, Int>(
      view: { $0.projectId },
      set: { $1.copy(projectId: $0) }
    )

    /// Lens focusing on the optional `Reward` selected for this backing.
    public static let reward = Lens<Backing, Reward?>(
      view: { $0.reward },
      set: { $1.copy(reward: $0) }
    )

    /// Lens focusing on the reward portion of the pledge amount.
    public static let rewardsAmount = Lens<Backing, Double?>(
      view: { $0.rewardsAmount },
      set: { $1.copy(rewardsAmount: $0) }
    )

    /// Lens focusing on the numeric identifier of the selected reward.
    public static let rewardId = Lens<Backing, Int?>(
      view: { $0.rewardId },
      set: { $1.copy(rewardId: $0) }
    )

    /// Lens focusing on the backer sequence number on the project.
    public static let sequence = Lens<Backing, Int>(
      view: { $0.sequence },
      set: { $1.copy(sequence: $0) }
    )

    /// Lens focusing on the shipping fee included in the backing amount.
    public static let shippingAmount = Lens<Backing, Double?>(
      view: { $0.shippingAmount },
      set: { $1.copy(shippingAmount: $0) }
    )

    /// Lens focusing on the current backing lifecycle `Status`.
    public static let status = Lens<Backing, Status>(
      view: { $0.status },
      set: { $1.copy(status: $0) }
    )
  }

  private func copy(
    addOns: [Reward]?? = nil,
    amount: Double? = nil,
    backer: User?? = nil,
    backerId: Int? = nil,
    backerCompleted: Bool?? = nil,
    backingDetailsPageRoute: String? = nil,
    bonusAmount: Double? = nil,
    cancelable: Bool? = nil,
    id: Int? = nil,
    isLatePledge: Bool? = nil,
    locationId: Int?? = nil,
    locationName: String?? = nil,
    order: Order?? = nil,
    paymentIncrements: [PledgePaymentIncrement]? = nil,
    paymentSource: Backing.PaymentSource?? = nil,
    pledgedAt: TimeInterval? = nil,
    projectCountry: String? = nil,
    projectId: Int? = nil,
    reward: Reward?? = nil,
    rewardsAmount: Double?? = nil,
    rewardId: Int?? = nil,
    sequence: Int? = nil,
    shippingAmount: Double?? = nil,
    status: Status? = nil
  ) -> Backing {
    return Backing(
      addOns: addOns ?? self.addOns,
      amount: amount ?? self.amount,
      backer: backer ?? self.backer,
      backerId: backerId ?? self.backerId,
      backerCompleted: backerCompleted ?? self.backerCompleted,
      backingDetailsPageRoute: backingDetailsPageRoute ?? self.backingDetailsPageRoute,
      bonusAmount: bonusAmount ?? self.bonusAmount,
      cancelable: cancelable ?? self.cancelable,
      id: id ?? self.id,
      isLatePledge: isLatePledge ?? self.isLatePledge,
      locationId: locationId ?? self.locationId,
      locationName: locationName ?? self.locationName,
      order: order ?? self.order,
      paymentIncrements: paymentIncrements ?? self.paymentIncrements,
      paymentSource: paymentSource ?? self.paymentSource,
      pledgedAt: pledgedAt ?? self.pledgedAt,
      projectCountry: projectCountry ?? self.projectCountry,
      projectId: projectId ?? self.projectId,
      reward: reward ?? self.reward,
      rewardsAmount: rewardsAmount ?? self.rewardsAmount,
      rewardId: rewardId ?? self.rewardId,
      sequence: sequence ?? self.sequence,
      shippingAmount: shippingAmount ?? self.shippingAmount,
      status: status ?? self.status
    )
  }
}
