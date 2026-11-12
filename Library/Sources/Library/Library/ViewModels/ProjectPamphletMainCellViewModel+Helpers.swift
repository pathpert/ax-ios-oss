import KDS
import KsApi
import UIKit

/// Helper definitions for `statsStackViewAccessibilityLabelForProperties` in `ProjectPamphletMainCellViewModel+Helpers.swift`.
func statsStackViewAccessibilityLabelForProperties(
  _ properties: ProjectPamphletMainCellProperties,
  needsConversion: Bool
) -> String {
  let projectCurrencyData = pledgeAmountAndGoalAndCountry(
    forProperties: properties,
    needsConversion: needsConversion
  )

  let pledged = Format.currency(
    projectCurrencyData.pledgedAmount,
    currencyCode: projectCurrencyData.currency,
    omitCurrencyCode: properties.omitUSCurrencyCode
  )
  let goal = Format.currency(
    projectCurrencyData.goalAmount,
    currencyCode: projectCurrencyData.currency,
    omitCurrencyCode: properties.omitUSCurrencyCode
  )

  let backersCount = properties.backersCount
  var (time, unit) = ("", "")

  if let deadline = properties.deadline {
    (time, unit) = Format.duration(secondsInUTC: deadline, useToGo: true)
  }

  let timeLeft = time + " " + unit

  return properties.state == .live
    ? Strings.dashboard_graphs_funding_accessibility_live_stat_value(
      pledged: pledged, goal: goal, backers_count: backersCount, time_left: timeLeft
    )
    : Strings.dashboard_graphs_funding_accessibility_non_live_stat_value(
      pledged: pledged, goal: goal, backers_count: backersCount, time_left: timeLeft
    )
}

func fundingStatus(forProperties properties: ProjectPamphletMainCellProperties) -> String {
  let date = Format.date(
    secondsInUTC: properties.stateChangedAt,
    dateStyle: .medium,
    timeStyle: .none
  )

  switch properties.state {
  case .canceled:
    return Strings.discovery_baseball_card_status_banner_canceled_date(date: date)
  case .failed:
    return Strings.creator_project_preview_subtitle_funding_unsuccessful_on_deadline(deadline: date)
  case .successful:
    return Strings.project_status_project_was_successfully_funded_on_deadline(deadline: date)
  case .suspended:
    return Strings.discovery_baseball_card_status_banner_suspended_date(date: date)
  case .live, .purged, .started, .submitted:
    return ""
  }
}

func pledgeAmountAndGoalAndCountry(
  forProperties properties: ProjectPamphletMainCellProperties,
  needsConversion: Bool
) -> ConvertedCurrrencyProjectData {
  guard needsConversion else {
    return (properties.pledged.amount, properties.goal.amount, properties.currency)
  }

  guard let goalCurrentCurrency = properties.goalCurrentCurrency,
        let pledgedCurrentCurrency = properties.convertedPledgedAmount,
        let userCurrency = properties.userCurrency else {
    return (Int(properties.pledgedUsd), Int(properties.goalUsd), Project.Country.us.currencyCode)
  }

  return (Int(pledgedCurrentCurrency), Int(goalCurrentCurrency), userCurrency)
}

func goalText(for properties: ProjectPamphletMainCellProperties, _ needsConversion: Bool) -> String {
  let projectCurrencyData = pledgeAmountAndGoalAndCountry(
    forProperties: properties,
    needsConversion: needsConversion
  )

  return Strings.activity_project_state_change_pledged_of_goal(
    goal: Format.currency(
      projectCurrencyData.goalAmount,
      currencyCode: projectCurrencyData.currency,
      omitCurrencyCode: properties.omitUSCurrencyCode
    )
  )
}

func pledgedText(
  for properties: ProjectPamphletMainCellProperties,
  _ needsConversion: Bool
) -> String {
  let projectCurrencyData = pledgeAmountAndGoalAndCountry(
    forProperties: properties,
    needsConversion: needsConversion
  )

  return Format.currency(
    projectCurrencyData.pledgedAmount,
    currencyCode: projectCurrencyData.currency,
    omitCurrencyCode: properties.omitUSCurrencyCode
  )
}

func conversionText(for properties: ProjectPamphletMainCellProperties) -> String {
  return Strings.discovery_baseball_card_stats_convert_from_pledged_of_goal(
    pledged: Format.currency(
      properties.pledged.amount,
      currencyCode: properties.currency,
      omitCurrencyCode: properties.omitUSCurrencyCode
    ),
    goal: Format.currency(
      properties.goal.amount,
      currencyCode: properties.currency,
      omitCurrencyCode: properties.omitUSCurrencyCode
    )
  )
}

func progressColor(forProperties properties: ProjectPamphletMainCellProperties) -> UIColor {
  switch properties.state {
  case .canceled, .failed, .suspended:
    return LegacyColors.ksr_support_400.uiColor()
  default:
    return LegacyColors.ksr_create_700.uiColor()
  }
}

