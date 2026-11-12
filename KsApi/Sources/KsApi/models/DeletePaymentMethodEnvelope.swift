import Foundation

/// GraphQL response envelope returned after deleting a saved credit card.
public struct DeletePaymentMethodEnvelope {
  /// Remaining saved credit cards on the user's account after deletion.
  public let storedCards: [UserCreditCards.CreditCard]
}

extension DeletePaymentMethodEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case nodes
    case paymentSourceDelete
    case user
    case storedCards
  }

  /// Decodes remaining stored cards from the nested `paymentSourceDelete.user.storedCards.nodes` payload.
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    self.storedCards = try values.nestedContainer(keyedBy: CodingKeys.self, forKey: .paymentSourceDelete)
      .nestedContainer(keyedBy: CodingKeys.self, forKey: .user)
      .nestedContainer(keyedBy: CodingKeys.self, forKey: .storedCards)
      .decode([UserCreditCards.CreditCard].self, forKey: .nodes)
  }
}
