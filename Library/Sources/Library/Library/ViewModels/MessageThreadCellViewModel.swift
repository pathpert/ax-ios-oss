import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Inputs accepted by `MessageThreadCellViewModel`.
public protocol MessageThreadCellViewModelInputs {
  /// Configures the cell with a `MessageThread` model.
  func configureWith(messageThread: MessageThread)
  /// Notifies the view model whether the row was selected (marking it read when selected).
  func setSelected(_ selected: Bool)
}

/// Outputs emitted by `MessageThreadCellViewModel`.
public protocol MessageThreadCellViewModelOutputs {
  /// Emits the formatted date string for the latest message.
  var date: Signal<String, Never> { get }
  /// Emits a descriptive date string for VoiceOver.
  var dateAccessibilityLabel: Signal<String, Never> { get }
  /// Emits a single-line preview of the latest message body.
  var messageBody: Signal<String, Never> { get }
  /// Emits the URL for the other participant's medium avatar image.
  var participantAvatarURL: Signal<URL?, Never> { get }
  /// Emits the participant name (prefixed with bold "Me" if the current user sent the last message).
  var participantName: Signal<String, Never> { get }
  /// Emits the project name associated with the message thread.
  var projectName: Signal<String, Never> { get }
  /// Emits whether the reply icon should be hidden.
  var replyIndicatorHidden: Signal<Bool, Never> { get }
  /// Emits whether the unread indicator dot should be hidden.
  var unreadIndicatorHidden: Signal<Bool, Never> { get }
}

/// Interface combining inputs and outputs for `MessageThreadCellViewModel`.
public protocol MessageThreadCellViewModelType {
  /// Input receiver for thread configuration and selection state.
  var inputs: MessageThreadCellViewModelInputs { get }
  /// Output signals formatting message thread cell content.
  var outputs: MessageThreadCellViewModelOutputs { get }
}

/// View model formatting individual message thread rows in the inbox list.
public final class MessageThreadCellViewModel: MessageThreadCellViewModelType,
  MessageThreadCellViewModelInputs, MessageThreadCellViewModelOutputs {
  /// Initializes the message thread cell view model.
  public init() {
    let messageThread = self.messageThreadProperty.signal.skipNil()
    self.date = messageThread.map {
      Format.date(secondsInUTC: $0.lastMessage.createdAt, dateStyle: .short, timeStyle: .none)
    }

    self.dateAccessibilityLabel = messageThread.map {
      Format.date(secondsInUTC: $0.lastMessage.createdAt, dateStyle: .long, timeStyle: .none)
    }

    self.messageBody = messageThread.map {
      $0.lastMessage.body.replacingOccurrences(of: "\n", with: " ")
    }

    self.participantAvatarURL = messageThread.map { URL(string: $0.participant.avatar.medium) }

    self.participantName = messageThread
      .map { thread -> String in
        if thread.lastMessage.sender.id == AppEnvironment.current.currentUser?.id {
          let me = Strings.messages_me()
          return "<b>\(me)</b>, \(thread.participant.name)"
        }
        return thread.participant.name
      }

    self.projectName = messageThread.map { $0.project.name }

    self.replyIndicatorHidden = messageThread.map {
      $0.lastMessage.sender.id != AppEnvironment.current.currentUser?.id
    }

    messageThread
      .takeWhen(self.setSelectedProperty.signal.filter(isTrue))
      .observeValues(markedAsRead)

    self.unreadIndicatorHidden = Signal.merge(
      self.setSelectedProperty.signal.filter(isTrue).mapConst(true),
      messageThread.map { !hasUnreadMessages(for: $0) }
    )
  }

  fileprivate let messageThreadProperty = MutableProperty<MessageThread?>(nil)
  /// Configures the cell with a `MessageThread`.
  public func configureWith(messageThread: MessageThread) {
    self.messageThreadProperty.value = messageThread
  }

  fileprivate let setSelectedProperty = MutableProperty<Bool>(false)
  /// Updates the cell selection state and caches read status when selected.
  public func setSelected(_ selected: Bool) {
    self.setSelectedProperty.value = selected
  }

  /// Emits the short date string of the last message.
  public let date: Signal<String, Never>
  /// Emits the long accessible date string of the last message.
  public let dateAccessibilityLabel: Signal<String, Never>
  /// Emits the single-line body snippet of the last message.
  public let messageBody: Signal<String, Never>
  /// Emits the avatar image URL of the thread participant.
  public let participantAvatarURL: Signal<URL?, Never>
  /// Emits the formatted participant name label text.
  public let participantName: Signal<String, Never>
  /// Emits the associated project title.
  public let projectName: Signal<String, Never>
  /// Emits whether the reply indicator should be hidden.
  public let replyIndicatorHidden: Signal<Bool, Never>
  /// Emits whether the unread dot should be hidden.
  public let unreadIndicatorHidden: Signal<Bool, Never>

  /// Returns `self` as `MessageThreadCellViewModelInputs`.
  public var inputs: MessageThreadCellViewModelInputs { return self }
  /// Returns `self` as `MessageThreadCellViewModelOutputs`.
  public var outputs: MessageThreadCellViewModelOutputs { return self }
}

private func hasUnreadMessages(for messageThread: MessageThread) -> Bool {
  return (AppEnvironment.current.cache[cacheKey(for: messageThread)] as? Bool)
    ?? (messageThread.unreadMessagesCount > 0)
}

private func cacheKey(for messageThread: MessageThread) -> String {
  return "\(KSCache.ksr_messageThreadHasUnreadMessages)_\(messageThread.id)"
}

private func markedAsRead(for messageThread: MessageThread) {
  AppEnvironment.current.cache[cacheKey(for: messageThread)] = false
}
