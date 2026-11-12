import Foundation
import KsApi
import Prelude
import ReactiveSwift

/// View model managing message thread loading, replies, marking read, and user blocking.
public final class MessagesViewModel: MessagesViewModelType, MessagesViewModelInputs,
  MessagesViewModelOutputs {
  /// Creates a new `MessagesViewModel`.
  public init() {
    let configData = self.configData.signal.skipNil()
      .takeWhen(self.viewDidLoadProperty.signal)

    let configBacking = configData.map { $0.right?.backing }

    let configThread = configData.map { $0.left }
      .skipNil()

    let currentUser = self.viewDidLoadProperty.signal
      .map { AppEnvironment.current.currentUser }
      .skipNil()

    self.project = configData
      .map {
        switch $0 {
        case let .left(thread):
          return thread.project
        case let .right((project, _)):
          return project
        }
      }

    let backingOrThread = Signal.merge(
      configBacking.skipNil().map(Either.left),
      configThread.map(Either.right)
    )

    let messageThreadEnvelopeEvent = Signal.merge(
      backingOrThread,
      backingOrThread.takeWhen(self.messageSentProperty.signal)
    )
    .switchMap { backingOrThread
      -> SignalProducer<Signal<MessageThreadEnvelope?, ErrorEnvelope>.Event, Never> in
      switch backingOrThread {
      case let .left(backing):
        return AppEnvironment.current.apiService.fetchMessageThread(backing: backing)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      case let .right(thread):
        return AppEnvironment.current.apiService.fetchMessageThread(messageThreadId: thread.id)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .map(MessageThreadEnvelope?.some)
          .materialize()
      }
    }

    let messageThreadEnvelope = messageThreadEnvelopeEvent.values().skipNil()

    let participant = messageThreadEnvelope.map { $0.messageThread.participant }

    self.backingAndProjectAndIsFromBacking = Signal.combineLatest(
      configBacking, self.project, participant, currentUser, messageThreadEnvelope
    )
    .switchMap { value -> SignalProducer<(Backing, Project, Bool), Never> in
      let (backing, project, participant, currentUser, messageThreadEnvelope) = value

      if let backing = backing {
        return SignalProducer(value: (backing, project, true))
      }

      let isBacker = project.personalization.isBacking == .some(true)

      guard let backingID = messageThreadEnvelope.messageThread.backing?.id else {
        // If the messageThread does not contain a backing ID, fall back to fetching the backing info using the V1 endpoint:
        // `fetchBacking(forProject:forUser:)`
        let user = isBacker ? currentUser : participant
        let request = AppEnvironment.current.apiService.fetchBacking(forProject: project, forUser: user)

        return request
          .map { (backing: $0, project: project, isFromBacking: false) }
          .demoteErrors()
      }

      let request = AppEnvironment.current.apiService.fetchBacking(id: backingID)
      return request.map { projectAndBacking in
        (projectAndBacking.backing, project, false)
      }
      .demoteErrors()
    }

    let projectAndBacking = self.backingAndProjectAndIsFromBacking.map { backing, project, _ -> (
      Project,
      Backing
    ) in
      (project, backing)
    }

    self.viewPledgeUseCase = .init(with: projectAndBacking)

    self.messages = messageThreadEnvelope
      .map { $0.messages }
      .sort { $0.id > $1.id }

    self.emptyStateIsVisibleAndMessageToUser = Signal.merge(
      self.viewDidLoadProperty.signal.mapConst((false, "")),
      Signal.combineLatest(
        messageThreadEnvelopeEvent.values().filter(isNil),
        configBacking.skipNil(),
        self.project
      )
      .map { _, backing, project in
        let isCreatorOrCollaborator = !project.memberData.permissions.isEmpty
          && backing.backer?.id != AppEnvironment.current.currentUser?.id
        let message = isCreatorOrCollaborator
          ? Strings.messages_empty_state_message_creator()
          : Strings.messages_empty_state_message_backer()
        return (true, message)
      }
    )

    self.participantPreviouslyBlocked = self.project
      .map { $0.creator.isBlocked }
      .takeWhen(self.viewWillAppearProperty.signal)

    self.replyButtonIsEnabled = Signal.combineLatest(
      self.messages.map { !$0.isEmpty },
      self.participantPreviouslyBlocked
    )
    .map { messages, isBlocked in
      messages && !isBlocked
    }

    self.presentMessageDialog = messageThreadEnvelope
      .map { ($0.messageThread, .messages) }
      .takeWhen(self.replyButtonPressedProperty.signal)

    self.goToProject = self.project.takeWhen(self.projectBannerTappedProperty.signal)
      .map { ($0, .messageThread) }

    self.successfullyMarkedAsRead = messageThreadEnvelope
      .switchMap {
        AppEnvironment.current.apiService.markAsRead(messageThread: $0.messageThread)
          .demoteErrors()
      }
      .ignoreValues()

    let blockUserEvent = self.blockUserProperty.signal
      .map(BlockUserInput.init(blockUserId:))
      .switchMap { input in
        AppEnvironment.current.apiService
          .blockUser(input: input)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.didBlockUser = blockUserEvent.values().ignoreValues()
      .map { _ in NotificationCenter.default.post(.init(name: .ksr_blockedUser)) }

    // TODO: Display proper error messaging from the backend
    self.didBlockUserError = blockUserEvent.errors().ignoreValues()

    // MARK: User Blocking Analytics

    _ = self.blockUserProperty.signal
      .combineLatest(with: self.project)
      .observeValues { blockedUserId, project in
        AppEnvironment.current.ksrAnalytics
          .trackBlockedUser(
            project,
            page: .messages,
            typeContext: .initiate,
            targetUserId: "\(blockedUserId)"
          )
      }

    _ = self.blockUserProperty.signal
      .combineLatest(with: self.project)
      .takeWhen(blockUserEvent.values().ignoreValues())
      .observeValues { blockedUserId, project in
        AppEnvironment.current.ksrAnalytics
          .trackBlockedUser(project, page: .messages, typeContext: .confirm, targetUserId: "\(blockedUserId)")
      }
  }

  /// Handles tap on the backing info button.
  public func backingInfoPressed() {
    self.viewPledgeUseCase.goToPledgeViewTapped()
  }

  private let blockUserProperty = MutableProperty<String>("")
  /// Initiates blocking the participant with `id`.
  public func blockUser(id: String) {
    self.blockUserProperty.value = id
  }

  private let configData = MutableProperty<Either<MessageThread, (project: Project, backing: Backing)>?>(nil)
  /// Configures the view model with a message thread or project and backing pair.
  public func configureWith(data: Either<MessageThread, (project: Project, backing: Backing)>) {
    self.configData.value = data
  }

  private let messageSentProperty = MutableProperty<Message?>(nil)
  /// Records a newly sent `message` returned by the composer dialog.
  public func messageSent(_ message: Message) {
    self.messageSentProperty.value = message
  }

  private let projectBannerTappedProperty = MutableProperty(())
  /// Handles tap on the project header banner.
  public func projectBannerTapped() {
    self.projectBannerTappedProperty.value = ()
  }

  private let replyButtonPressedProperty = MutableProperty(())
  /// Handles tap on the reply action button.
  public func replyButtonPressed() {
    self.replyButtonPressedProperty.value = ()
  }

  private let viewDidLoadProperty = MutableProperty(())
  /// Notifies that the messages view loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  private let viewWillAppearProperty = MutableProperty(())
  /// Notifies that the messages view will appear.
  public func viewWillAppear() {
    self.viewWillAppearProperty.value = ()
  }

  private let viewPledgeUseCase: ViewPledgeUseCase

  /// Emits the backing, project, and whether navigation came from the backing screen.
  public let backingAndProjectAndIsFromBacking: Signal<(Backing, Project, Bool), Never>
  /// Emits whether the empty state is visible along with the message copy.
  public let emptyStateIsVisibleAndMessageToUser: Signal<(Bool, String), Never>
  /// Emits project and ref tag to open the project page.
  public let goToProject: Signal<(Project, RefTag), Never>
  /// Emits the ordered list of thread messages.
  public let messages: Signal<[Message], Never>
  /// Emits whether the other participant was previously blocked.
  public let participantPreviouslyBlocked: Signal<Bool, Never>
  /// Emits thread and analytics context to present the reply dialog.
  public let presentMessageDialog: Signal<(MessageThread, KSRAnalytics.MessageDialogContext), Never>
  /// Emits the project associated with the message thread.
  public let project: Signal<Project, Never>
  /// Emits whether the reply button is enabled.
  public let replyButtonIsEnabled: Signal<Bool, Never>
  /// Emits when the thread has been marked as read.
  public let successfullyMarkedAsRead: Signal<(), Never>
  /// Emits when blocking the participant succeeds.
  public let didBlockUser: Signal<(), Never>
  /// Emits when blocking the participant fails.
  public let didBlockUserError: Signal<(), Never>

  /// Emits native backing management navigation parameters.
  public var goToBacking: Signal<ManagePledgeViewParamConfigData, Never> {
    self.viewPledgeUseCase.goToNativePledgeView
  }

  /// Emits web pledge manager URL when viewing a pledge manager backing.
  public var goToPledgeManagementViewPledge: Signal<String, Never> {
    self.viewPledgeUseCase.goToPledgeManagementPledgeView
  }

  /// Input receiver (`self`).
  public var inputs: MessagesViewModelInputs { return self }
  /// Output provider (`self`).
  public var outputs: MessagesViewModelOutputs { return self }
}
