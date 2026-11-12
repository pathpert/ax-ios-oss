import Foundation
import KsApi
import Prelude
import ReactiveExtensions
import ReactiveSwift

/// Immutable value type representing `CommentsPaginationOutputs`.
internal struct CommentsPaginationOutputs {
  let beginOrEndRefreshing: Signal<Bool, Never>
  let cellSeparatorHidden: Signal<Bool, Never>
  let loadCommentsAndProjectIntoDataSource: Signal<([Comment], Project, Bool), Never>
  let configureFooterViewWithState: Signal<CommentTableViewFooterViewState, Never>
  let currentComments: Signal<[Comment], Never>
  let failableOrComment: Signal<(Comment, String), Never>
  let retryingComment: Signal<(Comment, String), Never>
}

internal func makeCommentsPaginationSignals(
  projectOrUpdate: Signal<Either<Project, Update>, Never>,
  initialProject: Signal<Project, Never>,
  currentUser: Signal<User?, Never>,
  currentCommentsInput: Signal<[Comment], Never>,
  retryingCommentInput: Signal<(Comment, String), Never>,
  failableOrCommentInput: Signal<(Comment, String), Never>,
  willDisplayRowSignal: Signal<(row: Int, total: Int), Never>,
  footerRetryTappedSignal: Signal<Void, Never>,
  refreshSignal: Signal<Void, Never>,
  didSelectCommentSignal: Signal<Comment, Never>,
  commentComposerDidSubmitTextSignal: Signal<String, Never>
) -> CommentsPaginationOutputs {
  let isCloseToBottom = willDisplayRowSignal
    .map { args -> Bool in
      let (row, total) = args
      guard total > 1 else { return false }
      return row >= total - 3
    }
    .skipRepeats()
    .filter(isTrue)
    .ignoreValues()

  let retryNextPage = Signal.combineLatest(isCloseToBottom.take(first: 1), footerRetryTappedSignal)
  let retryFirstPage = footerRetryTappedSignal.take(until: isCloseToBottom)
  let requestNextPage = Signal.merge(isCloseToBottom.ignoreValues(), retryNextPage.ignoreValues())

  let requestFirstPageWith = Signal.merge(
    projectOrUpdate,
    projectOrUpdate.takeWhen(retryFirstPage),
    projectOrUpdate.takeWhen(refreshSignal)
      .ksr_debounce(.nanoseconds(0), on: AppEnvironment.current.scheduler)
  )
  let hasRequestedNextPage = Signal.merge(
    requestFirstPageWith.mapConst(false),
    requestNextPage.mapConst(true)
  )
  let (comments, isLoading, _, errors) = paginate(
    requestFirstPageWith: requestFirstPageWith,
    requestNextPageWhen: requestNextPage,
    clearOnNewRequest: true,
    valuesFromEnvelope: { $0.comments },
    cursorFromEnvelope: { ($0.slug, $0.cursor, $0.updateID) },
    requestFromParams: commentsFirstPage,
    requestFromCursor: commentsNextPage,
    concater: { _, value in value }
  )

  let commentsWithRetryingComment = currentCommentsInput
    .takePairWhen(retryingCommentInput)
    .map(unpack)
    .map(commentsReplacingCommentById)

  let commentsWithFailableOrComment = currentCommentsInput
    .takePairWhen(failableOrCommentInput)
    .map(unpack)
    .map(commentsReplacingCommentById)

  let paginatedComments = Signal.merge(
    refreshSignal.mapConst(([], true)),
    comments.map { comments in (comments, false) },
    commentsWithRetryingComment.map { comments in (comments, true) },
    commentsWithFailableOrComment.map { comments in (comments, true) }
  )
  .scan([]) { accum, value -> [Comment] in
    let (comments, clear) = value
    guard clear == false else { return comments }
    return accum + comments
  }

  let commentsAndProject = Signal.combineLatest(paginatedComments, initialProject)
  let currentComments = commentsAndProject.map(first)
    .ksr_debounce(.nanoseconds(0), on: AppEnvironment.current.scheduler)

  let emptyCommentsWithInitialProject = Signal.zip(comments, initialProject)
    .filter { comments, _ in comments.isEmpty }
    .map { args in (args.0, args.1, false) }

  let paginatedCommentsAndProject = commentsAndProject
    .filter { comments, _ in comments.isEmpty == false }
    .map { args in (args.0, args.1, false) }

  let errorsAndHasRequestedNextPage: Signal<([Comment], Project, Bool), Never> = Signal
    .combineLatest(errors, hasRequestedNextPage)
    .filter(second >>> isFalse)
    .map(first)
    .withLatestFrom(initialProject)
    .map { args in ([], args.1, true) }

  let loadCommentsAndProjectIntoDataSource = Signal.merge(
    emptyCommentsWithInitialProject,
    paginatedCommentsAndProject,
    errorsAndHasRequestedNextPage
  )

  let commentableId = projectOrUpdate
    .flatMap { projectOrUpdate in
      projectOrUpdate.ifLeft { project in
        SignalProducer(value: project.graphID)
      } ifRight: { update in
        SignalProducer(value: encodeToBase64("FreeformPost-\(update.id)"))
      }
    }

  let postFailableCommentConfigData: Signal<(project: Project, commentableId: String, user: User), Never> = Signal
    .combineLatest(initialProject, commentableId, currentUser.skipNil())
    .map { args in (project: args.0, commentableId: args.1, user: args.2) }

  let failableOrComment = postFailableCommentConfigData
    .takePairWhen(commentComposerDidSubmitTextSignal)
    .map { data in
      let ((project, commentableId, user), text) = data
      return (project, commentableId, nil, user, text)
    }
    .flatMap(
      .concurrent(limit: CommentsViewModel.concurrentCommentLimit),
      CommentsViewModel.postCommentProducer
    )

  let erroredCommentTapped = didSelectCommentSignal.filter { $0.status == .failed }
  let currentlyRetrying = MutableProperty<Set<String>>([])
  let newErroredCommentTapped = erroredCommentTapped
    .filter { [currentlyRetrying] comment in !currentlyRetrying.value.contains(comment.id) }
    .on(value: { [currentlyRetrying] comment in currentlyRetrying.value.insert(comment.id) })

  let retryingComment = commentableId
    .takePairWhen(newErroredCommentTapped)
    .map { args in (args.1, args.0, nil) }
    .flatMap(
      .concurrent(limit: CommentsViewModel.concurrentCommentLimit),
      CommentsViewModel.retryCommentProducer
    )
    .on(value: { [currentlyRetrying] _, id in currentlyRetrying.value.remove(id) })

  let footerViewActivityState = Signal
    .combineLatest(isCloseToBottom, isLoading)
    .filter(second >>> isTrue)

  let initialLoadOrReload = Signal.merge(
    projectOrUpdate.ignoreValues(),
    loadCommentsAndProjectIntoDataSource.ignoreValues()
  )

  let hideFooterView: Signal<CommentTableViewFooterViewState, Never> = Signal.merge(
    initialLoadOrReload.mapConst(.hidden),
    errors.mapConst(.hidden).withLatestFrom(hasRequestedNextPage).filter(second >>> isFalse).map(first)
  )

  let configureFooterViewWithState = Signal.merge(
    hideFooterView,
    footerViewActivityState.mapConst(.activity),
    errors.mapConst(.error).withLatestFrom(hasRequestedNextPage).filter(second >>> isTrue).map(first)
  )
  .skipRepeats()

  return CommentsPaginationOutputs(
    beginOrEndRefreshing: isLoading,
    cellSeparatorHidden: commentsAndProject.map(first).map { $0.count == .zero },
    loadCommentsAndProjectIntoDataSource: loadCommentsAndProjectIntoDataSource,
    configureFooterViewWithState: configureFooterViewWithState,
    currentComments: currentComments,
    failableOrComment: failableOrComment,
    retryingComment: retryingComment
  )
}
