import Foundation
import GraphAPI
@testable import KsApi
import Prelude

/// Legacy dictionary-encoding test protocol preserved only for `KsApiTests` compatibility.
public protocol EncodableType {
  /// Encodes the model into a flat test inspection dictionary.
  func encode() -> [String: Any]
}

public extension EncodableType {
  /// Serializes the encoded dictionary to JSON `Data`.
  func toJSONData() -> Data? {
    return try? JSONSerialization.data(withJSONObject: self.encode(), options: [])
  }

  /// Serializes the encoded dictionary to a UTF-8 JSON `String`.
  func toJSONString() -> String? {
    return self.toJSONData().flatMap { String(data: $0, encoding: .utf8) }
  }
}

extension Encodable {
  /// Encodes an `Encodable` value via `JSONEncoder` and deserializes it as a dictionary for unit test assertions.
  internal var dictionaryRepresentation: [String: Any]? {
    guard let data = try? JSONEncoder().encode(self) else { return nil }
    return (try? JSONSerialization.jsonObject(with: data, options: .allowFragments))
      .flatMap { $0 as? [String: Any] }
  }
}

extension GraphMutationInput {
  /// Converts this `Encodable` mutation input into a dictionary for legacy unit tests.
  public func toInputDictionary() -> [String: Any] {
    return self.dictionaryRepresentation ?? [:]
  }
}

extension KsApi.CreateFlaggingInput {
  /// Returns raw dictionary fields preserving `GraphAPI.NonDeprecatedFlaggingKind` for unit tests.
  public func toInputDictionary() -> [String: Any] {
    return [
      "contentId": self.contentId,
      "kind": self.kind,
      "details": self.details as Any,
      "clientMutationId": self.clientMutationId as Any
    ]
  }
}

extension KsApi.CreateSetupIntentInput {
  /// Returns nullable dictionary fields for setup intent unit tests.
  public func toInputDictionary() -> [String: Any?] {
    return [
      "projectId": self.projectId,
      "setupIntentContext": self.setupIntentContext
    ]
  }
}

extension KsApi.TriggerThirdPartyEventInput {
  /// Returns raw dictionary fields preserving `GraphAPI.AppDataInput` for unit tests.
  public func toInputDictionary() -> [String: Any] {
    return [
      "deviceId": self.deviceId,
      "eventName": self.eventName,
      "projectId": self.projectId,
      "pledgeAmount": self.pledgeAmount as Any,
      "shipping": self.shipping as Any,
      "transactionId": self.transactionId as Any,
      "userId": self.userId as Any,
      "appData": self.appData as Any,
      "clientMutationId": self.clientMutationId
    ]
  }
}

extension Config: EncodableType {
  /// Encodes `Config` into a dictionary for legacy `ConfigTests` round-trip assertions.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["ab_experiments"] = self.abExperiments
    result["app_id"] = self.appId
    result["apple_pay_countries"] = self.applePayCountries
    result["country_code"] = self.countryCode
    result["features"] = self.features
    result["itunes_link"] = self.iTunesLink
    result["launched_countries"] = self.launchedCountries.map { $0.encode() }
    result["locale"] = self.locale
    result["stripe"] = ["publishable_key": self.stripePublishableKey]
    return result
  }
}

extension Location: EncodableType {
  /// Encodes `Location` into a dictionary for legacy `LocationTests` round-trip assertions.
  public func encode() -> [String: Any] {
    return [
      "country": self.country,
      "displayable_name": self.displayableName,
      "id": self.id,
      "localized_name": self.localizedName,
      "name": self.name
    ]
  }
}

extension Project.Country: EncodableType {
  /// Encodes `Project.Country` into a dictionary for legacy `CountryTests` assertions.
  public func encode() -> [String: Any] {
    return [
      "country": self.countryCode,
      "currency": self.currencyCode,
      "currency_symbol": self.currencySymbol,
      "currency_trailing_code": self.trailingCode
    ]
  }
}

