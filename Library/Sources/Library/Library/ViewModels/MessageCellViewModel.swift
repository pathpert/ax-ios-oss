import Foundation
import KsApi
import ReactiveSwift

/// Inputs accepted by `MessageCellViewModel`.
public protocol MessageCellViewModelInputs {
  /// Configures the cell with a `Message` model.
  func configureWith(message: Message)

  /// Call when the cell header is tapped
  func cellHeaderTapped()
}

/// Outputs emitted by `MessageCellViewModel`.
public protocol MessageCellViewModelOutputs {
  /// Emits the message sender's avatar image URL.
  var avatarURL: Signal<URL?, Never> { get }
  /// Emits the sender's display name.
  var name: Signal<String, Never> { get }
  /// Emits the short formatted message creation timestamp.
  var timestamp: Signal<String, Never> { get }
  /// Emits the long accessible timestamp string for VoiceOver.
  var timestampAccessibilityLabel: Signal<String, Never> { get }
  /// Emits the plain-text message body.
  var body: Signal<String, Never> { get }

  /// Emits the message's `Sender` of the tapped message.
  var messageSender: Signal<User, Never> { get }
}

/// Interface combining inputs and outputs for `MessageCellViewModel`.
public protocol MessageCellViewModelType {
  /// Input receiver for message configuration and header taps.
  var inputs: MessageCellViewModelInputs { get }
  /// Output signals formatting sender details, body copy, and timestamps.
  var outputs: MessageCellViewModelOutputs { get }
}

/// View model formatting individual message bubbles in a conversation thread.
public final class MessageCellViewModel: MessageCellViewModelType, MessageCellViewModelInputs,
  MessageCellViewModelOutputs {
  /// Initializes the message cell view model.
  public init() {
    let message = self.messageProperty.signal.skipNil()

    self.avatarURL = message.map { URL.init(string: $0.sender.avatar.large ?? $0.sender.avatar.medium) }

    self.name = message.map { $0.sender.name }

    self.timestamp = message.map {
      Format.date(secondsInUTC: $0.createdAt, dateStyle: .short, timeStyle: .short)
    }

    self.timestampAccessibilityLabel = message.map {
      Format.date(secondsInUTC: $0.createdAt, dateStyle: .long, timeStyle: .short)
    }

    self.body = message.map { $0.body }

    self.messageSender = message
      .takeWhen(self.cellHeaderTappedProperty.signal)
      .map(\.sender)
  }

  fileprivate let messageProperty = MutableProperty<Message?>(nil)
  /// Configures the cell with a `Message`.
  public func configureWith(message: Message) {
    self.messageProperty.value = message
  }

  fileprivate let cellHeaderTappedProperty = MutableProperty(())
  /// Emits the message sender when the sender header is tapped.
  public func cellHeaderTapped() {
    self.cellHeaderTappedProperty.value = ()
  }

  /// Emits the sender avatar URL.
  public let avatarURL: Signal<URL?, Never>
  /// Emits the sender's display name.
  public let name: Signal<String, Never>
  /// Emits the concise timestamp string.
  public let timestamp: Signal<String, Never>
  /// Emits the verbose timestamp string for VoiceOver.
  public var timestampAccessibilityLabel: Signal<String, Never>
  /// Emits the message body text.
  public let body: Signal<String, Never>
  /// Emits the `User` who sent the message on header tap.
  public let messageSender: Signal<User, Never>

  /// Returns `self` as `MessageCellViewModelInputs`.
  public var inputs: MessageCellViewModelInputs { return self }
  /// Returns `self` as `MessageCellViewModelOutputs`.
  public var outputs: MessageCellViewModelOutputs { return self }
}
