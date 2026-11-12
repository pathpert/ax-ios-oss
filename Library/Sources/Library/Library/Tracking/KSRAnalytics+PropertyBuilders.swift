import Foundation
import KsApi

// MARK: - Project & Commerce Property Builders

/// Helper definitions for `projectProperties` in `KSRAnalytics+PropertyBuilders.swift`.
internal func projectProperties(
  from project: any ProjectAnalyticsProperties,
  loggedInUser: User? = nil,
  dateType: DateProtocol.Type = AppEnvironment.current.dateType,
  isBacker: Bool = false,
  calendar: Calendar = AppEnvironment.current.calendar,
  prefix: String = "project_"
) -> AnalyticsPropertyBag {
  var props = AnalyticsPropertyBag()

  props["backers_count"] = project.statsBackerCount
  props["subcategory"] = project.categoryAnalyticsName
  props["country"] = project.countryCode
  props["comments_count"] = project.statsCommentsCount ?? 0
  props["currency"] = project.statsCurrency
  props["creator_uid"] = project.creatorId
  props["deadline"] = project.datesDeadline?.toISO8601DateTimeString()
  props["has_add_ons"] = project.hasAddOns
  props["launched_at"] = project.datesLaunchedAt?.toISO8601DateTimeString()
  props["name"] = project.name
  props["pid"] = String(project.id)
  props["category"] = project.categoryParentAnalyticsName
  props["category_id"] = project.categoryParentId
  props["percent_raised"] = project.statsPercentFunded
  props["current_pledge_amount"] = project.statsPledged
  props["current_amount_pledged_usd"] = rounded(project.statsTotalAmountPledgedUsdCurrency ?? 0, places: 2)
  props["goal_usd"] = rounded(project.statsGoalUsdCurrency ?? 0, places: 2)
  props["has_video"] = project.hasVideo
  props["prelaunch_activated"] = project.prelaunchActivated
  props["rewards_count"] = project.rewardsCount
  props["tags"] = project.tags?.joined(separator: ", ")
  props["updates_count"] = project.statsUpdatesCount
  props["is_repeat_creator"] = project.creatorIsRepeatCreator ?? false
  props["late_pledge_enabled"] = project.postCampaignPledgingEnabled
  props["state"] = project.isInPostCampaignPledgingPhase
    ? "post_campaign"
    : project.stateValue

  let now = dateType.init().date
  props["hours_remaining"] = project.datesHoursRemaining(from: now, using: calendar)
  props["duration"] = project.datesDuration(using: calendar)

  var userProperties = AnalyticsPropertyBag()
  userProperties["has_watched"] = project.personalizationIsStarred

  // is_backer should be false in all situations except on a new pledge on the thanks page and when a user is viewing an existing pledge
  userProperties["is_backer"] = (project.personalizationIsBacking ?? false) || isBacker

  // Only send this property if the user is logged in
  if let loggedInUser = loggedInUser {
    userProperties["is_project_creator"] = project.creatorId == String(loggedInUser.id)
  }

  let userProps = userProperties.prefixedKeys("user_")

  return props
    .withAllValuesFrom(userProps)
    .prefixedKeys(prefix)
}

internal func pledgeProperties(from reward: Reward, prefix: String = "pledge_backer_reward_")
  -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  if let items = reward.rewardsItems {
    result["has_items"] = !items.isEmpty
  } else {
    assertionFailure("Expected items to be fetched for the reward by the time the backer is making a pledge.")
  }

  result["id"] = reward.id
  result["minimum"] = reward.minimum

  return result.prefixedKeys(prefix)
}

internal func checkoutProperties(
  from data: KSRAnalytics.CheckoutPropertiesData,
  and reward: Reward? = nil,
  prefix: String = "checkout_"
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["amount_total_usd"] = data.revenueInUsd
  result["add_ons_count_total"] = data.addOnsCountTotal
  result["add_ons_count_unique"] = data.addOnsCountUnique
  result["add_ons_minimum_usd"] = rounded(data.addOnsMinimumUsd, places: 2)
  result["bonus_amount_usd"] = data.bonusAmountInUsd
  result["id"] = data.checkoutId
  result["payment_type"] = data.paymentType
  result["reward_estimated_delivery_on"] = data.estimatedDelivery?.toISO8601DateTimeString()
  result["reward_id"] = data.rewardId
  result["reward_is_limited_quantity"] = reward?.isLimitedQuantity
  result["reward_is_limited_time"] = reward?.isLimitedTime
  result["reward_minimum_usd"] = data.rewardMinimumUsd
  result["reward_shipping_enabled"] = data.shippingEnabled
  result["reward_shipping_preference"] = reward?.shipping.preference?.trackingString
  result["reward_title"] = data.rewardTitle
  result["shipping_amount_usd"] = rounded(data.shippingAmountUsd ?? 0, places: 2)
  result["user_has_eligible_stored_apple_pay_card"] = data.userHasStoredApplePayCard

  return result.prefixedKeys(prefix)
}

internal func discoveryProperties(
  from params: DiscoveryParams,
  results: Int? = nil,
  prefix: String = "discover_"
) -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  // NB: All filters should be added here since `result["everything"]` is derived from this.

  // If a `Category`'s `parent` field is nil, use the `Category`'s name.
  result["category_name"] = params.category?.parent?.analyticsName ?? params.category?.analyticsName
  result["recommended"] = params.recommended
  result["social"] = params.social
  result["pwl"] = params.staffPicks
  result["watched"] = params.starred
  let categoryProps = params.category.map { properties(category: $0, prefix: "subcategory_") }
  let parentCategoryProps = params.category?.parent.map { properties(category: $0) }

  result = result
    .withAllValuesFrom(categoryProps ?? AnalyticsPropertyBag())
    .withAllValuesFrom(parentCategoryProps ?? AnalyticsPropertyBag())

  result["everything"] = result.isEmpty
  result["sort"] = params.sort?.trackingString
  result["ref_tag"] = RefTag.fromParams(params).stringTag
  result["search_term"] = params.query
  result["search_results_count"] = results

  return result.prefixedKeys(prefix)
}

private func properties(category: KsApi.Category, prefix: String = "category_") -> AnalyticsPropertyBag {
  var result = AnalyticsPropertyBag()

  result["id"] = category.intID
  result["name"] = category.analyticsName

  return result.prefixedKeys(prefix)
}

extension Reward.Shipping.Preference {
  fileprivate var trackingString: String {
    switch self {
    case .local: return "local"
    case .none: return "none"
    case .restricted: return "restricted"
    case .unrestricted: return "unrestricted"
    }
  }
}

