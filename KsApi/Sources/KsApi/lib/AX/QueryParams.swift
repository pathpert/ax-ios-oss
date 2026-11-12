import Foundation

/// Contract-first query/body parameter protocol replacing untyped `[String: Any]` dictionaries (AX Pillar 2).
///
/// Format: Concrete conformers must define explicit typed properties and `CodingKeys`.
/// Negative Constraint: Do not introduce raw `[String: Any]` parameter bags in new routes or services.
public protocol EncodableQueryParams: Encodable {}

/// Typed empty query payload for endpoints without query/body parameters.
public struct EmptyQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Creates an empty query payload.
  public init() {}
}

/// Query payload for `GET /v1/activities`.
public struct ActivitiesQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Activity category identifiers included in the feed filter.
  public let categories: [String]
  /// Optional maximum number of activities to return per page.
  public let count: Int?

  /// Creates an activity feed query payload.
  public init(categories: [String], count: Int? = nil) {
    self.categories = categories
    self.count = count
  }
}

/// Body payload for `PUT /v1/projects/:id/backers/:backer_id`.
public struct BackingUpdateQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Flag encoded as `"1"` or `"0"` indicating reward receipt confirmation.
  public let backerCompletedAt: String

  enum CodingKeys: String, CodingKey {
    case backerCompletedAt = "backer_completed_at"
  }

  /// Creates a backing reward-received update payload.
  public init(received: Bool) {
    self.backerCompletedAt = received ? "1" : "0"
  }
}

/// Cache-busting query payload for `GET /v1/app/ios/config`.
public struct CacheBustQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Timestamp token appended as `no_cache` to bypass intermediate caches.
  public let noCache: String

  enum CodingKeys: String, CodingKey {
    case noCache = "no_cache"
  }

  /// Creates a cache-busting config query payload.
  public init(noCache: String = "\(Date().timeIntervalSince1970)") {
    self.noCache = noCache
  }
}

/// Typed wrapper encoding `DiscoveryParams` fields as flat discovery query items.
public struct DiscoveryQueryParams: EncodableQueryParams, Equatable {
  private let values: [String: String]

  /// Converts a `DiscoveryParams` struct into encodable discovery query items.
  public init(params: DiscoveryParams) {
    self.values = params.queryParams
  }

  /// Encodes each discovery filter entry using its dynamic query parameter key.
  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: _DynamicStringCodingKey.self)
    for (key, value) in self.values {
      try container.encode(value, forKey: _DynamicStringCodingKey(stringValue: key))
    }
  }
}

private struct _DynamicStringCodingKey: CodingKey {
  var stringValue: String
  var intValue: Int? { return nil }
  init(stringValue: String) { self.stringValue = stringValue }
  init?(intValue _: Int) { return nil }
}

/// Body payload for `PUT v1/facebook/connect`.
public struct FacebookConnectQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Short-lived Facebook OAuth access token obtained from the SDK.
  public let accessToken: String

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
  }

  /// Creates a Facebook account link payload.
  public init(accessToken: String) {
    self.accessToken = accessToken
  }
}

/// Body payload for `PUT /v1/facebook/access_token` during login.
public struct FacebookLoginQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Facebook OAuth access token.
  public let accessToken: String
  /// Fixed flow discriminator (`"login"`).
  public let intent: String
  /// Optional two-factor authentication verification code.
  public let code: String?

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case intent
    case code
  }

  /// Creates a Facebook login payload.
  public init(accessToken: String, code: String? = nil) {
    self.accessToken = accessToken
    self.intent = "login"
    self.code = code
  }
}

/// Body payload for `PUT /v1/facebook/access_token` during signup.
public struct FacebookSignupQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Facebook OAuth access token.
  public let accessToken: String
  /// Fixed flow discriminator (`"register"`).
  public let intent: String
  /// Whether to opt the user into Kickstarter newsletters.
  public let sendNewsletters: Bool
  /// Legacy mirror of `sendNewsletters` expected by the v1 endpoint.
  public let newsletterOptIn: Bool

  enum CodingKeys: String, CodingKey {
    case accessToken = "access_token"
    case intent
    case sendNewsletters = "send_newsletters"
    case newsletterOptIn = "newsletter_opt_in"
  }

  /// Creates a Facebook signup payload.
  public init(accessToken: String, sendNewsletters: Bool) {
    self.accessToken = accessToken
    self.intent = "register"
    self.sendNewsletters = sendNewsletters
    self.newsletterOptIn = sendNewsletters
  }
}

/// Query payload for `GET v1/users/self/friends/find` stats count.
public struct FriendStatsQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Count parameter expected by the friend stats endpoint (`0` by default).
  public let count: Int

  /// Creates a friend stats query payload.
  public init(count: Int = 0) {
    self.count = count
  }
}

/// Body payload for `POST v1/users/self/friends`.
public struct FollowFriendQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Positive numeric identifier of the user to follow.
  public let followedId: Int

  enum CodingKeys: String, CodingKey {
    case followedId = "followed_id"
  }

  /// Creates a follow-friend request payload.
  public init(followedId: Int) {
    self.followedId = followedId
  }
}

/// Body payload for video playback start/complete analytics endpoints.
public struct VideoPlayEventQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Video telemetry event kind (`start` or `complete`).
  public enum EventType: String, Encodable, Sendable {
    /// Emitted when playback begins.
    case start
    /// Emitted when playback finishes.
    case complete
  }

  /// Playback lifecycle event name.
  public let eventType: EventType
  /// Placement origin string (defaults to `"internal"`).
  public let location: String

  enum CodingKeys: String, CodingKey {
    case eventType = "event_type"
    case location
  }

  /// Creates a video playback event payload.
  public init(eventType: EventType, location: String = "internal") {
    self.eventType = eventType
    self.location = location
  }
}

/// Body payload for `POST /xauth/access_token`.
public struct LoginQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Account email address.
  public let email: String
  /// Account password.
  public let password: String
  /// Optional 2FA TOTP or SMS code.
  public let code: String?

  /// Creates an xAuth email/password login payload.
  public init(email: String, password: String, code: String? = nil) {
    self.email = email
    self.password = password
    self.code = code
  }
}

/// Query payload for `GET /v1/users/self/projects`.
public struct MemberProjectsQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Boolean flag serialized as `"1"` or `"0"`.
  public let member: String

  /// Creates a member-projects query payload.
  public init(member: Bool) {
    self.member = member ? "1" : "0"
  }
}

/// Body payload for `POST v1/users/self/ios/push_tokens`.
public struct RegisterPushTokenQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Lowercase hex-encoded APNs device token string.
  public let token: String

  /// Creates an APNs push-token registration payload.
  public init(token: String) {
    self.token = token
  }
}