extension User.Avatar: EncodableType {
  /// Encodes `User.Avatar` into a dictionary for legacy `UserTests`.
  public func encode() -> [String: Any] {
    var ret: [String: Any] = ["medium": self.medium, "small": self.small]
    ret["large"] = self.large
    return ret
  }
}

extension User.NewsletterSubscriptions: EncodableType {
  /// Encodes `User.NewsletterSubscriptions` into a dictionary for legacy unit tests.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["arts_culture_newsletter"] = self.arts
    result["games_newsletter"] = self.games
    result["happening_newsletter"] = self.happening
    result["invent_newsletter"] = self.invent
    result["promo_newsletter"] = self.promo
    result["weekly_newsletter"] = self.weekly
    result["film_newsletter"] = self.films
    result["publishing_newsletter"] = self.publishing
    result["alumni_newsletter"] = self.alumni
    result["music_newsletter"] = self.music
    return result
  }
}

extension User.Notifications: EncodableType {
  /// Encodes `User.Notifications` into a dictionary for legacy unit tests.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["notify_of_backings"] = self.backings
    result["notify_of_comment_replies"] = self.commentReplies
    result["notify_of_comments"] = self.comments
    result["notify_of_creator_digest"] = self.creatorDigest
    result["notify_of_creator_edu"] = self.creatorTips
    result["notify_of_follower"] = self.follower
    result["notify_of_friend_activity"] = self.friendActivity
    result["notify_of_messages"] = self.messages
    result["notify_mobile_of_comments"] = self.mobileComments
    result["notify_mobile_of_follower"] = self.mobileFollower
    result["notify_mobile_of_friend_activity"] = self.mobileFriendActivity
    result["notify_mobile_of_marketing_update"] = self.mobileMarketingUpdate
    result["notify_mobile_of_messages"] = self.mobileMessages
    result["notify_mobile_of_post_likes"] = self.mobilePostLikes
    result["notify_mobile_of_updates"] = self.mobileUpdates
    result["notify_of_post_likes"] = self.postLikes
    result["notify_of_updates"] = self.updates
    result["notify_mobile_of_backings"] = self.mobileBackings
    return result
  }
}

extension User.Stats: EncodableType {
  /// Encodes `User.Stats` into a dictionary for legacy unit tests.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["backed_projects_count"] = self.backedProjectsCount
    result["created_projects_count"] = self.createdProjectsCount
    result["draft_projects_count"] = self.draftProjectsCount
    result["member_projects_count"] = self.memberProjectsCount
    result["starred_projects_count"] = self.starredProjectsCount
    result["unanswered_surveys_count"] = self.unansweredSurveysCount
    result["unread_messages_count"] = self.unreadMessagesCount
    return result
  }
}

extension User: EncodableType {
  /// Encodes `User` into a dictionary for legacy `UserTests` assertions.
  public func encode() -> [String: Any] {
    var result: [String: Any] = [:]
    result["avatar"] = self.avatar.encode()
    result["chosen_currency"] = self.chosenCurrency
    result["facebook_connected"] = self.facebookConnected ?? false
    result["id"] = self.id
    result["is_admin"] = self.isAdmin ?? false
    result["is_email_verified"] = self.isEmailVerified ?? false
    result["is_friend"] = self.isFriend ?? false
    result["isBlocked"] = self.isBlocked ?? false
    result["location"] = self.location?.encode()
    result["name"] = self.name
    result["needs_password"] = self.needsPassword ?? false
    result["opted_out_of_recommendations"] = self.optedOutOfRecommendations ?? false
    result["social"] = self.social ?? false
    result["show_public_profile"] = self.showPublicProfile ?? false
    result = result.withAllValuesFrom(self.newsletters.encode())
    result = result.withAllValuesFrom(self.notifications.encode())
    result = result.withAllValuesFrom(self.stats.encode())
    return result
  }
}

