import KDS
import KsApi
import Prelude
import UIKit

func rewardCardNeedsConversion(project: Project) -> Bool {
  return project.stats.needsConversion
}

func rewardCardLocalizedDescription(project: Project, reward: Reward) -> String {
  guard project.personalization.isBacking == true else {
    return reward.isNoReward ? Strings.Back_it_because_you_believe_in_it() : reward.description
  }

  if reward.isNoReward {
    return userIsBacking(reward: reward, inProject: project)
      ? Strings.Thanks_for_bringing_this_project_one_step_closer_to_becoming_a_reality()
      : Strings.Back_it_because_you_believe_in_it()
  }

  return reward.description
}

func rewardCardTitle(project: Project, reward: Reward) -> NSAttributedString {
  guard project.personalization.isBacking == true || currentUserIsCreator(of: project) else {
    return NSAttributedString(
      string: reward.isNoReward ? Strings.Pledge_without_a_reward() : reward.title.coalesceWith("")
    )
  }

  if reward.isNoReward {
    let string = userIsBacking(reward: reward, inProject: project)
      ? Strings.You_pledged_without_a_reward() : Strings.Pledge_without_a_reward()
    return NSAttributedString(string: string)
  }

  let attributes: [NSAttributedString.Key: Any] = [.font: UIFont.ksr_title2().bolded]
  let title = reward.title.coalesceWith("")
  let titleAttributed = title.attributed(
    with: UIFont.ksr_title2(),
    foregroundColor: LegacyColors.ksr_support_700.uiColor(),
    attributes: attributes,
    bolding: [title]
  )

  guard
    let backing = project.personalization.backing,
    // Not the base reward, for that we just return the title without quantity.
    reward.id != backing.reward?.id,
    let selectedQuantity = selectedRewardQuantities(in: backing)[reward.id],
    selectedQuantity > 1 else {
    return titleAttributed
  }

  let qty = "\(selectedQuantity) x "
  let qtyAttributed = qty.attributed(
    with: UIFont.ksr_title2(),
    foregroundColor: LegacyColors.ksr_create_700.uiColor(),
    attributes: attributes,
    bolding: [title]
  )
  return qtyAttributed + titleAttributed
}

func rewardCardPillValues(project: Project, reward: Reward) -> [RewardCardPillData] {
  return [
    timeLeftString(project: project, reward: reward),
    backerCountOrRemainingString(project: project, reward: reward),
    shippingSummaryString(project: project, reward: reward),
    addOnsString(reward: reward)
  ]
  .compact()
}

private func addOnsString(reward: Reward) -> RewardCardPillData? {
  guard reward.hasAddOns else { return nil }

  return RewardCardPillData(
    backgroundColor: LegacyColors.Tags.Success.background.uiColor(),
    text: Strings.Add_ons(),
    textColor: LegacyColors.Tags.Success.foreground.uiColor()
  )
}

private func timeLeftString(project: Project, reward: Reward) -> RewardCardPillData? {
  let isUnlimitedOrAvailable = reward.limit == nil || reward.remaining ?? 0 > 0

  if project.state == .live,
     let endsAt = reward.endsAt,
     let deadline = project.dates.deadline,
     endsAt > 0,
     endsAt >= AppEnvironment.current.dateType.init().timeIntervalSince1970,
     isUnlimitedOrAvailable {
    let (time, unit) = Format.duration(
      secondsInUTC: min(endsAt, deadline),
      abbreviate: true,
      useToGo: false
    )

    return RewardCardPillData(
      backgroundColor: LegacyColors.Tags.Warn.background.uiColor(),
      text: Strings.Time_left_left(time_left: time + " " + unit),
      textColor: LegacyColors.Tags.Warn.foreground.uiColor()
    )
  }

  return nil
}

private func backerCountOrRemainingString(project: Project, reward: Reward) -> RewardCardPillData? {
  guard
    let limit = reward.limit,
    let remaining = rewardLimitRemainingForBacker(project: project, reward: reward),
    remaining > 0,
    project.state == .live
  else {
    let backersCount = reward.backersCount ?? 0

    return backersCount > 0 ? RewardCardPillData(
      backgroundColor: LegacyColors.Tags.Success.background.uiColor(),
      text: Strings.general_backer_count_backers(backer_count: backersCount),
      textColor: LegacyColors.Tags.Success.foreground.uiColor()
    ) : nil
  }

  return RewardCardPillData(
    backgroundColor: LegacyColors.Tags.Warn.background.uiColor(),
    text: Strings.remaining_count_left_of_limit_count(
      remaining_count: "\(remaining)",
      limit_count: "\(limit)"
    ),
    textColor: LegacyColors.Tags.Warn.foreground.uiColor()
  )
}

private func shippingSummaryString(project: Project, reward: Reward) -> RewardCardPillData? {
  if project.state == .live,
     reward.shipping.enabled,
     let shippingSummaryText = reward.shipping.summary {
    return RewardCardPillData(
      backgroundColor: LegacyColors.Tags.Success.background.uiColor(),
      text: shippingSummaryText,
      textColor: LegacyColors.Tags.Success.foreground.uiColor()
    )
  }

  return nil
}

func rewardCardEstimatedDeliveryDateText(with reward: Reward) -> String? {
  return reward.estimatedDeliveryOn.map {
    Format.date(
      secondsInUTC: $0,
      template: DateFormatter.monthYear,
      timeZone: UTCTimeZone
    )
  }
}

public extension RewardCardBadgeData {
  /// Returns badge styling and icon metadata for secret or featured rewards, if applicable.
  static func forReward(_ reward: Reward) -> RewardCardBadgeData? {
    if reward.isSecretReward {
      let badgeStyle = BadgeStyle.custom(
        foregroundColor: Colors.Text.Accent.Green.bolder.uiColor(),
        backgroundColor: Colors.Background.Accent.Green.subtle.uiColor()
      )

      return RewardCardBadgeData(
        text: Strings.Secret_reward(),
        badgeStyle: badgeStyle,
        image: Library.image(named: "Locked")
      )
    }

    // It's technically possible for a reward to be both Featured and Secret.
    // In that case, we just display the Secret badge.
    if reward.featured {
      let foreground = Colors.Text.Accent.Purple.bolder.uiColor()
      let background = Colors.Background.Accent.Purple.subtle.uiColor()
      let badgeStyle = BadgeStyle.custom(foregroundColor: foreground, backgroundColor: background)
      let icon = Library.image(named: "icon-star-open-new")?.withTintColor(foreground)

      return RewardCardBadgeData(
        text: Strings.Featured(),
        badgeStyle: badgeStyle,
        image: icon
      )
    }

    return nil
  }
}

