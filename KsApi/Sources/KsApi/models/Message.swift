
import Foundation

/// Direct message exchanged between a backer and creator within a `MessageThread`.
public struct Message {
  /// Plain-text body of the message.
  public let body: String
  /// Unix timestamp (seconds since epoch) when the message was created.
  public let createdAt: TimeInterval
  /// Numeric identifier of the message.
  public let id: Int
  /// Recipient user.
  public let recipient: User
  /// Sender user.
  public let sender: User
}

extension Message: Decodable {
  enum CodingKeys: String, CodingKey {
    case body
    case createdAt = "created_at"
    case id
    case recipient
    case sender
  }
}
