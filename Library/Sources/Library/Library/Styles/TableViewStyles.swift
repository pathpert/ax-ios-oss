import Foundation
import KDS
import KsApi
import Prelude
import Prelude_UIKit
import UIKit

/// Base table view controller style with self-sizing rows and hidden cell separators.
public func baseTableControllerStyle<TVC: UITableViewControllerProtocol>
(estimatedRowHeight: CGFloat = 44.0) -> ((TVC) -> TVC) {
  let style = baseControllerStyle()
    <> TVC.lens.view.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    <> TVC.lens.tableView.rowHeight .~ UITableView.automaticDimension
    <> TVC.lens.tableView.estimatedRowHeight .~ estimatedRowHeight

  return style <> TVC.lens.tableView.separatorStyle .~ .none
}

/// Base table view cell style with responsive layout margins and disabled selection highlight.
public func baseTableViewCellStyle<TVC: UITableViewCellProtocol>() -> ((TVC) -> TVC) {
  return
    TVC.lens.contentView.layoutMargins %~~ { _, cell in
      if cell.traitCollection.isRegularRegular {
        return .init(topBottom: Styles.grid(3), leftRight: Styles.grid(12))
      }
      return .init(topBottom: Styles.grid(1), leftRight: Styles.grid(2))
    }
    <> TVC.lens.backgroundColor .~ LegacyColors.ksr_white.uiColor()
    <> (TVC.lens.contentView .. UIView.lens.preservesSuperviewLayoutMargins) .~ false
    <> TVC.lens.layoutMargins .~ .init(all: 0.0)
    <> TVC.lens.preservesSuperviewLayoutMargins .~ false
    <> TVC.lens.selectionStyle .~ .none
}

/// Primary title label style used inside standard table view cells.
public let baseTableViewCellTitleLabelStyle: LabelStyle = { label in
  label
    |> \.textColor .~ LegacyColors.ksr_support_700.uiColor()
    |> \.font .~ .ksr_body()
}
