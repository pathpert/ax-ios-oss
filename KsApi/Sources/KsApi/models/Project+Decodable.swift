import Foundation

extension Project: Decodable {
  enum CodingKeys: String, CodingKey {
    case availableCardTypes = "available_card_types"
    case blurb
    case category
    case creator
    case displayPrelaunch = "display_prelaunch"
    case flagging
    case id
    case lastWave
    case location
    case name
    case photo
    case pledgeManager
    case pledgeOverTimeCollectionPlanChargeExplanation = "pledge_over_time_collection_plan_charge_explanation"
    case pledgeOverTimeCollectionPlanChargedAsNPayments =
      "pledge_over_time_collection_plan_charged_as_n_payments"
    case pledgeOverTimeCollectionPlanShortPitch = "pledge_over_time_collection_plan_short_pitch"
    case pledgeOverTimeMinimumExplanation = "pledge_over_time_minimum_explanation"
    case isInPostCampaignPledgingPhase = "is_in_post_campaign_pledging_phase"
    case postCampaignPledgingEnabled = "post_campaign_pledging_enabled"
    case prelaunchActivated = "prelaunch_activated"
    case redemptionPageUrl
    case sendMetaCapiEvents = "send_meta_capi_events"
    case slug
    case staffPick = "staff_pick"
    case state
    case tags
    case urls
    case video
    case isPledgeOverTimeAllowed
  }

  /// Decodes `Project` from REST API JSON (`snake_case` and `camelCase` mixed keys).
  ///
  /// Negative Constraint: Do not pass GraphQL fragment payloads directly; use `Project+ProjectFragment` adapters.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.availableCardTypes = try values.decodeIfPresent([String].self, forKey: .availableCardTypes)
    self.blurb = try values.decode(String.self, forKey: .blurb)
    self.category = try values.decode(Category.self, forKey: .category)
    self.country = try Project.Country(from: decoder)
    self.creator = try values.decode(User.self, forKey: .creator)
    self.memberData = try Project.MemberData(from: decoder)
    self.dates = try Project.Dates(from: decoder)
    self.displayPrelaunch = try values.decodeIfPresent(Bool.self, forKey: .displayPrelaunch)
    self.extendedProjectProperties = nil
    self.flagging = try values.decodeIfPresent(Bool.self, forKey: .flagging) ?? false
    self.id = try values.decode(Int.self, forKey: .id)
    self.lastWave = try values.decodeIfPresent(LastWave.self, forKey: .lastWave)
    self.location = (try? values.decodeIfPresent(Location.self, forKey: .location)) ?? Location.none
    self.name = try values.decode(String.self, forKey: .name)
    self.personalization = try Project.Personalization(from: decoder)
    self.photo = try values.decode(Photo.self, forKey: .photo)
    self.isInPostCampaignPledgingPhase =
      try values.decodeIfPresent(Bool.self, forKey: .isInPostCampaignPledgingPhase) ?? false
    self.pledgeManager = try values.decodeIfPresent(PledgeManager.self, forKey: .pledgeManager)
    self.pledgeOverTimeCollectionPlanChargeExplanation = try values.decodeIfPresent(
      String.self,
      forKey: .pledgeOverTimeCollectionPlanChargeExplanation
    ) ?? ""
    self.pledgeOverTimeCollectionPlanChargedAsNPayments = try values.decodeIfPresent(
      String.self,
      forKey: .pledgeOverTimeCollectionPlanChargedAsNPayments
    ) ?? ""
    self.pledgeOverTimeCollectionPlanShortPitch = try values.decodeIfPresent(
      String.self,
      forKey: .pledgeOverTimeCollectionPlanShortPitch
    ) ?? ""
    self.pledgeOverTimeMinimumExplanation = try values.decodeIfPresent(
      String.self,
      forKey: .pledgeOverTimeMinimumExplanation
    ) ?? ""
    self.postCampaignPledgingEnabled =
      try values.decodeIfPresent(Bool.self, forKey: .postCampaignPledgingEnabled) ?? false
    self.prelaunchActivated = try values.decodeIfPresent(Bool.self, forKey: .prelaunchActivated)
    self.redemptionPageUrl = try values.decodeIfPresent(String.self, forKey: .redemptionPageUrl) ?? ""
    self.rewardData = try Project.RewardData(from: decoder)
    self.sendMetaCapiEvents = try values.decodeIfPresent(Bool.self, forKey: .sendMetaCapiEvents) ?? false
    self.slug = try values.decode(String.self, forKey: .slug)
    self.staffPick = try values.decode(Bool.self, forKey: .staffPick)
    self.state = try values.decode(State.self, forKey: .state)
    self.stats = try Project.Stats(from: decoder)
    self.tags = try values.decodeIfPresent([String].self, forKey: .tags)
    self.urls = try values.decode(UrlsEnvelope.self, forKey: .urls)
    self.video = try values.decodeIfPresent(Video.self, forKey: .video)
    self.watchesCount = nil
    self.isPledgeOverTimeAllowed =
      try values.decodeIfPresent(Bool.self, forKey: .isPledgeOverTimeAllowed)
  }
}

