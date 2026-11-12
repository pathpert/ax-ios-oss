/// Legacy target subject when replying to an existing thread or messaging a project creator.
///
/// Negative Constraint: @deprecated Legacy message target enum — prefer `SendMessageRequestSchema` and `MessagingController` in `KsApi/modules/messaging`.
public enum MessageSubject: Equatable {
  /// Reply to an existing `MessageThread`.
  case messageThread(MessageThread)
  /// Compose a new message addressed to a project's creator.
  case project(id: Int, name: String)

  /// Extracts the associated `MessageThread` when `.messageThread`; otherwise `nil`.
  public var messageThread: MessageThread? {
    if case let .messageThread(messageThread) = self {
      return messageThread
    }
    return nil
  }

  /// Extracts the project identifier and display name when `.project`; otherwise `nil`.
  public var project: (id: Int, name: String)? {
    if case let .project(id, name) = self {
      return (id, name)
    }
    return nil
  }
}
