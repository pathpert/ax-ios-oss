

/// Full conversation payload for a single `MessageThread`.
public struct MessageThreadEnvelope {
  /// Users participating in the thread.
  public let participants: [User]
  /// Ordered list of messages in the thread.
  public let messages: [Message]
  /// Thread summary metadata.
  public let messageThread: MessageThread
}

extension MessageThreadEnvelope: Decodable {
  enum CodingKeys: String, CodingKey {
    case participants
    case messages
    case messageThread = "message_thread"
  }
}
