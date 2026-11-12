import Foundation
import Prelude

extension Lens where Whole == Project, Part == User {
  /// Composed lens from `Project` to the creator's `User.Avatar`.
  public var avatar: Lens<Project, User.Avatar> {
    return Project.lens.creator .. User.lens.avatar
  }

  /// Composed lens from `Project` to the creator's numeric user ID.
  public var id: Lens<Project, Int> {
    return Project.lens.creator .. User.lens.id
  }

  /// Composed lens from `Project` to the creator's display name.
  public var name: Lens<Project, String> {
    return Project.lens.creator .. User.lens.name
  }
}

extension Lens where Whole == Project, Part == Project.Stats {
  /// Composed lens from `Project` to total backer count.
  public var backersCount: Lens<Project, Int> {
    return Project.lens.stats .. lens(\Project.Stats.backersCount)
  }

  /// Composed lens from `Project` to public comment count.
  public var commentsCount: Lens<Project, Int?> {
    return Project.lens.stats .. lens(\Project.Stats.commentsCount)
  }

  /// Composed lens from `Project` to viewer-currency converted pledged total.
  public var convertedPledgedAmount: Lens<Project, Float?> {
    return Project.lens.stats .. lens(\Project.Stats.convertedPledgedAmount)
  }

  /// Composed lens from `Project` to native project ISO currency code.
  public var projectCurrency: Lens<Project, String> {
    return Project.lens.stats .. lens(\Project.Stats.projectCurrency)
  }

  /// Composed lens from `Project` to viewer preferred ISO currency code.
  public var userCurrency: Lens<Project, String?> {
    return Project.lens.stats .. lens(\Project.Stats.userCurrency)
  }

  /// Composed lens from `Project` to viewer currency exchange multiplier.
  public var userCurrencyRate: Lens<Project, Float?> {
    return Project.lens.stats .. lens(\Project.Stats.userCurrencyRate)
  }

  /// Composed lens from `Project` to funding goal in native project currency.
  public var goal: Lens<Project, Int> {
    return Project.lens.stats .. lens(\Project.Stats.goal)
  }

  /// Composed lens from `Project` to total amount pledged in native project currency.
  public var pledged: Lens<Project, Int> {
    return Project.lens.stats .. lens(\Project.Stats.pledged)
  }

  /// Composed lens from `Project` to static USD conversion rate.
  public var staticUsdRate: Lens<Project, Float> {
    return Project.lens.stats .. lens(\Project.Stats.staticUsdRate)
  }

  /// Composed lens from `Project` to project update count.
  public var updatesCount: Lens<Project, Int?> {
    return Project.lens.stats .. lens(\Project.Stats.updatesCount)
  }

  /// Composed lens from `Project` to live USD exchange rate.
  public var usdExchangeRate: Lens<Project, Float?> {
    return Project.lens.stats .. lens(\Project.Stats.usdExchangeRate)
  }

  /// Composed lens from `Project` to computed funding progress ratio.
  public var fundingProgress: Lens<Project, Float> {
    return Project.lens.stats .. Project.Stats.lens.fundingProgress
  }
}

extension Lens where Whole == Project, Part == Project.MemberData {
  /// Composed lens from `Project` to timestamp of the latest published project update.
  public var lastUpdatePublishedAt: Lens<Project, TimeInterval?> {
    return Project.lens.memberData .. Project.MemberData.lens.lastUpdatePublishedAt
  }

  /// Composed lens from `Project` to creator unread message count.
  public var unreadMessagesCount: Lens<Project, Int?> {
    return Project.lens.memberData .. Project.MemberData.lens.unreadMessagesCount
  }

  /// Composed lens from `Project` to creator unseen activity count.
  public var unseenActivityCount: Lens<Project, Int?> {
    return Project.lens.memberData .. Project.MemberData.lens.unseenActivityCount
  }

  /// Composed lens from `Project` to the viewer's collaborator permission roles.
  public var permissions: Lens<Whole, [Project.MemberData.Permission]> {
    return Whole.lens.memberData .. Part.lens.permissions
  }
}

extension Lens where Whole == Project, Part == Project.Dates {
  /// Composed lens from `Project` to campaign deadline timestamp.
  public var deadline: Lens<Project, TimeInterval?> {
    return Project.lens.dates .. Project.Dates.lens.deadline
  }

  /// Composed lens from `Project` to campaign featured timestamp.
  public var featuredAt: Lens<Project, TimeInterval?> {
    return Project.lens.dates .. Project.Dates.lens.featuredAt
  }

  /// Composed lens from `Project` to campaign launch timestamp.
  public var launchedAt: Lens<Project, TimeInterval?> {
    return Project.lens.dates .. Project.Dates.lens.launchedAt
  }

  /// Composed lens from `Project` to timestamp of last state transition.
  public var stateChangedAt: Lens<Project, TimeInterval> {
    return Project.lens.dates .. Project.Dates.lens.stateChangedAt
  }
}

extension Lens where Whole == Project, Part == Project.Personalization {
  /// Composed lens from `Project` to the viewer's `Backing` record.
  public var backing: Lens<Project, Backing?> {
    return Project.lens.personalization .. Project.Personalization.lens.backing
  }

  /// Composed lens from `Project` to friends who also backed the campaign.
  public var friends: Lens<Project, [User]?> {
    return Project.lens.personalization .. Project.Personalization.lens.friends
  }

  /// Composed lens from `Project` to whether the viewer is backing this campaign.
  public var isBacking: Lens<Project, Bool?> {
    return Project.lens.personalization .. Project.Personalization.lens.isBacking
  }

  /// Composed lens from `Project` to whether the viewer saved/starred this campaign.
  public var isStarred: Lens<Project, Bool?> {
    return Project.lens.personalization .. Project.Personalization.lens.isStarred
  }
}

extension Lens where Whole == Project, Part == Project.RewardData {
  /// Composed lens from `Project` to available add-on rewards.
  public var addOns: Lens<Project, [Reward]?> {
    return Project.lens.rewardData .. Project.RewardData.lens.addOns
  }

  /// Composed lens from `Project` to main reward tiers.
  public var rewards: Lens<Project, [Reward]> {
    return Project.lens.rewardData .. Project.RewardData.lens.rewards
  }
}

extension Lens where Whole == Project, Part == Project.Photo {
  /// Composed lens from `Project` to full-resolution cover photo URL.
  public var full: Lens<Project, String> {
    return Project.lens.photo .. Project.Photo.lens.full
  }

  /// Composed lens from `Project` to medium cover photo URL.
  public var med: Lens<Project, String> {
    return Project.lens.photo .. Project.Photo.lens.med
  }

  /// Composed lens from `Project` to 1024x768 cover photo URL.
  public var size1024x768: Lens<Project, String?> {
    return Project.lens.photo .. Project.Photo.lens.size1024x768
  }

  /// Composed lens from `Project` to small thumbnail cover photo URL.
  public var small: Lens<Project, String> {
    return Project.lens.photo .. Project.Photo.lens.small
  }
}

extension Lens where Whole == Project, Part == Project.UrlsEnvelope {
  /// Composed lens from `Project` to nested web URLs envelope.
  public var web: Lens<Whole, Project.UrlsEnvelope.WebEnvelope> {
    return Whole.lens.urls .. Part.lens.web
  }
}

extension Lens where Whole == Project, Part == Project.UrlsEnvelope.WebEnvelope {
  /// Composed lens from `Project` to canonical project web URL.
  public var project: Lens<Whole, String> {
    return Whole.lens.urls.web .. Part.lens.project
  }
}

