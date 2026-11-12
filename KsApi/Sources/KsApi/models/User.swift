import Foundation

/// Authenticated viewer or public Kickstarter user account model.
///
/// Format: Numeric `id` with nested `Avatar`, `NewsletterSubscriptions`, `Notifications`, and `Stats`.
/// Negative Constraint: Many profile/settings flags (`chosenCurrency`, `isEmailVerified`, `needsPassword`)
/// are omitted (`nil`) for other users when decoded outside `/v1/users/self`. Do not treat `nil` as `false`
/// unless explicitly defaulted.
public struct User {
  /// Profile picture image URLs (`small`, `medium`, optional `large`).
  public var avatar: Avatar
  /// Viewer's preferred display currency ISO 4217 code (e.g., `"USD"`, `"EUR"`). `nil` if unset.
  public var chosenCurrency: String?
  /// Count of the viewer's backings currently in `.errored` payment state (`nil` for non-self users).
  public var erroredBackingsCount: Int?
  /// `true` when a Facebook account is linked (`nil` when unqueried).
  public var facebookConnected: Bool?
  /// Unique numeric Kickstarter user identifier.
  /// Negative Constraint: Do not pass raw `id` where GraphQL relay `graphID` is expected.
  public var id: Int
  /// `true` if the user holds Kickstarter staff admin privileges.
  public var isAdmin: Bool?
  /// `true` once the user's primary email address has been verified.
  public var isEmailVerified: Bool?
  /// `true` if the viewer follows/friends this user (`nil` outside social endpoints).
  public var isFriend: Bool?
  /// `true` if this user has been blocked by the current viewer.
  public var isBlocked: Bool
  /// User-configured city/country `Location` (`nil` if hidden or unset).
  public var location: Location?
  /// Public display name of the user.
  public var name: String
  /// `true` if the user's linked Facebook OAuth token needs re-authorization.
  public var needsFreshFacebookToken: Bool?
  /// `true` when the account lacks a password (e.g., OAuth-only signup) and must set one before email changes.
  public var needsPassword: Bool?
  /// Email newsletter category opt-in preferences.
  public var newsletters: NewsletterSubscriptions
  /// Email and push notification opt-in preferences.
  public var notifications: Notifications
  /// `true` if the user opted out of personalized recommendations.
  public var optedOutOfRecommendations: Bool?
  /// `true` when the user's profile and backed projects are publicly visible.
  public var showPublicProfile: Bool?
  /// `true` when social friend activity sharing is enabled.
  public var social: Bool?
  /// Aggregate activity counters (`backedProjectsCount`, `createdProjectsCount`, etc.).
  public var stats: Stats
  /// Number of unseen creator/backer activity feed items (`nil` for non-self users).
  public var unseenActivityCount: Int?

  /// `true` when the user has created at least one Kickstarter project (`stats.createdProjectsCount > 0`).
  public var isCreator: Bool {
    return (self.stats.createdProjectsCount ?? 0) > 0
  }

  /// `true` if the user has created more than one project (`nil` when `createdProjectsCount` is unavailable).
  public var isRepeatCreator: Bool? {
    guard let createdProjectsCount = self.stats.createdProjectsCount else {
      return nil
    }

    return createdProjectsCount > 1
  }
}

extension User: Equatable {}
/// Compares two `User` values by their unique server `id`.
public func == (lhs: User, rhs: User) -> Bool {
  return lhs.id == rhs.id
}

extension User: CustomDebugStringConvertible {
  /// Concise debug summary containing the user's `id` and `name`.
  public var debugDescription: String {
    return "User(id: \(self.id), name: \"\(self.name)\")"
  }
}

