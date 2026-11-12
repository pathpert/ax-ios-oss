import KsApi
import Library
import UIKit

extension CommentRepliesDataSource {
  /// Returns an `IndexPath?` if the given replyId exists in the dataSource.
  /// - parameter replyId: The reply identifier of a `Comment`.
  /// - returns: The `IndexPath?` with the matching replyId.
  public func index(for replyId: String) -> IndexPath? {
    let commentIndex = self.items(in: Section.replies.rawValue).firstIndex { value in
      let foundAsCommentCell = (value as? (value: (Comment, Project), reusableId: String))?.value.0
        .id == replyId
      return foundAsCommentCell
    }

    if let commentIndex = commentIndex {
      return IndexPath(row: commentIndex, section: Section.replies.rawValue)
    }

    return nil
  }

  /// Returns `true` when the `replies` section of the data source is empty.
  /// - parameter tableView: `UITableView` object providing the section count.
  /// - returns: `true` if the number of items in the `replies` section is `0`.
  public func isRepliesSectionEmpty(in tableView: UITableView) -> Bool {
    if self.numberOfSections(in: tableView) > Section.replies.rawValue {
      return self.numberOfItems(in: Section.replies.rawValue) == 0
    }
    return true
  }

  /// Returns `true` when `indexPath` belongs to `Section.viewMoreReplies` or `Section.viewMoreRepliesError`.
  /// - parameter indexPath: `IndexPath` object to inspect.
  public func sectionForViewMoreReplies(_ indexPath: IndexPath) -> Bool {
    switch indexPath.section {
    case Section.viewMoreReplies.rawValue, Section.viewMoreRepliesError.rawValue:
      return true
    default:
      return false
    }
  }

  /// Returns `true` when `indexPath` belongs to `Section.replies`.
  /// - parameter indexPath: `IndexPath` object to inspect.
  public func sectionForReplies(_ indexPath: IndexPath) -> Bool {
    return indexPath.section == Section.replies.rawValue
  }

  /// Clears the `viewMoreReplies` section and sets a `CommentViewMoreRepliesFailedCell` in `viewMoreRepliesError`.
  public func showPaginationErrorState() {
    self.clearValues(section: Section.viewMoreReplies.rawValue)

    self.set(
      values: [()],
      cellClass: CommentViewMoreRepliesFailedCell.self,
      inSection: Section.viewMoreRepliesError.rawValue
    )
  }
}

