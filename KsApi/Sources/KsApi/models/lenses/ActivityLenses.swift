import Foundation
import Prelude

extension Activity {
  /// Functional lenses for `Activity`.
  public enum lens {
    private static func copy(
      _ activity: Activity,
      category: Activity.Category? = nil,
      comment: ActivityComment?? = nil,
      createdAt: TimeInterval? = nil,
      id: Int? = nil,
      memberData: MemberData? = nil,
      project: Project?? = nil,
      trackingNumber: String?? = nil,
      trackingUrl: String?? = nil,
      update: Update?? = nil,
      user: User?? = nil
    ) -> Activity {
      Activity(
        category: category ?? activity.category,
        comment: comment ?? activity.comment,
        createdAt: createdAt ?? activity.createdAt,
        id: id ?? activity.id,
        memberData: memberData ?? activity.memberData,
        project: project ?? activity.project,
        trackingNumber: trackingNumber ?? activity.trackingNumber,
        trackingUrl: trackingUrl ?? activity.trackingUrl,
        update: update ?? activity.update,
        user: user ?? activity.user
      )
    }

    /// Lens focusing on the activity feed event `Category`.
    public static let category = Lens<Activity, Activity.Category>(
      view: { $0.category },
      set: { copy($1, category: $0) }
    )

    /// Lens focusing on the associated comment for comment-type activities.
    public static let comment = Lens<Activity, ActivityComment?>(
      view: { $0.comment },
      set: { copy($1, comment: .some($0)) }
    )

    /// Lens focusing on the activity creation timestamp (UTC Unix seconds).
    public static let createdAt = Lens<Activity, TimeInterval>(
      view: { $0.createdAt },
      set: { copy($1, createdAt: $0) }
    )

    /// Lens focusing on the numeric activity item identifier.
    public static let id = Lens<Activity, Int>(
      view: { $0.id },
      set: { copy($1, id: $0) }
    )

    /// Lens focusing on nested activity metadata such as backing amounts and reward changes.
    public static let memberData = Lens<Activity, MemberData>(
      view: { $0.memberData },
      set: { copy($1, memberData: $0) }
    )

    /// Lens focusing on the optional `Project` linked to this activity event.
    public static let project = Lens<Activity, Project?>(
      view: { $0.project },
      set: { copy($1, project: .some($0)) }
    )

    /// Lens focusing on the shipment tracking number for reward-shipped events.
    public static let trackingNumber = Lens<Activity, String?>(
      view: { $0.trackingNumber },
      set: { copy($1, trackingNumber: .some($0)) }
    )

    /// Lens focusing on the carrier tracking URL string.
    public static let trackingUrl = Lens<Activity, String?>(
      view: { $0.trackingNumber },
      set: { copy($1, trackingUrl: .some($0)) }
    )

    /// Lens focusing on the linked project `Update`, if applicable.
    public static let update = Lens<Activity, Update?>(
      view: { $0.update },
      set: { copy($1, update: .some($0)) }
    )

    /// Lens focusing on the `User` who triggered the activity.
    public static let user = Lens<Activity, User?>(
      view: { $0.user },
      set: { copy($1, user: .some($0)) }
    )
  }
}

extension Lens where Whole == Activity, Part == Activity.MemberData {
  /// Composed lens focusing on `MemberData.amount`.
  public var amount: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.amount
  }

  /// Composed lens focusing on `MemberData.backing`.
  public var backing: Lens<Activity, Backing?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.backing
  }

  /// Composed lens focusing on `MemberData.oldAmount`.
  public var oldAmount: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.oldAmount
  }

  /// Composed lens focusing on `MemberData.oldRewardId`.
  public var oldRewardId: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.oldRewardId
  }

  /// Composed lens focusing on `MemberData.newAmount`.
  public var newAmount: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.newAmount
  }

  /// Composed lens focusing on `MemberData.newRewardId`.
  public var newRewardId: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.newRewardId
  }

  /// Composed lens focusing on `MemberData.rewardId`.
  public var rewardId: Lens<Activity, Int?> {
    return Activity.lens.memberData .. Activity.MemberData.lens.rewardId
  }
}