extension User: Decodable {
  /// Decodes a `User` payload from the v1 REST or JSON decoder.
  /// - Negative Constraint: Do not use directly to decode GraphQL fragment models; use GraphQL adapters instead.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.avatar = try values.decode(Avatar.self, forKey: .avatar)
    self.chosenCurrency = try? values.decode(String?.self, forKey: .chosenCurrency)
    self.erroredBackingsCount = try values.decodeIfPresent(Int.self, forKey: .erroredBackingsCount)
    self.facebookConnected = try values.decodeIfPresent(Bool.self, forKey: .facebookConnected)
    self.id = try values.decode(Int.self, forKey: .id)
    self.isAdmin = try values.decodeIfPresent(Bool.self, forKey: .isAdmin)
    self.isEmailVerified = try values.decodeIfPresent(Bool.self, forKey: .isEmailVerified)
    self.isFriend = try values.decodeIfPresent(Bool.self, forKey: .isFriend)
    self.isBlocked = try values.decodeIfPresent(Bool.self, forKey: .isBlocked) ?? false
    self.location = try? values.decodeIfPresent(Location.self, forKey: .location)
    self.name = try values.decode(String.self, forKey: .name)
    self.needsFreshFacebookToken = try values.decodeIfPresent(Bool.self, forKey: .needsFreshFacebookToken)
    self.needsPassword = try values.decodeIfPresent(Bool.self, forKey: .needsPassword)
    self.newsletters = try User.NewsletterSubscriptions(from: decoder)
    self.notifications = try User.Notifications(from: decoder)
    self.optedOutOfRecommendations = try values.decodeIfPresent(Bool.self, forKey: .optedOutOfRecommendations)
    self.showPublicProfile = try values.decodeIfPresent(Bool.self, forKey: .showPublicProfile)
    self.social = try values.decodeIfPresent(Bool.self, forKey: .social)
    self.stats = try User.Stats(from: decoder)
    self.unseenActivityCount = try values.decodeIfPresent(Int.self, forKey: .unseenActivityCount)
  }

  enum CodingKeys: String, CodingKey {
    case avatar
    case chosenCurrency = "chosen_currency"
    case erroredBackingsCount = "errored_backings_count"
    case facebookConnected = "facebook_connected"
    case id
    case isAdmin = "is_admin"
    case isEmailVerified = "is_email_verified"
    case isFriend = "is_friend"
    case isBlocked
    case location
    case name
    case needsFreshFacebookToken = "needs_fresh_facebook_token"
    case needsPassword = "needs_password"
    case optedOutOfRecommendations = "opted_out_of_recommendations"
    case showPublicProfile = "show_public_profile"
    case social
    case unseenActivityCount = "unseen_activity_count"
  }
}

extension User: Encodable {
  /// Encodes the `User` model into a keyed JSON encoder for local persistence.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.avatar, forKey: .avatar)
    try container.encodeIfPresent(self.chosenCurrency, forKey: .chosenCurrency)
    try container.encodeIfPresent(self.erroredBackingsCount, forKey: .erroredBackingsCount)
    try container.encode(self.facebookConnected ?? false, forKey: .facebookConnected)
    try container.encode(self.id, forKey: .id)
    try container.encode(self.isAdmin ?? false, forKey: .isAdmin)
    try container.encode(self.isEmailVerified ?? false, forKey: .isEmailVerified)
    try container.encode(self.isFriend ?? false, forKey: .isFriend)
    try container.encode(self.isBlocked, forKey: .isBlocked)
    try container.encodeIfPresent(self.location, forKey: .location)
    try container.encode(self.name, forKey: .name)
    try container.encodeIfPresent(self.needsFreshFacebookToken, forKey: .needsFreshFacebookToken)
    try container.encode(self.needsPassword ?? false, forKey: .needsPassword)
    try container.encode(self.optedOutOfRecommendations ?? false, forKey: .optedOutOfRecommendations)
    try container.encode(self.showPublicProfile ?? false, forKey: .showPublicProfile)
    try container.encode(self.social ?? false, forKey: .social)
    try container.encodeIfPresent(self.unseenActivityCount, forKey: .unseenActivityCount)
    try self.newsletters.encode(to: encoder)
    try self.notifications.encode(to: encoder)
    try self.stats.encode(to: encoder)
  }
}

extension User: EncodableType {
  /// Serializes user fields to a legacy dictionary payload for v1 parameter encoding.
  /// - Negative Constraint: Do not use for new GraphQL or `EncodableQueryParams` requests.
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