extension Project.MemberData: Decodable {
  enum CodingKeys: String, CodingKey {
    case lastUpdatePublishedAt = "last_update_published_at"
    case permissions
    case unreadMessagesCount = "unread_messages_count"
    case unseenActivityCount = "unseen_activity_count"
  }

  /// Decodes `Project.MemberData` and strips unrecognized permission cases.
  ///
  /// Negative Constraint: Do not use directly to authorize creator actions; rely on `permissions` non-empty checks or server enforcement.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.lastUpdatePublishedAt = try values.decodeIfPresent(TimeInterval.self, forKey: .lastUpdatePublishedAt)
    self.permissions = removeUnknowns(try values.decodeIfPresent([Permission].self, forKey: .permissions) ?? [])
    self.unreadMessagesCount = try values.decodeIfPresent(Int.self, forKey: .unreadMessagesCount)
    self.unseenActivityCount = try values.decodeIfPresent(Int.self, forKey: .unseenActivityCount)
  }
}

extension Project.RewardData: Decodable {
  enum CodingKeys: String, CodingKey {
    case addOns = "add_ons"
    case rewards
  }

  /// Decodes `Project.RewardData` (`add_ons` and `rewards`, defaulting `rewards` to `[]`).
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.addOns = try values.decodeIfPresent([Reward].self, forKey: .addOns)
    self.rewards = try values.decodeIfPresent([Reward].self, forKey: .rewards) ?? []
  }
}

extension Project.Photo: Decodable {
  enum CodingKeys: String, CodingKey {
    case full
    case med
    case size1024x768 = "1024x768"
    case size1024x576 = "1024x576"
    case small
  }

  /// Decodes `Project.Photo` sizes, falling back between `1024x768` and `1024x576`.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.full = try values.decode(String.self, forKey: .full)
    self.med = try values.decode(String.self, forKey: .med)
    self.size1024x768 = try values
      .decodeIfPresent(String.self, forKey: .size1024x768) ??
      (try values.decodeIfPresent(String.self, forKey: .size1024x576))
    self.small = try values.decode(String.self, forKey: .small)
  }
}

extension Project.MemberData.Permission: Decodable {
  /// Decodes a `Project.MemberData.Permission` from a single raw string, mapping unknown cases to `.unknown`.
  public init(from decoder: Decoder) throws {
    self = try Project.MemberData
      .Permission(rawValue: decoder.singleValueContainer().decode(RawValue.self)) ?? .unknown
  }
}

private func removeUnknowns(_ xs: [Project.MemberData.Permission]) -> [Project.MemberData.Permission] {
  return xs.filter { $0 != .unknown }
}

