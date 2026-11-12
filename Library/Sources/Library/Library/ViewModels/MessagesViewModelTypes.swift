import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// Input methods accepted by `MessagesViewModel`.
public protocol MessagesViewModelInputs {
  /// Call when the backing button is pressed.
  func backingInfoPressed()

  /// Call when block user is tapped.
  func blockUser(id: String)

  /// Configures the view model with either a message thread or a project and a backing.
  func configureWith(data: Either<MessageThread, (project: Project, backing: Backing)>)

  /// Call when the message dialog has told us that a message was successfully posted.
  func messageSent(_ message: Message)

  /// Call when the project banner is tapped.
  func projectBannerTapped()

  /// Call when the reply button is pressed.
  func replyButtonPressed()

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when the view will appear.
  func viewWillAppear()
}

/// Output signals emitted by `MessagesViewModel`.
public protocol MessagesViewModelOutputs {
  /**
   Emits a Backing and Project that can be used to populate the BackingCell.
   The boolean tells if navigation to this screen occurred from the backing info screen.
   */
  var backingAndProjectAndIsFromBacking: Signal<(Backing, Project, Bool), Never> { get }

  /// Emits a boolean that determines if the empty state is visible and a message to display.
  var emptyStateIsVisibleAndMessageToUser: Signal<(Bool, String), Never> { get }

  /// Emits when we should go to the backing screen.
  var goToBacking: Signal<ManagePledgeViewParamConfigData, Never> { get }

  /// Emits when we should go to the Pledge Management View Pledge webview.
  var goToPledgeManagementViewPledge: Signal<String, Never> { get }

  /// Emits when we should go to the project.
  var goToProject: Signal<(Project, RefTag), Never> { get }

  /// Emits a list of messages to be displayed.
  var messages: Signal<[Message], Never> { get }

  /// Emits a bool whether the message participant has previously been blocked on viewWillAppear.
  var participantPreviouslyBlocked: Signal<Bool, Never> { get }

  /// Emits when we should show the message dialog.
  var presentMessageDialog: Signal<(MessageThread, KSRAnalytics.MessageDialogContext), Never> { get }

  /// Emits the project we are viewing the messages for.
  var project: Signal<Project, Never> { get }

  /// Emits a bool whether the reply button is enabled.
  var replyButtonIsEnabled: Signal<Bool, Never> { get }

  /// Emits when the thread has been marked as read.
  var successfullyMarkedAsRead: Signal<(), Never> { get }

  /// Emits when a block user request is successful.
  var didBlockUser: Signal<(), Never> { get }

  /// Emits when a block user request fails.
  var didBlockUserError: Signal<(), Never> { get }
}

/// Interface combining inputs and outputs for `MessagesViewModel`.
public protocol MessagesViewModelType {
  /// Input receiver for message thread events.
  var inputs: MessagesViewModelInputs { get }
  /// Output signals observed by the messages controller.
  var outputs: MessagesViewModelOutputs { get }
}

