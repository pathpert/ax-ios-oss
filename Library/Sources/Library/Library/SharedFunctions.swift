import KDS
import KsApi
import Prelude
import ReactiveSwift
import UIKit
import UserNotifications

/// Determines if the personalization data in `project` implies that the current user is backing `reward`.
/// - parameter reward: A reward tier.
/// - parameter project: A project model.
/// - returns: `true` when the user's active backing matches `reward`.
public func userIsBacking(reward: Reward, inProject project: Project) -> Bool {
  guard let backing = project.personalization.backing else { return false }

  return backing.reward?.id == reward.id
    || backing.rewardId == reward.id
    || (backing.reward == nil && backing.rewardId == nil && reward == Reward.noReward)
}

/**
 Determines if the personalization data in the project implies that the current user is backing the
 project passed in.

 - parameter project: A project.

 - returns: A boolean.
 */
internal func userIsBackingProject(_ project: Project) -> Bool {
  return project.personalization.backing != nil || project.personalization.isBacking == .some(true)
}

/// Determines if the current signed-in user is the creator of `project`.
/// - parameter project: A project model.
/// - returns: `true` if `project.creator.id` equals the signed-in user's ID.
public func currentUserIsCreator(of project: Project) -> Bool {
  guard let user = AppEnvironment.current.currentUser else { return false }

  return project.creator.id == user.id
}

/**
 Returns a reward from a backing in a given project

 - parameter backing: A backing
 - parameter project: A project

 - returns: A reward
 */

internal func reward(from backing: Backing, inProject project: Project) -> Reward {
  if let backingReward = backing.reward {
    return backingReward
  }

  guard let rewardId = backing.rewardId else { return Reward.noReward }

  return reward(withId: rewardId, inProject: project)
}

/**
 Returns a reward for a backing ID in a given project

 - parameter backing: A backing ID
 - parameter project: A project

 - returns: A reward
 */

internal func reward(withId rewardId: Int, inProject project: Project) -> Reward {
  let noRewardFromProject = project.rewards.first { $0.id == Reward.noReward.id }

  return project.rewards.first { $0.id == rewardId }
    ?? noRewardFromProject
    ?? Reward.noReward
}

/**
 Computes the minimum and maximum amounts that can be pledge to a reward. For the "no reward" reward,
 this looks up values in the table of launched countries, since the values depend on the currency.

 - parameter project: A project.
 - parameter reward:  A reward.

 - returns: A pair of the minimum and maximum amount that can be pledged to a reward.
 */
internal func minAndMaxPledgeAmount(forProject project: Project, reward: Reward?)
  -> (min: Double, max: Double) {
  // The country on the project cannot be trusted to have the min/max values, so first try looking
  // up the country in our launched countries array that we get back from the server config.
  // project currency is more accurate to find the country to base the min/max values off of.
  let projectCurrencyCountry = projectCountry(forCurrency: project.stats.projectCurrency) ?? project.country
  let country = AppEnvironment.current.launchedCountries.countries
    .first { $0 == projectCurrencyCountry }
    .coalesceWith(projectCurrencyCountry)

  switch reward {
  case .none, .some(Reward.noReward):
    return (Double(country.minPledge ?? 1), Double(country.maxPledge ?? 10_000))
  case let .some(reward):
    guard let backing = project.personalization.backing else {
      return (reward.minimum, Double(country.maxPledge ?? 10_000))
    }

    let min: Double

    /// Account for the case where the originally selected reward pricing, for this backing, has since changed to late pledge pricing. We should always use the original pricing at the time of the backing over the most current state.
    if backing.isLatePledge == true {
      min = reward.latePledgeAmount > 0 ? reward.latePledgeAmount : reward.minimum
    } else {
      min = reward.pledgeAmount > 0 ? reward.pledgeAmount : reward.minimum
    }

    return (min, Double(country.maxPledge ?? 10_000))
  }
}

/**
 Computes the minimum amount needed to pledge to a reward. For the "no reward" reward,
 this looks up values in the table of launched countries, since the values depend on the currency.

 - parameter project: A project.
 - parameter reward:  A reward.

 - returns: The minimum amount needed to pledge to the reward.
 */
internal func minPledgeAmount(forProject project: Project, reward: Reward?) -> Double {
  return minAndMaxPledgeAmount(forProject: project, reward: reward).min
}


/// Clears the current user's unseen activity count and returns the updated `User` signal.
/// Never completes with an error (`SignalProducer<User, Never>`).
public func updatedUserWithClearedActivityCountProducer() -> SignalProducer<User, Never> {
  return AppEnvironment.current.apiService.clearUserUnseenActivity(input: .init())
    .filter { _ in AppEnvironment.current.currentUser != nil }
    .map { $0.activityIndicatorCount }
    .map { count in AppEnvironment.current.currentUser ?|> User.lens.unseenActivityCount .~ count }
    .skipNil()
    .demoteErrors()
}


internal func classNameWithoutModule(_ class: AnyClass) -> String {
  return `class`
    .description()
    .components(separatedBy: ".")
    .dropFirst()
    .joined(separator: ".")
}


/// Returns a unique device identifier string scoped to the given UUID generator and environment.
/// Reads from the keychain/user defaults store in `env` and must not be blank in production analytics.
public func deviceIdentifier(uuid: UUIDType, env: Environment = AppEnvironment.current) -> String {
  guard let identifier = env.device.identifierForVendor else {
    return uuid.uuidString
  }

  return identifier.uuidString
}


/// Returns the standard background color used by discovery collection views.
public func discoveryPageBackgroundColor() -> UIColor {
  return LegacyColors.ksr_white.uiColor()
}


/// Rounds a `Double` value to the specified number of decimal `places` using plain decimal rounding.
public func rounded(_ value: Double, places: Int16) -> Decimal {
  let roundingBehavior = NSDecimalNumberHandler(
    roundingMode: .bankers,
    scale: places,
    raiseOnExactness: true,
    raiseOnOverflow: true,
    raiseOnUnderflow: true,
    raiseOnDivideByZero: true
  )

  return NSDecimalNumber(value: value).rounding(accordingToBehavior: roundingBehavior) as Decimal
}


/// Rounds a `Float` value to the specified number of decimal `places` using plain decimal rounding.
public func rounded(_ value: Float, places: Int16) -> Decimal {
  let roundingBehavior = NSDecimalNumberHandler(
    roundingMode: .bankers,
    scale: places,
    raiseOnExactness: true,
    raiseOnOverflow: true,
    raiseOnUnderflow: true,
    raiseOnDivideByZero: true
  )

  return NSDecimalNumber(value: value).rounding(accordingToBehavior: roundingBehavior) as Decimal
}


/// Determines the section header height for the pledge summary table view in checkout screens.
/// - parameter sectionIdentifier: A `PledgeRewardsSummarySection?` section identifier.
/// - returns: A `CGFloat` height (`0` to suppress the header, or `UITableView.automaticDimension`).
public func heightForHeaderInPledgeSummarySection(sectionIdentifier: PledgeRewardsSummarySection?)
  -> CGFloat {
  guard let section = sectionIdentifier else {
    return UITableView.automaticDimension
  }

  /// Hides the first section header because we're using our own custom UITableCell.
  let shouldHideSectionHeader = section == .header || section == .shipping || section == .bonusSupport
  return shouldHideSectionHeader ? 0 : UITableView.automaticDimension
}
