import Foundation
import KsApi
import ReactiveSwift

/// Input events handled by `CommentsViewModel`.
public protocol CommentsViewModelInputs {
  /// Call when block user is tapped.
  func blockUser(id: String)
  /// Call when the delegate method for `CommentCellDelegate` is called to reply.
  func commentCellDidTapReply(comment: Comment)
  /// Call when the delegate method for `CommentCellDelegate` is called to view replies.
  func commentCellDidTapViewReplies(_ comment: Comment)
  /// Call when the user is posting a comment or reply.
  func commentComposerDidSubmitText(_ text: String)
  /// Call when the delegate method for `CommentRemovedCellDelegate` is called.
  func commentRemovedCellDidTapURL(_ url: URL)
  /// Call when the user tapped to retry after failed pagination.
  func commentTableViewFooterViewDidTapRetry()
  /// Call with the project and/or update whose comments are being viewed.
  func configureWith(project: Project?, update: Update?)
  /// Call with a `Comment` when it is selected.
  func didSelectComment(_ comment: Comment)
  /// Call when pull-to-refresh is invoked.
  func refresh()
  /// Call when the view loads.
  func viewDidLoad()
  /// Call when a new row is displayed.
  func willDisplayRow(_ row: Int, outOf totalRows: Int)
}

/// Output signals emitted by `CommentsViewModel`.
public protocol CommentsViewModelOutputs {
  /// Emits a boolean indicating whether comments are currently refreshing.
  var beginOrEndRefreshing: Signal<Bool, Never> { get }
  /// Emits a boolean determining whether the cell separator is hidden.
  var cellSeparatorHidden: Signal<Bool, Never> { get }
  /// Emits data to configure the comment composer view.
  var configureCommentComposerViewWithData: Signal<CommentComposerViewData, Never> { get }
  /// Configures the table footer view with the current pagination state.
  var configureFooterViewWithState: Signal<CommentTableViewFooterViewState, Never> { get }
  /// Emits the selected `Comment`, `Project`, `Update?`, and whether the keyboard should appear when navigating to replies.
  var goToRepliesWithCommentProjectUpdateAndBecomeFirstResponder: Signal<
    (Comment, Project, Update?, Bool),
    Never
  > { get }
  /// Emits loaded comments, `Project`, and whether an error state should be displayed.
  var loadCommentsAndProjectIntoDataSource: Signal<([Comment], Project, Bool), Never> { get }
  /// Emits a `HelpType` when presenting `HelpWebViewController`.
  var showHelpWebViewController: Signal<HelpType, Never> { get }
  /// Emits when a comment is posted so the UI scrolls to top and resets the composer.
  var resetCommentComposerAndScrollToTop: Signal<(), Never> { get }
  /// Emits when a block user request succeeds.
  var didBlockUser: Signal<(), Never> { get }
  /// Emits when a block user request fails.
  var didBlockUserError: Signal<(), Never> { get }
}

/// Protocol unifying inputs and outputs for `CommentsViewModel`.
public protocol CommentsViewModelType {
  /// Input receiver for comments UI events.
  var inputs: CommentsViewModelInputs { get }
  /// Output signal provider for comments UI updates.
  var outputs: CommentsViewModelOutputs { get }
}

