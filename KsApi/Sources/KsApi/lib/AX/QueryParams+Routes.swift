import Foundation

/// Body payload for `POST /v1/users/reset`.
public struct ResetPasswordQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Target account email address requesting a password reset link.
  public let email: String

  /// Creates a password reset payload for `email`.
  public init(email: String) {
    self.email = email
  }
}

/// Query payload for message thread search.
public struct SearchMessagesQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Search keyword query sent as `?q=...`.
  public let q: String

  /// Creates a message search query payload.
  public init(query: String) {
    self.q = query
  }
}

/// Body payload for sending messages.
public struct SendMessageQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Plain-text message content.
  public let body: String

  /// Creates a send-message payload.
  public init(body: String) {
    self.body = body
  }
}

/// Body payload for `PUT /v1/projects/:id/updates/draft`.
public struct UpdateDraftQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Creator update draft headline.
  public let title: String
  /// Creator update draft body text.
  public let body: String
  /// Whether the published update will be visible to the public (`"public"` on wire).
  public let isPublic: Bool

  enum CodingKeys: String, CodingKey {
    case title
    case body
    case isPublic = "public"
  }

  /// Creates an update draft payload.
  public init(title: String, body: String, isPublic: Bool) {
    self.title = title
    self.body = body
    self.isPublic = isPublic
  }
}

/// Body payload for `PUT /v1/users/self/notifications/:id`.
public struct ProjectNotificationQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Whether email notifications are enabled for the project.
  public let email: Bool
  /// Whether mobile push notifications are enabled for the project.
  public let mobile: Bool

  /// Creates a project notification preference update payload.
  public init(email: Bool, mobile: Bool) {
    self.email = email
    self.mobile = mobile
  }
}

/// Body payload for `POST /v1/users/self/verify_email`.
public struct VerifyEmailQueryParams: EncodableQueryParams, Equatable, Sendable {
  /// Single-use verification token extracted from the verification email link.
  public let emailAccessToken: String

  enum CodingKeys: String, CodingKey {
    case emailAccessToken = "email_access_token"
  }

  /// Creates an email verification payload.
  public init(emailAccessToken: String) {
    self.emailAccessToken = emailAccessToken
  }
}

/// Typed wrapper preserving `User` serialization for `PUT /v1/users/self`.
public struct UpdateUserSelfQueryParams: EncodableQueryParams {
  /// User model serialized directly via `User.encode(to:)` for `PUT /v1/users/self`.
  public let user: User

  /// Wraps a `User` model for `PUT /v1/users/self` encoding.
  public init(user: User) {
    self.user = user
  }

  /// Encodes the wrapped `User` directly into the top-level request payload.
  public func encode(to encoder: Encoder) throws {
    try self.user.encode(to: encoder)
  }
}

