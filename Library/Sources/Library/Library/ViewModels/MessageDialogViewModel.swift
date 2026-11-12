import KsApi
import Prelude
import ReactiveSwift

/// Input events handled by `MessageDialogViewModel`.
public protocol MessageDialogViewModelInputs {
  /// Call when the message text changes.
  func bodyTextChanged(_ body: String)

  /// Call when the cancel button is pressed.
  func cancelButtonPressed()

  /// Call with the backing/message-thread/project that was given to the view.
  func configureWith(messageSubject: MessageSubject, context: KSRAnalytics.MessageDialogContext)

  /// Call when the post button is pressed.
  func postButtonPressed()

  /// Call when the view loads.
  func viewDidLoad()
}

/// Output signals exposed by `MessageDialogViewModel`.
public protocol MessageDialogViewModelOutputs {
  /// Emits a boolean that determines if the keyboard is shown or not.
  var keyboardIsVisible: Signal<Bool, Never> { get }

  /// Emits a boolean that determines if the loading view is hidden or not.
  var loadingViewIsHidden: Signal<Bool, Never> { get }

  /// Emits the message just successfully posted.
  var notifyPresenterCommentWasPostedSuccesfully: Signal<Message, Never> { get }

  /// Emits when the dialog should be dismissed.
  var notifyPresenterDialogWantsDismissal: Signal<(), Never> { get }

  /// Emits a boolean that determines if the post button is enabled.
  var postButtonEnabled: Signal<Bool, Never> { get }

  /// Emits the recipient's name.
  var recipientName: Signal<String, Never> { get }

  /// Emits a string that should be alerted to the user.
  var showAlertMessage: Signal<String, Never> { get }
}

/// Interface combining inputs and outputs for `MessageDialogViewModel`.
public protocol MessageDialogViewModelType {
  /// Input receiver for message composer events.
  var inputs: MessageDialogViewModelInputs { get }
  /// Output signals driving the message dialog UI.
  var outputs: MessageDialogViewModelOutputs { get }
}

/// View model managing composition, submission, and validation of creator/backer direct messages.
public final class MessageDialogViewModel: MessageDialogViewModelType, MessageDialogViewModelInputs,
  MessageDialogViewModelOutputs {
  /// Initializes the message dialog view model.
  public init() {
    let messageSubject = self.messageSubjectProperty.signal.skipNil()
      .takeWhen(self.viewDidLoadProperty.signal)

    let body = self.bodyTextChangedProperty.signal.skipNil()

    let bodyIsPresent = body
      .map { !$0.trimmed().isEmpty }
      .skipRepeats()

    self.postButtonEnabled = Signal.merge(
      self.viewDidLoadProperty.signal.take(first: 1).mapConst(false),
      bodyIsPresent
    )

    let sendMessageResult = Signal.combineLatest(
      body,
      messageSubject
    )
    .takeWhen(self.postButtonPressedProperty.signal)
    .switchMap { body, messageSubject in
      AppEnvironment.current.apiService.sendMessage(body: body, toSubject: messageSubject)
        .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
        .materialize()
    }

    self.notifyPresenterCommentWasPostedSuccesfully = sendMessageResult.values()

    self.showAlertMessage = sendMessageResult.errors()
      .map { $0.errorMessages.first ?? Strings.messages_dialog_generic_error() }

    self.notifyPresenterDialogWantsDismissal = Signal.merge(
      self.cancelButtonPressedProperty.signal,
      self.notifyPresenterCommentWasPostedSuccesfully.ignoreValues()
    )

    self.loadingViewIsHidden = Signal.merge(
      self.postButtonPressedProperty.signal.mapConst(false),
      sendMessageResult.filter { $0.isTerminating }.mapConst(true),
      self.viewDidLoadProperty.signal.take(first: 1).mapConst(true)
    )

    self.recipientName = messageSubject
      .take(first: 1)
      .flatMap { messageSubject -> SignalProducer<String, Never> in
        switch messageSubject {
        case let .messageThread(messageThread):
          return .init(value: messageThread.participant.name)
        case let .project(_, name):
          return .init(value: name)
        }
      }

    self.keyboardIsVisible = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst(true),
      self.notifyPresenterDialogWantsDismissal.mapConst(false)
    )
  }

  fileprivate let bodyTextChangedProperty = MutableProperty<String?>(nil)
  /// Updates the current message body text typed by the user.
  public func bodyTextChanged(_ body: String) {
    self.bodyTextChangedProperty.value = body
  }

  fileprivate let cancelButtonPressedProperty = MutableProperty(())
  /// Signals that the cancel button was pressed to dismiss the dialog.
  public func cancelButtonPressed() {
    self.cancelButtonPressedProperty.value = ()
  }

  fileprivate let messageSubjectProperty = MutableProperty<MessageSubject?>(nil)
  fileprivate let contextProperty = MutableProperty<KSRAnalytics.MessageDialogContext?>(nil)
  /// Configures the message dialog with its target thread/project and analytics context.
  public func configureWith(
    messageSubject: MessageSubject,
    context _: KSRAnalytics.MessageDialogContext
  ) {
    self.messageSubjectProperty.value = messageSubject
  }

  fileprivate let postButtonPressedProperty = MutableProperty(())
  /// Submits the composed message when the post button is tapped.
  public func postButtonPressed() {
    self.postButtonPressedProperty.value = ()
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the dialog view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  /// Emits whether the loading spinner should be hidden.
  public let loadingViewIsHidden: Signal<Bool, Never>
  /// Emits whether the send/post button should be enabled.
  public let postButtonEnabled: Signal<Bool, Never>
  /// Emits when the presenter should dismiss the message dialog.
  public let notifyPresenterDialogWantsDismissal: Signal<(), Never>
  /// Emits the newly sent `Message` upon successful submission.
  public let notifyPresenterCommentWasPostedSuccesfully: Signal<Message, Never>
  /// Emits the formatted recipient display name.
  public let recipientName: Signal<String, Never>
  /// Emits whether the keyboard should be presented or dismissed.
  public let keyboardIsVisible: Signal<Bool, Never>
  /// Emits an error alert message string if sending fails.
  public let showAlertMessage: Signal<String, Never>

  /// Returns `self` as `MessageDialogViewModelInputs`.
  public var inputs: MessageDialogViewModelInputs { return self }
  /// Returns `self` as `MessageDialogViewModelOutputs`.
  public var outputs: MessageDialogViewModelOutputs { return self }
}
