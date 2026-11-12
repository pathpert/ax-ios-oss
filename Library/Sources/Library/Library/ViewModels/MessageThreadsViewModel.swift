import KsApi
import Prelude
import ReactiveSwift

/// Inputs accepted by `MessageThreadsViewModel`.
public protocol MessageThreadsViewModelInputs {
  /// Call when the mailbox chooser button is pressed.
  func mailboxButtonPressed()

  /// Call with the project whose message threads we are viewing. If no project or refTag is given, then use
  /// `nil`.
  func configureWith(project: Project?, refTag: RefTag?)

  /// Call when pull-to-refresh is invoked.
  func refresh()

  /// Call when the search button is pressed.
  func searchButtonPressed()

  /// Call when the user has selected a mailbox to switch to.
  func switchTo(mailbox: Mailbox)

  /// Call when the view loads.
  func viewDidLoad()

  /// Call when a new row is displayed.
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

/// Outputs exposed by `MessageThreadsViewModel`.
public protocol MessageThreadsViewModelOutputs {
  /// Emits a boolean that determines if the empty state is visible.
  var emptyStateIsVisible: Signal<Bool, Never> { get }

  /// Emits when we should go to the search messages screen.
  var goToSearch: Signal<(), Never> { get }

  /// Emits a boolean that determines if the footer loading view is hidden.
  var loadingFooterIsHidden: Signal<Bool, Never> { get }

  /// Emits a string of the mailbox we are currently viewing.
  var mailboxName: Signal<String, Never> { get }

  /// Emits an array of message threads to be displayed.
  var messageThreads: Signal<[MessageThread], Never> { get }

  /// Emits when the refresh control should end refreshing.
  var refreshControlEndRefreshing: Signal<(), Never> { get }

  /// Emits when an action sheet should be displayed that allows the user to choose mailboxes.
  var showMailboxChooserActionSheet: Signal<(), Never> { get }
}

/// Combined inputs and outputs interface for `MessageThreadsViewModel`.
public protocol MessageThreadsViewModelType {
  /// The view model's inputs.
  var inputs: MessageThreadsViewModelInputs { get }
  /// The view model's outputs.
  var outputs: MessageThreadsViewModelOutputs { get }
}

/// View model managing the inbox/sent message threads list, pagination, and mailbox switching.
public final class MessageThreadsViewModel: MessageThreadsViewModelType, MessageThreadsViewModelInputs,
  MessageThreadsViewModelOutputs {
  /// Creates a new `MessageThreadsViewModel` and binds mailbox pagination signals.
  public init() {
    let isCloseToBottom = self.willDisplayRowProperty.signal.skipNil()
      .filter { _, total in total > 1 }
      .map { row, total in row >= total - 3 }
      .skipRepeats()
      .filter { isClose in isClose }
      .ignoreValues()

    let mailbox = Signal.merge(
      self.switchToMailbox.signal.skipNil(),
      self.viewDidLoadProperty.signal.mapConst(.inbox)
    )

    let requestFirstPageWith = Signal.merge(
      mailbox,
      mailbox.takeWhen(self.refreshProperty.signal)
    )

    let (messageThreads, isLoading, _, _) = paginate(
      requestFirstPageWith: requestFirstPageWith,
      requestNextPageWhen: isCloseToBottom,
      clearOnNewRequest: true,
      valuesFromEnvelope: { $0.messageThreads },
      cursorFromEnvelope: { $0.urls.api.moreMessageThreads },
      requestFromParams: { [project = configDataProperty.producer.map { $0?.project }] mailbox in
        project.take(first: 1)
          .promoteError(ErrorEnvelope.self)
          .flatMap { project in
            AppEnvironment.current.apiService.fetchMessageThreads(mailbox: mailbox, project: project)
          }
      },
      requestFromCursor: {
        AppEnvironment.current.apiService.fetchMessageThreads(paginationUrl: $0)
      }
    )

    self.mailboxName = mailbox.map {
      switch $0 {
      case .inbox: return Strings.messages_navigation_inbox()
      case .sent: return Strings.messages_navigation_sent()
      }
    }

    self.messageThreads = messageThreads

    self.refreshControlEndRefreshing = isLoading.filter(isFalse).ignoreValues()

    self.emptyStateIsVisible = Signal.merge(
      self.messageThreads.filter { !$0.isEmpty }.mapConst(false),
      self.messageThreads.takeWhen(isLoading.filter(isFalse)).filter { $0.isEmpty }.mapConst(true)
    ).skipRepeats()

    self.loadingFooterIsHidden = Signal.merge([
      self.viewDidLoadProperty.signal.take(first: 1).mapConst(false),
      isCloseToBottom.mapConst(false),
      mailbox.mapConst(false),
      isLoading.filter(isFalse).mapConst(true)
    ]).skipRepeats()

    self.showMailboxChooserActionSheet = self.mailboxButtonPressedProperty.signal

    self.goToSearch = self.searchButtonPressedProperty.signal
  }

  fileprivate let mailboxButtonPressedProperty = MutableProperty(())
  /// Requests presentation of the inbox/sent mailbox chooser action sheet.
  public func mailboxButtonPressed() {
    self.mailboxButtonPressedProperty.value = ()
  }

  fileprivate let configDataProperty = MutableProperty<ConfigData?>(nil)
  /// Configures the message threads view with an optional scoped `Project` and `RefTag`.
  public func configureWith(project: Project?, refTag: RefTag?) {
    self.configDataProperty.value = ConfigData(project: project, refTag: refTag)
  }

  fileprivate let refreshProperty = MutableProperty(())
  /// Reloads message threads from the first page.
  public func refresh() {
    self.refreshProperty.value = ()
  }

  fileprivate let searchButtonPressedProperty = MutableProperty(())
  /// Navigates to message thread search.
  public func searchButtonPressed() {
    self.searchButtonPressedProperty.value = ()
  }

  fileprivate let switchToMailbox = MutableProperty<Mailbox?>(nil)
  /// Switches the active list between inbox and sent mailboxes.
  public func switchTo(mailbox: Mailbox) {
    self.switchToMailbox.value = mailbox
  }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals that the message threads view has loaded.
  public func viewDidLoad() {
    self.viewDidLoadProperty.value = ()
  }

  fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
  /// Notifies pagination as rows near the end of the table are displayed.
  public func willDisplayRow(_ row: Int, outOf totalRows: Int) {
    self.willDisplayRowProperty.value = (row, totalRows)
  }

  /// Emits whether the empty-mailbox state should be shown.
  public let emptyStateIsVisible: Signal<Bool, Never>
  /// Emits whether the loading footer spinner should be hidden.
  public let loadingFooterIsHidden: Signal<Bool, Never>
  /// Emits when navigating to message search.
  public let goToSearch: Signal<(), Never>
  /// Emits the localized title for the selected mailbox.
  public let mailboxName: Signal<String, Never>
  /// Emits the paginated list of `MessageThread` values.
  public let messageThreads: Signal<[MessageThread], Never>
  /// Emits when pull-to-refresh should stop animating.
  public let refreshControlEndRefreshing: Signal<(), Never>
  /// Emits when the mailbox selection sheet should be presented.
  public let showMailboxChooserActionSheet: Signal<(), Never>

  /// The inputs interface for this view model.
  public var inputs: MessageThreadsViewModelInputs { return self }
  /// The outputs interface for this view model.
  public var outputs: MessageThreadsViewModelOutputs { return self }
}

private struct ConfigData {
  fileprivate let project: Project?
  fileprivate let refTag: RefTag?
}
