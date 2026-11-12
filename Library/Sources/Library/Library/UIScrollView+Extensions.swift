import UIKit

/// `UIScrollView` extensions declared in `UIScrollView+Extensions.swift`.
extension UIScrollView {
  /// Scrolls to the top (index path `(0, 0)` on non-empty `UITableView` instances, or adjusted content offset otherwise).
  public func scrollToTop() {
    if let tableView = self as? UITableView,
       tableView.numberOfSections > 0, tableView.numberOfRows(inSection: 0) > 0 {
      tableView.scrollToRow(at: .init(row: 0, section: 0), at: .top, animated: true)

    } else {
      self.setContentOffset(CGPoint(x: 0.0, y: -self.contentInset.top), animated: true)
    }
  }

  /// Adjusts `contentInset` and `scrollIndicatorInsets` to account for keyboard appearance and dismissal.
  public func handleKeyboardVisibilityDidChange(_ change: Keyboard.Change, insets: UIEdgeInsets = .zero) {
    UIView.animate(
      withDuration: change.duration,
      delay: 0.0,
      options: change.options,
      animations: {
        switch change.notificationName {
        case UIResponder.keyboardWillShowNotification:
          guard let window = self.window else { return }

          // We need to properly calculate how much of the keyboard is taking over the scroll view
          // which could be presented using modal presentation style .formSheet on iPads
          let frameInWindowCoordinates = window.convert(self.frame, from: self.superview)
          let bottomEdgeInWindowCoordinates = window.frame.maxY - frameInWindowCoordinates.maxY
          let bottomInsets = max(insets.bottom, change.frame.height - bottomEdgeInWindowCoordinates)

          self.contentInset.bottom = bottomInsets
          self.verticalScrollIndicatorInsets.bottom = bottomInsets

        case UIResponder.keyboardWillHideNotification:
          self.contentInset = insets
          self.scrollIndicatorInsets = insets

        default:
          return
        }
      }, completion: nil
    )
  }
}
