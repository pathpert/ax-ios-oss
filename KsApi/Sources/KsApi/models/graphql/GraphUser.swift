import Foundation
import Prelude

/// GraphQL representation of the authenticated user profile and saved payment methods.
/// Prefer `User` or domain-specific GraphQL fragments for new features.
public struct GraphUser: Decodable {
  /// User-selected ISO 4217 currency code for pledge displays, if configured.
  public var chosenCurrency: String?
  /// Primary account email address, omitted for public queries.
  public var email: String?
  /// Indicates whether the user has configured a Kickstarter password.
  public var hasPassword: Bool?
  /// Opaque GraphQL Relay node ID.
  public var id: String
  /// Indicates whether the authenticated viewer has blocked this user.
  public var isBlocked: Bool?
  /// Indicates whether the user has launched or created a Kickstarter project.
  public var isCreator: Bool?
  /// URL string for the user's medium avatar image.
  public var imageUrl: String
  /// Indicates whether Sign in with Apple is linked to the account.
  public var isAppleConnected: Bool?
  /// Indicates whether the primary email address has been verified.
  public var isEmailVerified: Bool?
  /// Indicates whether emails to the account are currently deliverable without bounces.
  public var isDeliverable: Bool?
  /// Display name of the user.
  public var name: String
  /// Container holding saved credit card payment methods for checkout.
  public var storedCards: UserCreditCards
  /// Numeric Kickstarter user identifier encoded as a string.
  public var uid: String
}

extension GraphUser: Equatable {
  /// Returns `true` when both `GraphUser` instances match across all decoded profile fields.
  public static func == (lhs: GraphUser, rhs: GraphUser) -> Bool {
    lhs.chosenCurrency == rhs.chosenCurrency &&
      lhs.email == rhs.email &&
      lhs.hasPassword == rhs.hasPassword &&
      lhs.id == rhs.id &&
      lhs.isBlocked == rhs.isBlocked &&
      lhs.isCreator == rhs.isCreator &&
      lhs.imageUrl == rhs.imageUrl &&
      lhs.isAppleConnected == rhs.isAppleConnected &&
      lhs.isEmailVerified == rhs.isEmailVerified &&
      lhs.isDeliverable == rhs.isDeliverable &&
      lhs.name == rhs.name &&
      lhs.storedCards == rhs.storedCards &&
      lhs.uid == rhs.uid
  }
}
