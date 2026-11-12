import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// View model managing pagination, reply composition, retry logic, and user blocking on comment replies.
public final class CommentRepliesViewModel: CommentRepliesViewModelType,
  CommentRepliesViewModelInputs,
  CommentRepliesViewModelOutputs {
  /// Initializes the comment replies view model.
  public init() {
    let rootCommentProject = Signal.combineLatest(
      self.commentProjectProperty.signal.skipNil(),
      self.viewDidLoadProperty.signal
    )
    .map(first)

    let rootComment = rootCommentProject.map(first)
    let project = rootCommentProject.map(second)

    self.loadCommentIntoDataSource = rootComment

    let currentUser = self.viewDidLoadProperty.signal
      .map { _ in AppEnvironment.current.currentUser }

    let inputAreaBecomeFirstResponder = Signal.merge(
      rootCommentProject
        .map(third)
        .takeWhen(self.viewDidAppearProperty.signal),
      self.viewDidLoadProperty.signal.mapConst(false)
    ).skipRepeats()

    self.resetCommentComposer = self.commentComposerDidSubmitTextProperty.signal.skipNil()
      .ignoreValues()

    self.configureCommentComposerViewWithData = Signal
      .combineLatest(
        project,
        currentUser.signal,
        self.viewDidLoadProperty.signal,
        inputAreaBecomeFirstResponder
      )
      .map { ($0.0, $0.1, $0.3) }
      .map { project, currentUser, inputAreaBecomeFirstResponder in
        let isBacker = userIsBackingProject(project)
        let isCreatorOrCollaborator = !project.memberData.permissions.isEmpty && !isBacker
        let canPostComment = isBacker || isCreatorOrCollaborator

        guard let user = currentUser else {
          return CommentComposerViewData(
            avatarURL: nil,
            canPostComment: false,
            hidden: true,
            becomeFirstResponder: false
          )
        }

        let url = URL(string: user.avatar.medium)
        return CommentComposerViewData(
          avatarURL: url,
          canPostComment: canPostComment,
          hidden: false,
          becomeFirstResponder: inputAreaBecomeFirstResponder
        )
      }

    let commentCellTapped = self.didSelectCommentProperty.signal.skipNil()
    let erroredCommentTapped = commentCellTapped.filter { comment in comment.status == .failed }

    let requestFirstPageWith = Signal.merge(
      rootComment,
      rootComment.takeWhen(self.retryFirstPageProperty.signal)
    )

    let totalCountProperty = MutableProperty<Int>(0)

    // TODO: Handle isLoading from here
    let (replies, _, _, error) = paginate(
      requestFirstPageWith: requestFirstPageWith,
      requestNextPageWhen: self.paginateOrErrorCellWasTappedProperty.signal,
      clearOnNewRequest: true,
      valuesFromEnvelope: { [totalCountProperty] envelope -> [Comment] in
        totalCountProperty.value = envelope.totalCount
        return envelope.replies
      },
      cursorFromEnvelope: { ($0.comment, $0.cursor) },
      requestFromParams: { comment in
        AppEnvironment.current.apiService.fetchCommentReplies(
          id: comment.id,
          cursor: nil,
          limit: CommentRepliesEnvelope.paginationLimit
        )
      },
      requestFromCursor: { comment, cursor in
        AppEnvironment.current.apiService.fetchCommentReplies(
          id: comment.id,
          cursor: cursor,
          limit: CommentRepliesEnvelope.paginationLimit
        )
      },
      // only return new pages, we'll concat them ourselves
      concater: { _, value in value }
    )

    let commentComposerDidSubmitText = self.commentComposerDidSubmitTextProperty.signal.skipNil()

    // If the Update is non-nil we send the FreeformPost format, otherwise we send the Project graphID
    let commentableId = self.updateProperty.signal.combineLatest(with: project)
      .map { update, project -> String in
        guard let update = update else { return project.graphID }
        return encodeToBase64("FreeformPost-\(update.id)")
      }

    let parentId = rootComment.flatMap { SignalProducer(value: $0.id) }

    let failablePostReplyCommentConfigData:
      Signal<(project: Project, commentableId: String, parentId: String, user: User), Never> = Signal
      .combineLatest(project, commentableId, parentId, currentUser.skipNil())
      .map { ($0, $1, $2, $3) }

    let failableCommentWithReplacementId = failablePostReplyCommentConfigData
      .takePairWhen(commentComposerDidSubmitText)
      .map { data in (data.0.project, data.0.commentableId, data.0.parentId, data.0.user, data.1) }
      .flatMap(
        .concurrent(limit: CommentsViewModel.concurrentCommentLimit),
        CommentsViewModel.postCommentProducer
      )

    let currentlyRetrying = MutableProperty<Set<String>>([])

    let newErroredCommentTapped = erroredCommentTapped
      // Check that we are not currently retrying this comment.
      .filter { [currentlyRetrying] comment in !currentlyRetrying.value.contains(comment.id) }
      // If we pass the filter add it to our set of retrying comments.
      .on(value: { [currentlyRetrying] comment in currentlyRetrying.value.insert(comment.id) })

    let retryingComment = commentableId
      .takePairWhen(newErroredCommentTapped)
      .map { commentableId, comment in (comment, commentableId, comment.parentId) }
      .flatMap(
        .concurrent(limit: CommentsViewModel.concurrentCommentLimit),
        CommentsViewModel.retryCommentProducer
      )
      // Once we've emitted a value here the comment has been retried and can be removed.
      .on(value: { [currentlyRetrying] _, id in currentlyRetrying.value.remove(id) })

    self.loadRepliesAndProjectIntoDataSource = replies.withLatestFrom(totalCountProperty.signal)
      .combineLatest(with: project)

    let failableOrRetriedComment = Signal.merge(retryingComment, failableCommentWithReplacementId)

    self.loadFailableReplyIntoDataSource = Signal.combineLatest(failableOrRetriedComment, project)
      .map(unpack)

    self.showPaginationErrorState = error.ignoreValues()
    self.scrollToReply = self.replyIdProperty.signal.skipNil().takeWhen(self.dataSourceLoadedProperty.signal)

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
      .combineLatest(with: project)
      .observeValues { blockedUserId, project in
        AppEnvironment.current.ksrAnalytics.trackBlockedUser(
          project,
          page: .project,
          sectionContext: .comments,
          typeContext: .initiate,
          targetUserId: "\(blockedUserId)"
        )
      }

    _ = self.blockUserProperty.signal
      .combineLatest(with: project)
      .takeWhen(blockUserEvent.values().ignoreValues())
      .observeValues { blockedUserId, project in
        AppEnvironment.current.ksrAnalytics.trackBlockedUser(
          project,
          page: .project,
          sectionContext: .comments,
          typeContext: .confirm,
          targetUserId: "\(blockedUserId)"
        )
      }
  }

  private let blockUserProperty = MutableProperty<String>("")
  /// Requests blocking the user with the given ID.
  public func blockUser(id: String) { self.blockUserProperty.value = id }

  private let didSelectCommentProperty = MutableProperty<Comment?>(nil)
  /// Notifies the view model that a comment cell was selected.
  public func didSelectComment(_ comment: Comment) { self.didSelectCommentProperty.value = comment }

  fileprivate let commentComposerDidSubmitTextProperty = MutableProperty<String?>(nil)
  /// Submits reply text entered in the comment composer.
  public func commentComposerDidSubmitText(_ text: String) { self.commentComposerDidSubmitTextProperty.value = text }

  fileprivate let commentProjectProperty = MutableProperty<(Comment, Project, Bool)?>(nil)
  fileprivate let updateProperty = MutableProperty<Update?>(nil)
  fileprivate let replyIdProperty = MutableProperty<String?>(nil)
  /// Configures the view model with root comment, project, optional update, composer state, and target reply ID.
  public func configureWith(
    comment: Comment,
    project: Project,
    update: Update?,
    inputAreaBecomeFirstResponder: Bool,
    replyId: String?
  ) {
    self.commentProjectProperty.value = (comment, project, inputAreaBecomeFirstResponder)
    self.updateProperty.value = update
    self.replyIdProperty.value = replyId
  }

  fileprivate let paginateOrErrorCellWasTappedProperty = MutableProperty(())
  /// Requests loading the next page of replies or retrying pagination.
  public func paginateOrErrorCellWasTapped() { self.paginateOrErrorCellWasTappedProperty.value = () }

  fileprivate let retryFirstPageProperty = MutableProperty(())
  /// Retries loading the first page of replies.
  public func retryFirstPage() { self.retryFirstPageProperty.value = () }

  fileprivate let dataSourceLoadedProperty = MutableProperty(())
  /// Signals that initial replies data finished loading into the data source.
  public func dataSourceLoaded() { self.dataSourceLoadedProperty.value = () }

  fileprivate let viewDidAppearProperty = MutableProperty(())
  /// Signals `viewDidAppear` lifecycle appearance.
  public func viewDidAppear() { self.viewDidAppearProperty.value = () }

  fileprivate let viewDidLoadProperty = MutableProperty(())
  /// Signals `viewDidLoad` lifecycle readiness.
  public func viewDidLoad() { self.viewDidLoadProperty.value = () }

  /// Emits data to configure comment composer view.
  public let configureCommentComposerViewWithData: Signal<CommentComposerViewData, Never>
  /// Emits a root `Comment` to load into the data source.
  public let loadCommentIntoDataSource: Signal<Comment, Never>
  /// Emits replies tuple and `Project` to load into the data source.
  public var loadRepliesAndProjectIntoDataSource: Signal<(([Comment], Int), Project), Never>
  /// Emits optimistic or retried comment reply alongside original ID and `Project`.
  public let loadFailableReplyIntoDataSource: Signal<(Comment, String, Project), Never>
  /// Emits when a comment has been posted to reset the composer.
  public let resetCommentComposer: Signal<(), Never>
  /// Emits reply ID to scroll to once loaded.
  public let scrollToReply: Signal<String, Never>
  /// Emits when a pagination error occurs.
  public let showPaginationErrorState: Signal<(), Never>
  /// Emits when a block user request succeeds.
  public var didBlockUser: Signal<(), Never>
  /// Emits when a block user request fails.
  public var didBlockUserError: Signal<(), Never>

  /// Input interface for this view model.
  public var inputs: CommentRepliesViewModelInputs { return self }
  /// Output interface for this view model.
  public var outputs: CommentRepliesViewModelOutputs { return self }
}
