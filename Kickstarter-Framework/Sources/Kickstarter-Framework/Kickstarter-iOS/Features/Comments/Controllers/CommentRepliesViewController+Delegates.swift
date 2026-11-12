import KsApi
import Library
import Prelude
import UIKit

// MARK: - CommentComposerViewDelegate

/// `CommentRepliesViewController` extensions declared in `CommentRepliesViewController+Delegates.swift`.
extension CommentRepliesViewController: CommentComposerViewDelegate {
  func commentComposerView(_: CommentComposerView, didSubmitText text: String) {
    self.viewModel.inputs.commentComposerDidSubmitText(text)
  }
}

// MARK: - CommentCellDelegate

extension CommentRepliesViewController: CommentCellDelegate {
  func commentCellDidTapHeader(_ cell: CommentCell, _ author: Comment.Author) {
    self.handleCommentCellHeaderTapped(in: cell, author)
  }

  func commentCellDidTapReply(_: CommentCell, comment _: Comment) {}

  func commentCellDidTapViewReplies(_: CommentCell, comment _: Comment) {}
}

// MARK: - RootCommentCellDelegate

extension CommentRepliesViewController: RootCommentCellDelegate {
  func commentCellDidTapHeader(_ cell: RootCommentCell, _ author: Comment.Author) {
    self.handleCommentCellHeaderTapped(in: cell, author)
  }
}

// MARK: - MessageBannerViewControllerDelegate

extension CommentRepliesViewController: MessageBannerViewControllerDelegate {
  func messageBannerViewDidHide(type: MessageBannerType) {
    if type == .success {
      self.navigationController?.popViewController(animated: true)
    }
  }
}

// MARK: - Styles

internal let commentRepliesTableViewStyle: TableViewStyle = { tableView in
  tableView
    |> \.estimatedRowHeight .~ 100.0
    |> \.rowHeight .~ UITableView.automaticDimension
    |> \.separatorStyle .~ .none
}

/**
 Returns `true` for insert and scrolling when the `newComment` provided is `true`. Scrolling is false only if `comment` status is `failed` and `newComment` is `false`.

 - parameter comment: `Comment` object that we need the `status` value from.
 - parameter newComment: `Bool` that we need to check if the comment is new to the table view.

 - returns: A `Bool, Bool` which tells the caller to insert a table row and if the table view should scroll.
 */
internal func commentRepliesRowBehaviour(
  for comment: Comment,
  newComment: Bool
) -> (insert: Bool, scroll: Bool) {
  (insert: newComment, scroll: newComment || comment.status == .failed)
}

