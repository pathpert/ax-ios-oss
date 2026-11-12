import KDS
import KsApi
import Prelude
import UIKit

/// Helper definitions for `addOnAmountStringForReward` in `RewardAddOnCardViewModel+Helpers.swift`.
internal func addOnAmountStringForReward(
  project: Project,
  reward: Reward,
  shippingRule: ShippingRule?
) -> NSAttributedString {
  let font: UIFont = UIFont.ksr_subhead().weighted(.medium)
  let foregroundColor: UIColor = LegacyColors.ksr_create_700.uiColor()

  let projectCurrency = project.statsCurrency

  let min = minPledgeAmount(forProject: project, reward: reward)
  let amountString = Format.currency(
    min,
    currencyCode: projectCurrency,
    omitCurrencyCode: project.stats.omitUSCurrencyCode
  )

  if let shippingRule = shippingRule, shippingRule.cost > 0 {
    let shippingAmount = Format.currency(
      shippingRule.cost,
      currencyCode: projectCurrency,
      omitCurrencyCode: project.stats.omitUSCurrencyCode
    )

    let combinedString = Strings.reward_amount_plus_shipping_cost_each(
      reward_amount: amountString,
      shipping_cost: shippingAmount
    )

    let attributedString = combinedString.attributed(
      with: UIFont.ksr_footnote().weighted(.medium),
      foregroundColor: foregroundColor,
      attributes: [:],
      bolding: []
    )

    let mutableString = NSMutableAttributedString(attributedString: attributedString)
    let amountRange = (combinedString as NSString).localizedStandardRange(of: amountString)

    mutableString.setAttributes([.font: font], range: amountRange)

    return mutableString
  }

  return amountString.attributed(
    with: font,
    foregroundColor: foregroundColor,
    attributes: [:],
    bolding: []
  )
}

internal func addOnItemsLabelAttributedText(_ items: [RewardsItem]) -> NSAttributedString? {
  guard !items.isEmpty else { return nil }

  let defaultAttributes: [NSAttributedString.Key: Any] = [
    .font: UIFont.ksr_callout()
  ]
  let bulletPrefix = "•  "

  let paragraphStyle = NSMutableParagraphStyle()
  paragraphStyle.headIndent = (bulletPrefix as NSString).size(withAttributes: defaultAttributes).width
  paragraphStyle.paragraphSpacing = Styles.grid(1)

  let bulletedListAttributes: [NSAttributedString.Key: Any] = [.paragraphStyle: paragraphStyle]

  let attributedString = NSMutableAttributedString()

  items.map { rewardsItem -> NSAttributedString in
    let itemString = rewardsItem.quantity > 1
      ? "\(Format.wholeNumber(rewardsItem.quantity)) x \(rewardsItem.item.name)"
      : rewardsItem.item.name

    let suffix = rewardsItem.item.id == items.last?.item.id ? "" : "\n"

    return NSAttributedString(
      string: "\(bulletPrefix)\(itemString)\(suffix)",
      attributes: defaultAttributes.withAllValuesFrom(bulletedListAttributes)
    )
  }
  .forEach { bulletItem in attributedString.append(bulletItem) }

  return attributedString
}

internal func addOnNeedsConversion(project: Project) -> Bool {
  return project.stats.needsConversion
}

internal func addOnPillValues(project: Project, reward: Reward) -> [String] {
  return [
    addOnTimeLeftString(project: project, reward: reward),
    addOnRemainingString(project: project, reward: reward),
    addOnLimitPerBackerString(project: project, reward: reward)
  ]
  .compact()
}

private func addOnTimeLeftString(project: Project, reward: Reward) -> String? {
  let isUnlimitedOrAvailable = reward.limit == nil || reward.remaining ?? 0 > 0

  if let endsAt = reward.endsAt,
     let deadline = project.dates.deadline,
     endsAt > 0,
     endsAt >= AppEnvironment.current.dateType.init().timeIntervalSince1970,
     isUnlimitedOrAvailable {
    let (time, unit) = Format.duration(
      secondsInUTC: min(endsAt, deadline),
      abbreviate: true,
      useToGo: false
    )

    return Strings.Time_left_left(time_left: time + " " + unit)
  }

  return nil
}

private func addOnLimitPerBackerString(project: Project, reward: Reward) -> String? {
  guard
    let limitPerBacker = rewardLimitPerBackerRemainingForBacker(project: project, reward: reward),
    limitPerBacker > 0
  else { return nil }

  return Strings.limit_limit_per_backer(limit_per_backer: "\(limitPerBacker)")
}

private func addOnRemainingString(project: Project, reward: Reward) -> String? {
  guard
    let limit = reward.limit,
    let remaining = rewardLimitRemainingForBacker(project: project, reward: reward),
    remaining > 0
  else { return nil }

  return Strings.remaining_count_left_of_limit_count(
    remaining_count: "\(remaining)",
    limit_count: "\(limit)"
  )
}

