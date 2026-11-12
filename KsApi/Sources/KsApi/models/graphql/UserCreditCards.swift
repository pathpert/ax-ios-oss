/// Container of credit cards stored on a Kickstarter user's Stripe customer profile.
public struct UserCreditCards: Decodable {
  /// Saved payment cards ordered for checkout selection.
  public var storedCards: [CreditCard]

  /// Summary metadata for a single saved credit or debit card.
  public struct CreditCard: Decodable, Equatable {
    /// Card expiration date string formatted as `YYYY-MM-DD`.
    public var expirationDate: String
    /// Opaque payment source identifier returned by the API.
    public var id: String
    /// Last four digits of the card primary account number.
    public var lastFour: String
    /// Card network brand (`visa`, `mastercard`, etc.), or `nil` when unrecognized.
    public var type: CreditCardType?
    /// Stripe PaymentMethod/Card identifier used when authorizing payment intents.
    public var stripeCardId: String?

    /// Expiration date shortened to `YYYY-MM` by dropping the trailing day component (`-DD`).
    public var formattedExpirationDate: String {
      return String(self.expirationDate.dropLast(3))
    }

    /// Asset catalog icon name corresponding to `type`, falling back to `"icon--generic"`.
    public var imageName: String {
      switch self.type {
      case nil, .some(.generic):
        return "icon--generic"
      case let .some(type):
        return "icon--\(type.rawValue.lowercased())"
      }
    }
  }
}

extension UserCreditCards: Equatable {
  /// Returns `true` when both containers have identical `storedCards` arrays.
  public static func == (lhs: UserCreditCards, rhs: UserCreditCards) -> Bool {
    lhs.storedCards == rhs.storedCards
  }
}
