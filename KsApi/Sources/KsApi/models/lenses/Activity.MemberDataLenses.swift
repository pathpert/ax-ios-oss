import Prelude

extension Activity.MemberData {
  /// Functional lenses for `Activity.MemberData`.
  public enum lens {
    private static func copy(
      _ data: Activity.MemberData,
      amount: Int?? = nil,
      backing: Backing?? = nil,
      oldAmount: Int?? = nil,
      oldRewardId: Int?? = nil,
      newAmount: Int?? = nil,
      newRewardId: Int?? = nil,
      rewardId: Int?? = nil
    ) -> Activity.MemberData {
      Activity.MemberData(
        amount: amount ?? data.amount,
        backing: backing ?? data.backing,
        oldAmount: oldAmount ?? data.oldAmount,
        oldRewardId: oldRewardId ?? data.oldRewardId,
        newAmount: newAmount ?? data.newAmount,
        newRewardId: newRewardId ?? data.newRewardId,
        rewardId: rewardId ?? data.rewardId
      )
    }

    /// Lens focusing on the pledge amount in whole currency units.
    public static let amount = Lens<Activity.MemberData, Int?>(
      view: { $0.amount },
      set: { copy($1, amount: .some($0)) }
    )

    /// Lens focusing on the optional `Backing` associated with the activity.
    public static let backing = Lens<Activity.MemberData, Backing?>(
      view: { $0.backing },
      set: { copy($1, backing: .some($0)) }
    )

    /// Lens focusing on the previous pledge amount prior to an adjustment.
    public static let oldAmount = Lens<Activity.MemberData, Int?>(
      view: { $0.oldAmount },
      set: { copy($1, oldAmount: .some($0)) }
    )

    /// Lens focusing on the previous reward identifier prior to a tier swap.
    public static let oldRewardId = Lens<Activity.MemberData, Int?>(
      view: { $0.oldRewardId },
      set: { copy($1, oldRewardId: .some($0)) }
    )

    /// Lens focusing on the updated pledge amount after an adjustment.
    public static let newAmount = Lens<Activity.MemberData, Int?>(
      view: { $0.newAmount },
      set: { copy($1, newAmount: .some($0)) }
    )

    /// Lens focusing on the updated reward identifier after a tier swap.
    public static let newRewardId = Lens<Activity.MemberData, Int?>(
      view: { $0.newRewardId },
      set: { copy($1, newRewardId: .some($0)) }
    )

    /// Lens focusing on the primary reward identifier.
    public static let rewardId = Lens<Activity.MemberData, Int?>(
      view: { $0.rewardId },
      set: { copy($1, rewardId: .some($0)) }
    )
  }
}
