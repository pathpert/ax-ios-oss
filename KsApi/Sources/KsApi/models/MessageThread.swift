

/// Summary metadata for a message thread between a user and a project's creator or backer.
public struct MessageThread {
  /// Associated backing, if present.
  public let backing: Backing?
  /// Whether further replies in this thread are disallowed.
  public let closed: Bool
  /// Numeric identifier of the message thread.
  public let id: Int
  /// Most recent message in the thread.
  public let lastMessage: Message
  /// The other user participating in the conversation.
  public let participant: User
  /// Project referenced by this message thread.
  public let project: Project
  /// Count of unread messages in the thread for the current user.
  public let unreadMessagesCount: Int
}

extension MessageThread: Decodable {
  enum CodingKeys: String, CodingKey {
    case backing
    case closed
    case id
    case lastMessage = "last_message"
    case participant
    case project
    case unreadMessagesCount = "unread_messages_count"
  }
}

extension MessageThread: Equatable {}
/// Compares two message threads by canonical `id`.
public func == (lhs: MessageThread, rhs: MessageThread) -> Bool {
  return lhs.id == rhs.id
}
