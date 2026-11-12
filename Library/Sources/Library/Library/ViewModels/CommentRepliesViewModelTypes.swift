import Foundation
import KsApi
import ReactiveSwift

/// Input actions supported by `CommentRepliesViewModel`.
public protocol CommentRepliesViewModelInputs {
  /// Call when block user is tapped.
  func blockUser(id: String)

  /**
    Call with the comment and project that we are viewing replies for. `Comment` can be provided to minimize
    the number of API requests made (ie. no need to find the comment id), but this is for viewing the replies for the root comment.

     - parameter comment: The `Comment` we are viewing the replies.
     - parameter project: The `Project` the comment replies are for.
     - parameter update: The `Update?` the comment replies are for.
     - parameter inputAreaBecomeFirstResponder: A Bool that determines if the composer should become first responder.
     - parameter replyId: A `String?` that determines which cell to scroll to, if visible on the first page.
   **/
  func configureWith(
    comment: Comment,
    project: Project,
    update: Update?,
    inputAreaBecomeFirstResponder: Bool,
    replyId: String?
  )

  /// Call when the User is posting a comment or reply.
  func commentComposerDidSubmitText(_ text: String)

  /// Call with a `Comment` when it is selected.
  func didSelectComment(_ comment: Comment)

  /// Call in `didSelectRow` when either a `ViewMoreRepliesCell` or `CommentViewMoreRepliesFailedCell` is tapped.
  func paginateOrErrorCellWasTapped()

  /// Call after the data source is loaded and the tableView reloads.
  func dataSourceLoaded()

  /// Call when there is a failure in requesting the first page of the data and the `CommentViewMoreRepliesFailedCell` is tapped.
  func retryFirstPage()

  /// Call when the view appears.
  func viewDidAppear()

  /// Call when the view loads.
  func viewDidLoad()
}

/// UI and pagination outputs emitted by `CommentRepliesViewModel`.
public protocol CommentRepliesViewModelOutputs {
  /// Emits data to configure comment composer view.
  var configureCommentComposerViewWithData: Signal<CommentComposerViewData, Never> { get }
  /// Emits a root `Comment` to load into the data source.
  var loadCommentIntoDataSource: Signal<Comment, Never> { get }
  /// Emits a tuple of (`[Comment]`, `Int`) and a `Project` to load into the data source.
  var loadRepliesAndProjectIntoDataSource: Signal<(([Comment], Int), Project), Never> { get }
  /// Emits a `Comment`, `String`, and `Project` to replace an optimistically posted comment.
  var loadFailableReplyIntoDataSource: Signal<(Comment, String, Project), Never> { get }
  /// Emits when a comment has been posted to reset the composer.
  var resetCommentComposer: Signal<(), Never> { get }
  /// Emits when a replyId is supplied to scroll to a specific reply.
  var scrollToReply: Signal<String, Never> { get }
  /// Emits when a pagination error has occurred.
  var showPaginationErrorState: Signal<(), Never> { get }
  /// Emits when a block user request is successful.
  var didBlockUser: Signal<(), Never> { get }
  /// Emits when a block user request fails.
  var didBlockUserError: Signal<(), Never> { get }
}

/// View model interface for the comment replies screen.
public protocol CommentRepliesViewModelType {
  /// Input interface for the comment replies view model.
  var inputs: CommentRepliesViewModelInputs { get }
  /// Output interface for the comment replies view model.
  var outputs: CommentRepliesViewModelOutputs { get }
}

