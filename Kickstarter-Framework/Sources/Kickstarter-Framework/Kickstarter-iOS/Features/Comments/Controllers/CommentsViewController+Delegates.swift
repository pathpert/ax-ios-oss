import KDS
import KsApi
import Library
import UIKit

// MARK: - UITableViewDelegate

/// `CommentsViewController` extensions declared in `CommentsViewController+Delegates.swift`.
extension CommentsViewController {
  override func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
    (cell as? CommentCell)?.delegate = self
    (cell as? CommentRemovedCell)?.delegate = self

    self.viewModel.inputs.willDisplayRow(
      self.dataSource.itemIndexAt(indexPath),
      outOf: self.dataSource.numberOfItems()
    )
  }

  override func tableView(_: UITableView, didSelectRowAt indexPath: IndexPath) {
    guard let comment = self.dataSource.comment(at: indexPath) else { return }

    self.viewModel.inputs.didSelectComment(comment)
  }

  override func tableView(_: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
    if self.dataSource.isInErrorState(indexPath: indexPath) {
      return self.view.safeAreaLayoutGuide.layoutFrame.height * CommentsLayout.ErrorState.cellHeightMuliplier
    }

    return UITableView.automaticDimension
  }
}

// MARK: - CommentComposerViewDelegate

extension CommentsViewController: CommentComposerViewDelegate {
  func commentComposerView(_: CommentComposerView, didSubmitText text: String) {
    self.viewModel.inputs.commentComposerDidSubmitText(text)
  }
}

// MARK: - CommentTableViewFooterViewDelegate

extension CommentsViewController: CommentTableViewFooterViewDelegate {
  func commentTableViewFooterViewDidTapRetry(_: CommentTableViewFooterView) {
    self.viewModel.inputs.commentTableViewFooterViewDidTapRetry()
  }
}

// MARK: - CommentCellDelegate

extension CommentsViewController: CommentCellDelegate {
  func commentCellDidTapHeader(_ cell: CommentCell, _ author: Comment.Author) {
    guard
      let currentUser = AppEnvironment.current.currentUser,
      String(currentUser.id) != author.id,
      !author.isBlocked
    else {
      return
    }

    let actionSheet = UIAlertController
      .blockUserActionSheet(
        blockUserHandler: { _ in self.presentBlockUserAlert(username: author.name, userId: author.id) },
        sourceView: cell,
        isIPad: self.traitCollection.userInterfaceIdiom == .pad
      )

    self.present(actionSheet, animated: true)
  }

  func commentCellDidTapReply(_: CommentCell, comment: Comment) {
    self.viewModel.inputs.commentCellDidTapReply(comment: comment)
  }

  func commentCellDidTapViewReplies(_: CommentCell, comment: Comment) {
    self.viewModel.inputs.commentCellDidTapViewReplies(comment)
  }
}

// MARK: - CommentRepliesViewControllerDelegate

extension CommentsViewController: CommentRepliesViewControllerDelegate {
  func commentRepliesViewControllerDidBlockUser(_: CommentRepliesViewController) {
    self.tableView.scrollToTop()
    self.viewModel.inputs.refresh()
  }
}

// MARK: - CommentRemovedCellDelegate

extension CommentsViewController: CommentRemovedCellDelegate {
  func commentRemovedCell(_: CommentRemovedCell, didTapURL: URL) {
    self.viewModel.inputs.commentRemovedCellDidTapURL(didTapURL)
  }
}

// MARK: - MessageBannerViewControllerDelegate

extension CommentsViewController: MessageBannerViewControllerDelegate {
  func messageBannerViewDidHide(type: MessageBannerType) {
    if type == .success {
      self.tableView.scrollToTop()
      self.viewModel.inputs.refresh()
    }
  }
}

internal func commentsViewController(
  for project: Project? = nil,
  update: Update? = nil
) -> UIViewController {
  return CommentsViewController.configuredWith(project: project, update: update)
}

