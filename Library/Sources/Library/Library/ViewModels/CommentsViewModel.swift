import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Manages project and update comments pagination, reply navigation, comment posting/retrying, and user blocking.
public final class CommentsViewModel: CommentsViewModelType,
  CommentsViewModelInputs,
  CommentsViewModelOutputs {
  // MARK: Initializers

  /// Creates a comments view model and binds pagination, composer, and blocking signals.
  public init() {
    let projectOrUpdate = Signal.combineLatest(
      self.projectAndUpdateProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)
    .flatMap { project, update in
      SignalProducer(value: project.map(Either.left) ?? update.map(Either.right))
        .skipNil()
    }

    let currentUser = self.viewDidLoadProperty.signal.map { _ in AppEnvironment.current.currentUser }
    let initialProject = projectOrUpdate.flatMap { projectOrUpdate in
      projectOrUpdate.ifLeft(
        SignalProducer.init(value:),
        ifRight: { AppEnvironment.current.apiService.fetchProject(param: .id($0.projectId)).demoteErrors() }
      )
    }

    self.configureCommentComposerViewWithData = Signal
      .combineLatest(initialProject, currentUser.signal, self.viewDidLoadProperty.signal.ignoreValues())
      .map { makeCommentComposerViewData(project: $0.0, currentUser: $0.1) }

    let pagination = makeCommentsPaginationSignals(
      projectOrUpdate: projectOrUpdate,
      initialProject: initialProject,
      currentUser: currentUser,
      currentCommentsInput: self.currentComments.signal.skipNil(),
      retryingCommentInput: self.retryingComment.signal.skipNil(),
      failableOrCommentInput: self.failableOrComment.signal.skipNil(),
      willDisplayRowSignal: self.willDisplayRowProperty.signal.skipNil(),
      footerRetryTappedSignal: self.commentTableViewFooterViewDidTapRetryProperty.signal,
      refreshSignal: self.refreshProperty.signal,
      didSelectCommentSignal: self.didSelectCommentProperty.signal.skipNil(),
      commentComposerDidSubmitTextSignal: self.commentComposerDidSubmitTextProperty.signal.skipNil()
    )

    self.currentComments <~ pagination.currentComments
    self.failableOrComment <~ pagination.failableOrComment
    self.retryingComment <~ pagination.retryingComment
    self.loadCommentsAndProjectIntoDataSource = pagination.loadCommentsAndProjectIntoDataSource
    self.beginOrEndRefreshing = pagination.beginOrEndRefreshing
    self.cellSeparatorHidden = pagination.cellSeparatorHidden
    self.configureFooterViewWithState = pagination.configureFooterViewWithState
    self.resetCommentComposerAndScrollToTop = self.commentComposerDidSubmitTextProperty.signal
      .skipNil().ignoreValues()

    let viewCommentReplies = self.commentCellDidTapViewRepliesProperty.signal
      .skipNil()
      .filter { ($0.replyCount ?? 0) > 0 }

    let update = self.projectAndUpdateProperty.signal.skipNil().map(second)
    let commentsWithRepliesAndProject = Signal.combineLatest(viewCommentReplies, initialProject, update)
    let replyCommentWithProject = Signal.combineLatest(
      self.commentCellDidTapReplyProperty.signal.skipNil(),
      initialProject,
      update
    )

    self.goToRepliesWithCommentProjectUpdateAndBecomeFirstResponder = Signal.merge(
      commentsWithRepliesAndProject.map { args in (args.0, args.1, args.2, false) },
      replyCommentWithProject.map { args in (args.0, args.1, args.2, true) }
    )

    self.showHelpWebViewController = self.commentRemovedCellDidTapURLProperty.signal.skipNil()
      .map(HelpType.helpType)
      .skipNil()

    let blockUserEvent = self.blockUserProperty.signal
      .map(BlockUserInput.init(blockUserId:))
      .switchMap { input in
        AppEnvironment.current.apiService.blockUser(input: input)
          .ksr_delay(AppEnvironment.current.apiDelayInterval, on: AppEnvironment.current.scheduler)
          .materialize()
      }

    self.didBlockUser = blockUserEvent.values().ignoreValues()
      .map { _ in NotificationCenter.default.post(.init(name: .ksr_blockedUser)) }
    // TODO: Display proper error messaging from the backend
    self.didBlockUserError = blockUserEvent.errors().ignoreValues()

    bindCommentsBlockingAnalytics(
      blockUserSignal: self.blockUserProperty.signal,
      initialProject: initialProject,
      blockUserSuccessSignal: self.didBlockUser
    )
  }

  private let currentComments = MutableProperty<[Comment]?>(nil)
  private let retryingComment = MutableProperty<(Comment, String)?>(nil)
  private let failableOrComment = MutableProperty<(Comment, String)?>(nil)

  private let blockUserProperty = MutableProperty<String>("")
  /// Requests blocking the comment author with the given identifier.
  public func blockUser(id: String) { self.blockUserProperty.value = id }

  private let commentCellDidTapViewRepliesProperty = MutableProperty<Comment?>(nil)
  /// Opens the replies screen for the selected comment.
  public func commentCellDidTapViewReplies(_ comment: Comment) { self.commentCellDidTapViewRepliesProperty.value = comment }

  private let didSelectCommentProperty = MutableProperty<Comment?>(nil)
  /// Handles selecting a comment row, triggering retry if it failed to post.
  public func didSelectComment(_ comment: Comment) { self.didSelectCommentProperty.value = comment }

  fileprivate let commentComposerDidSubmitTextProperty = MutableProperty<String?>(nil)
  /// Submits newly composed comment text.
  public func commentComposerDidSubmitText(_ text: String) { self.commentComposerDidSubmitTextProperty.value = text }

  fileprivate let commentRemovedCellDidTapURLProperty = MutableProperty<URL?>(nil)
  /// Handles tapping a guidelines URL inside a removed comment cell.
  public func commentRemovedCellDidTapURL(_ url: URL) { self.commentRemovedCellDidTapURLProperty.value = url }

  fileprivate let commentCellDidTapReplyProperty = MutableProperty<Comment?>(nil)
  /// Opens the replies screen with the keyboard focused to reply.
  public func commentCellDidTapReply(comment: Comment) { self.commentCellDidTapReplyProperty.value = comment }

  private let commentTableViewFooterViewDidTapRetryProperty = MutableProperty(())
  /// Retries loading the next page of comments after a pagination failure.
  public func commentTableViewFooterViewDidTapRetry() { self.commentTableViewFooterViewDidTapRetryProperty.value = () }

  fileprivate let projectAndUpdateProperty = MutableProperty<(Project?, Update?)?>(nil)
  /// Configures the view model with a project or update to display comments for.
  public func configureWith(project: Project?, update: Update?) { self.projectAndUpdateProperty.value = (project, update) }

  fileprivate let refreshProperty = MutableProperty(())
  /// Refreshes the comments feed from the first page.
  public func refresh() { self.refreshProperty.value = () }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Notifies the view model that the view loaded.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  fileprivate let willDisplayRowProperty = MutableProperty<(row: Int, total: Int)?>(nil)
  /// Triggers next-page prefetching as rows near the bottom of the list.
  public func willDisplayRow(_ row: Int, outOf totalRows: Int) { self.willDisplayRowProperty.value = (row, totalRows) }

  /// Emits whether comments are currently refreshing.
  public let beginOrEndRefreshing: Signal<Bool, Never>
  /// Emits whether table cell separators should be hidden.
  public let cellSeparatorHidden: Signal<Bool, Never>
  /// Emits configuration data for the comment composer view.
  public let configureCommentComposerViewWithData: Signal<CommentComposerViewData, Never>
  /// Emits footer loading/error/hidden state updates.
  public let configureFooterViewWithState: Signal<CommentTableViewFooterViewState, Never>
  /// Navigates to replies with comment, project, optional update, and first-responder flag.
  public let goToRepliesWithCommentProjectUpdateAndBecomeFirstResponder: Signal<(Comment, Project, Update?, Bool), Never>
  /// Loads fetched comments, project, and error state into the data source.
  public let loadCommentsAndProjectIntoDataSource: Signal<([Comment], Project, Bool), Never>
  /// Opens a help web view controller for removed-comment policy links.
  public let showHelpWebViewController: Signal<HelpType, Never>
  /// Resets the composer and scrolls back to the top after posting.
  public let resetCommentComposerAndScrollToTop: Signal<(), Never>
  /// Emits when a block-user request succeeds.
  public let didBlockUser: Signal<(), Never>
  /// Emits when a block-user request fails.
  public var didBlockUserError: Signal<(), Never>

  /// Input interface.
  public var inputs: CommentsViewModelInputs { return self }
  /// Output interface.
  public var outputs: CommentsViewModelOutputs { return self }
}
